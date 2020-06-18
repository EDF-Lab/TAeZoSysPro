within TAeZoSysPro.FluidDynamics.Components.Valves.Tests;

model test_Damper

  TAeZoSysPro.FluidDynamics.Components.Valves.Damper_parallelBlades damper(redeclare package Medium = Modelica.Media.Air.SimpleAir, CvData = Modelica.Fluid.Types.CvTypes.Kv, Kv = 106.73, allowFlowReversal = true, dp_nominal = 100000, m_flow_nominal = 1, m_flow_small = 1e-3, p_nominal = 201325, rho_nominal = 1.204, show_T = false, show_V_flow = false)  annotation(
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Fluid.Sources.FixedBoundary source(redeclare package Medium = Modelica.Media.Air.SimpleAir, T = 277.15, nPorts = 1, p = 101325 + 1e5)  annotation(
    Placement(visible = true, transformation(origin = {-80, 3.55271e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Fluid.Sources.FixedBoundary sink(redeclare package Medium = Modelica.Media.Air.SimpleAir, nPorts = 1)  annotation(
    Placement(visible = true, transformation(origin = {80, 0}, extent = {{20, -20}, {-20, 20}}, rotation = 0)));
  Modelica.Blocks.Sources.Ramp position(duration = 1)  annotation(
    Placement(visible = true, transformation(origin = {-50, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(source.ports[1], damper.port_a) annotation(
    Line(points = {{-60, 0}, {-20, 0}}, color = {0, 127, 255}));
  connect(position.y, damper.opening) annotation(
    Line(points = {{-38, 70}, {0, 70}, {0, 16}}, color = {0, 0, 127}));
  connect(damper.port_b, sink.ports[1]) annotation(
    Line(points = {{20, 0}, {60, 0}, {60, 0}, {60, 0}}, color = {0, 127, 255}));

end test_Damper;
