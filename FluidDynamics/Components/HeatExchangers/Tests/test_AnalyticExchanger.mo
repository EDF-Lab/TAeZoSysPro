within TAeZoSysPro.FluidDynamics.Components.HeatExchangers.Tests;

model test_AnalyticExchanger
  TAeZoSysPro.FluidDynamics.Components.HeatExchangers.AnalyticExchanger analyticExchanger(A = 100,CrossSectionA = 1, CrossSectionB = 1)  annotation(
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Fluid.Sources.MassFlowSource_T massFlowSource_A(redeclare package Medium = Modelica.Media.Air.ReferenceAir.Air_pT, T = 30 + 273.15, m_flow = 1, nPorts = 1)  annotation(
    Placement(visible = true, transformation(origin = {-50, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Sources.MassFlowSource_T massFlowSource_B(redeclare package Medium = Modelica.Media.Air.ReferenceAir.Air_pT, T = 10 + 273.15, m_flow = 1, nPorts = 1)  annotation(
    Placement(visible = true, transformation(origin = {-10, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Sources.FixedBoundary boundary(redeclare package Medium = Modelica.Media.Air.ReferenceAir.Air_pT, nPorts = 2)  annotation(
    Placement(visible = true, transformation(origin = {50, 50}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
equation
  connect(massFlowSource_B.ports[1], analyticExchanger.port_B_in) annotation(
    Line(points = {{0, -50}, {14, -50}, {14, -16}, {14, -16}}, color = {0, 127, 255}));
  connect(massFlowSource_A.ports[1], analyticExchanger.port_A_in) annotation(
    Line(points = {{-40, 0}, {-20, 0}, {-20, 0}, {-20, 0}}, color = {0, 127, 255}));
  connect(analyticExchanger.port_B_out, boundary.ports[1]) annotation(
    Line(points = {{-14, 16}, {-14, 16}, {-14, 50}, {40, 50}, {40, 50}}, color = {0, 127, 255}));
  connect(analyticExchanger.port_A_out, boundary.ports[2]) annotation(
    Line(points = {{20, 0}, {40, 0}, {40, 50}, {40, 50}}, color = {0, 127, 255}));
end test_AnalyticExchanger;
