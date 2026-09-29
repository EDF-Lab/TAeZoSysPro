"""Markdown report of ModelicaTests results, for the GitHub run summary.

1. Results of the tested configuration: the table of the ModelicaTests HTML
   report (<new>.html), with the same columns and legend.
2. Comparison with the reference configuration: status of each model on both
   versions and, for models simulated in both, the relative differences between
   the final values of the saved variables, computed as in the ModelicaTests
   HTML comparison (<ref>-<new>.html). The 10 largest differences are listed
   for each model whose results changed.

Column order and relative differences come from ModelicaTests' own
post-processing, so this report matches its HTML files.

Usage, from the ModelicaTests tests directory (TMP_0 = reference, TMP_1 = tested):
    python report.py config_ref_openmodelica.csv config_new_openmodelica.csv > report.md
"""

import argparse
import math
import os

import DyMat
import numpy as np
import pandas as pd
from ModelicaTests.postprocessing import compute_relative_diff, sort_columns

PHASES = ["check", "translate", "simulate"]

# Plain-text version of the ModelicaTests column names (MathJax is not rendered in the run summary)
LABELS = {
    "number_variable": "N_var",
    "number_equation": "N_eq",
    "translation_time": "T_translation [s]",
    "warnings": "warnings",
    "initialisation_time": "T_init [s]",
    "simulation_time": "T_sim [s]",
    "failed_time": "T_failed [s]",
}

LEGEND = """*Key to abbreviated columns:*
N_var: number of variables · N_eq: number of equations (🟠 when different) ·
T_translation: translation time · T_init: initialization time ·
T_sim: simulation time · T_failed: simulation failure time
"""


def to_bool(value):
    """Convert True/False strings and numpy booleans to Python booleans."""
    if isinstance(value, str):
        return {"True": True, "False": False}.get(value, value)
    return bool(value) if isinstance(value, np.bool_) else value


def read_results(csv_file):
    """Read a ModelicaTests CSV report."""
    df = pd.read_csv(csv_file, sep=";", header=[0, 1], index_col=0)
    df.index.name = None
    return df


def format_cell(value, field):
    """Format a cell as in the ModelicaTests HTML report (colors replaced by symbols)."""
    value = to_bool(value)
    if value is None or (isinstance(value, float) and math.isnan(value)):
        return "–"
    if isinstance(value, bool) or field == "success":
        return {True: "✅", False: "❌", "TimedOut": "⏱️ TimedOut"}.get(value, str(value))
    if field in ("number_variable", "number_equation"):
        return str(int(value))
    if isinstance(value, float):
        return f"{value:.3f}"
    return str(value)


def results_table(df, name):
    """Markdown version of the ModelicaTests HTML table of one configuration."""
    columns = sort_columns(df.columns)
    header = ["Model"] + [phase if field == "success" else LABELS.get(field, field) for phase, field in columns]
    lines = [f"## Results of simulation tests for configuration {name}\n",
             f"**{sum(to_bool(v) is True for v in df[('simulate', 'success')])}/{len(df)} models simulated.**\n",
             "| " + " | ".join(header) + " |",
             "|" + "---|" * len(header)]
    for model, row in df.iterrows():
        n_var, n_eq = row.get(("check", "number_variable")), row.get(("check", "number_equation"))
        mismatch = pd.notna(n_var) and pd.notna(n_eq) and n_var != n_eq
        cells = []
        for phase, field in columns:
            cell = format_cell(row[(phase, field)], field)
            if mismatch and field in ("number_variable", "number_equation"):
                cell = "🟠 " + cell
            cells.append(cell)
        lines.append(f"| `{model}` | " + " | ".join(cells) + " |")
    return "\n".join(lines) + "\n\n" + LEGEND


def status(row):
    """'OK', or the first failing phase of a model."""
    for phase in PHASES:
        value = to_bool(row.get((phase, "success")))
        if value is not True:
            return "timeout" if value == "TimedOut" else f"{phase} failed"
    return "OK"


def final_values(mat_file):
    """Return (final time, final values) of a result file, without internal variables."""
    res = DyMat.DyMatFile(mat_file)
    names = [n for n in res.names() if not n.startswith(("_", "$"))]
    values = pd.Series({n: float(res.data(n)[-1]) for n in names}, dtype=float)
    end_time = float(res.abscissa(names[0])[0][-1]) if names else math.nan
    return end_time, values


