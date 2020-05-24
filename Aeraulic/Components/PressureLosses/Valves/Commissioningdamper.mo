within TAeZoSysPro.Aeraulic.Components.PressureLosses.Valves;

model Commissioningdamper
  package Medium = TAeZoSysPro.Aeraulic.Media.MyMedia;
  //
  parameter Modelica.SIunits.Area crossArea "Inner cross section area" annotation(
    Dialog(group = "Geometry"));
  //
  parameter Real ksi(fixed = false, start = 1) "dynamic pressure loss" annotation(
    Dialog(group = "Flow"));
  parameter Modelica.SIunits.MassFlowRate m_flow_start(displayUnit = "kg/h") = 2.0 "wanted" annotation(
    Dialog(group = "Flow"));
  parameter Modelica.SIunits.Velocity Vel_start = 0 "initialize velocity to help numerical convergence" annotation(
    Dialog(group = "Flow"));
  Medium.BaseProperties medium_a(p = fluidport_a.p, h = inStream(fluidport_a.h_outflow), Xi = inStream(fluidport_a.Xi_outflow)) "medium properties at port a";
  Medium.BaseProperties medium_b(p = fluidport_b.p, h = inStream(fluidport_b.h_outflow), Xi = inStream(fluidport_b.Xi_outflow)) "medium properties at port b";
  //
  Modelica.SIunits.PressureDifference dp;
  Modelica.SIunits.PressureDifference dp_loss;
  Modelica.SIunits.Velocity Vel(start = Vel_start);
  Modelica.SIunits.MassFlowRate m_flow(start = m_flow_start, fixed = true, displayUnit = "kg/h") "Aperture flow kg/s";
  Modelica.SIunits.Density d;
  //
  Modelica.Fluid.Interfaces.FluidPort_a fluidport_a(replaceable package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-100, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_b fluidport_b(replaceable package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {100, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
// mass balance
//d = TAeZoSysPro.Aeraulic.Functions.regStep(x = Vel, x_small = 0.01, y1 = medium_a.d, y2 = medium_a.d) ;
  d = if Vel >= 0.0 then medium_a.d else medium_a.d;
  m_flow = d * crossArea * Vel;
// momentum balance
  dp = fluidport_a.p - fluidport_b.p;
  dp_loss = 1 / 2 * ksi * d * Modelica.Fluid.Utilities.regSquare2(x = Vel, x_small = 0.001, k1 = 1, k2 = 1);
  dp - dp_loss = 0.0;
// port handover
  fluidport_a.m_flow = m_flow;
  fluidport_a.m_flow + fluidport_b.m_flow = 0.0;
  fluidport_a.h_outflow = inStream(fluidport_b.h_outflow);
  fluidport_b.h_outflow = inStream(fluidport_a.h_outflow);
  fluidport_a.Xi_outflow = inStream(fluidport_b.Xi_outflow);
  fluidport_b.Xi_outflow = inStream(fluidport_a.Xi_outflow);
  annotation(
    Icon(graphics = {Text(origin = {14, -111}, extent = {{-46, 33}, {24, 13}}, textString = "ksi=%ksi"), Text(origin = {6, 35}, extent = {{-46, 33}, {24, 13}}, textString = "%name"), Rectangle(origin = {-1, -6}, extent = {{-77, 74}, {81, -70}}), Line(origin = {-63, 0}, points = {{-29, 0}, {29, 0}, {55, 0}}), Line(origin = {61.6412, 0}, points = {{-53, 0}, {29, 0}, {29, 0}}), Line(origin = {-1, -2}, points = {{-67, -64}, {71, 66}}), Ellipse(fillPattern = FillPattern.Solid,extent = {{-8, 8}, {8, -8}}, endAngle = 360), Polygon(origin = {0, 83}, lineThickness = 0.5, points = {{0, -15}, {-12, 15}, {12, 15}, {0, -15}})}, coordinateSystem(initialScale = 0.1)));

end Commissioningdamper;