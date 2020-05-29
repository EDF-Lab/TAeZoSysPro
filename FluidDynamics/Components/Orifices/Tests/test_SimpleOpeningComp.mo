within TAeZoSysPro.FluidDynamics.Components.Orifices.Tests;

model test_SimpleOpeningComp

  TAeZoSysPro.FluidDynamics.Components.Orifices.SimpleOpeningComp simpleOpeningComp annotation(
    Placement(visible = true, transformation(origin = {20, 3.55271e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  TAeZoSysPro.FluidDynamics.Sources.Atmosphere atmosphere(RH = 0,T = 373.15, use_p_in = true)  annotation(
    Placement(visible = true, transformation(origin = {-40, 3.55271e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  TAeZoSysPro.FluidDynamics.Sources.Atmosphere atmosphere1 annotation(
    Placement(visible = true, transformation(origin = {80, 0}, extent = {{20, -20}, {-20, 20}}, rotation = 0)));
  Modelica.Blocks.Sources.Ramp pressureProfile(duration = 10, height = 101225, offset = 101425)  annotation(
    Placement(visible = true, transformation(origin = {-90, 12}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(atmosphere.Flowport, simpleOpeningComp.port_a) annotation(
    Line(points = {{-40, 0}, {6, 0}}, color = {0, 85, 255}));
  connect(simpleOpeningComp.port_b, atmosphere1.Flowport) annotation(
    Line(points = {{34, 0}, {80, 0}}, color = {0, 85, 255}));
  connect(pressureProfile.y, atmosphere.p_in) annotation(
    Line(points = {{-78, 12}, {-60, 12}, {-60, 12}, {-58, 12}}, color = {0, 0, 127}));
annotation(
    experiment(StartTime = 0, StopTime = 10, Tolerance = 1e-6, Interval = 0.02));
end test_SimpleOpeningComp;
