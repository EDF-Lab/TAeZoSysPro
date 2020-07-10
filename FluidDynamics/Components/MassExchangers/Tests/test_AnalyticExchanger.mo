within TAeZoSysPro.FluidDynamics.Components.MassExchangers.Tests;

model test_AnalyticExchanger
  TAeZoSysPro.FluidDynamics.Components.MassExchangers.AnalyticWetExchanger analyticWetExchanger(MediumB = Modelica.Media.Water.StandardWaterOnePhase)  annotation(
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Fluid.Sources.FixedBoundary Water_sink(Medium = Modelica.Media.Water.WaterIF97_ph, nPorts = 1)  annotation(
    Placement(visible = true, transformation(origin = {50, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Fluid.Sources.FixedBoundary Air_sink(Medium = Modelica.Media.Water.StandardWaterOnePhase)  annotation(
    Placement(visible = true, transformation(origin = {10, 50}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Fluid.Sources.MassFlowSource_T Water_source(Medium = Modelica.Media.Water.WaterIF97_ph, T = 273.15 + 5, m_flow = 1)  annotation(
    Placement(visible = true, transformation(origin = {-50, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Sources.MassFlowSource_T Air_source(Medium = Modelica.Media.Water.StandardWaterOnePhase, T = 273.15 + 30, m_flow = 10)  annotation(
    Placement(visible = true, transformation(origin = {-10, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(Air_source.ports[1], analyticWetExchanger.port_in_A) annotation(
    Line(points = {{0, -50}, {16, -50}, {16, -18}, {16, -18}}, color = {0, 127, 255}));
  connect(Air_sink.ports[1], analyticWetExchanger.port_out_A) annotation(
    Line(points = {{0, 50}, {-16, 50}, {-16, 18}, {-16, 18}}, color = {0, 127, 255}));
  connect(Water_source.ports[1], analyticWetExchanger.port_in_B) annotation(
    Line(points = {{-40, 0}, {-22, 0}, {-22, 0}, {-20, 0}}, color = {0, 127, 255}));
  connect(analyticWetExchanger.port_out_B, Water_sink.ports[1]) annotation(
    Line(points = {{20, 0}, {40, 0}, {40, 0}, {40, 0}}, color = {0, 127, 255}));
end test_AnalyticExchanger;
