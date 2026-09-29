within TAeZoSysPro_testsuite.Media.SimpleMoistAir;

model test_r_dTX
  parameter Modelica.SIunits.Density d = 1.2;
  parameter Modelica.SIunits.MassFraction X[2] = {0.03, 0.97};
  Modelica.SIunits.Temperature T;
  Modelica.SIunits.SpecificHeatCapacity R;
equation
  T = 190 + time;
  R = TAeZoSysPro.Media.Air.MoistAir.r_dTX(d = d, T = T, X = X);
  annotation(
    experiment(StartTime = 0, StopTime = 100, Tolerance = 1e-06, Interval = 0.2));
end test_r_dTX;