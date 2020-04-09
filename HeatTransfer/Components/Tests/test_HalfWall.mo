within TAeZoSysPro.HeatTransfer.Components.Tests;

model test_HalfWall
  TAeZoSysPro.HeatTransfer.Components.HalfWall halfWall1(A = 1, Lc = 1, Th = 0.1, UseImplicitConnection = false, correlation = TAeZoSysPro.HeatTransfer.Types.FreeConvectionCorrelation.Constant, cp = 1000, d = 1000, energyDynamics = TAeZoSysPro.HeatTransfer.Types.Dynamics.FixedInitial, eps = 1, h_cv_const = 1, k = 0.1)  annotation(
    Placement(visible = true, transformation(origin = {1, -1}, extent = {{-21, -21}, {21, 21}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature1(T = 303.15)  annotation(
    Placement(visible = true, transformation(origin = {-70, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature2(T = 303.15)  annotation(
    Placement(visible = true, transformation(origin = {-70, -52}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(fixedTemperature1.port, halfWall1.port_a_conv) annotation(
    Line(points = {{-60, 50}, {-40, 50}, {-40, 14}, {-18, 14}, {-18, 14}}, color = {191, 0, 0}));
  connect(halfWall1.A_wall, halfWall1.F_view) annotation(
    Line(points = {{-18, -12}, {-26, -12}, {-26, -6}, {-18, -6}, {-18, -6}}, color = {0, 0, 127}));
  connect(fixedTemperature2.port, halfWall1.port_a_rad) annotation(
    Line(points = {{-60, -52}, {-40, -52}, {-40, -18}, {-18, -18}, {-18, -16}}, color = {191, 0, 0}));
end test_HalfWall;
