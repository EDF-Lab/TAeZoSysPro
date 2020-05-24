within TAeZoSysPro.Aeraulic.Components.PressureLosses.Valves;

model ControlDamper

package Medium = TAeZoSysPro.Aeraulic.Media.MyMedia;
  //
  parameter Modelica.SIunits.Area crossArea "Inner cross section area" annotation(
    Dialog(group = "Geometry"));
  //
  parameter Modelica.SIunits.Velocity Vel_start = 0 "initialize velocity to help numerical convergence" annotation(
    Dialog(group = "Flow"));
  //
  Medium.BaseProperties medium_a(p = fluidport_a.p, h = inStream(fluidport_a.h_outflow), Xi = inStream(fluidport_a.Xi_outflow)) "medium properties at port a";
  Medium.BaseProperties medium_b(p = fluidport_b.p, h = inStream(fluidport_b.h_outflow), Xi = inStream(fluidport_b.Xi_outflow)) "medium properties at port b";
  //
  Modelica.SIunits.PressureDifference dp;
  Modelica.SIunits.PressureDifference dp_loss;
  Modelica.SIunits.Velocity Vel(start = Vel_start);
  Modelica.SIunits.MassFlowRate m_flow "Aperture flow kg/s";
  Modelica.SIunits.Density d;
  //
  Modelica.Fluid.Interfaces.FluidPort_a fluidport_a(replaceable package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-100, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_b fluidport_b(replaceable package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {100, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PressureLossCoeff annotation(
    Placement(visible = true, transformation(origin = {4, -8}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-8.88178e-16, -86}, extent = {{-12, -12}, {12, 12}}, rotation = 90)));
equation
// mass balance
//d = TAeZoSysPro.Aeraulic.Functions.regStep(x = Vel, x_small = 0.01, y1 = medium_a.d, y2 = medium_a.d) ;
  d = if Vel >= 0.0 then medium_a.d else medium_b.d;
  m_flow = d * crossArea * Vel;
// momentum balance
  dp = fluidport_a.p - fluidport_b.p;
  dp_loss = 1 / 2 * PressureLossCoeff * d * Modelica.Fluid.Utilities.regSquare2(x = Vel, x_small = 0.001, k1 = 1, k2 = 1);
  dp - dp_loss = 0.0;
// port handover
  fluidport_a.m_flow = m_flow;
  fluidport_a.m_flow + fluidport_b.m_flow = 0.0;
  fluidport_a.h_outflow = inStream(fluidport_b.h_outflow);
  fluidport_b.h_outflow = inStream(fluidport_a.h_outflow);
  fluidport_a.Xi_outflow = inStream(fluidport_b.Xi_outflow);
  fluidport_b.Xi_outflow = inStream(fluidport_a.Xi_outflow);
  annotation(
    Icon(graphics = {Text(origin = {8, 39}, extent = {{-46, 33}, {24, 13}}, textString = "%name"), Rectangle(origin = {-1, -2}, extent = {{-77, 74}, {81, -70}}), Line(origin = {-63, 0}, points = {{-29, 0}, {29, 0}, {55, 0}}), Line(origin = {61.6412, 0}, points = {{-53, 0}, {29, 0}, {29, 0}}), Line(origin = {-1, -2}, points = {{-69, -64}, {73, 70}}), Ellipse(fillPattern = FillPattern.Solid,extent = {{-8, 8}, {8, -8}}, endAngle = 360), Text(origin = {24, -89}, extent = {{-62, 41}, {24, 13}}, textString = "Pressure Loss Coefficient",  fontSize = 0 ), Ellipse(origin = {-3, 131}, lineThickness = 0.5, extent = {{-19, 15}, {25, -25}}, endAngle = 360), Text(origin = {7, 115}, lineThickness = 0.5, extent = {{-21, 23}, {7, 1}}, textString = "M",  fontSize = 0 ), Polygon(origin = {-3, 89}, lineThickness = 0.5, points = {{3, -17}, {-11, 17}, {17, 17}, {3, -17}})}, coordinateSystem(extent = {{-100, -100}, {100, 150}}, initialScale = 0.1)),
    __OpenModelica_commandLineOptions = "");

end ControlDamper;