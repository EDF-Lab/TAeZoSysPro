within TAeZoSysPro.FluidDynamics.Components.Orifices.Tests;

model test_VerticalOpening
  TAeZoSysPro.FluidDynamics.Components.Orifices.VerticalOpening verticalOpening annotation(
    Placement(visible = true, transformation(origin = {-1.77636e-15, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  TAeZoSysPro.FluidDynamics.Sources.Atmosphere atmosphere(T = 303.15)  annotation(
    Placement(visible = true, transformation(origin = {-80, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  TAeZoSysPro.FluidDynamics.Sources.Atmosphere atmosphere1(T = 283.15)  annotation(
    Placement(visible = true, transformation(origin = {80, 60}, extent = {{20, -20}, {-20, 20}}, rotation = 0)));
  TAeZoSysPro.FluidDynamics.Sources.Atmosphere atmosphere2(T = 101425 * 293.15 / 101325, p = 101425)  annotation(
    Placement(visible = true, transformation(origin = {-80, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  TAeZoSysPro.FluidDynamics.Components.Orifices.VerticalOpening verticalOpening1 annotation(
    Placement(visible = true, transformation(origin = {0, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  TAeZoSysPro.FluidDynamics.Sources.Atmosphere atmosphere3 annotation(
    Placement(visible = true, transformation(origin = {80, -60}, extent = {{20, -20}, {-20, 20}}, rotation = 0)));
equation
  connect(atmosphere.Flowport, verticalOpening.port_a) annotation(
    Line(points = {{-80, 60}, {-14, 60}}, color = {0, 85, 255}));
  connect(verticalOpening.port_b, atmosphere1.Flowport) annotation(
    Line(points = {{14, 60}, {80, 60}}, color = {0, 85, 255}));
  connect(atmosphere2.Flowport, verticalOpening1.port_a) annotation(
    Line(points = {{-80, -60}, {-14, -60}, {-14, -60}, {-14, -60}}, color = {0, 85, 255}));
  connect(verticalOpening1.port_b, atmosphere3.Flowport) annotation(
    Line(points = {{14, -60}, {80, -60}, {80, -60}, {80, -60}}, color = {0, 85, 255}));
end test_VerticalOpening;
