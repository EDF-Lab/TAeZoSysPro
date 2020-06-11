within TAeZoSysPro.HeatTransfer.Sensors.Tests;

model test_density
  TAeZoSysPro.HeatTransfer.Sensors.Density density annotation(
    Placement(visible = true, transformation(origin = {-3.55271e-15, 3.55271e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant pressure(k = 101325)  annotation(
    Placement(visible = true, transformation(origin = {-70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T = 293.15)  annotation(
    Placement(visible = true, transformation(origin = {-30, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(pressure.y, density.p) annotation(
    Line(points = {{-58, 0}, {-20, 0}, {-20, 0}, {-20, 0}}, color = {0, 0, 127}));
  connect(fixedTemperature.port, density.port) annotation(
    Line(points = {{-20, -50}, {0, -50}, {0, -20}, {0, -20}}, color = {191, 0, 0}));
annotation(
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-6, Interval = 0.002));
end test_density;
