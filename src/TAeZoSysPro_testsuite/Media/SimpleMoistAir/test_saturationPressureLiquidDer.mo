within TAeZoSysPro_testsuite.Media.SimpleMoistAir;

model test_saturationPressureLiquidDer

  Modelica.SIunits.Temperature T;
  Modelica.SIunits.Pressure p;
  Real dpdt, dpdt_num;

equation

  T = 273.15 + time;
  p = TAeZoSysPro.Media.Air.MoistAir.saturationPressureLiquid(T);
  dpdt = TAeZoSysPro.Media.Air.MoistAir.saturationPressureLiquid_der(T, der(T));
  dpdt_num = der(p);

  annotation (
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-06, Interval = 0.002));

end test_saturationPressureLiquidDer;
