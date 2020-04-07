within TAeZoSysPro.HeatTransfer.Components.Tests;

model test_HeatExchanger
  TAeZoSysPro.HeatTransfer.Components.HeatExchanger heatExchanger1(
    replaceable package MediumA = Modelica.Media.Water.ConstantPropertyLiquidWater, 
    redeclare function heatTransferCoeff = TAeZoSysPro.HeatTransfer.Functions.    ExchangerHeatTransferCoeff.user_defined(h_in = 10.0)) annotation(
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature T_water_in(T = 278.15)  annotation(
    Placement(visible = true, transformation(origin = {-70, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature T_air_in(T = 308.15) annotation(
    Placement(visible = true, transformation(origin = {50, -50}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant m_flow_water(k = 1)  annotation(
    Placement(visible = true, transformation(origin = {-70, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant m_flow_air(k = 5)  annotation(
    Placement(visible = true, transformation(origin = {-10, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(m_flow_air.y, heatExchanger1.m_flowB) annotation(
    Line(points = {{2, -50}, {8, -50}, {8, -18}, {8, -18}}, color = {0, 0, 127}));
  connect(m_flow_water.y, heatExchanger1.m_flowA) annotation(
    Line(points = {{-58, -30}, {-40, -30}, {-40, -6}, {-20, -6}, {-20, -6}}, color = {0, 0, 127}));
  connect(T_water_in.port, heatExchanger1.port_A_in) annotation(
    Line(points = {{-60, 30}, {-40, 30}, {-40, 0}, {-20, 0}}, color = {191, 0, 0}));
  connect(T_air_in.port, heatExchanger1.port_B_in) annotation(
    Line(points = {{40, -50}, {14, -50}, {14, -18}, {14, -18}}, color = {191, 0, 0}));
end test_HeatExchanger;
