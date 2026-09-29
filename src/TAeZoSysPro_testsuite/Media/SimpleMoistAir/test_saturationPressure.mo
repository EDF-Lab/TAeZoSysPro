within TAeZoSysPro_testsuite.Media.SimpleMoistAir;

model test_saturationPressure
  Modelica.SIunits.Temperature T, T_bis, T_ter;
  Modelica.SIunits.Pressure p_ice, p_steam, p;
equation
  T = 272 + time;
  T = T_bis;
  T = T_ter;
  p_steam = TAeZoSysPro.Media.Air.MoistAir.saturationPressureLiquid(T);
  p_ice = TAeZoSysPro.Media.Air.MoistAir.sublimationPressureIce(T);
  p = TAeZoSysPro.Media.Air.MoistAir.saturationPressure(T);
  annotation(
    experiment(StartTime = 0, StopTime = 2, Tolerance = 1e-06, Interval = 0.005));
end test_saturationPressure;