within TAeZoSysPro_testsuite.Media.SimpleMoistAir;

model test_pressure

  package Medium = TAeZoSysPro.Media.Air.MoistAir;
  parameter Modelica.SIunits.Pressure p = 101325;
  parameter Modelica.SIunits.Temperature T = 303.15;
  parameter Modelica.SIunits.MassFraction X[2] = {0.03, 0.97};
  Medium.ThermodynamicState state;
  Modelica.SIunits.SpecificEnthalpy h;
  Modelica.SIunits.Pressure p_guess;
  Modelica.SIunits.Temperature T_guess;
  Modelica.SIunits.MassFraction X_steam(start = X[1]), X_steam_guess;

equation

  X_steam = Medium.massFraction_pTphi(p = p, T = T, phi = 1);
  X_steam_guess = Medium.Xsaturation(state);
  h = X[Medium.Air] * Medium.dryair.cp * (T - Medium.reference_T) + min(X_steam, X[Medium.Water]) * (Medium.steam.cp * (T - Medium.reference_T) + Medium.steam.h_lv) + max(X[Medium.Water] - X_steam, 0.0) * Medium.water.cp * (T - Medium.reference_T);
  state = Medium.setState_phX(p = p, h = h, X = X);
  T_guess = Medium.T_phX(p = p, h = h, X = X);
  p_guess = Medium.pressure(state);

  annotation (
    Icon(coordinateSystem(preserveAspectRatio = false)),
    Diagram(
      coordinateSystem(preserveAspectRatio = false)),
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-6, Interval = 0.002));

end test_pressure;
