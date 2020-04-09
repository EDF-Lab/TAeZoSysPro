within TAeZoSysPro.HeatTransfer.Components.Tests;

model test_Wall
  TAeZoSysPro.HeatTransfer.Components.Wall wall(A = 1, Lc = 1, Th = 0.1, cp = 1000, d = 1000, energyDynamics = TAeZoSysPro.HeatTransfer.Types.Dynamics.FixedInitial, eps_a = 1, eps_b = 1, k = 1)  annotation(
    Placement(visible = true, transformation(origin = {-3.55271e-15, 3.55271e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature1(T = 303.15) annotation(
    Placement(visible = true, transformation(origin = {-70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature3(T = 303.15) annotation(
    Placement(visible = true, transformation(origin = {70, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
equation
  connect(wall.A_wall_a, wall.F_view_a) annotation(
    Line(points = {{-18, -10}, {-34, -10}, {-34, -4}, {-18, -4}, {-18, -6}}, color = {0, 0, 127}));
  connect(wall.A_wall_b, wall.F_view_b) annotation(
    Line(points = {{18, -10}, {34, -10}, {34, -6}, {18, -6}, {18, -6}}, color = {0, 0, 127}));
  connect(wall.port_a_conv, fixedTemperature1.port) annotation(
    Line(points = {{-18, 14}, {-50, 14}, {-50, 0}, {-60, 0}, {-60, 0}}, color = {191, 0, 0}));
  connect(wall.port_b_conv, fixedTemperature3.port) annotation(
    Line(points = {{18, 14}, {50, 14}, {50, 0}, {60, 0}, {60, 0}}, color = {191, 0, 0}));
  connect(wall.port_b_rad, fixedTemperature3.port) annotation(
    Line(points = {{18, -18}, {50, -18}, {50, 0}, {60, 0}, {60, 0}}, color = {191, 0, 0}));
  connect(wall.port_a_rad, fixedTemperature1.port) annotation(
    Line(points = {{-18, -18}, {-50, -18}, {-50, 0}, {-60, 0}, {-60, 0}}, color = {191, 0, 0}));
end test_Wall;
