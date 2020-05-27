within TAeZoSysPro.FluidDynamics.Components.Orifices.Tests;

model test_VerticalOpening
  TAeZoSysPro.FluidDynamics.Components.Orifices.VerticalOpening verticalOpening annotation(
    Placement(visible = true, transformation(origin = {-1.77636e-15, 1.77636e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  TAeZoSysPro.FluidDynamics.Sources.Atmosphere atmosphere(T = 303.15)  annotation(
    Placement(visible = true, transformation(origin = {-80, 3.10862e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  TAeZoSysPro.FluidDynamics.Sources.Atmosphere atmosphere1(T = 283.15)  annotation(
    Placement(visible = true, transformation(origin = {80, 0}, extent = {{20, -20}, {-20, 20}}, rotation = 0)));
equation
  connect(atmosphere.Flowport, verticalOpening.port_a) annotation(
    Line(points = {{-80, 0}, {-14, 0}, {-14, 0}, {-14, 0}}, color = {0, 85, 255}));
  connect(verticalOpening.port_b, atmosphere1.Flowport) annotation(
    Line(points = {{14, 0}, {80, 0}, {80, 0}, {80, 0}}, color = {0, 85, 255}));
end test_VerticalOpening;
