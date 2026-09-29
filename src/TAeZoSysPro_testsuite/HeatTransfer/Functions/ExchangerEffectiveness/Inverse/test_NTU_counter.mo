within TAeZoSysPro_testsuite.HeatTransfer.Functions.ExchangerEffectiveness.Inverse;

model test_NTU_counter

  parameter Modelica.SIunits.Efficiency Eff = 0.8
    "Exchanger effectiveness";
  Real Cr
    "Ratio of thermal condutance";
  Real NTU
    "Number of transfer unit";
  Modelica.Blocks.Sources.Ramp ramp1(duration = 1, height = 1)
    annotation (
      Placement(visible = true, transformation(origin = {-10, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation

  Cr = ramp1.y;
  NTU = TAeZoSysPro.HeatTransfer.Functions.ExchangerEffectiveness.Inverse.NTU_counterCurrent(Eff = Eff, Cr = Cr);

  annotation (
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-6, Interval = 0.01));

end test_NTU_counter;
