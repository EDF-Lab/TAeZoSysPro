within TAeZoSysPro.HeatTransfer.Components.Tests;

model test_FanVentilation
  TAeZoSysPro.HeatTransfer.Components.FanVentilation fanVentilation1(Q_flow_aero_nominal = 1000, Use_External_MassFlow = true, V_flow_nominal = 1)  annotation(
    Placement(visible = true, transformation(origin = { 0, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  TAeZoSysPro.HeatTransfer.Components.FanVentilation fanVentilation2(Q_flow_aero_nominal = 1000, Use_External_MassFlow = false, V_flow_nominal = 1)  annotation(
    Placement(visible = true, transformation(origin = {0, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature T_in(T = 303.15)  annotation(
    Placement(visible = true, transformation(origin = {-70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature T_source(T = 293.15)  annotation(
    Placement(visible = true, transformation(origin = {70, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant m_flow(k = 1)  annotation(
    Placement(visible = true, transformation(origin = {-70, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant V_flow(k = 1 / 1.164) annotation(
    Placement(visible = true, transformation(origin = {-70, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow1(Q_flow = 0)  annotation(
    Placement(visible = true, transformation(origin = {70, -50}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));

equation
  connect(fanVentilation2.port_b, fixedHeatFlow1.port) annotation(
    Line(points = {{10, -50}, {60, -50}, {60, -50}, {60, -50}}, color = {191, 0, 0}));
  connect(V_flow.y, fanVentilation2.V_flow_input) annotation(
    Line(points = {{-58, -70}, {-20, -70}, {-20, -58}, {-10, -58}, {-10, -58}}, color = {0, 0, 127}));
  connect(T_in.port, fanVentilation2.port_a) annotation(
    Line(points = {{-60, 0}, {-40, 0}, {-40, -50}, {-10, -50}}, color = {191, 0, 0}));
  connect(m_flow.y, fanVentilation1.m_flow_input) annotation(
    Line(points = {{-58, 90}, {-20, 90}, {-20, 60}, {-10, 60}, {-10, 58}}, color = {0, 0, 127}));
  connect(fanVentilation1.port_b, T_source.port) annotation(
    Line(points = {{10, 50}, {40, 50}, {40, 0}, {60, 0}, {60, 0}}, color = {191, 0, 0}));
  connect(T_in.port, fanVentilation1.port_a) annotation(
    Line(points = {{-60, 0}, {-40, 0}, {-40, 50}, {-10, 50}, {-10, 50}}, color = {191, 0, 0}));
end test_FanVentilation;
