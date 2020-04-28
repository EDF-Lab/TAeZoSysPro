within TAeZoSysPro.FluidDynamics.Components.Machines.Tests;

model test_PrescribedPump
  TAeZoSysPro.FluidDynamics.Components.Machines.PrescribedPump prescribedPump(
  redeclare function flowCharacteristic = TAeZoSysPro.FluidDynamics.Components.Machines.BaseClasses.PumpCharacteristics.polynomialFlow(
    V_flow_nominal = linspace(0.1, 0.9, 10),
    head_nominal = {24.78, 17.36, 20.30, 15.58, 17.43, 12.66, 13.18, 8.61, 7.53, 3.42}), N_nominal = 1500,
    V_flow(start = 0.5),checkValve = false, use_N_in = false)   annotation(
    Placement(visible = true, transformation(origin = {-3.55271e-15, 3.55271e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Fluid.Sources.FixedBoundary boundary(redeclare package Medium = Modelica.Media.Water.StandardWater, nPorts = 1, p = 101325) annotation(
    Placement(visible = true, transformation(origin = {-80, -1}, extent = {{-20, -19}, {20, 19}}, rotation = 0)));
  Modelica.Fluid.Sources.FixedBoundary boundary1(redeclare package Medium = Modelica.Media.Water.StandardWater, nPorts = 1, p = 101325 + 15) annotation(
    Placement(visible = true, transformation(origin = {80, 1}, extent = {{20, -19}, {-20, 19}}, rotation = 0)));
  Modelica.Blocks.Sources.Ramp ramp(duration = 100, height = 100, offset = 1500)  annotation(
    Placement(visible = true, transformation(origin = {-50, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(boundary.ports[1], prescribedPump.port_a) annotation(
    Line(points = {{-60, -2}, {-22, -2}, {-22, 0}, {-20, 0}}, color = {0, 127, 255}));
  connect(prescribedPump.port_b, boundary1.ports[1]) annotation(
    Line(points = {{20, 0}, {58, 0}, {58, 2}, {60, 2}}, color = {0, 127, 255}));
  connect(ramp.y, prescribedPump.N_in) annotation(
    Line(points = {{-38, 70}, {0, 70}, {0, 20}, {0, 20}}, color = {0, 0, 127}));
end test_PrescribedPump;
