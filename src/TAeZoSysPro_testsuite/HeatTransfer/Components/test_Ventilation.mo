within TAeZoSysPro_testsuite.HeatTransfer.Components;

model test_Ventilation

  TAeZoSysPro.HeatTransfer.Components.Ventilation ventilation1(Use_External_MassFlow = true)
    annotation (
      Placement(visible = true, transformation(origin = {0, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  TAeZoSysPro.HeatTransfer.Components.Ventilation ventilation2(Use_External_MassFlow = false)
    annotation (
      Placement(visible = true, transformation(origin = {0, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature T_in(T = 303.15)
    annotation (
      Placement(visible = true, transformation(origin = {-70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature T_source(T = 293.15)
    annotation (
      Placement(visible = true, transformation(origin = {70, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant m_flow(k = 1)
    annotation (
      Placement(visible = true, transformation(origin = {-70, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant V_flow(k = 1 / 1.164)
    annotation (
      Placement(visible = true, transformation(origin = {-70, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow1(Q_flow = 0)
    annotation (
      Placement(visible = true, transformation(origin = {70, -50}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));

equation

  connect(m_flow.y, ventilation1.m_flow_in)
    annotation (
      Line(points = {{-58, 90}, {-34, 90}, {-34, 58}, {-10, 58}, {-10, 58}}, color = {0, 0, 127}));
  connect(T_in.port, ventilation1.port_a)
    annotation (
      Line(points = {{-60, 0}, {-22, 0}, {-22, 50}, {-10, 50}, {-10, 50}}, color = {191, 0, 0}));
  connect(T_in.port, ventilation2.port_a)
    annotation (
      Line(points = {{-60, 0}, {-22, 0}, {-22, -50}, {-10, -50}, {-10, -50}}, color = {191, 0, 0}));
  connect(V_flow.y, ventilation2.V_flow_in)
    annotation (
      Line(points = {{-58, -70}, {-34, -70}, {-34, -58}, {-10, -58}, {-10, -58}}, color = {0, 0, 127}));
  connect(ventilation1.port_b, T_source.port)
    annotation (
      Line(points = {{10, 50}, {34, 50}, {34, 0}, {60, 0}, {60, 0}}, color = {191, 0, 0}));
  connect(ventilation2.port_b, fixedHeatFlow1.port)
    annotation (
      Line(points = {{10, -50}, {60, -50}, {60, -50}, {60, -50}}, color = {191, 0, 0}));

  annotation (
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-6, Interval = 0.002));

end test_Ventilation;
