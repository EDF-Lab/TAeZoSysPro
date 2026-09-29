within TAeZoSysPro_testsuite.Media.SimpleMoistAir;

model test_sublimationPressureIceDer

  Modelica.SIunits.Temperature T ;
  Modelica.SIunits.Pressure p;
  Real dpdt, dpdt_num;

equation

  T = 273.15 - time;
  p = TAeZoSysPro.Media.Air.MoistAir.sublimationPressureIce(T);
  dpdt = TAeZoSysPro.Media.Air.MoistAir.sublimationPressureIce_der(T, der(T));
  dpdt_num = der(p);

annotation(
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-6, Interval = 0.002));
end test_sublimationPressureIceDer;