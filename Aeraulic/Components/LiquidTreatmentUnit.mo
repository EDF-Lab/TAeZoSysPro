within TAeZoSysPro.Aeraulic.Components;

model LiquidTreatmentUnit
  replaceable package Medium = Modelica.Media.Water.WaterIF97_pT(Region = 1) "Medium in the component";
  parameter Modelica.SIunits.SpecificHeatCapacity cp = 4185 "fluid heat capacity at constant pressure";
  parameter Boolean Variable_SpecificHeatCapacity = false;
  // Output port
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port_a annotation(
    Placement(visible = true, transformation(origin = {0, 98}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  // Input port
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a1 annotation(
    Placement(visible = true, transformation(origin = {-1, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-109, -4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput Qmwater annotation(
    Placement(visible = true, transformation(origin = {-106, 78}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-84, 76}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  // Variables are defined
  Modelica.SIunits.Temperature Twater;
  // Room 1 Air temperature
  Modelica.SIunits.Temperature Tsupply;
  // Room 2 Air temperature
  Modelica.SIunits.SpecificHeatCapacity c;
protected
  Medium.ThermodynamicState state;
equation
//state fill
  state.h = 0;
  state.p = 101325;
  state.T = Tsupply;
  state.d = 0;
  state.phase = 1;
  if Variable_SpecificHeatCapacity == true then
    c = Medium.specificHeatCapacityCp(state);
  else
    c = cp;
  end if;
  Twater = port_a.T;
  Tsupply = port_a1.T;
  port_a.Q_flow = c * Qmwater * (Twater - Tsupply);
// Heat flow through port_a is calcualted
  port_a1.Q_flow = 0;
// Heat flow through port_a1 is set to 0
  annotation(
    Diagram(coordinateSystem(grid = {1, 2}, initialScale = 0.1)),
    Icon(coordinateSystem(preserveAspectRatio = true, extent = {{-100, -100}, {100, 100}}), graphics = {Rectangle(extent = {{-100, 46}, {100, -46}}, lineColor = {0, 0, 0}, fillColor = {0, 127, 255}, fillPattern = FillPattern.HorizontalCylinder), Polygon(points = {{-48, -60}, {-72, -100}, {72, -100}, {48, -60}, {-48, -60}}, lineColor = {0, 0, 255}, pattern = LinePattern.None, fillColor = {0, 0, 0}, fillPattern = FillPattern.VerticalCylinder), Ellipse(extent = {{-80, 80}, {80, -80}}, lineColor = {0, 0, 0}, fillPattern = FillPattern.Sphere, fillColor = {0, 100, 199}), Polygon(points = {{-28, 30}, {-28, -30}, {50, -2}, {-28, 30}}, lineColor = {0, 0, 0}, pattern = LinePattern.None, fillPattern = FillPattern.HorizontalCylinder, fillColor = {255, 255, 255})}),
    experiment(StartTime = 0, StopTime = 3600100, Tolerance = 1e-06, Interval = 5));
end LiquidTreatmentUnit;