def diff_symbol(diff):
    """Color scale of the ModelicaTests HTML comparison: green <= 0.1, red >= 0.3."""
    return "🟢" if diff <= 0.1 else "🔴" if diff >= 0.3 else "🟠"


def compare(ref_mat, new_mat, rtol, names):
    """Return (change description or None, markdown details) for a model simulated in both."""
    (ref_end, ref), (new_end, new) = final_values(ref_mat), final_values(new_mat)
    common = ref.index.intersection(new.index)
    if common.empty:
        return "❔ no saved variable to compare", ""
    diff = pd.Series(compute_relative_diff(ref[common], new[common])).sort_values(ascending=False)
    if not math.isclose(ref_end, new_end, rel_tol=1e-9):
        change = f"🔶 end time changed: {ref_end:g} → {new_end:g} s"
    elif diff.iloc[0] > rtol:
        change = f"🔶 results changed: `{diff.index[0]}` {diff.iloc[0]:.2e}"
    else:
        return None, ""
    rows = [f"| `{var}` | {ref[var]:.6g} | {new[var]:.6g} | {diff_symbol(d)} {d:.4f} |" for var, d in diff.iloc[:10].items()]
    table = "\n".join([f"| Variable | {names[0]} | {names[1]} | Relative diff |", "|---|---|---|---|"] + rows)
    return change, table


def comparison(ref_df, new_df, names, simu_dir, rtol):
    """Markdown comparison of the tested configuration with the reference."""
    rows, details = [], []  # rows: (sort key, model, reference status, tested status, change)
    for model in sorted(ref_df.index.union(new_df.index)):
        r = status(ref_df.loc[model]) if model in ref_df.index else "absent"
        n = status(new_df.loc[model]) if model in new_df.index else "absent"
        if r == "absent":
            change, key = "🆕 new model", 3
        elif n == "absent":
            change, key = "🗑️ removed", 4
        elif r != "OK" and n == "OK":
            change, key = "✅ fixed", 1
        elif r == "OK" and n != "OK":
            change, key = "❌ regression", 0
        elif r != "OK":
            change, key = ("⚠️ still failing" if r == n else "⚠️ fails differently"), 2
        else:
            mats = [os.path.join(f"{simu_dir}_{i}", model, f"{model}.mat") for i in (0, 1)]
            try:
                change, table = compare(*mats, rtol, names)
            except Exception as error:  # missing or unreadable result file
                change, table = f"❔ results not compared ({type(error).__name__})", ""
            key = 5 if change else 6
            change = change or "= unchanged"
            if table:
                details.append(f"<details><summary><code>{model}</code>: 10 largest relative differences</summary>\n\n{table}\n\n</details>")
        rows.append((key, model, r, n, change))

    counts = {}
    for *_, change in rows:
        label = change.split(":")[0].split(" (")[0]
        counts[label] = counts.get(label, 0) + 1
    lines = [f"## Comparison of simulation test results for configurations {names[0]} - {names[1]}\n",
             " · ".join(f"{label}: {count}" for label, count in counts.items()) + "\n",
             f"Results are compared on the final values of all saved variables. Relative difference as in "
             f"ModelicaTests: |{names[0]} - {names[1]}| / max(|{names[0]}|, |{names[1]}|, 0.01); "
             f"results are reported as changed above {rtol:g}.\n",
             f"| Model | {names[0]} | {names[1]} | Change |",
             "|---|---|---|---|"]
    lines += [f"| `{model}` | {r} | {n} | {change} |" for _, model, r, n, change in sorted(rows)]
    return "\n".join(lines + [""] + details) + "\n"


def main():
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("ref_csv", help="ModelicaTests CSV report of the reference configuration")
    parser.add_argument("new_csv", help="ModelicaTests CSV report of the tested configuration")
    parser.add_argument("--simu-dir", default="TMP", help="Simulation directory prefix used by ModelicaTests")
    parser.add_argument("--rtol", type=float, default=1e-4, help="Relative difference above which results are reported as changed")
    args = parser.parse_args()

    names = [os.path.basename(f).removesuffix(".csv") for f in (args.ref_csv, args.new_csv)]
    ref_df, new_df = read_results(args.ref_csv), read_results(args.new_csv)
    print(results_table(new_df, names[1]))
    print(comparison(ref_df, new_df, names, args.simu_dir, args.rtol))


if __name__ == "__main__":
    main()
