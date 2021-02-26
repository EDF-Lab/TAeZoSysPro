within TAeZoSysPro.PDE.Examples;

model BoundaryStepDiffusion
  import pi = Modelica.Constants.pi ;

  extends Modelica.Icons.Example ;
  
  constant Real std_dev = 0.05 ;
  constant Real u_init = 0 ;
  constant Real u_left = 20 ;
  
  parameter Integer N(quantity ="number of discrete layer", min=11) = 11 "Number of layer" ;  
  parameter Modelica.SIunits.Length L = 1 "length of the domain";
  parameter Real dx = L / N ;
  parameter Real x[N+2] = cat(1, {0.0}, linspace(dx/2,L-dx/2,N), {L} ) ;
  parameter Real xbis[N+2] = cat(1, {0.0}, linspace(dx/2,L-dx/2,N), {L} ) ;
  parameter Modelica.SIunits.DiffusionCoefficient Dth = 0.001  ;
  Real[N+2] u_1order ;
  Real[N+2] u_analytic ;
  
  TAeZoSysPro.PDE.ThermalDiffusion.CentralSecondOrder centralSecondOrder(
    N = N,
    x = linspace(0,L,N+1),
    CoeffTimeDer = 1,
    CoeffSpaceDer = -Dth ) annotation(
    Placement(visible = true, transformation(origin = {0, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

initial equation
//  for i in 2:N+2-1 loop
//    u_1order[i] = exp(-( (x[i] - L/2) / (2*std_dev) ) ^2) "Initial Condition" ;
//  end for ;
  
  centralSecondOrder.u[2:end-1] = fill(u_init,N) "Initial Condition" ; 
  
  
equation
// Analytical solution
for compt in 1:N+2 loop
  u_analytic[compt] = u_left*(1-x[compt]/L) - 2*u_left/pi * sum( 1/i*exp(-(i*Dth^0.5*pi/L)^2*time) * sin(i * pi / L * x[compt]) for i in 1:30 ) ;
end for ;
  

  // Boundary conditions
  centralSecondOrder.u[1] = if initial() then u_init else u_left "Left boundary condition";
  centralSecondOrder.u[end] = u_init "Right boundary condition";

  // PDE domain
  centralSecondOrder.SourceTerm = zeros(N);
  u_1order = centralSecondOrder.u
 

annotation(
    experiment(StartTime = 0, StopTime = 300, Tolerance = 1e-06, Interval = 0.3));

end BoundaryStepDiffusion;
