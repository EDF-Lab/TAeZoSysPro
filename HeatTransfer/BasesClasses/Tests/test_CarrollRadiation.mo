within TAeZoSysPro.HeatTransfer.BasesClasses.Tests;

model test_CarrollRadiation
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature T_solid(T = 303.15) annotation(
    Placement(visible = true, transformation(origin = {-50, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature T_radiative_mean(T = 293.15) annotation(
    Placement(visible = true, transformation(origin = {50, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  TAeZoSysPro.HeatTransfer.BasesClasses.CarrollRadiation carrollRadiation1(A = 1, eps = 0.8) annotation(
    Placement(visible = true, transformation(origin = {0, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant ViewFactor(k = 1) annotation(
    Placement(visible = true, transformation(origin = {0, -10}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Components.BodyRadiation bodyRadiation1(Gr = 0.8 * 1) annotation(
    Placement(visible = true, transformation(origin = {0, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  TAeZoSysPro.HeatTransfer.BasesClasses.CarrollRadiation carrollRadiation2(A = 1, eps = 0.8) annotation(
    Placement(visible = true, transformation(origin = {0, -50}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow1(Q_flow = 50) annotation(
    Placement(visible = true, transformation(origin = {50, -50}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Components.BodyRadiation bodyRadiation2(Gr = 0.8 * 1) annotation(
    Placement(visible = true, transformation(origin = {0, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow2(Q_flow = 50) annotation(
    Placement(visible = true, transformation(origin = {50, -80}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
equation
  connect(bodyRadiation2.port_b, fixedHeatFlow2.port) annotation(
    Line(points = {{10, -80}, {40, -80}, {40, -80}, {40, -80}}, color = {191, 0, 0}));
  connect(T_solid.port, bodyRadiation2.port_a) annotation(
    Line(points = {{-40, 0}, {-30, 0}, {-30, -80}, {-10, -80}, {-10, -80}}, color = {191, 0, 0}));
  connect(fixedHeatFlow1.port, carrollRadiation2.port_b) annotation(
    Line(points = {{40, -50}, {10, -50}, {10, -50}, {10, -50}}, color = {191, 0, 0}));
  connect(T_solid.port, carrollRadiation2.port_a) annotation(
    Line(points = {{-40, 0}, {-30, 0}, {-30, -50}, {-10, -50}, {-10, -50}}, color = {191, 0, 0}));
  connect(T_solid.port, carrollRadiation1.port_a) annotation(
    Line(points = {{-40, 0}, {-30, 0}, {-30, 30}, {-10, 30}, {-10, 30}}, color = {191, 0, 0}));
  connect(bodyRadiation1.port_a, T_solid.port) annotation(
    Line(points = {{-10, 70}, {-30, 70}, {-30, 0}, {-40, 0}}, color = {191, 0, 0}));
  connect(ViewFactor.y, carrollRadiation2.Fview) annotation(
    Line(points = {{-12, -10}, {-20, -10}, {-20, -42}, {-8, -42}, {-8, -42}}, color = {0, 0, 127}));
  connect(ViewFactor.y, carrollRadiation1.Fview) annotation(
    Line(points = {{-12, -10}, {-20, -10}, {-20, 22}, {-8, 22}, {-8, 22}}, color = {0, 0, 127}));
  connect(carrollRadiation1.port_b, T_radiative_mean.port) annotation(
    Line(points = {{10, 30}, {30, 30}, {30, 0}, {40, 0}, {40, 0}}, color = {191, 0, 0}));
  connect(bodyRadiation1.port_b, T_radiative_mean.port) annotation(
    Line(points = {{10, 70}, {30, 70}, {30, 0}, {40, 0}}, color = {191, 0, 0}));
  annotation(
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-06, Interval = 0.1));
end test_CarrollRadiation;
