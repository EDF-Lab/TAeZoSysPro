within TAeZoSysPro.FluidDynamics.BasesClasses.Tests;

model test_Interface_liq_gas
  TAeZoSysPro.FluidDynamics.BasesClasses.Interface_liq_gas interFace_liq_gas(A = 1)  annotation(
    Placement(visible = true, transformation(origin = {-3.55271e-15, 3.33067e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature T_interface(T = 278.15)  annotation(
    Placement(visible = true, transformation(origin = {-70, -52}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  TAeZoSysPro.FluidDynamics.Sources.Atmosphere atmosphere annotation(
    Placement(visible = true, transformation(origin = {-40, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant F_view(k = 1)  annotation(
    Placement(visible = true, transformation(origin = {50, 30}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Fluid.Sources.FixedBoundary boundary(redeclare package Medium = Modelica.Media.Water.StandardWater, nPorts = 1)  annotation(
    Placement(visible = true, transformation(origin = {50, -52}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
equation
  connect(T_interface.port, interFace_liq_gas.heatPort_a) annotation(
    Line(points = {{-60, -52}, {-12, -52}, {-12, -18}, {-12, -18}}, color = {191, 0, 0}));
  connect(atmosphere.Heatport, interFace_liq_gas.port_rad) annotation(
    Line(points = {{-40, 52}, {-14, 52}, {-14, 18}, {-14, 18}}, color = {191, 0, 0}));
  connect(atmosphere.Flowport, interFace_liq_gas.flowPort_b) annotation(
    Line(points = {{-40, 60}, {14, 60}, {14, 18}, {14, 18}}, color = {0, 85, 255}));
  connect(F_view.y, interFace_liq_gas.F_view) annotation(
    Line(points = {{40, 30}, {-2, 30}, {-2, 18}, {-2, 18}}, color = {0, 0, 127}));
  connect(boundary.ports[1], interFace_liq_gas.fluidPort_a) annotation(
    Line(points = {{40, -52}, {12, -52}, {12, -18}, {12, -18}}, color = {0, 127, 255}));  

end test_Interface_liq_gas;
