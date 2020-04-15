within TAeZoSysPro.FluidDynamics.BasesClasses.Tests;

model test_GasNode
  TAeZoSysPro.FluidDynamics.BasesClasses.GasNode gasNode(nPorts = 1)  annotation(
    Placement(visible = true, transformation(origin = {-3.55271e-15, 3.55271e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Fluid.Sources.MassFlowSource_T boundary(redeclare package Medium = Modelica.Media.Air.MoistAir, m_flow = 0.001, nPorts = 1)  annotation(
    Placement(visible = true, transformation(origin = {-62, 4}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
equation
  connect(boundary.ports[1], gasNode.fluidPort[1]) annotation(
    Line(points = {{-42, 4}, {-4, 4}, {-4, 4}, {-4, 4}}, color = {0, 127, 255}));
end test_GasNode;
