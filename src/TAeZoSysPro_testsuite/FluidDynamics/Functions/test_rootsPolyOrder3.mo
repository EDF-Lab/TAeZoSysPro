within TAeZoSysPro_testsuite.FluidDynamics.Functions;

model test_rootsPolyOrder3

  /*
polynom: ax^3 + bx^2 + cx + d = 0
roots: 1, 2 and 3 
*/
  parameter Real a = 1, b = -6, c = 11, d = -6;
  parameter Real e = 1, f = -3, g = 2;
  Real roots_3rd[3]
    "Roots of the Thid order polynom";
  Real roots_2nd[3]
    "Roots of the Thid order polynom";

equation

  roots_3rd = TAeZoSysPro.FluidDynamics.Functions.rootsPolyOrder3(a = a, b = b, c = c, d = d);
  roots_2nd = TAeZoSysPro.FluidDynamics.Functions.rootsPolyOrder3(a = 0, b = e, c = f, d = g);

  annotation (
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-6, Interval = 0.002));

end test_rootsPolyOrder3;
