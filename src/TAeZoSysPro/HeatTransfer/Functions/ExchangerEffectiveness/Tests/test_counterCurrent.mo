within TAeZoSysPro.HeatTransfer.Functions.ExchangerEffectiveness.Tests;

model test_counterCurrent

  parameter Real NTU = 10
    "Number of transfer unit";
  Real Cr
    "Ratio of thermal condutance";
  Modelica.SIunits.Efficiency Eff
    "Exchanger effectiveness";
  // Cr stops at 0.99: counterCurrent evaluates its general formula (0/0 at Cr = 1) even where regStep only uses the Cr = 1 limit
  Modelica.Blocks.Sources.Ramp ramp1(duration = 1, height = 0.99)
    annotation (
      Placement(visible = true, transformation(origin = {-10, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation

  Cr = ramp1.y;
  Eff = TAeZoSysPro.HeatTransfer.Functions.ExchangerEffectiveness.counterCurrent(NTU = NTU, Cr = Cr);

  annotation (
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-6, Interval = 0.01));

end test_counterCurrent;
