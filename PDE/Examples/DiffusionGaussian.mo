within TAeZoSysPro.PDE.Examples;

model DiffusionGaussian
  import pi = Modelica.Constants.pi ;

  extends Modelica.Icons.Example ;
  
  parameter Integer N(quantity ="number of discrete layer", min=11) = 22 "Number of layer" ;  
  parameter Modelica.SIunits.Length L = 2 "length of the domain";
  parameter Real dx = L / N ;
  parameter Real x[N+2] = cat(1, {0.0}, linspace(dx/2,L-dx/2,N), {L} ) ;
  parameter Real xbis[N+2] = cat(1, {0.0}, linspace(dx/2,L-dx/2,N), {L} ) ;
  parameter Modelica.SIunits.DiffusionCoefficient Dth = 1  ;
  parameter Modelica.SIunits.Time t_0 = 1e-3 " Initial time to avoid divisions by zero";
  Real[N+2] u_1order ;
  Real[N+2] u_analytic ;
  
  TAeZoSysPro.PDE.ThermalDiffusion.CentralSecondOrder centralSecondOrder(
    N = N,
    x = linspace(0,L,N+1),
    CoeffTimeDer = 1,
    CoeffSpaceDer = -Dth ) annotation(
    Placement(visible = true, transformation(origin = {0, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

initial equation
  for i in 2:N+1 loop
    centralSecondOrder.u[i] = 1 / sqrt(4 * Modelica.Constants.pi * Dth * t_0) * exp(- (x[i] - L/2)^2 / (4*Dth*t_0)) "Initial Condition" ; 
  end for ;
  
equation
// Analytical solution
for compt in 1:N+2 loop
  u_analytic[compt] = 1 / sqrt(4 * Modelica.Constants.pi * Dth * time) * exp(-(x[compt]-L/2)^2/(4*Dth*time));  
end for ;
  

  // Boundary conditions
  centralSecondOrder.u[1] = 1 / sqrt(4 * Modelica.Constants.pi * Dth * time)  * exp(-(-L/2)^2/(4*Dth*time)) "Left boundary condition";
  centralSecondOrder.u[end] = 1 / sqrt(4 * Modelica.Constants.pi * Dth * time)  * exp(-(L/2)^2/(4*Dth*time)) "Right boundary condition";

  // PDE domain
  centralSecondOrder.SourceTerm = zeros(N);
  u_1order = centralSecondOrder.u
  
annotation(
    experiment(StartTime = t_0, StopTime = 1, Tolerance = 1e-6, Interval = 0.0001));

end DiffusionGaussian;
