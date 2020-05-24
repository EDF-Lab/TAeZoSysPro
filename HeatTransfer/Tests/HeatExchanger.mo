within TAeZoSysPro.HeatTransfer.Tests;

model HeatExchanger
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature TA_in(T = 278.15) annotation(
    Placement(visible = true, transformation(origin = {-50, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature TB_in(T = 293.15) annotation(
    Placement(visible = true, transformation(origin = {-30, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  TAeZoSysPro.HeatTransfer.BasesClasses.HeatExchanger heatExchanger1(A = 100) annotation(
    Placement(visible = true, transformation(origin = {4, 3.55271e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant QV_A(k = 1) annotation(
    Placement(visible = true, transformation(origin = {-50, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Ramp QV_B(duration = 1, height = 1 / 1000) annotation(
    Placement(visible = true, transformation(origin = {30, 50}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant Kex(k = 10)  annotation(
    Placement(visible = true, transformation(origin = {-6, -52}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Aeraulic.BasesClasses.dropwiseCondensation dropwiseCondensation1 annotation(
    Placement(visible = true, transformation(origin = {-92, 48}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(Kex.y, heatExchanger1.K_overall) annotation(
    Line(points = {{6, -52}, {14, -52}, {14, -16}, {14, -16}}, color = {0, 0, 127}));
  connect(QV_A.y, heatExchanger1.Qv_fluidA) annotation(
    Line(points = {{-38, -30}, {-30, -30}, {-30, -14}, {-10, -14}, {-10, -13}}, color = {0, 0, 127}));
  connect(QV_B.y, heatExchanger1.Qv_fluidB) annotation(
    Line(points = {{20, 50}, {-10, 50}, {-10, 13}}, color = {0, 0, 127}));
  connect(TA_in.port, heatExchanger1.port_in_FluidA) annotation(
    Line(points = {{-40, 0}, {-14, 0}}, color = {191, 0, 0}));
  connect(TB_in.port, heatExchanger1.port_in_FluidB) annotation(
    Line(points = {{-20, 50}, {-8, 50}, {-8, 18}}, color = {191, 0, 0}));
end HeatExchanger;
