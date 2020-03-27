within TAeZoSysPro.HeatTransfer.Functions.FreeConvection.Tests;

model ceiling_ASHRAE

  Modelica.SIunits.NusseltNumber Nu;
  Modelica.SIunits.RayleighNumber Ra;
  Modelica.SIunits.TemperatureDifference dT "Difference of Temperature plate - fluid";
  
equation

  Ra = min(10 ^ time, 10 ^ 11);
  dT = -20;
  Nu = Functions.FreeConvection.ceiling_ASHRAE(Ra = Ra, dT = dT);
  
  annotation(
    experiment(StartTime = 0, StopTime = 10, Tolerance = 1e-06, Interval = 0.1));

end ceiling_ASHRAE;
