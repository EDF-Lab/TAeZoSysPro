within TAeZoSysPro.Aeraulic.Components.PressureLosses.Valves;

model CheckValve
  package Medium = TAeZoSysPro.Aeraulic.Media.MyMedia;
  //
  parameter Modelica.SIunits.Area crossArea "Inner cross section area" annotation(
    Dialog(group = "Geometry"));
  //
  parameter Real ksi "dynamic pressure loss" annotation(
    Dialog(group = "Flow"));
  Medium.BaseProperties medium_a(p = fluidport_a.p, h = inStream(fluidport_a.h_outflow), Xi = inStream(fluidport_a.Xi_outflow)) "medium properties at port a";
  Medium.BaseProperties medium_b(p = fluidport_b.p, h = inStream(fluidport_b.h_outflow), Xi = inStream(fluidport_b.Xi_outflow)) "medium properties at port b";
  //
  Modelica.SIunits.CrossSection A "cross section";
  Modelica.SIunits.PressureDifference dp;
  Modelica.SIunits.PressureDifference dp_loss;
  Modelica.SIunits.Velocity Vel(start = 0.0);
  Modelica.SIunits.MassFlowRate m_flow(displayUnit = "kg/h") "Aperture flow kg/s";
  //
  Modelica.Fluid.Interfaces.FluidPort_a fluidport_a(replaceable package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-100, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_b fluidport_b(replaceable package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {100, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
// mass balance
  m_flow = medium_a.d * A * Vel;
// momentum balance
  dp = fluidport_a.p - fluidport_b.p;
  if dp <= 0.0 then
    A = 0.0;
  else
    A = crossArea;
  end if;
  dp_loss = 1 / 2 * ksi * medium_a.d * Modelica.Fluid.Utilities.regSquare2(x = Vel, x_small = 0.001, k1 = 1, k2 = 1);
  dp - dp_loss = 0.0;
// port handover
  fluidport_a.m_flow = m_flow;
  fluidport_a.m_flow + fluidport_b.m_flow = 0.0;
  fluidport_a.h_outflow = inStream(fluidport_b.h_outflow);
  fluidport_b.h_outflow = inStream(fluidport_a.h_outflow);
  fluidport_a.Xi_outflow = inStream(fluidport_b.Xi_outflow);
  fluidport_b.Xi_outflow = inStream(fluidport_a.Xi_outflow);
  annotation(
    Icon(graphics = {Line(origin = {-73, 0}, points = {{-21, 0}, {13, 0}}, thickness = 0.5), Line(origin = {64, 0}, points = {{-4, 0}, {24, 0}}, thickness = 0.5), Rectangle(origin = {5, -4}, lineThickness = 0.5, extent = {{-83, 78}, {73, -66}}), Line(origin = {-60, 0}, points = {{0, 40}, {0, -40}}, thickness = 0.5), Line(origin = {60, 0}, points = {{0, 40}, {0, -40}}, thickness = 0.5), Line(points = {{-60, 40}, {60, -40}}, thickness = 0.5)}, coordinateSystem(initialScale = 0.1)));
end CheckValve;
