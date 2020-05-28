within TAeZoSysPro.FluidDynamics.Components.Orifices.Tests;

model test_HorizontalOpening
  TAeZoSysPro.FluidDynamics.Components.Orifices.HorizontalOpening horizontalOpening(L_down = 0) annotation(
    Placement(visible = true, transformation(origin = {-60, 4.44089e-16}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  /*replaceable package Medium = Modelica.Media.Air.SimpleAir, */
  TAeZoSysPro.FluidDynamics.Sources.Atmosphere atmosphere(RH = 0) annotation(
    Placement(visible = true, transformation(origin = {-80, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  /*replaceable package Medium = Modelica.Media.Air.SimpleAir*/
  TAeZoSysPro.FluidDynamics.BasesClasses.GasNode gasNode(RH_start = 0,T_start = 323.15, p_start = 101337) annotation(
    Placement(visible = true, transformation(origin = {-40, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  /*replaceable package Medium = Modelica.Media.Air.SimpleAir, */
equation
  connect(atmosphere.Flowport, horizontalOpening.port_a) annotation(
    Line(points = {{-80, 60}, {-60, 60}, {-60, 14}}, color = {0, 85, 255}));
  connect(horizontalOpening.port_b, gasNode.flowPort) annotation(
    Line(points = {{-60, -14}, {-60, -14}, {-60, -60}, {-44, -60}, {-44, -60}}, color = {0, 85, 255}));
end test_HorizontalOpening;
