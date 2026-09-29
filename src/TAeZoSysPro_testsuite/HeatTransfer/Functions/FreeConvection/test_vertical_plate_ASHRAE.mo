within TAeZoSysPro_testsuite.HeatTransfer.Functions.FreeConvection;

model test_vertical_plate_ASHRAE

  Modelica.SIunits.NusseltNumber Nu ;
  Modelica.SIunits.RayleighNumber Ra ;

equation
  Ra = min(10^time, 10^11);
    
  Nu = TAeZoSysPro.HeatTransfer.Functions.FreeConvection.vertical_plate_ASHRAE(Pr = 1, Ra = Ra) ;

annotation(
    experiment(StartTime = 1, StopTime = 10, Tolerance = 1e-6, Interval = 0.0045));

end test_vertical_plate_ASHRAE;
