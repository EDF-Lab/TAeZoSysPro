within TAeZoSysPro_testsuite.Media.SimpleMoistAir;

model test_d_phX

  package Medium = TAeZoSysPro.Media.Air.MoistAir;
  parameter Modelica.SIunits.Density d = 1.2;
  parameter Modelica.SIunits.Temperature T = 303.15;
  parameter Modelica.SIunits.MassFraction X[2] = {0.03, 0.97};

  Medium.ThermodynamicState state;
  Modelica.SIunits.Pressure p;
  Modelica.SIunits.SpecificEnthalpy h;
  Modelica.SIunits.Density d_guess;

equation

  state = Medium.setState_dTX(d = d, T = T, X = X);
  p = Medium.pressure(state);
  h = Medium.specificEnthalpy(state);
  d_guess = Medium.d_phX(p = p, h = h, X = X)
    annotation (
      Icon(coordinateSystem(preserveAspectRatio = false)),
      Diagram(
        coordinateSystem(preserveAspectRatio = false)));

  annotation (
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-6, Interval = 0.002));

end test_d_phX;
