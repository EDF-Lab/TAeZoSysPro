within TAeZoSysPro_testsuite.Media.SimpleMoistAir;

model test_r_dTX_der

  parameter Modelica.SIunits.Density d = 1.2;
  parameter Modelica.SIunits.MassFraction X[2] = {0.03, 0.97};
  Modelica.SIunits.Temperature T;
  Modelica.SIunits.SpecificHeatCapacity R;
  Real der_R
    "Analytical time derivative of R";
  Real der_R_num
    "Numererical time derivative of R";

equation

  T = 190 + time;
  R = TAeZoSysPro.Media.Air.MoistAir.r_dTX(d = d, T = T, X = X);
  der_R = TAeZoSysPro.Media.Air.MoistAir.r_dTX_der(
    d = d,
    T = T,
    X = X,
    dd = 0.0,
    dT = der(T),
    dX = {0.0, 0.0});
  der_R_num = der(R);

  annotation (
    experiment(StartTime = 0, StopTime = 150, Tolerance = 1e-6, Interval = 0.3));

end test_r_dTX_der;
