within TAeZoSysPro_testsuite.HeatTransfer.Functions.ForcedConvection;

model test_flat_plate_ASHRAE

  Modelica.SIunits.NusseltNumber Nu;
  Modelica.SIunits.ReynoldsNumber Re;

equation

  Re = 5 * 10 ^ (time + 5);
  Nu = TAeZoSysPro.HeatTransfer.Functions.ForcedConvection.flat_plate_ASHRAE(Pr = 1, Re = Re);

  annotation (
    experiment(StartTime = 0, StopTime = 6, Tolerance = 1e-6, Interval = 0.06));

end test_flat_plate_ASHRAE;
