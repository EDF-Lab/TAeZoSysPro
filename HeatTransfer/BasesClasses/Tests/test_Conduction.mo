within TAeZoSysPro.HeatTransfer.BasesClasses.Tests;
model test_Conduction
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature T_port_a(T = 303.15)  annotation (
    Placement(visible = true, transformation(origin = {-70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature T_port_b(T = 293.15)  annotation (
    Placement(visible = true, transformation(origin = {70, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  TAeZoSysPro.HeatTransfer.BasesClasses.Conduction conduction_linear(A = 1, Th = 0.2, k = 2.3)  annotation (
    Placement(visible = true, transformation(origin = {0, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  TAeZoSysPro.HeatTransfer.BasesClasses.Conduction conduction_cylindric(L = 1 / (2 * 3.14 * conduction_cylindric.Ri), Ri = 0.5, Th = 0.2, conduction = TAeZoSysPro.HeatTransfer.BasesClasses.Conduction.ConductionType.Radial, k = 2.3)  annotation (
    Placement(visible = true, transformation(origin = {0, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(conduction_linear.port_b, T_port_b.port) annotation (
    Line(points = {{10, 30}, {40, 30}, {40, 0}, {60, 0}, {60, 0}}, color = {191, 0, 0}));
  connect(T_port_a.port, conduction_linear.port_a) annotation (
    Line(points = {{-60, 0}, {-40, 0}, {-40, 30}, {-10, 30}, {-10, 30}}, color = {191, 0, 0}));
  connect(conduction_cylindric.port_b, T_port_b.port) annotation (
    Line(points = {{10, -30}, {40, -30}, {40, 0}, {60, 0}, {60, 0}}, color = {191, 0, 0}));
  connect(T_port_a.port, conduction_cylindric.port_a) annotation (
    Line(points = {{-60, 0}, {-40, 0}, {-40, -30}, {-10, -30}, {-10, -30}}, color = {191, 0, 0}));
annotation (
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-6, Interval = 0.002));
end test_Conduction;
