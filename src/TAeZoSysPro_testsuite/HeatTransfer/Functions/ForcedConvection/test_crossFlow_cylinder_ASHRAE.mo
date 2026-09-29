within TAeZoSysPro_testsuite.HeatTransfer.Functions.ForcedConvection;

model test_crossFlow_cylinder_ASHRAE

  Modelica.SIunits.NusseltNumber Nu;
  Modelica.SIunits.ReynoldsNumber Re;
  
equation

  Re = 10 ^ time;
  Nu = TAeZoSysPro.HeatTransfer.Functions.ForcedConvection.crossFlow_cylinder_ASHRAE(Pr = 1, Re = Re);
  
  annotation(
    experiment(StartTime = 0, StopTime = 13, Tolerance = 1e-06, Interval = 0.1));

end test_crossFlow_cylinder_ASHRAE;
