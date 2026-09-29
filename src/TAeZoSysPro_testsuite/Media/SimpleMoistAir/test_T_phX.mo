within TAeZoSysPro_testsuite.Media.SimpleMoistAir;

model test_T_phX

  package Medium = TAeZoSysPro.Media.Air.MoistAir;
  parameter Modelica.SIunits.Pressure p = 101325;
  parameter Modelica.SIunits.MassFraction X[2] = {0.03, 0.97};
  Modelica.SIunits.SpecificEnthalpy h;
  Modelica.SIunits.Temperature T, T_guess;
  Modelica.SIunits.MassFraction X_steam;
  Modelica.SIunits.Temperature T_sat;
  Modelica.SIunits.Pressure p_sat;
  //
  Modelica.Blocks.Sources.Ramp ramp(
    height = 20,
    duration = 1,
    offset = 293.15)
    annotation (Placement(transformation(extent = {{-10, -10}, {10, 10}})));

equation

  T_sat = Modelica.Media.Water.IF97_Utilities.BaseIF97.Basic.tsat(1000);
  p_sat = Medium.saturationPressure(T_sat);
  X_steam = Medium.massFraction_pTphi(p = p, T = T, phi = 1);
  T = ramp.y;
  h = X[Medium.Air] * Medium.dryair.cp * (T - Medium.reference_T) + min(X_steam, X[Medium.Water]) * (Medium.steam.cp * (T - Medium.reference_T) + Medium.steam.h_lv) + max(X[Medium.Water] - X_steam, 0.0) * Medium.water.cp * (T - Medium.reference_T);
  T_guess = Medium.T_phX(p = p, h = h, X = X);

  annotation (
    Icon(coordinateSystem(preserveAspectRatio = false)),
    Diagram(coordinateSystem(preserveAspectRatio = false)),
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-6, Interval = 0.002));

end test_T_phX;
