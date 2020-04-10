within TAeZoSysPro.HeatTransfer.Components.Tests;

model test_CabinetPower
  TAeZoSysPro.HeatTransfer.Components.CabinetPower cabinetPower(A_conv_casing = 1, A_conv_emitter = 0.1, A_in_casing = 1, A_rad_casing = 1, A_rad_emitter = 0.1, Lc_casing = 1, Lc_emitter = 0.1, T_start = 303.15, cp_casing = 100, cp_emitter = 100, energyDynamics = TAeZoSysPro.HeatTransfer.Types.Dynamics.FixedInitial, m_casing = 100, m_emitter = 10)  annotation(
    Placement(visible = true, transformation(origin = {-3.55271e-15, 3.55271e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant F_view(k = 1)  annotation(
    Placement(visible = true, transformation(origin = {-70, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature T_MRT(T = 298.15)  annotation(
    Placement(visible = true, transformation(origin = {-70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature T_ambiance(T = 293.15)  annotation(
    Placement(visible = true, transformation(origin = {70, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant heatLoad(k = 1000)  annotation(
    Placement(visible = true, transformation(origin = {-30, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(F_view.y, cabinetPower.F_view) annotation(
    Line(points = {{-58, 50}, {-40, 50}, {-40, 16}, {-20, 16}, {-20, 16}}, color = {0, 0, 127}));
  connect(cabinetPower.port_rad, T_MRT.port) annotation(
    Line(points = {{-20, 0}, {-60, 0}, {-60, 0}, {-60, 0}}, color = {191, 0, 0}));
  connect(T_ambiance.port, cabinetPower.port_conv) annotation(
    Line(points = {{60, 0}, {22, 0}, {22, 0}, {20, 0}}, color = {191, 0, 0}));
  connect(cabinetPower.port_hood, T_ambiance.port) annotation(
    Line(points = {{0, 22}, {0, 30}, {40, 30}, {40, 0}, {60, 0}}, color = {191, 0, 0}));
  connect(heatLoad.y, cabinetPower.Heatload_Variable) annotation(
    Line(points = {{-18, -50}, {0, -50}, {0, -20}, {0, -20}}, color = {0, 0, 127}));
end test_CabinetPower;
