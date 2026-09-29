within TAeZoSysPro_testsuite.FluidDynamics.Components.Pipes;

model test_DynamicPipe

  Modelica.SIunits.SpecificEnthalpy h;
  TAeZoSysPro.FluidDynamics.Sources.Atmosphere atmosphere(redeclare package Medium = TAeZoSysPro.Media.Air.MoistAir, nPorts = 1, p = 101425)
    annotation (
      Placement(visible = true, transformation(origin = {-80, 3.55271e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  TAeZoSysPro.FluidDynamics.Sources.Atmosphere atmosphere1(redeclare package Medium = TAeZoSysPro.Media.Air.MoistAir, nPorts = 1)
    annotation (
      Placement(visible = true, transformation(origin = {80, 0}, extent = {{20, -20}, {-20, 20}}, rotation = 0)));
  TAeZoSysPro.FluidDynamics.Components.Pipes.DynamicPipe pipe(A = 1, L = 1, redeclare package Medium = TAeZoSysPro.Media.Air.MoistAir, T_start(displayUnit = "degC") = 298.15, energyDynamics = TAeZoSysPro.HeatTransfer.Types.Dynamics.FixedInitial, ksi = 10, massDynamics = TAeZoSysPro.HeatTransfer.Types.Dynamics.FixedInitial)
    annotation (
      Placement(visible = true, transformation(origin = {-3.55271e-15, 3.55271e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

equation

  h = TAeZoSysPro.Media.Air.MoistAir.specificEnthalpy_pTX(
    p = pipe.port_a.p,
    T = atmosphere.T,
    X = {0.00767631});
  connect(atmosphere.Fluidport[1], pipe.port_a)
    annotation (
      Line(points = {{-80, 8}, {-60, 8}, {-60, 0}, {-20, 0}, {-20, 0}}, color = {0, 127, 255}));
  connect(pipe.port_b, atmosphere1.Fluidport[1])
    annotation (
      Line(points = {{20, 0}, {60, 0}, {60, 8}, {80, 8}, {80, 8}}, color = {0, 127, 255}));

  annotation (
    experiment(StartTime = 0, StopTime = 10, Tolerance = 1e-06, Interval = 0.1));

end test_DynamicPipe;
