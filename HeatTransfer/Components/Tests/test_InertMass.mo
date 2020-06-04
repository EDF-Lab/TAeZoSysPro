within TAeZoSysPro.HeatTransfer.Components.Tests;

model test_InertMass
  TAeZoSysPro.HeatTransfer.Components.InertMass inertMass(A_conv = 1, T_start = 303.15, UseImplicitConnection = false, correlation = TAeZoSysPro.HeatTransfer.Types.FreeConvectionCorrelation.Constant, cp = 500, energyDynamics = TAeZoSysPro.HeatTransfer.Types.Dynamics.FixedInitial, eps = 1, h_cv_const = 10, m = 1)  annotation(
    Placement(visible = true, transformation(origin = {-3.55271e-15, 3.55271e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T = 293.15)  annotation(
    Placement(visible = true, transformation(origin = {-70, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = 1)  annotation(
    Placement(visible = true, transformation(origin = {-70, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(const.y, inertMass.F_view) annotation(
    Line(points = {{-58, -30}, {-30, -30}, {-30, -6}, {-18, -6}, {-18, -6}}, color = {0, 0, 127}));
  connect(fixedTemperature.port, inertMass.port_a_conv) annotation(
    Line(points = {{-60, 30}, {-40, 30}, {-40, 14}, {-20, 14}, {-20, 14}}, color = {191, 0, 0}));
  connect(fixedTemperature.port, inertMass.port_a_rad) annotation(
    Line(points = {{-60, 30}, {-40, 30}, {-40, -16}, {-20, -16}, {-20, -18}}, color = {191, 0, 0}));
end test_InertMass;
