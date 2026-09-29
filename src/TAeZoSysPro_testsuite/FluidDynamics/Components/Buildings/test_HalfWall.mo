within TAeZoSysPro_testsuite.FluidDynamics.Components.Buildings;

model test_HalfWall
  package Medium = TAeZoSysPro.Media.Air.MoistAir ;
  TAeZoSysPro.FluidDynamics.Sources.Atmosphere atmosphere(redeclare package Medium = Medium, RH = 0.99)  annotation(
    Placement(visible = true, transformation(origin = {-60, 3.55271e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  TAeZoSysPro.FluidDynamics.Components.Buildings.HalfWall halfWall( A = 1, Lc = 1, redeclare package Medium = Medium, N=5, T_start=283.15, Th = 0.1, correlation = TAeZoSysPro.HeatTransfer.Types.FreeConvectionCorrelation.ceiling_ASHRAE, cp = 1000, d = 2500, energyDynamics = TAeZoSysPro.HeatTransfer.Types.Dynamics.SteadyStateInitial, eps = 1, h_cv_const = 10, k = 2.3)  annotation (
    Placement(visible = true, transformation(origin = {22, 3.55271e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
equation
  connect(atmosphere.Flowport, halfWall.port_a) annotation(
    Line(points = {{-60, 0}, {-20, 0}, {-20, 14}, {4, 14}}, color = {0, 85, 255}));
  connect(halfWall.A_wall, halfWall.F_view) annotation(
    Line(points = {{3.4, -10.6}, {-4.6, -10.6}, {-4.6, -6.6}, {3.4, -6.6}, {3.4, -6.6}}, color = {0, 0, 127}));
  connect(halfWall.port_a_rad, halfWall.port_surface) annotation(
    Line(points = {{4, -18}, {-8, -18}, {-8, 2}, {14, 2}, {14, 2}}, color = {191, 0, 0}));
annotation(
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-6, Interval = 0.002));
end test_HalfWall;