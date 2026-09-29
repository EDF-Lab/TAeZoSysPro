within TAeZoSysPro_testsuite.FluidDynamics.Components.Orifices;

model test_HorizontalOpening

  TAeZoSysPro.FluidDynamics.Sources.Atmosphere atmosphere(T = 303.15, use_T_in = true)
    annotation (
      Placement(visible = true, transformation(origin = {-80, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  TAeZoSysPro.FluidDynamics.Sources.Atmosphere atmosphere2(T = 101425 * 293.15 / 101325, p = 101425)
    annotation (
      Placement(visible = true, transformation(origin = {-80, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  TAeZoSysPro.FluidDynamics.Sources.Atmosphere atmosphere1(T = 283.15)
    annotation (
      Placement(visible = true, transformation(origin = {80, 60}, extent = {{20, -20}, {-20, 20}}, rotation = 0)));
  TAeZoSysPro.FluidDynamics.Sources.Atmosphere atmosphere3
    annotation (
      Placement(visible = true, transformation(origin = {80, -60}, extent = {{20, -20}, {-20, 20}}, rotation = 0)));
  TAeZoSysPro.FluidDynamics.Components.Orifices.HorizontalOpening horizontalOpening
    annotation (
      Placement(visible = true, transformation(origin = {-1.77636e-15, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  TAeZoSysPro.FluidDynamics.Components.Orifices.HorizontalOpening horizontalOpening1
    annotation (
      Placement(visible = true, transformation(origin = {0, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Sources.Ramp ramp(duration = 10, height = -25, offset = 303.15, startTime = 1)
    annotation (
      Placement(visible = true, transformation(origin = {-70, 10}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));

equation

  connect(horizontalOpening.port_b, atmosphere1.Flowport)
    annotation (
      Line(points = {{0, 78}, {47, 78}, {47, 60}, {80, 60}}, color = {0, 85, 255}));
  connect(atmosphere2.Flowport, horizontalOpening1.port_a)
    annotation (
      Line(points = {{-80, -60}, {-47, -60}, {-47, -78}, {0, -78}}, color = {0, 85, 255}));
  connect(atmosphere.Flowport, horizontalOpening.port_a)
    annotation (
      Line(points = {{-80, 60}, {-47, 60}, {-47, 42}, {0, 42}}, color = {0, 85, 255}));
  connect(horizontalOpening1.port_b, atmosphere3.Flowport)
    annotation (
      Line(points = {{0, -42}, {47, -42}, {47, -60}, {80, -60}}, color = {0, 85, 255}));
  connect(ramp.y, atmosphere.T_in)
    annotation (
      Line(points = {{-80, 10}, {-120, 10}, {-120, 60}, {-98, 60}}, color = {0, 0, 127}));

  annotation (
    experiment(StartTime = 0, StopTime = 12, Tolerance = 1e-6, Interval = 0.024));

end test_HorizontalOpening;
