within TAeZoSysPro_testsuite.Media.SimpleMoistAir;

model test_cp

  package Medium = TAeZoSysPro.Media.Air.MoistAir;
  parameter Modelica.SIunits.Pressure p = 101325;
  parameter Modelica.SIunits.Temperature T = 303.15;
  Modelica.SIunits.Pressure p_sat;
  Medium.ThermodynamicState state;
  Modelica.SIunits.SpecificHeatCapacityAtConstantPressure cp;

equation

  p_sat = Medium.saturationPressure(T);
  state = TAeZoSysPro.Media.Air.MoistAir.setState_pTX(p = p, T = T, X = {0.01, 0.99});
  cp = Medium.specificHeatCapacityCp(state);

  annotation (
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-6, Interval = 0.002));

end test_cp;
