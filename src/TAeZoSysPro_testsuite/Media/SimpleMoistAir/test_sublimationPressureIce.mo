within TAeZoSysPro_testsuite.Media.SimpleMoistAir;

model test_sublimationPressureIce

  Modelica.SIunits.Temperature T;
  Modelica.SIunits.Pressure p;

equation

  T = 273.16 - time;
  p = TAeZoSysPro.Media.Air.MoistAir.sublimationPressureIce(T);

  annotation (
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-6, Interval = 0.002));

end test_sublimationPressureIce;
