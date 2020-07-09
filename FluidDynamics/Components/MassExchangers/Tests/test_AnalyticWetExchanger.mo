within TAeZoSysPro.FluidDynamics.Components.MassExchangers.Tests;

model test_AnalyticWetExchanger
  package Medium_Liq = Modelica.Media.Water.ConstantPropertyLiquidWater ; 
  TAeZoSysPro.FluidDynamics.Components.MassExchangers.AnalyticWetExchanger analyticWetExchanger(redeclare package MediumB = Medium_Liq, CrossSectionB = 1.82e-2, ExchangeSurface = 631.8, K_global = 25, hcv_A = 30, ksi_fixedA = 39.54, ksi_fixedB = 52.53) annotation(
    Placement(visible = true, transformation(origin = {-3.55271e-15, 3.55271e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Fluid.Sources.FixedBoundary Air_sink(redeclare package Medium = Modelica.Media.Air.MoistAir, nPorts = 1)  annotation(
    Placement(visible = true, transformation(origin = {-50, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Sources.FixedBoundary Water_sink(redeclare package Medium = Medium_Liq, nPorts = 1)  annotation(
    Placement(visible = true, transformation(origin = {50, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Fluid.Sources.MassFlowSource_T Water_source(redeclare package Medium = Medium_Liq, T = 273.15 + 5, m_flow = 16.69, nPorts = 1)  annotation(
    Placement(visible = true, transformation(origin = {-50, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  TAeZoSysPro.FluidDynamics.Sources.Atmosphere atmosphere(RH = 0.33, T = 308.15)  annotation(
    Placement(visible = true, transformation(origin = {-70, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Sources.MassFlowSource_T Air_source(redeclare package Medium = Modelica.Media.Air.MoistAir, T = 273.15 + 35, X = {0.011482, 1 - 0.011482}, m_flow = 13.04, nPorts = 1) annotation(
    Placement(visible = true, transformation(origin = {-10, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(Water_source.ports[1], analyticWetExchanger.port_in_B) annotation(
    Line(points = {{-40, 0}, {-20, 0}, {-20, 0}, {-20, 0}}, color = {0, 127, 255}));
  connect(analyticWetExchanger.port_out_B, Water_sink.ports[1]) annotation(
    Line(points = {{20, 0}, {40, 0}, {40, 0}, {40, 0}}, color = {0, 127, 255}));
  connect(Air_sink.ports[1], analyticWetExchanger.port_out_A) annotation(
    Line(points = {{-40, 50}, {-16, 50}, {-16, 18}, {-16, 18}}, color = {0, 127, 255}));
  connect(Air_source.ports[1], analyticWetExchanger.port_in_A) annotation(
    Line(points = {{0, -50}, {16, -50}, {16, -18}, {16, -18}}, color = {0, 127, 255}));
end test_AnalyticWetExchanger;
