within TAeZoSysPro.HeatTransfer.BasesClasses.Tests;

model test_LumpVolume
  LumpVolume lumpVolume1(T_start = 293.15, energyDynamics = TAeZoSysPro.HeatTransfer.Types.Dynamics.FixedInitial)  annotation(
    Placement(visible = true, transformation(origin = {0, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  TAeZoSysPro.HeatTransfer.BasesClasses.LumpVolume lumpVolume2(energyDynamics = TAeZoSysPro.HeatTransfer.Types.Dynamics.SteadyStateInitial)  annotation(
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor thermalConductor1(G = 10)  annotation(
    Placement(visible = true, transformation(origin = {50, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature1(T = 293.15)  annotation(
    Placement(visible = true, transformation(origin = {90, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  TAeZoSysPro.HeatTransfer.BasesClasses.LumpVolume lumpVolume3(energyDynamics = TAeZoSysPro.HeatTransfer.Types.Dynamics.SteadyState) annotation(
    Placement(visible = true, transformation(origin = {0, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor thermalConductor2(G = 10) annotation(
    Placement(visible = true, transformation(origin = {50, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature2(T = 293.15) annotation(
    Placement(visible = true, transformation(origin = {90, -50}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow1 annotation(
    Placement(visible = true, transformation(origin = {-50, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Ramp ramp1(duration = 10, height = 100)  annotation(
    Placement(visible = true, transformation(origin = {-90, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Ramp ramp2(duration = 10, height = 100) annotation(
    Placement(visible = true, transformation(origin = {-90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow2 annotation(
    Placement(visible = true, transformation(origin = {-50, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(prescribedHeatFlow2.port, lumpVolume2.port_a) annotation(
    Line(points = {{-40, 0}, {0, 0}, {0, 0}, {0, 0}}, color = {191, 0, 0}));
  connect(ramp2.y, prescribedHeatFlow2.Q_flow) annotation(
    Line(points = {{-78, 0}, {-62, 0}, {-62, 0}, {-60, 0}}, color = {0, 0, 127}));
  connect(ramp1.y, prescribedHeatFlow1.Q_flow) annotation(
    Line(points = {{-78, -50}, {-62, -50}, {-62, -50}, {-60, -50}}, color = {0, 0, 127}));
  connect(prescribedHeatFlow1.port, lumpVolume3.port_a) annotation(
    Line(points = {{-40, -50}, {-2, -50}, {-2, -50}, {0, -50}}, color = {191, 0, 0}));
  connect(thermalConductor2.port_b, fixedTemperature2.port) annotation(
    Line(points = {{60, -50}, {80, -50}, {80, -50}, {80, -50}}, color = {191, 0, 0}));
  connect(lumpVolume3.port_a, thermalConductor2.port_a) annotation(
    Line(points = {{0, -50}, {40, -50}, {40, -50}, {40, -50}}, color = {191, 0, 0}));
  connect(thermalConductor1.port_b, fixedTemperature1.port) annotation(
    Line(points = {{60, 0}, {80, 0}, {80, 0}, {80, 0}}, color = {191, 0, 0}));
  connect(lumpVolume2.port_a, thermalConductor1.port_a) annotation(
    Line(points = {{0, 0}, {40, 0}, {40, 0}, {40, 0}}, color = {191, 0, 0}));
end test_LumpVolume;
