within TAeZoSysPro.HeatTransfer.BasesClasses.Tests;

model test_PartialWall
  TAeZoSysPro.HeatTransfer.BasesClasses.PartialWall partialWall2(N = 5, T_start = 293.15, Th = 0.1, cp = 1000, d (displayUnit = "kg/m3") = 1, energyDynamics = TAeZoSysPro.HeatTransfer.Types.Dynamics.FixedInitial, k = 1) annotation(
    Placement(visible = true, transformation(origin = {0, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature2(T = 293.15)  annotation(
    Placement(visible = true, transformation(origin = {50, 10}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  TAeZoSysPro.HeatTransfer.BasesClasses.PartialWall partialWall3(N = 5, T_start = 293.15, Th = 1, cp = 1000, d = 2500, energyDynamics = TAeZoSysPro.HeatTransfer.Types.Dynamics.SteadyState, k = 1) annotation(
    Placement(visible = true, transformation(origin = {0, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow1 annotation(
    Placement(visible = true, transformation(origin = {-40, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature3(T = 293.15)  annotation(
    Placement(visible = true, transformation(origin = {50, -30}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Ramp ramp1(duration = 10, height = 10)  annotation(
    Placement(visible = true, transformation(origin = {-90, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  TAeZoSysPro.HeatTransfer.BasesClasses.PartialWall partialWall1(N = 5, T_start = 293.15, Th = 1, cp = 1000, d (displayUnit = "kg/m3") = 1, energyDynamics = TAeZoSysPro.HeatTransfer.Types.Dynamics.FixedInitial, k = 1) annotation(
    Placement(visible = true, transformation(origin = {0, 52}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow2 annotation(
    Placement(visible = true, transformation(origin = {-40, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Ramp ramp2(duration = 10, height = 100) annotation(
    Placement(visible = true, transformation(origin = {-90, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(partialWall2.port_b, fixedTemperature2.port) annotation(
    Line(points = {{10, 10}, {40, 10}, {40, 10}, {40, 10}}, color = {191, 0, 0}));
  connect(prescribedHeatFlow2.port, partialWall2.port_a) annotation(
    Line(points = {{-30, 10}, {-10, 10}, {-10, 10}, {-10, 10}}, color = {191, 0, 0}));
  connect(ramp2.y, prescribedHeatFlow2.Q_flow) annotation(
    Line(points = {{-78, 10}, {-50, 10}, {-50, 10}, {-50, 10}}, color = {0, 0, 127}));
  connect(ramp1.y, prescribedHeatFlow1.Q_flow) annotation(
    Line(points = {{-78, -30}, {-52, -30}, {-52, -30}, {-50, -30}}, color = {0, 0, 127}));
  connect(prescribedHeatFlow1.port, partialWall3.port_a) annotation(
    Line(points = {{-30, -30}, {-10, -30}}, color = {191, 0, 0}));
  connect(partialWall3.port_b, fixedTemperature3.port) annotation(
    Line(points = {{10, -30}, {38, -30}, {38, -30}, {40, -30}}, color = {191, 0, 0}));
end test_PartialWall;
