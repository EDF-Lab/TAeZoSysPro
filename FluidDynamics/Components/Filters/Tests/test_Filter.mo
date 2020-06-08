within TAeZoSysPro.FluidDynamics.Components.Filters.Tests;

model test_Filter

  Modelica.Fluid.Sources.FixedBoundary source(redeclare package Medium = Modelica.Media.Air.SimpleAir, T = 277.15, nPorts = 1, p = 101325 + 1e5, use_p = true) annotation(
    Placement(visible = true, transformation(origin = {-80, 3.55271e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Fluid.Sources.FixedBoundary sink(redeclare package Medium = Modelica.Media.Air.SimpleAir, nPorts = 1) annotation(
    Placement(visible = true, transformation(origin = {80, 0}, extent = {{20, -20}, {-20, 20}}, rotation = 0)));
  TAeZoSysPro.FluidDynamics.Components.Filters.Filter airFilter(redeclare package Medium = Modelica.Media.Air.SimpleAir, V_flow_nominal = 1, dp_nominal = 100000)  annotation(
    Placement(visible = true, transformation(origin = {-3.55271e-15, 3.55271e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
equation
  connect(source.ports[1], airFilter.port_a) annotation(
    Line(points = {{-60, 0}, {-20, 0}, {-20, 0}, {-20, 0}}, color = {0, 127, 255}));
  connect(airFilter.port_b, sink.ports[1]) annotation(
    Line(points = {{20, 0}, {60, 0}, {60, 0}, {60, 0}}, color = {0, 127, 255}));
protected
end test_Filter;
