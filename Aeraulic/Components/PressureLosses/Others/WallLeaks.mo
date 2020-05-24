within TAeZoSysPro.Aeraulic.Components.PressureLosses.Others;

model WallLeaks
  package Medium = TAeZoSysPro.Aeraulic.Media.MyMedia;
  //
  parameter Modelica.SIunits.Area crossArea "Wall surface" annotation(
    Dialog(group = "Geometry"));
  parameter Real leakSurfaceRtatio(unit = "m²leak / m²wall") = 1e-4 "ratio of leak surface" annotation(
    Dialog(group = "Geometry"));
  //
  parameter Real ksi = 1.0 "dynamic pressure loss (if quadratic)" annotation(
    Dialog(group = "Flow"));
  parameter Real leakExponent = 1.35 "Exponent for Behavior model of the leak" annotation(
    Dialog(group = "Flow"));
  parameter Modelica.SIunits.Velocity Vel_start = 0 "initialize velocity to help numerical convergence" annotation(
    Dialog(group = "Flow"));
  parameter Modelica.SIunits.PressureDifference dp_start = 100 "initialize pressure difference to help numerical convergence" annotation(
    Dialog(group = "Flow"));
  Medium.BaseProperties medium_a(p = fluidport_a.p, h = inStream(fluidport_a.h_outflow), Xi = inStream(fluidport_a.Xi_outflow)) "medium properties at port a";
  Medium.BaseProperties medium_b(p = fluidport_b.p, h = inStream(fluidport_b.h_outflow), Xi = inStream(fluidport_b.Xi_outflow)) "medium properties at port b";
  //
  Modelica.SIunits.PressureDifference dp(start = dp_start, fixed = false);
  Modelica.SIunits.PressureDifference dp_loss;
  Modelica.SIunits.Velocity Vel(start = Vel_start);
  Modelica.SIunits.MassFlowRate m_flow "Aperture flow kg/s";
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
  m_flow = d * leakSurfaceRtatio * crossArea * Vel;
// momentum balance
  dp = fluidport_a.p - fluidport_b.p;
  dp_loss = 1 / 2 * ksi * d * Modelica.Fluid.Utilities.regPow(x = Vel, delta = 0.001, a = leakExponent);
  dp - dp_loss = 0.0;
// port handover
  fluidport_a.m_flow = m_flow;
  fluidport_a.m_flow + fluidport_b.m_flow = 0.0;
  fluidport_a.h_outflow = inStream(fluidport_b.h_outflow);
  fluidport_b.h_outflow = inStream(fluidport_a.h_outflow);
  fluidport_a.Xi_outflow = inStream(fluidport_b.Xi_outflow);
  fluidport_b.Xi_outflow = inStream(fluidport_a.Xi_outflow);
  annotation(
    Diagram,
    Icon(graphics = {Rectangle(origin = {50, 5}, fillColor = {0, 85, 255}, fillPattern = FillPattern.HorizontalCylinder, lineThickness = 0.5, extent = {{-84, 29}, {-24, 23}}), Text(origin = {-42, 113}, lineThickness = 0.5, extent = {{-8, -15}, {92, -49}}, textString = "%name"), Rectangle(origin = {-2, 9}, fillColor = {190, 190, 190}, fillPattern = FillPattern.Cross, lineThickness = 0.5, extent = {{-32, 55}, {28, 25}}), Rectangle(origin = {-2, -27}, fillColor = {190, 190, 190}, fillPattern = FillPattern.Cross, lineThickness = 0.5, extent = {{-32, 55}, {28, 25}}), Rectangle(origin = {50, -31}, fillColor = {0, 85, 255}, fillPattern = FillPattern.HorizontalCylinder, lineThickness = 0.5, extent = {{-84, 29}, {-24, 23}}), Rectangle(origin = {50, -103}, fillColor = {0, 85, 255}, fillPattern = FillPattern.HorizontalCylinder, lineThickness = 0.5, extent = {{-84, 29}, {-24, 23}}), Rectangle(origin = {50, -67}, fillColor = {0, 85, 255}, fillPattern = FillPattern.HorizontalCylinder, lineThickness = 0.5, extent = {{-84, 29}, {-24, 23}}), Rectangle(origin = {-2, -63}, fillColor = {190, 190, 190}, fillPattern = FillPattern.Cross, lineThickness = 0.5, extent = {{-32, 55}, {28, 25}}), Rectangle(origin = {-2, -99}, fillColor = {190, 190, 190}, fillPattern = FillPattern.Cross, lineThickness = 0.5, extent = {{-32, 55}, {28, 25}}), Rectangle(origin = {-2, -135}, fillColor = {190, 190, 190}, fillPattern = FillPattern.Cross, lineThickness = 0.5, extent = {{-32, 55}, {28, 35}})}, coordinateSystem(initialScale = 0.1)),
    __OpenModelica_commandLineOptions = "");
end WallLeaks;