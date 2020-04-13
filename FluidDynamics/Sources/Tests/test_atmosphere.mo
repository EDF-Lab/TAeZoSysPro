within TAeZoSysPro.FluidDynamics.Sources.Tests;

model test_atmosphere
  TAeZoSysPro.FluidDynamics.Sources.Atmosphere atmosphere annotation(
    Placement(visible = true, transformation(origin = {-1.77636e-15, 78}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  TAeZoSysPro.FluidDynamics.Sources.Atmosphere atmosphere1(use_p_in = true)  annotation(
    Placement(visible = true, transformation(origin = {-8.88178e-16, 30}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  TAeZoSysPro.FluidDynamics.Sources.Atmosphere atmosphere2(use_T_in = true)  annotation(
    Placement(visible = true, transformation(origin = {-8.88178e-16, -20}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  TAeZoSysPro.FluidDynamics.Sources.Atmosphere atmosphere3(use_RH_in = true)  annotation(
    Placement(visible = true, transformation(origin = {0, -70}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Sources.Ramp p(duration = 10, height = 1000, offset = 101325)  annotation(
    Placement(visible = true, transformation(origin = {-90, 42}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Ramp T(duration = 10, height = 20, offset = 283.15)  annotation(
    Placement(visible = true, transformation(origin = {-90, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Ramp RH(duration = 10, height = 1)  annotation(
    Placement(visible = true, transformation(origin = {-90, -82}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(p.y, atmosphere1.p_in) annotation(
    Line(points = {{-79, 42}, {-19, 42}}, color = {0, 0, 127}));
  connect(RH.y, atmosphere3.RH_in) annotation(
    Line(points = {{-78, -82}, {-22, -82}, {-22, -82}, {-18, -82}}, color = {0, 0, 127}));
  connect(T.y, atmosphere2.T_in) annotation(
    Line(points = {{-78, -20}, {-20, -20}, {-20, -20}, {-18, -20}}, color = {0, 0, 127}));
end test_atmosphere;
