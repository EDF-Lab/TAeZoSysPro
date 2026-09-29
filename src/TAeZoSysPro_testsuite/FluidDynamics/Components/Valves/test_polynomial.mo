within TAeZoSysPro_testsuite.FluidDynamics.Components.Valves;

model test_polynomial

  Modelica.SIunits.Position pos ;
  Modelica.Blocks.Sources.Ramp ramp(duration = 1)  annotation(
    Placement(visible = true, transformation(origin = {-10, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Real rc "Relative flow coefficient (per unit)";

equation

  pos = ramp.y ;
  rc = TAeZoSysPro.FluidDynamics.Components.Valves.BaseClasses.ValveCharacteristics.polynomial(pos = pos, c={0,0,1}) ;

annotation(
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-6, Interval = 0.002));
end test_polynomial;