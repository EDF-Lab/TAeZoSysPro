within TAeZoSysPro.HeatTransfer.Components.Tests;

model test_FviewCalculator
  TAeZoSysPro.HeatTransfer.Components.FviewCalculator fviewCalculator1(N = 3)  annotation(
    Placement(visible = true, transformation(origin = {0, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = 1)  annotation(
    Placement(visible = true, transformation(origin = {-70, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const1(k = 1)  annotation(
    Placement(visible = true, transformation(origin = {-70, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const2(k = 1)  annotation(
    Placement(visible = true, transformation(origin = {-70, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

 TAeZoSysPro.HeatTransfer.Components.FviewCalculator fviewCalculator2(N = 2)  annotation(
    Placement(visible = true, transformation(origin = {0, -30}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Sources.Constant Sa(k = 1)  annotation(
    Placement(visible = true, transformation(origin = {-70, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant Sb(k = 2)  annotation(
    Placement(visible = true, transformation(origin = {70, -20}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  TAeZoSysPro.HeatTransfer.BasesClasses.CarrollRadiation carrollRadiation_a(A = Sa.k)  annotation(
    Placement(visible = true, transformation(origin = {-30, -60}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  TAeZoSysPro.HeatTransfer.BasesClasses.CarrollRadiation carrollRadiation_b(A = Sb.k)  annotation(
    Placement(visible = true, transformation(origin = {30, -60}, extent = {{10, 10}, {-10, -10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature Ta(T = 293.15)  annotation(
    Placement(visible = true, transformation(origin = {-70, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature Tb(T = 283.15)  annotation(
    Placement(visible = true, transformation(origin = {70, -90}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Components.BodyRadiation bodyRadiation1(Gr = Sa.k)  annotation(
    Placement(visible = true, transformation(origin = {0, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  connect(const2.y, fviewCalculator1.A_wall[3]) annotation(
    Line(points = {{-58, 10}, {-40, 10}, {-40, 50}, {-10, 50}, {-10, 50}}, color = {0, 0, 127}));
  connect(const1.y, fviewCalculator1.A_wall[2]) annotation(
    Line(points = {{-58, 50}, {-10, 50}, {-10, 50}, {-10, 50}}, color = {0, 0, 127}));
  connect(const.y, fviewCalculator1.A_wall[1]) annotation(
    Line(points = {{-58, 90}, {-40, 90}, {-40, 50}, {-10, 50}, {-10, 50}}, color = {0, 0, 127}));
  connect(Sb.y, fviewCalculator2.A_wall[2]) annotation(
    Line(points = {{60, -20}, {0, -20}, {0, -20}, {0, -20}}, color = {0, 0, 127}));
  connect(Sa.y, fviewCalculator2.A_wall[1]) annotation(
    Line(points = {{-58, -20}, {-2, -20}, {-2, -20}, {0, -20}}, color = {0, 0, 127}));
  connect(fviewCalculator2.F_view[2], carrollRadiation_b.Fview) annotation(
    Line(points = {{0, -40}, {0, -40}, {0, -46}, {40, -46}, {40, -52}, {38, -52}}, color = {0, 0, 127}));
  connect(fviewCalculator2.F_view[1], carrollRadiation_a.Fview) annotation(
    Line(points = {{0, -40}, {0, -40}, {0, -46}, {-40, -46}, {-40, -52}, {-38, -52}}, color = {0, 0, 127}));
  connect(bodyRadiation1.port_b, Tb.port) annotation(
    Line(points = {{10, -90}, {58, -90}, {58, -90}, {60, -90}}, color = {191, 0, 0}));
  connect(Ta.port, bodyRadiation1.port_a) annotation(
    Line(points = {{-60, -90}, {-10, -90}, {-10, -90}, {-10, -90}}, color = {191, 0, 0}));
  connect(carrollRadiation_b.port_a, Tb.port) annotation(
    Line(points = {{40, -60}, {40, -60}, {40, -90}, {60, -90}, {60, -90}}, color = {191, 0, 0}));
  connect(carrollRadiation_a.port_b, carrollRadiation_b.port_b) annotation(
    Line(points = {{-20, -60}, {20, -60}, {20, -60}, {20, -60}}, color = {191, 0, 0}));
  connect(Ta.port, carrollRadiation_a.port_a) annotation(
    Line(points = {{-60, -90}, {-40, -90}, {-40, -60}, {-40, -60}}, color = {191, 0, 0}));
end test_FviewCalculator;
