within TAeZoSysPro.FluidDynamics.BasesClasses.Tests;

model test_Condensation
  TAeZoSysPro.FluidDynamics.Sources.Atmosphere atmosphere annotation(
    Placement(visible = true, transformation(origin = {-70, 3.55271e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  TAeZoSysPro.FluidDynamics.BasesClasses.Condensation condensation annotation(
    Placement(visible = true, transformation(origin = {-3.55271e-15, 3.55271e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature T_wall(T = 278.15)  annotation(
    Placement(visible = true, transformation(origin = {70, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant h_cv(k = 10)  annotation(
    Placement(visible = true, transformation(origin = {-70, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(atmosphere.Flowport, condensation.flowPort) annotation(
    Line(points = {{-70, 0}, {-20, 0}, {-20, 0}, {-18, 0}}, color = {0, 85, 255}));
  connect(T_wall.port, condensation.heatPort) annotation(
    Line(points = {{60, 0}, {16, 0}, {16, 0}, {18, 0}}, color = {191, 0, 0}));
  connect(h_cv.y, condensation.h_cv) annotation(
    Line(points = {{-58, 70}, {-30, 70}, {-30, 12}, {-16, 12}, {-16, 12}}, color = {0, 0, 127}));
end test_Condensation;
