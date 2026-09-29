within TAeZoSysPro_testsuite.FluidDynamics.Components.Buildings;

model test_InertMass

  package Medium = TAeZoSysPro.Media.Air.MoistAir ;
  TAeZoSysPro.FluidDynamics.Sources.Atmosphere atmosphere(redeclare package Medium = Medium, RH = 0.99)  annotation(
    Placement(visible = true, transformation(origin = {-60, 3.55271e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  TAeZoSysPro.FluidDynamics.Components.Buildings.InertMass inertMass(redeclare
      package                                                                          Medium = Medium, A_conv = 1, A_rad = 1, T_start = 283.15, correlation = TAeZoSysPro.HeatTransfer.Types.FreeConvectionCorrelation.Constant, cp = 1005, energyDynamics = TAeZoSysPro.HeatTransfer.Types.Dynamics.FixedInitial, eps = 1, h_cv_const = 10, m = 1)  annotation (
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
equation
  connect(inertMass.A_wall, inertMass.F_view) annotation(
    Line(points = {{-18, -10}, {-28, -10}, {-28, -6}, {-18, -6}, {-18, -6}}, color = {0, 0, 127}));
  connect(inertMass.port_a, atmosphere.Flowport) annotation(
    Line(points = {{-20, 10}, {-40, 10}, {-40, 0}, {-60, 0}, {-60, 0}}, color = {0, 85, 255}));
annotation(
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-6, Interval = 0.002));
end test_InertMass;