within TAeZoSysPro_testsuite.FluidDynamics.BaseClasses;

model test_LiquidNode

  TAeZoSysPro.FluidDynamics.BasesClasses.LiquidNode liquidNode(V_start = 1, nPorts = 1)
    annotation (
      Placement(visible = true, transformation(origin = {-3.55271e-15, 3.55271e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  TAeZoSysPro.FluidDynamics.Sources.Boundary_p boundary_p(redeclare package Medium = Modelica.Media.Water.WaterIF97_ph, nPorts = 1)
    annotation (
      Placement(visible = true, transformation(origin = {-60, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

equation

  connect(boundary_p.ports[1], liquidNode.fluidPort[1])
    annotation (
      Line(points = {{-40, 60}, {10, 60}, {10, 18}, {10, 18}}, color = {0, 127, 255}));

end test_LiquidNode;
