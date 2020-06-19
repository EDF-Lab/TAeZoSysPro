within TAeZoSysPro.FluidDynamics.Components.Valves.Tests;

model test_CommissioningDamper

  TAeZoSysPro.FluidDynamics.Components.Valves.CommissioningDamper commissioningDamper(redeclare package Medium = Modelica.Media.Air.SimpleAir, dp_nominal = 100000, m_flow_nominal = 1)  annotation(
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Fluid.Sources.FixedBoundary source(redeclare package Medium = Modelica.Media.Air.SimpleAir, T = 277.15, nPorts = 1, p = 101325 + 1e5)  annotation(
    Placement(visible = true, transformation(origin = {-80, 3.55271e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Fluid.Sources.FixedBoundary sink(redeclare package Medium = Modelica.Media.Air.SimpleAir, nPorts = 1)  annotation(
    Placement(visible = true, transformation(origin = {80, 0}, extent = {{20, -20}, {-20, 20}}, rotation = 0)));
equation
  connect(source.ports[1], commissioningDamper.port_a) annotation(
    Line(points = {{-60, 0}, {-20, 0}}, color = {0, 127, 255}));
  connect(commissioningDamper.port_b, sink.ports[1]) annotation(
    Line(points = {{20, 0}, {60, 0}, {60, 0}, {60, 0}}, color = {0, 127, 255}));

end test_CommissioningDamper;
