within TAeZoSysPro.PDE.Examples;

model AdvectionGaussian
  extends Modelica.Icons.Example;
  
  constant Integer N = 30 "number of discrete node";
  constant Real std_dev = 0.05;
  
  parameter Modelica.SIunits.Length L = 1 "length of the domain";
  parameter Real dx = L / (N + 1 - 1);
  parameter Real x[N] = linspace(dx/2, L - dx/2, N);
  parameter Real x_bis[N] = linspace(dx/2, L - dx/2, N);
  
  Modelica.SIunits.Velocity Vel "Displacemement velocity";
  Real[N] u_1order;
  Real[N] u_analytic;
  Real positionMean;
  
  Transport.UpwindFirstOrder upwindFirstOrder(N = N, N_quantity = 1, x = linspace(0, L, N + 1)) annotation(
    Placement(visible = true, transformation(origin = {-26, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Pulse pulse_velocity(amplitude = -2, offset = 1, period = 0.4, startTime = 0.1, width = 50) annotation(
    Placement(visible = true, transformation(origin = {-70, -28}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

initial equation
//gaussian
  positionMean = L / 2;
  for i in 1:N loop
    u_1order[i] = exp(-((x[i] - L / 2) / (2 * std_dev)) ^ 2);
  end for;
  
equation
// Analytical solution
  Vel = pulse_velocity.y;
  der(positionMean) = Vel;
  for i in 1:N loop
    u_analytic[i] = exp(-((x[i] - positionMean) / (2 * std_dev)) ^ 2);
  end for;
  
// Boundary conditions: linear extrapolation
  upwindFirstOrder.u_ghost_left = (-(upwindFirstOrder.u[2] - upwindFirstOrder.u[1]) / 2) + upwindFirstOrder.u[1] "Left boundary condition";
  upwindFirstOrder.u_ghost_right = (upwindFirstOrder.u[end] - upwindFirstOrder.u[end - 1]) / 2 + upwindFirstOrder.u[end - 1] "Right boundary condition";
  
// PDE domain
  upwindFirstOrder.SourceTerm = zeros(N);
  upwindFirstOrder.CoeffSpaceDer = Vel;
  u_1order = upwindFirstOrder.u[:, 1];
  
  annotation(
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-06, Interval = 0.001));

end AdvectionGaussian;
