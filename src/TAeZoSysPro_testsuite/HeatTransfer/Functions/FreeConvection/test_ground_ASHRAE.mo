within TAeZoSysPro_testsuite.HeatTransfer.Functions.FreeConvection;

model test_ground_ASHRAE

  Modelica.SIunits.NusseltNumber Nu ;
  Modelica.SIunits.RayleighNumber Ra ;
  Modelica.SIunits.TemperatureDifference dT "Difference of Temperature plate - fluid";

equation
  Ra = min(10^time, 10^11);
  dT = 20 ;
    
  Nu = TAeZoSysPro.HeatTransfer.Functions.FreeConvection.ground_ASHRAE(Ra = Ra, dT = dT) ; 

annotation(
    experiment(StartTime = 0, StopTime = 10, Tolerance = 1e-6, Interval = 0.1));
    
end test_ground_ASHRAE;
