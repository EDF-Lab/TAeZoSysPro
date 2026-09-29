within TAeZoSysPro_testsuite.FluidDynamics.Components.Machines;

model test_PrescribedPump
  TAeZoSysPro.FluidDynamics.Components.Machines.PrescribedPump prescribedPump(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    redeclare function flowCharacteristic = TAeZoSysPro.FluidDynamics.Components.Machines.BaseClasses.PumpCharacteristics.polynomialFlow(
      V_flow_nominal = linspace(0.1, 0.9, 10), 
      head_nominal={24.78, 17.36, 20.30, 15.58, 17.43, 12.66, 13.18, 8.61, 7.53, 3.42}, 
      OrderPolyFitting=2),
    N_nominal = 1500,
    V_flow(start = 0.5),checkValve = false, d_nominal = 1000, use_N_in = false)   annotation(
      Placement(visible = true, transformation(origin = {-28, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Fluid.Sources.FixedBoundary boundary(redeclare package Medium = Modelica.Media.Water.StandardWater, nPorts = 1, p = 101325) annotation(
    Placement(visible = true, transformation(origin = {-80, -1.9984e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Fluid.Sources.FixedBoundary boundary1(redeclare package Medium = Modelica.Media.Water.StandardWater, nPorts = 1, p = 101325) annotation(
    Placement(visible = true, transformation(origin = {80, 1}, extent = {{20, -19}, {-20, 19}}, rotation = 0)));
  Modelica.Blocks.Sources.Ramp ramp(duration = 100, height = 100, offset = 1500) annotation(
    Placement(visible = true, transformation(origin = {-50, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  TAeZoSysPro.FluidDynamics.Components.Pipes.StaticPipe pipe(redeclare package Medium = Modelica.Media.Water.StandardWater, A = 0.1, ksi = 10) annotation(
    Placement(visible = true, transformation(origin = {26, 3.55271e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
equation
  connect(pipe.port_b, boundary1.ports[1]) annotation(
    Line(points = {{46, 0}, {60, 0}, {60, 2}, {60, 2}}, color = {0, 127, 255}));
  connect(boundary.ports[1], prescribedPump.port_a) annotation(
    Line(points = {{-60, 0}, {-48, 0}, {-48, -60}, {-48, -60}}, color = {0, 127, 255}));
  connect(prescribedPump.port_b, pipe.port_a) annotation(
    Line(points = {{-8, -60}, {-8, -60}, {-8, 0}, {6, 0}, {6, 0}}, color = {0, 127, 255}));
  annotation(
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-06, Interval = 0.002));
end test_PrescribedPump;
