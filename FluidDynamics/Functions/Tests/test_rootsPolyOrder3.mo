within TAeZoSysPro.FluidDynamics.Functions.Tests;

model test_rootsPolyOrder3
/*
polynom: ax^3 + bx^2 + cx + d = 0
roots: 1, 2 and 3 
*/
  parameter Real a = 1, b = -6, c = 11, d = -6 ;
  Real roots[3] ; 

equation

roots = rootsPolyOrder3(a=a, b=b, c=c, d=d) ;

end test_rootsPolyOrder3;
