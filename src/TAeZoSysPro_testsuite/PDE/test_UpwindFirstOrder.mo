within TAeZoSysPro_testsuite.PDE;

model test_UpwindFirstOrder

  parameter Modelica.SIunits.Length L = 1
    "Length of the domain";
  parameter Integer N = 5
    "Number of discrete layer";
  Modelica.SIunits.Velocity Vel;
  TAeZoSysPro.PDE.Transport.UpwindFirstOrder transport(CoeffTimeDer = 1, CoeffSpaceDer = Vel, N = N, N_quantity = 2, x = linspace(0, L, N + 1), SourceTerm = fill(0.0, N))
    annotation (
      Placement(visible = true, transformation(origin = {0, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Sources.Pulse pulse(amplitude = -2, offset = 1, period = 4, startTime = 2)
    annotation (
      Placement(visible = true, transformation(origin = {-60, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

initial equation

  transport.u[:, 1] = fill(0.0, N);
  transport.u[:, 2] = fill(0.0, N);

equation

  //
  Vel = pulse.y;
  // Boundary conditions
  transport.u_ghost_left[:] = fill(1.0, 2);
  transport.u_ghost_right[:] = fill(2.0, 2);

  annotation (
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-06, Interval = 0.002));

end test_UpwindFirstOrder;
