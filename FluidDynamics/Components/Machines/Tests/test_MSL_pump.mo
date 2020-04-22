within TAeZoSysPro.FluidDynamics.Components.Machines.Tests;

model test_MSL_pump
  Modelica.Fluid.Machines.ControlledPump pump(redeclare package Medium = Modelica.Media.Air.MoistAir, V = 1, allowFlowReversal = true, m_flow_nominal = 1, m_flow_start = 1, p_a_nominal = 101325, p_a_start = 101325, p_b_nominal = 102315) annotation(
    Placement(visible = true, transformation(origin = {1, 39}, extent = {{-21, -21}, {21, 21}}, rotation = 0)));
  TAeZoSysPro.FluidDynamics.Sources.Atmosphere atmosphere(nPorts = 2)  annotation(
    Placement(visible = true, transformation(origin = {-80, 38}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Fluid.Pipes.StaticPipe pipe(redeclare package Medium = Modelica.Media.Air.MoistAir, diameter = 0.1, length = 1)  annotation(
    Placement(visible = true, transformation(origin = {60, 38}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Fluid.Sources.FixedBoundary boundary1(nPorts = 1, p = 101325 + 15) annotation(
    Placement(visible = true, transformation(origin = {80, -61}, extent = {{20, -19}, {-20, 19}}, rotation = 0)));
  Modelica.Fluid.Sources.FixedBoundary boundary(nPorts = 1, p = 101325) annotation(
    Placement(visible = true, transformation(origin = {-80, -59}, extent = {{-20, -19}, {20, 19}}, rotation = 0)));
  Modelica.Fluid.Machines.PrescribedPump pump1(redeclare package Medium = Modelica.Media.Water.StandardWater, N_const = 1500) annotation(
    Placement(visible = true, transformation(origin = {-3.55271e-15, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
equation
  connect(atmosphere.Fluidport[1], pump.port_a) annotation(
    Line(points = {{-80, 46}, {-40, 46}, {-40, 38}, {-20, 38}, {-20, 39}}, color = {0, 127, 255}));
  connect(pump.port_b, pipe.port_a) annotation(
    Line(points = {{22, 39}, {31, 39}, {31, 41}, {40, 41}, {40, 38}}, color = {0, 127, 255}));
  connect(pipe.port_b, atmosphere.Fluidport[2]) annotation(
    Line(points = {{80, 38}, {100, 38}, {100, 80}, {-80, 80}, {-80, 46}, {-80, 46}}, color = {0, 127, 255}));
  connect(boundary.ports[1], pump1.port_a) annotation(
    Line(points = {{-60, -58}, {-22, -58}, {-22, -60}, {-20, -60}}, color = {0, 127, 255}));
  connect(pump1.port_b, boundary1.ports[1]) annotation(
    Line(points = {{20, -60}, {60, -60}, {60, -61}}, color = {0, 127, 255}));
end test_MSL_pump;
