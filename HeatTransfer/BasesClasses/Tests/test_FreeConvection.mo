within TAeZoSysPro.HeatTransfer.BasesClasses.Tests;

model test_FreeConvection
  TAeZoSysPro.HeatTransfer.BasesClasses.FreeConvection freeConvection1(A = 1, Lc = 1, correlation = TAeZoSysPro.HeatTransfer.Types.FreeConvectionCorrelation.vertical_plate_ASHRAE)  annotation(
    Placement(visible = true, transformation(origin = {0, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature T_wall(T = 303.15)  annotation(
    Placement(visible = true, transformation(origin = {-50, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature T_fluid(T = 293.15)  annotation(
    Placement(visible = true, transformation(origin = {50, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  TAeZoSysPro.HeatTransfer.BasesClasses.FreeConvection freeConvection2(A = 1, Lc = 1, correlation = TAeZoSysPro.HeatTransfer.Types.FreeConvectionCorrelation.vertical_plate_ASHRAE)  annotation(
    Placement(visible = true, transformation(origin = {0, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow1(Q_flow = 32)  annotation(
    Placement(visible = true, transformation(origin = {-50, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  TAeZoSysPro.HeatTransfer.BasesClasses.FreeConvection freeConvection3(A = 1, Lc = 1, correlation = TAeZoSysPro.HeatTransfer.Types.FreeConvectionCorrelation.vertical_plate_Recknagel) annotation(
    Placement(visible = true, transformation(origin = {0, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  TAeZoSysPro.HeatTransfer.BasesClasses.FreeConvection freeConvection4(A = 1, Lc = 1, correlation = TAeZoSysPro.HeatTransfer.Types.FreeConvectionCorrelation.ground_ASHRAE) annotation(
    Placement(visible = true, transformation(origin = {0, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  TAeZoSysPro.HeatTransfer.BasesClasses.FreeConvection freeConvection5(A = 1, Lc = 1, correlation = TAeZoSysPro.HeatTransfer.Types.FreeConvectionCorrelation.ceiling_ASHRAE) annotation(
    Placement(visible = true, transformation(origin = {0, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  TAeZoSysPro.HeatTransfer.BasesClasses.FreeConvection freeConvection6(A = 1, Lc = 1, correlation = TAeZoSysPro.HeatTransfer.Types.FreeConvectionCorrelation.horizontal_cylinder_ASHRAE) annotation(
    Placement(visible = true, transformation(origin = {0, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  TAeZoSysPro.HeatTransfer.BasesClasses.FreeConvection freeConvection7(A = 1, Lc = 1, correlation = TAeZoSysPro.HeatTransfer.Types.FreeConvectionCorrelation.Constant, h_cv_const = 10)  annotation(
    Placement(visible = true, transformation(origin = {0, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(freeConvection7.port_b, T_fluid.port) annotation(
    Line(points = {{10, -10}, {30, -10}, {30, 0}, {40, 0}, {40, 0}}, color = {191, 0, 0}));
  connect(freeConvection7.port_a, T_wall.port) annotation(
    Line(points = {{-10, -10}, {-30, -10}, {-30, 50}, {-40, 50}, {-40, 50}}, color = {191, 0, 0}));
  connect(freeConvection6.port_b, T_fluid.port) annotation(
    Line(points = {{10, 10}, {30, 10}, {30, 0}, {40, 0}, {40, 0}}, color = {191, 0, 0}));
  connect(freeConvection5.port_b, T_fluid.port) annotation(
    Line(points = {{10, 30}, {30, 30}, {30, 0}, {40, 0}, {40, 0}}, color = {191, 0, 0}));
  connect(freeConvection4.port_b, T_fluid.port) annotation(
    Line(points = {{10, 50}, {30, 50}, {30, 0}, {40, 0}, {40, 0}}, color = {191, 0, 0}));
  connect(freeConvection3.port_b, T_fluid.port) annotation(
    Line(points = {{10, 70}, {30, 70}, {30, 0}, {40, 0}, {40, 0}}, color = {191, 0, 0}));
  connect(T_wall.port, freeConvection6.port_a) annotation(
    Line(points = {{-40, 50}, {-30, 50}, {-30, 10}, {-10, 10}, {-10, 10}}, color = {191, 0, 0}));
  connect(T_wall.port, freeConvection5.port_a) annotation(
    Line(points = {{-40, 50}, {-30, 50}, {-30, 30}, {-10, 30}, {-10, 30}}, color = {191, 0, 0}));
  connect(T_wall.port, freeConvection4.port_a) annotation(
    Line(points = {{-40, 50}, {-10, 50}, {-10, 50}, {-10, 50}}, color = {191, 0, 0}));
  connect(T_wall.port, freeConvection3.port_a) annotation(
    Line(points = {{-40, 50}, {-30, 50}, {-30, 70}, {-10, 70}, {-10, 70}}, color = {191, 0, 0}));
  connect(T_wall.port, freeConvection1.port_a) annotation(
    Line(points = {{-40, 50}, {-30, 50}, {-30, 90}, {-10, 90}, {-10, 90}}, color = {191, 0, 0}));
  connect(freeConvection1.port_b, T_fluid.port) annotation(
    Line(points = {{10, 90}, {30, 90}, {30, 0}, {40, 0}}, color = {191, 0, 0}));
  connect(fixedHeatFlow1.port, freeConvection2.port_a) annotation(
    Line(points = {{-40, -50}, {-10, -50}, {-10, -50}, {-10, -50}}, color = {191, 0, 0}));
  connect(freeConvection2.port_b, T_fluid.port) annotation(
    Line(points = {{10, -50}, {30, -50}, {30, 0}, {40, 0}, {40, 0}}, color = {191, 0, 0}));
end test_FreeConvection;
