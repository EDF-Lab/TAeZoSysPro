within TAeZoSysPro.HeatTransfer.BasesClasses.Tests;

model test_ForcedConvection
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature T_wall(T = 303.15)  annotation(
    Placement(visible = true, transformation(origin = {-50, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature T_fluid(T = 293.15)  annotation(
    Placement(visible = true, transformation(origin = {70, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow1(Q_flow = 383)  annotation(
    Placement(visible = true, transformation(origin = {-50, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  TAeZoSysPro.HeatTransfer.BasesClasses.ForcedConvection forcedConvection1(A = 1, Lc = 1, correlation = TAeZoSysPro.HeatTransfer.Types.ForcedConvectionCorrelation.flat_plate_ASHRAE)  annotation(
    Placement(visible = true, transformation(origin = {0, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  TAeZoSysPro.HeatTransfer.BasesClasses.ForcedConvection forcedConvection2(A = 1, Lc = 1, correlation = TAeZoSysPro.HeatTransfer.Types.ForcedConvectionCorrelation.crossFlow_cylinder_ASHRAE)  annotation(
    Placement(visible = true, transformation(origin = {0, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  TAeZoSysPro.HeatTransfer.BasesClasses.ForcedConvection forcedConvection3(A = 1, Lc = 1, correlation = TAeZoSysPro.HeatTransfer.Types.ForcedConvectionCorrelation.internal_pipe_ASHRAE)  annotation(
    Placement(visible = true, transformation(origin = {0, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  TAeZoSysPro.HeatTransfer.BasesClasses.ForcedConvection forcedConvection4(A = 1, Lc = 1, correlation = TAeZoSysPro.HeatTransfer.Types.ForcedConvectionCorrelation.Constant, h_cv_const = 100)  annotation(
    Placement(visible = true, transformation(origin = {0, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  TAeZoSysPro.HeatTransfer.BasesClasses.ForcedConvection forcedConvection5(A = 1)  annotation(
    Placement(visible = true, transformation(origin = {0, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant Velocity(k = 10)  annotation(
    Placement(visible = true, transformation(origin = {70, 90}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
equation
  connect(Velocity.y, forcedConvection5.Vel) annotation(
    Line(points = {{58, 90}, {50, 90}, {50, -40}, {6, -40}, {6, -42}}, color = {0, 0, 127}));
  connect(forcedConvection5.port_b, T_fluid.port) annotation(
    Line(points = {{10, -50}, {30, -50}, {30, 0}, {60, 0}}, color = {191, 0, 0}));
  connect(forcedConvection4.port_b, T_fluid.port) annotation(
    Line(points = {{10, 10}, {30, 10}, {30, 0}, {60, 0}}, color = {191, 0, 0}));
  connect(forcedConvection3.port_b, T_fluid.port) annotation(
    Line(points = {{10, 30}, {30, 30}, {30, 0}, {60, 0}}, color = {191, 0, 0}));
  connect(forcedConvection2.port_b, T_fluid.port) annotation(
    Line(points = {{10, 50}, {30, 50}, {30, 0}, {60, 0}}, color = {191, 0, 0}));
  connect(forcedConvection1.port_b, T_fluid.port) annotation(
    Line(points = {{10, 70}, {30, 70}, {30, 0}, {60, 0}}, color = {191, 0, 0}));
  connect(Velocity.y, forcedConvection4.Vel) annotation(
    Line(points = {{58, 90}, {50, 90}, {50, 20}, {6, 20}, {6, 18}}, color = {0, 0, 127}));
  connect(Velocity.y, forcedConvection3.Vel) annotation(
    Line(points = {{58, 90}, {50, 90}, {50, 40}, {6, 40}, {6, 38}}, color = {0, 0, 127}));
  connect(Velocity.y, forcedConvection2.Vel) annotation(
    Line(points = {{58, 90}, {50, 90}, {50, 60}, {6, 60}, {6, 58}}, color = {0, 0, 127}));
  connect(Velocity.y, forcedConvection1.Vel) annotation(
    Line(points = {{59, 90}, {4, 90}, {4, 78}, {6, 78}}, color = {0, 0, 127}));
  connect(fixedHeatFlow1.port, forcedConvection5.port_a) annotation(
    Line(points = {{-40, -50}, {-10, -50}, {-10, -50}, {-10, -50}}, color = {191, 0, 0}));
  connect(T_wall.port, forcedConvection4.port_a) annotation(
    Line(points = {{-40, 50}, {-30, 50}, {-30, 10}, {-10, 10}, {-10, 10}}, color = {191, 0, 0}));
  connect(T_wall.port, forcedConvection3.port_a) annotation(
    Line(points = {{-40, 50}, {-30, 50}, {-30, 30}, {-10, 30}, {-10, 30}}, color = {191, 0, 0}));
  connect(T_wall.port, forcedConvection2.port_a) annotation(
    Line(points = {{-40, 50}, {-10, 50}, {-10, 50}, {-10, 50}}, color = {191, 0, 0}));
  connect(T_wall.port, forcedConvection1.port_a) annotation(
    Line(points = {{-40, 50}, {-30, 50}, {-30, 70}, {-10, 70}, {-10, 70}}, color = {191, 0, 0}));
annotation(
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-6, Interval = 0.1));end test_ForcedConvection;
