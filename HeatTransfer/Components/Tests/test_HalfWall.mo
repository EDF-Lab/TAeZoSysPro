within TAeZoSysPro.HeatTransfer.Components.Tests;

model test_HalfWall
  TAeZoSysPro.HeatTransfer.Components.HalfWall halfWall1(A = 1, Lc = 1, Th = 0.1, UseImplicitConnection = false, correlation = TAeZoSysPro.HeatTransfer.Types.FreeConvectionCorrelation.Constant, cp = 1000, d = 1000, energyDynamics = TAeZoSysPro.HeatTransfer.Types.Dynamics.FixedInitial, eps = 1, h_cv_const = 1, k = 0.1)  annotation(
    Placement(visible = true, transformation(origin = {1, 79}, extent = {{-21, -21}, {21, 21}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature1(T = 303.15)  annotation(
    Placement(visible = true, transformation(origin = {-70, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  TAeZoSysPro.HeatTransfer.Components.HalfWall halfWall(A = 1, Lc = 1, N = 5, Th = 0.1, UseImplicitConnection = false, correlation = TAeZoSysPro.HeatTransfer.Types.FreeConvectionCorrelation.Constant, cp = 1000, d = 1000, energyDynamics = TAeZoSysPro.HeatTransfer.Types.Dynamics.SteadyStateInitial, eps = 1, h_cv_const = 1, k = 0.1) annotation(
    Placement(visible = true, transformation(origin = {1, -1}, extent = {{-21, -21}, {21, 21}}, rotation = 0)));
  TAeZoSysPro.HeatTransfer.Components.HalfWall halfWall2(A = 1, Lc = 1, N = 5, Th = 0.1, UseImplicitConnection = false, correlation = TAeZoSysPro.HeatTransfer.Types.FreeConvectionCorrelation.Constant, cp = 1000, d = 1000, energyDynamics = TAeZoSysPro.HeatTransfer.Types.Dynamics.SteadyState, eps = 1, h_cv_const = 1, k = 0.1) annotation(
    Placement(visible = true, transformation(origin = {-1, -81}, extent = {{-21, -21}, {21, 21}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T = 293.15) annotation(
    Placement(visible = true, transformation(origin = {90, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature3(T = 293.15) annotation(
    Placement(visible = true, transformation(origin = {90, -80}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature2(T = 303.15) annotation(
    Placement(visible = true, transformation(origin = {-70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature4(T = 303.15) annotation(
    Placement(visible = true, transformation(origin = {-70, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(halfWall1.A_wall, halfWall1.F_view) annotation(
    Line(points = {{-19, 68}, {-26, 68}, {-26, 73}, {-19, 73}}, color = {0, 0, 127}));
  connect(halfWall2.port_b, fixedTemperature3.port) annotation(
    Line(points = {{18, -80}, {80, -80}, {80, -80}, {80, -80}}, color = {191, 0, 0}));
  connect(halfWall.A_wall, halfWall.F_view) annotation(
    Line(points = {{-18, -12}, {-28, -12}, {-28, -6}, {-18, -6}, {-18, -6}}, color = {0, 0, 127}));
  connect(fixedTemperature2.port, halfWall.port_a_conv) annotation(
    Line(points = {{-60, 0}, {-40, 0}, {-40, 14}, {-18, 14}, {-18, 14}}, color = {191, 0, 0}));
  connect(fixedTemperature2.port, halfWall.port_a_rad) annotation(
    Line(points = {{-60, 0}, {-40, 0}, {-40, -20}, {-18, -20}}, color = {191, 0, 0}));
  connect(fixedTemperature4.port, halfWall2.port_a_conv) annotation(
    Line(points = {{-60, -80}, {-40, -80}, {-40, -66}, {-20, -66}, {-20, -66}}, color = {191, 0, 0}));
  connect(fixedTemperature4.port, halfWall2.port_a_rad) annotation(
    Line(points = {{-60, -80}, {-40, -80}, {-40, -100}, {-20, -100}, {-20, -100}}, color = {191, 0, 0}));
  connect(halfWall2.A_wall, halfWall2.F_view) annotation(
    Line(points = {{-20, -92}, {-28, -92}, {-28, -86}, {-20, -86}, {-20, -86}}, color = {0, 0, 127}));
  connect(fixedTemperature1.port, halfWall1.port_a_conv) annotation(
    Line(points = {{-60, 80}, {-40, 80}, {-40, 94}, {-18, 94}, {-18, 94}}, color = {191, 0, 0}));
  connect(fixedTemperature1.port, halfWall1.port_a_rad) annotation(
    Line(points = {{-60, 80}, {-40, 80}, {-40, 60}, {-18, 60}, {-18, 60}}, color = {191, 0, 0}));
  connect(fixedTemperature.port, halfWall.port_b) annotation(
    Line(points = {{80, 0}, {18, 0}, {18, 0}, {20, 0}}, color = {191, 0, 0}));
end test_HalfWall;
