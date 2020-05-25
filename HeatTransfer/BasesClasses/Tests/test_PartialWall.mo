within TAeZoSysPro.HeatTransfer.BasesClasses.Tests;

model test_PartialWall
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature2(T = 293.15)  annotation(
    Placement(visible = true, transformation(origin = {90, 50}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature3(T = 293.15)  annotation(
    Placement(visible = true, transformation(origin = {90, -30}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  TAeZoSysPro.HeatTransfer.BasesClasses.PartialWall partialWall( T_start = 293.15, Th = 1, cp = 1000, d (displayUnit = "kg/m3") = 1, energyDynamics = TAeZoSysPro.HeatTransfer.Types.Dynamics.FixedInitial, k = 1, mesh = TAeZoSysPro.HeatTransfer.Types.MeshGrid.biotAndGeometricalGrowth) annotation(
    Placement(visible = true, transformation(origin = {0, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Ramp ramp(duration = 10, height = 10) annotation(
    Placement(visible = true, transformation(origin = {-90, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T = 293.15) annotation(
    Placement(visible = true, transformation(origin = {90, 10}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  TAeZoSysPro.HeatTransfer.BasesClasses.PartialWall partialWall1(N = 5,T_start = 293.15, Th = 1, cp = 1000, d(displayUnit = "kg/m3") = 1, energyDynamics = TAeZoSysPro.HeatTransfer.Types.Dynamics.FixedInitial, k = 1, mesh = TAeZoSysPro.HeatTransfer.Types.MeshGrid.biotAndGeometricalGrowth) annotation(
    Placement(visible = true, transformation(origin = {0, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow annotation(
    Placement(visible = true, transformation(origin = {-40, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor thermalConductor(G = 1e6)  annotation(
    Placement(visible = true, transformation(origin = {40, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor thermalConductor1(G = 1e6) annotation(
    Placement(visible = true, transformation(origin = {40, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  TAeZoSysPro.HeatTransfer.BasesClasses.PartialWall partialWall2(N = 5, T_start = 293.15, Th = 1, cp = 1000, d(displayUnit = "kg/m3") = 1, energyDynamics = TAeZoSysPro.HeatTransfer.Types.Dynamics.SteadyStateInitial, k = 1, mesh = TAeZoSysPro.HeatTransfer.Types.MeshGrid.biotAndGeometricalGrowth) annotation(
    Placement(visible = true, transformation(origin = {0, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow1 annotation(
    Placement(visible = true, transformation(origin = {-40, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  TAeZoSysPro.HeatTransfer.BasesClasses.PartialWall partialWall3(N = 5, T_start = 293.15, Th = 1, cp = 1000, d(displayUnit = "kg/m3") = 1, energyDynamics = TAeZoSysPro.HeatTransfer.Types.Dynamics.SteadyState, k = 1, mesh = TAeZoSysPro.HeatTransfer.Types.MeshGrid.biotAndGeometricalGrowth) annotation(
    Placement(visible = true, transformation(origin = {0, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow2 annotation(
    Placement(visible = true, transformation(origin = {-40, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor thermalConductor2(G = 1e6) annotation(
    Placement(visible = true, transformation(origin = {40, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature1(T = 293.15) annotation(
    Placement(visible = true, transformation(origin = {90, -70}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor thermalConductor3(G = 1) annotation(
    Placement(visible = true, transformation(origin = {20, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow3 annotation(
    Placement(visible = true, transformation(origin = {-40, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(ramp.y, prescribedHeatFlow.Q_flow) annotation(
    Line(points = {{-79, 50}, {-50, 50}}, color = {0, 0, 127}));
  connect(prescribedHeatFlow.port, partialWall1.port_a) annotation(
    Line(points = {{-30, 50}, {-10, 50}}, color = {191, 0, 0}));
  connect(thermalConductor.port_b, fixedTemperature2.port) annotation(
    Line(points = {{50, 50}, {80, 50}}, color = {191, 0, 0}));
  connect(partialWall1.port_b, thermalConductor.port_a) annotation(
    Line(points = {{10, 50}, {30, 50}}, color = {191, 0, 0}));
  connect(prescribedHeatFlow1.port, partialWall2.port_a) annotation(
    Line(points = {{-30, 10}, {-10, 10}}, color = {191, 0, 0}));
  connect(partialWall2.port_b, thermalConductor1.port_a) annotation(
    Line(points = {{10, 10}, {30, 10}}, color = {191, 0, 0}));
  connect(prescribedHeatFlow2.port, partialWall3.port_a) annotation(
    Line(points = {{-30, -30}, {-10, -30}}, color = {191, 0, 0}));
  connect(partialWall3.port_b, thermalConductor2.port_a) annotation(
    Line(points = {{10, -30}, {30, -30}}, color = {191, 0, 0}));
  connect(prescribedHeatFlow3.port, thermalConductor3.port_a) annotation(
    Line(points = {{-30, -70}, {10, -70}, {10, -70}, {10, -70}}, color = {191, 0, 0}));
  connect(thermalConductor1.port_b, fixedTemperature2.port) annotation(
    Line(points = {{50, 10}, {60, 10}, {60, 50}, {80, 50}, {80, 50}}, color = {191, 0, 0}));
  connect(thermalConductor2.port_b, fixedTemperature2.port) annotation(
    Line(points = {{50, -30}, {60, -30}, {60, 50}, {80, 50}, {80, 50}}, color = {191, 0, 0}));
  connect(thermalConductor3.port_b, fixedTemperature2.port) annotation(
    Line(points = {{30, -70}, {60, -70}, {60, 50}, {80, 50}, {80, 50}}, color = {191, 0, 0}));
  connect(ramp.y, prescribedHeatFlow1.Q_flow) annotation(
    Line(points = {{-78, 50}, {-70, 50}, {-70, 10}, {-50, 10}, {-50, 10}}, color = {0, 0, 127}));
  connect(ramp.y, prescribedHeatFlow2.Q_flow) annotation(
    Line(points = {{-78, 50}, {-70, 50}, {-70, -30}, {-50, -30}, {-50, -30}}, color = {0, 0, 127}));
  connect(ramp.y, prescribedHeatFlow3.Q_flow) annotation(
    Line(points = {{-78, 50}, {-70, 50}, {-70, -70}, {-50, -70}, {-50, -70}}, color = {0, 0, 127}));
protected
end test_PartialWall;
