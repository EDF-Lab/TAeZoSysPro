within TAeZoSysPro_testsuite.FluidDynamics.Components.Buildings;

model test_Wall

  package Medium = TAeZoSysPro.Media.Air.MoistAir;
  TAeZoSysPro.FluidDynamics.Sources.Atmosphere atmosphere(redeclare package Medium = Medium, RH = 0.99)
    annotation (
      Placement(visible = true, transformation(origin = {-60, 3.55271e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  TAeZoSysPro.FluidDynamics.Components.Buildings.Wall Wall(A = 1, Lc = 1, redeclare package Medium = Medium, N = 10, T_start = 283.15, Th = 0.1, correlation_a = TAeZoSysPro.HeatTransfer.Types.FreeConvectionCorrelation.vertical_plate_ASHRAE, cp = 1000, d = 2500, energyDynamics = TAeZoSysPro.HeatTransfer.Types.Dynamics.FixedInitial, eps_a = 1, eps_b = 1, h_cv_const_a = 10, h_cv_const_b = 10, k = 2.3, mesh = TAeZoSysPro.HeatTransfer.Types.MeshGrid.biotAndGeometricalGrowth)
    annotation (
      Placement(visible = true, transformation(origin = {22, 3.55271e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

equation

  connect(atmosphere.Flowport, Wall.port_a)
    annotation (
      Line(points = {{-60, 0}, {-20, 0}, {-20, 14}, {4, 14}}, color = {0, 85, 255}));
  connect(Wall.port_a_rad, Wall.port_surface_a)
    annotation (
      Line(points = {{4, -18}, {-8, -18}, {-8, 2}, {14, 2}, {14, 2}}, color = {191, 0, 0}));
  connect(Wall.port_b_rad, Wall.port_surface_b)
    annotation (
      Line(points = {{40, -18}, {58, -18}, {58, 2}, {30, 2}, {30, 2}}, color = {191, 0, 0}));
  connect(Wall.A_wall_a, Wall.F_view_a)
    annotation (
      Line(points = {{4, -10}, {-2, -10}, {-2, -4}, {4, -4}, {4, -6}}, color = {0, 0, 127}));
  connect(Wall.A_wall_b, Wall.F_view_b)
    annotation (
      Line(points = {{40, -10}, {48, -10}, {48, -6}, {40, -6}, {40, -6}}, color = {0, 0, 127}));
  connect(Wall.port_a, atmosphere.Flowport)
    annotation (
      Line(points = {{2, 14}, {-40, 14}, {-40, 0}, {-60, 0}, {-60, 0}}, color = {0, 85, 255}));
  connect(Wall.port_b, atmosphere.Flowport)
    annotation (
      Line(points = {{40, 14}, {60, 14}, {60, 32}, {-40, 32}, {-40, 0}, {-60, 0}, {-60, 0}}, color = {0, 85, 255}));

  annotation (
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-6, Interval = 0.002));

end test_Wall;
