within TAeZoSysPro_testsuite.FluidDynamics.BaseClasses;

model test_FreeConvection

  package Medium = TAeZoSysPro.Media.Air.MoistAir ;

  TAeZoSysPro.FluidDynamics.BasesClasses.FreeConvection freeConvection(redeclare package Medium=Medium, A = 1, Lc = 1, correlation = TAeZoSysPro.HeatTransfer.Types.FreeConvectionCorrelation.vertical_plate_ASHRAE, h_cv_const = 10)  annotation(
    Placement(visible = true, transformation(origin = {-3.55271e-15, 3.55271e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  TAeZoSysPro.FluidDynamics.Sources.Atmosphere atmosphere(redeclare package Medium=Medium) annotation(
    Placement(visible = true, transformation(origin = {60, 3.55271e-15}, extent = {{20, -20}, {-20, 20}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature prescribedTemperature annotation(
    Placement(visible = true, transformation(origin = {-50, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Ramp T_wall(duration = 10, height = 20, offset = 283.15)  annotation(
    Placement(visible = true, transformation(origin = {-90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(T_wall.y, prescribedTemperature.T) annotation(
    Line(points = {{-78, 0}, {-64, 0}, {-64, 0}, {-62, 0}}, color = {0, 0, 127}));
  connect(prescribedTemperature.port, freeConvection.port_a) annotation(
    Line(points = {{-40, 0}, {-20, 0}, {-20, 0}, {-20, 0}}, color = {191, 0, 0}));
  connect(freeConvection.port_b, atmosphere.Flowport) annotation(
    Line(points = {{20, 0}, {62, 0}, {62, 0}, {60, 0}}, color = {0, 85, 255}));
annotation(
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-6, Interval = 0.002));
end test_FreeConvection;