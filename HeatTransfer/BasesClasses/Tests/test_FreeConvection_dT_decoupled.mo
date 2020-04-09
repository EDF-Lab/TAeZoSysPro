within TAeZoSysPro.HeatTransfer.BasesClasses.Tests;

model test_FreeConvection_dT_decoupled
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature T_wall(T = 303.15)  annotation(
    Placement(visible = true, transformation(origin = {-90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature T_fluid(T = 293.15)  annotation(
    Placement(visible = true, transformation(origin = {90, 50}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temperatureSensor annotation(
    Placement(visible = true, transformation(origin = {30, 50}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  TAeZoSysPro.HeatTransfer.BasesClasses.FreeConvection_dT_decoupled freeConvection_dT_decoupled(A = 1)  annotation(
    Placement(visible = true, transformation(origin = { -2, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature T_source(T = 283.15) annotation(
    Placement(visible = true, transformation(origin = {70, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
equation
  connect(T_wall.port, freeConvection_dT_decoupled.port_a) annotation(
    Line(points = {{-80, 0}, {-12, 0}, {-12, 0}, {-12, 0}}, color = {191, 0, 0}));
  connect(freeConvection_dT_decoupled.port_b, T_source.port) annotation(
    Line(points = {{8, 0}, {60, 0}, {60, 0}, {60, 0}}, color = {191, 0, 0}));
  connect(temperatureSensor.T, freeConvection_dT_decoupled.T_fluid) annotation(
    Line(points = {{20, 50}, {0, 50}, {0, 8}, {0, 8}}, color = {0, 0, 127}));
  connect(T_fluid.port, temperatureSensor.port) annotation(
    Line(points = {{80, 50}, {40, 50}, {40, 50}, {40, 50}}, color = {191, 0, 0}));
end test_FreeConvection_dT_decoupled;
