within TAeZoSysPro.Aeraulic.Components.PressureLosses.Others;

model Filter
  package Medium = TAeZoSysPro.Aeraulic.Media.MyMedia;
  type filterBehaviorModel = enumeration(linear, linearAndQuadratic);
  parameter filterBehaviorModel filterBehavior = filterBehaviorModel.linear "Behavior model of the filter";
  //
  parameter Modelica.SIunits.Area crossArea "Inner cross section area" annotation(
    Dialog(group = "Geometry"));
  parameter Real K(unit = "Pa.s/m") "linear pressure loss coefficient" annotation(
    Dialog(group = "Flow"));
  parameter Real ksi = 0.0 "dynamic pressure loss (if quadratic)" annotation(
    Dialog(group = "Flow"));
  Medium.BaseProperties medium_a(p = fluidport_a.p, h = inStream(fluidport_a.h_outflow), Xi = inStream(fluidport_a.Xi_outflow)) "medium properties at port a";
  Medium.BaseProperties medium_b(p = fluidport_b.p, h = inStream(fluidport_b.h_outflow), Xi = inStream(fluidport_b.Xi_outflow)) "medium properties at port b";
  //
  Modelica.SIunits.PressureDifference dp;
  Modelica.SIunits.PressureDifference dp_loss;
  Modelica.SIunits.Velocity Vel;
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
  m_flow = d * crossArea * Vel;
// momentum balance
  dp = fluidport_a.p - fluidport_b.p;
  if filterBehavior == filterBehaviorModel.linear then
    dp_loss = K * Vel;
  else
    dp_loss = K * Vel + 1 / 2 * ksi * d * Modelica.Fluid.Utilities.regSquare2(x = Vel, x_small = 0.001, k1 = 1, k2 = 1);
  end if;
  dp - dp_loss = 0.0;
// port handover
  fluidport_a.m_flow = m_flow;
  fluidport_a.m_flow + fluidport_b.m_flow = 0.0;
  fluidport_a.h_outflow = inStream(fluidport_b.h_outflow);
  fluidport_b.h_outflow = inStream(fluidport_a.h_outflow);
  fluidport_a.Xi_outflow = inStream(fluidport_b.Xi_outflow);
  fluidport_b.Xi_outflow = inStream(fluidport_a.Xi_outflow);
  annotation(
    Icon(graphics = {Line(origin = {4, 70}, points = {{-78, 0}, {78, 0}}, pattern = LinePattern.Dash, thickness = 0.5), Line(origin = {4.38168, -70.5038}, points = {{-78, 0}, {78, 0}}, pattern = LinePattern.Dash, thickness = 0.5), Rectangle(origin = {7, 0}, fillColor = {170, 255, 127}, fillPattern = FillPattern.Solid, lineThickness = 0.5, extent = {{-37, 70}, {25, -70}}), Line(origin = {1, 0}, points = {{-31, 70}, {31, 54}, {-31, 38}, {31, 24}, {-31, 6}, {31, -8}, {-31, -26}, {31, -38}, {-31, -56}, {31, -70}}, thickness = 0.5), Text(origin = {1, 87}, lineThickness = 0.5, extent = {{-65, 9}, {65, -9}}, textString = "%name"), Text(origin = {-53, -86}, lineThickness = 0.5, extent = {{-17, 10}, {17, -10}}, textString = "K = %K",  fontSize = 0 ), Text(origin = {51, -86}, lineThickness = 0.5, extent = {{-17, 10}, {17, -10}}, textString = "ksi = %ksi",  fontSize = 0 )}, coordinateSystem(initialScale = 0.1)));
end Filter;