within TAeZoSysPro.HeatTransfer.Functions.FreeConvection.Tests;

model horizontal_cylinder_ASHRAE

  Modelica.SIunits.NusseltNumber Nu;
  Modelica.SIunits.RayleighNumber Ra;
  
equation

  Ra = 10 ^ time;
  Nu = Functions.FreeConvection.horizontal_cylinder_ASHRAE(Pr = 1, Ra = Ra);
  annotation(
    experiment(StartTime = 1, StopTime = 12, Tolerance = 1e-06, Interval = 0.11));

end horizontal_cylinder_ASHRAE;
