within TAeZoSysPro.HeatTransfer.BasesClasses.Tests;

model test_HeatCapacitor
  TAeZoSysPro.HeatTransfer.BasesClasses.HeatCapacitor heatCapacitor1(Mass = 1, Tstart = 303.15, cp = 1000, energyDynamics = TAeZoSysPro.HeatTransfer.Types.Dynamics.FixedInitial)  annotation(
    Placement(visible = true, transformation(origin = {0, 72}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  TAeZoSysPro.HeatTransfer.BasesClasses.HeatCapacitor heatCapacitor2(Mass = 1, Tstart = 293.15, cp = 1000)  annotation(
    Placement(visible = true, transformation(origin = {0, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow1 annotation(
    Placement(visible = true, transformation(origin = {-30, -12}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature T_infinite(T = 293.15)  annotation(
    Placement(visible = true, transformation(origin = {72, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor thermalConductor1(G = 10)  annotation(
    Placement(visible = true, transformation(origin = {30, -12}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Ramp ramp1(duration = 10, height = 100)  annotation(
    Placement(visible = true, transformation(origin = {-70, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor thermalConductor2(G = 10) annotation(
    Placement(visible = true, transformation(origin = {30, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow2 annotation(
    Placement(visible = true, transformation(origin = {-30, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  TAeZoSysPro.HeatTransfer.BasesClasses.HeatCapacitor heatCapacitor3(Mass = 1, Tstart = 293.15, cp = 1000, energyDynamics = TAeZoSysPro.HeatTransfer.Types.Dynamics.SteadyState) annotation(
    Placement(visible = true, transformation(origin = {0, -70}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor thermalConductor3(G = 10) annotation(
    Placement(visible = true, transformation(origin = {30, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature1(T = 293.15) annotation(
    Placement(visible = true, transformation(origin = {70, -50}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
equation
  connect(thermalConductor3.port_b, fixedTemperature1.port) annotation(
    Line(points = {{40, -50}, {60, -50}, {60, -50}, {60, -50}}, color = {191, 0, 0}));
  connect(thermalConductor3.port_a, heatCapacitor3.port) annotation(
    Line(points = {{20, -50}, {0, -50}, {0, -60}, {0, -60}}, color = {191, 0, 0}));
  connect(prescribedHeatFlow2.port, heatCapacitor3.port) annotation(
    Line(points = {{-20, -50}, {0, -50}, {0, -60}, {0, -60}}, color = {191, 0, 0}));
  connect(ramp1.y, prescribedHeatFlow2.Q_flow) annotation(
    Line(points = {{-58, -30}, {-50, -30}, {-50, -50}, {-40, -50}, {-40, -50}}, color = {0, 0, 127}));
  connect(ramp1.y, prescribedHeatFlow1.Q_flow) annotation(
    Line(points = {{-59, -30}, {-50, -30}, {-50, -12}, {-41, -12}}, color = {0, 0, 127}));
  connect(heatCapacitor2.port, thermalConductor1.port_a) annotation(
    Line(points = {{0, 0}, {0, -12}, {20, -12}}, color = {191, 0, 0}));
  connect(thermalConductor1.port_b, T_infinite.port) annotation(
    Line(points = {{40, -12}, {50, -12}, {50, 0}, {62, 0}}, color = {191, 0, 0}));
  connect(prescribedHeatFlow1.port, heatCapacitor2.port) annotation(
    Line(points = {{-20, -12}, {0, -12}, {0, 0}}, color = {191, 0, 0}));
  connect(thermalConductor2.port_b, T_infinite.port) annotation(
    Line(points = {{40, 50}, {50, 50}, {50, 0}, {62, 0}}, color = {191, 0, 0}));
  connect(heatCapacitor1.port, thermalConductor2.port_a) annotation(
    Line(points = {{0, 62}, {0, 50}, {20, 50}}, color = {191, 0, 0}));
annotation(
    experiment(StartTime = 0, StopTime = 10, Tolerance = 1e-6, Interval = 0.1));end test_HeatCapacitor;
