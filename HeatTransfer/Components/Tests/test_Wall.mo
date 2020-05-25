within TAeZoSysPro.HeatTransfer.Components.Tests;

model test_Wall
  TAeZoSysPro.HeatTransfer.Components.Wall wall(A = 1, Lc = 1, Th = 0.1, cp = 1000, d = 1000, energyDynamics = TAeZoSysPro.HeatTransfer.Types.Dynamics.FixedInitial, eps_a = 1, eps_b = 1, k = 1, mesh = TAeZoSysPro.HeatTransfer.Types.MeshGrid.uniform)  annotation(
    Placement(visible = true, transformation(origin = {-3.55271e-15, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature1(T = 303.15) annotation(
    Placement(visible = true, transformation(origin = {-70, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature3(T = 293.15) annotation(
    Placement(visible = true, transformation(origin = {70, 80}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  TAeZoSysPro.HeatTransfer.Components.Wall wall1(A = 1, Lc = 1, N = 5, Th = 0.1, cp = 1000, d = 1000, energyDynamics = TAeZoSysPro.HeatTransfer.Types.Dynamics.SteadyStateInitial, eps_a = 1, eps_b = 1, k = 1, mesh = TAeZoSysPro.HeatTransfer.Types.MeshGrid.uniform) annotation(
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  TAeZoSysPro.HeatTransfer.Components.Wall wall2(A = 1, Lc = 1, N = 5, Th = 0.1, cp = 1000, d = 1000, energyDynamics = TAeZoSysPro.HeatTransfer.Types.Dynamics.SteadyState, eps_a = 1, eps_b = 1, k = 1, mesh = TAeZoSysPro.HeatTransfer.Types.MeshGrid.uniform) annotation(
    Placement(visible = true, transformation(origin = {0, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T = 303.15) annotation(
    Placement(visible = true, transformation(origin = {-70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature2(T = 293.15) annotation(
    Placement(visible = true, transformation(origin = {70, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature4(T = 303.15) annotation(
    Placement(visible = true, transformation(origin = {-70, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature5(T = 293.15) annotation(
    Placement(visible = true, transformation(origin = {70, -80}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
equation
  connect(wall.A_wall_a, wall.F_view_a) annotation(
    Line(points = {{-19, 69}, {-26.5, 69}, {-26.5, 71}, {-34, 71}, {-34, 76}, {-19, 76}, {-19, 75}}, color = {0, 0, 127}));
  connect(wall.A_wall_b, wall.F_view_b) annotation(
    Line(points = {{19, 69}, {26, 69}, {26, 70}, {34, 70}, {34, 74}, {17, 74}, {17, 72.5}, {19, 72.5}, {19, 75}}, color = {0, 0, 127}));
  connect(wall.port_a_conv, fixedTemperature1.port) annotation(
    Line(points = {{-18, 94}, {-50, 94}, {-50, 80}, {-60, 80}}, color = {191, 0, 0}));
  connect(wall.port_b_conv, fixedTemperature3.port) annotation(
    Line(points = {{18, 94}, {50, 94}, {50, 80}, {60, 80}}, color = {191, 0, 0}));
  connect(wall.port_b_rad, fixedTemperature3.port) annotation(
    Line(points = {{18, 62}, {50, 62}, {50, 80}, {60, 80}}, color = {191, 0, 0}));
  connect(wall.port_a_rad, fixedTemperature1.port) annotation(
    Line(points = {{-18, 62}, {-50, 62}, {-50, 80}, {-60, 80}}, color = {191, 0, 0}));
  connect(fixedTemperature.port, wall1.port_a_conv) annotation(
    Line(points = {{-60, 0}, {-40, 0}, {-40, 14}, {-18, 14}, {-18, 14}}, color = {191, 0, 0}));
  connect(fixedTemperature.port, wall1.port_a_rad) annotation(
    Line(points = {{-60, 0}, {-40, 0}, {-40, -18}, {-18, -18}, {-18, -18}}, color = {191, 0, 0}));
  connect(wall1.A_wall_a, wall1.F_view_a) annotation(
    Line(points = {{-18, -10}, {-28, -10}, {-28, -6}, {-18, -6}, {-18, -6}}, color = {0, 0, 127}));
  connect(fixedTemperature2.port, wall1.port_b_conv) annotation(
    Line(points = {{60, 0}, {40, 0}, {40, 14}, {18, 14}, {18, 14}}, color = {191, 0, 0}));
  connect(fixedTemperature2.port, wall1.port_b_rad) annotation(
    Line(points = {{60, 0}, {40, 0}, {40, -18}, {18, -18}, {18, -18}}, color = {191, 0, 0}));
  connect(wall1.A_wall_b, wall1.F_view_b) annotation(
    Line(points = {{18, -10}, {28, -10}, {28, -6}, {18, -6}, {18, -6}}, color = {0, 0, 127}));
  connect(fixedTemperature4.port, wall2.port_a_conv) annotation(
    Line(points = {{-60, -80}, {-40, -80}, {-40, -66}, {-18, -66}, {-18, -66}}, color = {191, 0, 0}));
  connect(fixedTemperature4.port, wall2.port_a_rad) annotation(
    Line(points = {{-60, -80}, {-40, -80}, {-40, -98}, {-18, -98}, {-18, -98}}, color = {191, 0, 0}));
  connect(wall2.A_wall_a, wall2.F_view_a) annotation(
    Line(points = {{-18, -90}, {-28, -90}, {-28, -86}, {-18, -86}, {-18, -86}}, color = {0, 0, 127}));
  connect(wall2.A_wall_b, wall2.F_view_b) annotation(
    Line(points = {{18, -90}, {28, -90}, {28, -84}, {18, -84}, {18, -86}}, color = {0, 0, 127}));
  connect(fixedTemperature5.port, wall2.port_b_conv) annotation(
    Line(points = {{60, -80}, {40, -80}, {40, -66}, {18, -66}, {18, -66}}, color = {191, 0, 0}));
  connect(fixedTemperature5.port, wall2.port_b_rad) annotation(
    Line(points = {{60, -80}, {40, -80}, {40, -98}, {18, -98}, {18, -98}}, color = {191, 0, 0}));
end test_Wall;
