within TAeZoSysPro.FluidDynamics.Components.Orifices.Tests;

model test_SimpleOpening
  TAeZoSysPro.FluidDynamics.Components.Orifices.SimpleOpening simpleOpening annotation(
    Placement(visible = true, transformation(origin = {-3.55271e-15, 3.55271e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  TAeZoSysPro.FluidDynamics.Sources.Atmosphere atmosphere(p = 101425)  annotation(
    Placement(visible = true, transformation(origin = {-80, 3.55271e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  TAeZoSysPro.FluidDynamics.Sources.Atmosphere atmosphere1 annotation(
    Placement(visible = true, transformation(origin = {80, 0}, extent = {{20, -20}, {-20, 20}}, rotation = 0)));
equation
  connect(atmosphere.Flowport, simpleOpening.port_a) annotation(
    Line(points = {{-80, 0}, {-14, 0}}, color = {0, 85, 255}));
  connect(simpleOpening.port_b, atmosphere1.Flowport) annotation(
    Line(points = {{14, 0}, {80, 0}}, color = {0, 85, 255}));
end test_SimpleOpening;
