"""Summarize ModelicaTests results of a branch against a reference (master).

Reads the CSV reports written by ModelicaTests for the two configurations and
the simulation results (TMP_0 = reference, TMP_1 = branch), and prints a
Markdown report:
  - status of each model on the branch and on the reference,
  - status changes (fixed, regression, new, removed),
  - for models simulated in both, the largest relative difference between the
    final values of the saved variables.

Usage (from the ModelicaTests tests directory):
    python compare_results.py config_ref_openmodelica.csv config_new_openmodelica.csv >> "$GITHUB_STEP_SUMMARY"
"""

import argparse
import math
import os

import DyMat
import pandas as pd

PHASES = ["check", "translate", "simulate"]


def read_results(csv_file):
    """Return {model: status}, status being 'OK' or the first failing phase."""
    df = pd.read_csv(csv_file, sep=";", header=[0, 1], index_col=0)
    status = {}
    for model, row in df.iterrows():
        status[model] = "OK"
        for phase in PHASES:
            value = str(row.get((phase, "success"))).strip()
            if value != "True":
                status[model] = "timeout" if value == "TimedOut" else f"{phase} failed"
                break
    return status


def final_values(mat_file):
    """Return (final time, {variable: final value}) of a result file, without internal variables."""
    res = DyMat.DyMatFile(mat_file)
    values = {}
    for name in res.names():
        if name.startswith(("_", "$")):
            continue
        values[name] = float(res.data(name)[-1])
    end_time = float(res.abscissa(next(iter(values)))[0][-1]) if values else math.nan
    return end_time, values


def compare(ref_mat, new_mat, rtol):
    """Return a description of the differences between two result files, or None if identical."""
    (ref_end, ref), (new_end, new) = final_values(ref_mat), final_values(new_mat)
    common = ref.keys() & new.keys()
    if not common:
        return "❔ no saved variable to compare"
    if not math.isclose(ref_end, new_end, rel_tol=1e-9):
        return f"🔶 end time changed: {ref_end:g} → {new_end:g} s"
    worst, worst_var = 0.0, None
    for var in common:
        a, b = ref[var], new[var]
        if math.isnan(a) or math.isnan(b):
            diff = 0.0 if math.isnan(a) and math.isnan(b) else math.inf
        else:
            scale = max(abs(a), abs(b))
            diff = abs(a - b) / scale if scale > 1e-12 else 0.0
        if diff > worst:
            worst, worst_var = diff, var
    if worst > rtol:
        return f"🔶 results changed: `{worst_var}` {worst:.2e}"
    return None


def main():
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("ref_csv")
    parser.add_argument("new_csv")
    parser.add_argument("--simu-dir", default="TMP", help="Simulation directory prefix used by ModelicaTests")
    parser.add_argument("--rtol", type=float, default=1e-4, help="Relative difference above which results are reported as changed")
    args = parser.parse_args()

    ref, new = read_results(args.ref_csv), read_results(args.new_csv)
    rows = []  # (sort key, model, reference, branch, change)
    for model in sorted(ref.keys() | new.keys()):
        r, n = ref.get(model, "absent"), new.get(model, "absent")
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
            ref_mat = os.path.join(f"{args.simu_dir}_0", model, f"{model}.mat")
            new_mat = os.path.join(f"{args.simu_dir}_1", model, f"{model}.mat")
            try:
                difference = compare(ref_mat, new_mat, args.rtol)
            except Exception as error:  # missing or unreadable result file
                difference = f"❔ results not compared ({type(error).__name__})"
            change, key = (difference, 5) if difference else ("= unchanged", 6)
        rows.append((key, model, r, n, change))

    n_ok = sum(s == "OK" for s in new.values())
    counts = {}
    for key, *_, change in rows:
        label = change.split(":")[0].split(" (")[0]
        counts[label] = counts.get(label, 0) + 1

    print("## OpenModelica tests: branch vs reference\n")
    print(f"**Branch: {n_ok}/{len(new)} models OK** (reference: {sum(s == 'OK' for s in ref.values())}/{len(ref)}).\n")
    print(" · ".join(f"{label}: {count}" for label, count in counts.items()) + "\n")
    print(f"Results are compared on the final values of the saved variables (relative tolerance {args.rtol:g}).\n")
    print("| Model | Reference | Branch | Change |")
    print("|---|---|---|---|")
    for key, model, r, n, change in sorted(rows):
        print(f"| `{model}` | {r} | {n} | {change} |")


if __name__ == "__main__":
    main()
