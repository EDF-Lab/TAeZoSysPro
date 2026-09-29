within TAeZoSysPro_testsuite.Media.SimpleMoistAir;

model test_saturationDensity
  parameter Modelica.SIunits.Temperature T = 303.15;
  Modelica.SIunits.Density d_sat;
  Modelica.SIunits.Density d_sat_IF97;
equation
  d_sat = TAeZoSysPro.Media.Air.MoistAir.saturationDensity(T);
  d_sat_IF97 = Modelica.Media.Water.IF97_Utilities.BaseIF97.Regions.rhov_T(T);
annotation(
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-6, Interval = 0.002));
end test_saturationDensity;