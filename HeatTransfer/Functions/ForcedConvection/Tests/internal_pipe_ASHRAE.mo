within TAeZoSysPro.HeatTransfer.Functions.ForcedConvection.Tests;

model internal_pipe_ASHRAE
  Modelica.SIunits.TemperatureDifference dT "Temperature difference between wall and fluid";
  Modelica.SIunits.NusseltNumber Nu;
  Modelica.SIunits.ReynoldsNumber Re;
  
equation

  dT = 20 ;
  Re = 5 * 10 ^ (time + 5);
  Nu = Functions.ForcedConvection.internal_pipe_ASHRAE(Pr = 1, Re = Re, dT = dT);
  
  annotation(
    experiment(StartTime = 0, StopTime = 6, Tolerance = 1e-06, Interval = 0.06));
end internal_pipe_ASHRAE;
