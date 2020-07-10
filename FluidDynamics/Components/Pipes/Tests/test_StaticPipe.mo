within TAeZoSysPro.FluidDynamics.Components.Pipes.Tests;

model test_StaticPipe
  TAeZoSysPro.FluidDynamics.Sources.Atmosphere atmosphere(p = 114250)  annotation(
    Placement(visible = true, transformation(origin = {-80, 3.55271e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  TAeZoSysPro.FluidDynamics.Sources.Atmosphere atmosphere1(nPorts = 1)  annotation(
    Placement(visible = true, transformation(origin = {80, 0}, extent = {{20, -20}, {-20, 20}}, rotation = 0)));
  TAeZoSysPro.FluidDynamics.Components.Pipes.StaticPipe pipe(A = 1, ksi = 10)  annotation(
    Placement(visible = true, transformation(origin = {-3.55271e-15, 3.55271e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
equation
  connect(atmosphere.Fluidport[1], pipe.port_a) annotation(
    Line(points = {{-80, 8}, {-60, 8}, {-60, 0}, {-20, 0}, {-20, 0}}, color = {0, 127, 255}));
  connect(pipe.port_b, atmosphere1.Fluidport[1]) annotation(
    Line(points = {{20, 0}, {60, 0}, {60, 8}, {80, 8}, {80, 8}}, color = {0, 127, 255}));
end test_StaticPipe;
