within TAeZoSysPro_testsuite.HeatTransfer.Components;

model test_HalfWall
  TAeZoSysPro.HeatTransfer.Components.HalfWall halfWall1(A = 1, Lc = 1, Th = 0.1, correlation = TAeZoSysPro.HeatTransfer.Types.FreeConvectionCorrelation.Constant, cp = 1000, d = 1000, energyDynamics = TAeZoSysPro.HeatTransfer.Types.Dynamics.FixedInitial, eps = 1, h_cv_const = 1, k = 0.1) annotation(
    Placement(visible = true, transformation(origin = {1, 49}, extent = {{-21, -21}, {21, 21}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature1(T = 303.15) annotation(
    Placement(visible = true, transformation(origin = {-70, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  TAeZoSysPro.HeatTransfer.Components.HalfWall halfWall2(A = 1, Lc = 1, N = 5, Th = 0.1, correlation = TAeZoSysPro.HeatTransfer.Types.FreeConvectionCorrelation.Constant, cp = 1000, d = 1000, energyDynamics = TAeZoSysPro.HeatTransfer.Types.Dynamics.SteadyState, eps = 1, h_cv_const = 1, k = 0.1, mesh = TAeZoSysPro.HeatTransfer.Types.MeshGrid.uniform) annotation(
    Placement(visible = true, transformation(origin = {-1, -51}, extent = {{-21, -21}, {21, 21}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature3(T = 293.15) annotation(
    Placement(visible = true, transformation(origin = {70, -50}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature4(T = 303.15) annotation(
    Placement(visible = true, transformation(origin = {-70, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(halfWall1.A_wall, halfWall1.F_view) annotation(
    Line(points = {{-19, 68}, {-26, 68}, {-26, 73}, {-19, 73}}, color = {0, 0, 127}));
  connect(fixedTemperature4.port, halfWall2.port_a_conv) annotation(
    Line(points = {{-60, -50}, {-40, -50}, {-40, -36}, {-20, -36}, {-20, -36}}, color = {191, 0, 0}));
  connect(fixedTemperature4.port, halfWall2.port_a_rad) annotation(
    Line(points = {{-60, -50}, {-40, -50}, {-40, -70}, {-20, -70}, {-20, -70}}, color = {191, 0, 0}));
  connect(halfWall2.A_wall, halfWall2.F_view) annotation(
    Line(points = {{-20, -92}, {-28, -92}, {-28, -86}, {-20, -86}, {-20, -86}}, color = {0, 0, 127}));
  connect(fixedTemperature1.port, halfWall1.port_a_conv) annotation(
    Line(points = {{-60, 50}, {-40, 50}, {-40, 64}, {-18, 64}, {-18, 64}}, color = {191, 0, 0}));
  connect(fixedTemperature1.port, halfWall1.port_a_rad) annotation(
    Line(points = {{-60, 50}, {-40, 50}, {-40, 30}, {-18, 30}, {-18, 30}}, color = {191, 0, 0}));
  connect(fixedTemperature3.port, halfWall2.port_b) annotation(
    Line(points = {{60, -50}, {18, -50}, {18, -50}, {18, -50}}, color = {191, 0, 0}));
  annotation(
    experiment(StartTime = 0, StopTime = 600, Tolerance = 1e-06, Interval = 1));
end test_HalfWall;