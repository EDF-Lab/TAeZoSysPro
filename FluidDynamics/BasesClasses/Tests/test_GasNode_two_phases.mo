within TAeZoSysPro.FluidDynamics.BasesClasses.Tests;

model test_GasNode_two_phases
  TAeZoSysPro.FluidDynamics.BasesClasses.GasNode_two_phases gasNode_two_phases(RH_start = 0.9, T_start = 303.15)  annotation(
    Placement(visible = true, transformation(origin = {-3.55271e-15, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow(Q_flow = -100)  annotation(
    Placement(visible = true, transformation(origin = {-70, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  TAeZoSysPro.FluidDynamics.BasesClasses.GasNode_two_phases gasNode_two_phases1(RH_start = 1.0, T_start = 293.15, nPorts = 1) annotation(
    Placement(visible = true, transformation(origin = {0, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Fluid.Sources.MassFlowSource_T boundary(redeclare package Medium = Modelica.Media.Air.MoistAir, T = 293.15, X = {0.999, 0.001}, m_flow = 1e-3, nPorts = 1)  annotation(
    Placement(visible = true, transformation(origin = {-70, -32}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(fixedHeatFlow.port, gasNode_two_phases.heatPort) annotation(
    Line(points = {{-60, 50}, {-4, 50}, {-4, 52}, {-4, 52}}, color = {191, 0, 0}));
  connect(boundary.ports[1], gasNode_two_phases1.fluidPort[1]) annotation(
    Line(points = {{-60, -32}, {-2, -32}, {-2, -32}, {-4, -32}}, color = {0, 127, 255}));
end test_GasNode_two_phases;
