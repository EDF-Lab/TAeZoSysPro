within TAeZoSysPro_testsuite.HeatTransfer.Functions.FreeConvection;

model test_ceiling_ASHRAE

  Modelica.SIunits.NusseltNumber Nu;
  Modelica.SIunits.RayleighNumber Ra;
  parameter Modelica.SIunits.TemperatureDifference dT = -20
    "Difference of Temperature plate - fluid";

equation

  Ra = min(10 ^ time, 10 ^ 11);
  Nu = TAeZoSysPro.HeatTransfer.Functions.FreeConvection.ceiling_ASHRAE(Ra = Ra, dT = dT);

  annotation (
    experiment(StartTime = 0, StopTime = 10, Tolerance = 1e-06, Interval = 0.1));

end test_ceiling_ASHRAE;
