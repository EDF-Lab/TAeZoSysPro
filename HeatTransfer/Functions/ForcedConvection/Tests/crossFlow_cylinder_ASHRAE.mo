within TAeZoSysPro.HeatTransfer.Functions.ForcedConvection.Tests;

model crossFlow_cylinder_ASHRAE

  Modelica.SIunits.NusseltNumber Nu;
  Modelica.SIunits.ReynoldsNumber Re;
  
equation

  Re = 10 ^ time;
  Nu = Functions.ForcedConvection.crossFlow_cylinder_ASHRAE(Pr = 1, Re = Re);
  
  annotation(
    experiment(StartTime = 0, StopTime = 13, Tolerance = 1e-06, Interval = 0.1));

end crossFlow_cylinder_ASHRAE;
