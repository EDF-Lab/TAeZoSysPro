within TAeZoSysPro_testsuite.FluidDynamics.Components.Buildings;

model test_BurstMembrane
  TAeZoSysPro.FluidDynamics.Sources.Atmosphere atmosphere(use_p_in = true, nPorts=1)  annotation (
    Placement(visible = true, transformation(origin = {-40, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  TAeZoSysPro.FluidDynamics.Sources.Atmosphere atmosphere1(nPorts = 1)  annotation(
    Placement(visible = true, transformation(origin = {80, 0}, extent = {{20, -20}, {-20, 20}}, rotation = 0)));
  TAeZoSysPro.FluidDynamics.Components.Pipes.StaticPipe staticPipe(A = 0.1)  annotation(
    Placement(visible = true, transformation(origin = {40, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  TAeZoSysPro.FluidDynamics.Components.Buildings.BurstMembrane burstMembrane(dp_burst(displayUnit = "Pa") = 100)  annotation(
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Trapezoid pressure_profile(amplitude = 110, falling = 0.5, nperiod = 1, offset = 101325, period = 1.5, rising = 0.5, width = 0)  annotation(
    Placement(visible = true, transformation(origin = {-90, 12}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(staticPipe.port_b, atmosphere1.Fluidport[1]) annotation(
    Line(points = {{50, 0}, {60, 0}, {60, 8}, {80, 8}, {80, 8}}, color = {0, 127, 255}));
  connect(atmosphere.Fluidport[1], burstMembrane.port_a) annotation(
    Line(points = {{-40, 8}, {-20, 8}, {-20, 0}, {-10, 0}, {-10, 0}}, color = {0, 127, 255}));
  connect(burstMembrane.port_b, staticPipe.port_a) annotation(
    Line(points = {{10, 0}, {30, 0}, {30, 0}, {30, 0}}, color = {0, 127, 255}));
  connect(pressure_profile.y, atmosphere.p_in) annotation(
    Line(points = {{-78, 12}, {-60, 12}, {-60, 12}, {-58, 12}}, color = {0, 0, 127}));
annotation(
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-6, Interval = 0.002));
end test_BurstMembrane;