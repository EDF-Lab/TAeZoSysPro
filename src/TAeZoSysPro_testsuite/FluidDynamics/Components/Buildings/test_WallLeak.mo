within TAeZoSysPro_testsuite.FluidDynamics.Components.Buildings;

model test_WallLeak
  TAeZoSysPro.FluidDynamics.Components.Buildings.WallLeaks wallLeaks(A = 1)  annotation(
    Placement(visible = true, transformation(origin = {-1.77636e-15, 1.77636e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  TAeZoSysPro.FluidDynamics.Sources.Atmosphere atmosphere(nPorts = 1)  annotation(
    Placement(visible = true, transformation(origin = {-60, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  TAeZoSysPro.FluidDynamics.Sources.Atmosphere atmosphere1(nPorts = 1)  annotation(
    Placement(visible = true, transformation(origin = {60, 0}, extent = {{20, -20}, {-20, 20}}, rotation = 0)));
equation
  connect(atmosphere.Fluidport[1], wallLeaks.port_a) annotation(
    Line(points = {{-60, 8}, {-40, 8}, {-40, 0}, {-20, 0}, {-20, 0}}, color = {0, 127, 255}));
  connect(atmosphere1.Fluidport[1], wallLeaks.port_b) annotation(
    Line(points = {{60, 8}, {40, 8}, {40, 0}, {20, 0}, {20, 0}}, color = {0, 127, 255}));
annotation(
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-6, Interval = 0.002));
end test_WallLeak;