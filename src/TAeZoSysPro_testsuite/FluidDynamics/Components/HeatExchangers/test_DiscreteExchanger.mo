within TAeZoSysPro_testsuite.FluidDynamics.Components.HeatExchangers;

model test_DiscreteExchanger
  TAeZoSysPro.FluidDynamics.Components.HeatExchangers.DiscreteExchanger discreteExchanger( A = 100, CrossSectionA = 1, CrossSectionB = 1,redeclare package MediumA = Modelica.Media.Air.ReferenceAir.Air_pT, redeclare package MediumB = Modelica.Media.Air.ReferenceAir.Air_pT, N = 10, flowConfiguration = TAeZoSysPro.FluidDynamics.Components.HeatExchangers.DiscreteExchanger.FlowConfiguration.CounterCurrent)  annotation(
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Fluid.Sources.MassFlowSource_T massFlowSource_A(redeclare package Medium = Modelica.Media.Air.ReferenceAir.Air_pT, T = 30 + 273.15, m_flow = 1, nPorts = 1)  annotation(
    Placement(visible = true, transformation(origin = {-50, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Sources.MassFlowSource_T massFlowSource_B(redeclare package Medium = Modelica.Media.Air.ReferenceAir.Air_pT, T = 10 + 273.15, m_flow = 1, nPorts = 1)  annotation(
    Placement(visible = true, transformation(origin = {-10, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Sources.FixedBoundary boundary(redeclare package Medium = Modelica.Media.Air.ReferenceAir.Air_pT, nPorts = 2)  annotation(
    Placement(visible = true, transformation(origin = {50, 50}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
equation
  connect(massFlowSource_A.ports[1], discreteExchanger.port_A_in) annotation(
    Line(points = {{-40, 0}, {-22, 0}, {-22, 0}, {-20, 0}}, color = {0, 127, 255}));
  connect(massFlowSource_B.ports[1], discreteExchanger.port_B_in) annotation(
    Line(points = {{0, -50}, {14, -50}, {14, -16}, {14, -16}}, color = {0, 127, 255}));
  connect(boundary.ports[1], discreteExchanger.port_B_out) annotation(
    Line(points = {{40, 50}, {-14, 50}, {-14, 16}, {-14, 16}}, color = {0, 127, 255}));
  connect(discreteExchanger.port_A_out, boundary.ports[2]) annotation(
    Line(points = {{20, 0}, {40, 0}, {40, 50}, {40, 50}}, color = {0, 127, 255}));
annotation(
    experiment(StartTime = 0, StopTime = 10, Tolerance = 1e-6, Interval = 0.1));
end test_DiscreteExchanger;
