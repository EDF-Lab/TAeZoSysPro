within TAeZoSysPro.FluidDynamics.Components.Machines.Tests;

model test_ControlledVolumeFlowPump
  TAeZoSysPro.FluidDynamics.Components.Machines.ControlledVolumeFlowPump controlledVolumeFlowPump(redeclare package Medium = Modelica.Media.Air.SimpleAir, Fan = false, V_flow_nominal = 1) annotation(
    Placement(visible = true, transformation(origin = {-30, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Sources.FixedBoundary boundary(redeclare package Medium = Modelica.Media.Air.SimpleAir, nPorts = 2)  annotation(
    Placement(visible = true, transformation(origin = {-90, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  TAeZoSysPro.FluidDynamics.Components.Pipes.StaticPipe pipe(redeclare package Medium = Modelica.Media.Air.SimpleAir, A = 0.1, ksi = 10)  annotation(
    Placement(visible = true, transformation(origin = {30, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(boundary.ports[1], controlledVolumeFlowPump.port_a) annotation(
    Line(points = {{-80, 10}, {-40, 10}, {-40, 10}, {-40, 10}}, color = {0, 127, 255}));
  connect(controlledVolumeFlowPump.port_b, pipe.port_a) annotation(
    Line(points = {{-20, 10}, {20, 10}, {20, 10}, {20, 10}}, color = {0, 127, 255}));
  connect(pipe.port_b, boundary.ports[2]) annotation(
    Line(points = {{40, 10}, {60, 10}, {60, -20}, {-80, -20}, {-80, 10}, {-80, 10}}, color = {0, 127, 255}));
end test_ControlledVolumeFlowPump;
