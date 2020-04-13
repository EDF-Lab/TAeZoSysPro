within TAeZoSysPro.FluidDynamics.BasesClasses.Tests;

model test_FreeConvection
  TAeZoSysPro.FluidDynamics.BasesClasses.FreeConvection freeConvection(A = 1, Lc = 1, correlation = TAeZoSysPro.HeatTransfer.Types.FreeConvectionCorrelation.vertical_plate_ASHRAE, h_cv_const = 10)  annotation(
    Placement(visible = true, transformation(origin = {-3.55271e-15, 3.55271e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  TAeZoSysPro.FluidDynamics.Sources.Atmosphere atmosphere annotation(
    Placement(visible = true, transformation(origin = {60, 3.55271e-15}, extent = {{20, -20}, {-20, 20}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature prescribedTemperature annotation(
    Placement(visible = true, transformation(origin = {-50, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Ramp T_wall(duration = 10, height = 20, offset = 283.15)  annotation(
    Placement(visible = true, transformation(origin = {-90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(T_wall.y, prescribedTemperature.T) annotation(
    Line(points = {{-78, 0}, {-64, 0}, {-64, 0}, {-62, 0}}, color = {0, 0, 127}));
  connect(prescribedTemperature.port, freeConvection.heatPort_a) annotation(
    Line(points = {{-40, 0}, {-20, 0}}, color = {191, 0, 0}));
  connect(atmosphere.Flowport, freeConvection.flowPort_inlet) annotation(
    Line(points = {{60, 0}, {20, 0}}, color = {0, 85, 255}));
  connect(freeConvection.flowPort_up, atmosphere.Flowport) annotation(
    Line(points = {{-2, 18}, {-2, 40}, {32, 40}, {32, 0}, {60, 0}}, color = {0, 85, 255}));
  connect(atmosphere.Flowport, freeConvection.flowPort_down) annotation(
    Line(points = {{60, 0}, {32, 0}, {32, -40}, {-2, -40}, {-2, -18}}, color = {0, 85, 255}));  end test_FreeConvection;
