within TAeZoSysPro.FluidDynamics.BasesClasses.Tests;

model test_GasNode_two_phases
  TAeZoSysPro.FluidDynamics.BasesClasses.GasNode_two_phases gasNode_two_phases(RH_start = 0.9, T_start = 303.15)  annotation(
    Placement(visible = true, transformation(origin = {-3.55271e-15, 20}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow(Q_flow = -500)  annotation(
    Placement(visible = true, transformation(origin = {-50, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(fixedHeatFlow.port, gasNode_two_phases.heatPort) annotation(
    Line(points = {{-40, -30}, {-4, -30}, {-4, 12}, {-4, 12}}, color = {191, 0, 0}));
end test_GasNode_two_phases;
