within TAeZoSysPro.Aeraulic.Components.PressureLosses.Pipes;

model inlet_outlet
  package Medium = TAeZoSysPro.Aeraulic.Media.MyMedia;
  //
  parameter Modelica.SIunits.Area crossArea "Inner cross section area" annotation(
    Dialog(group = "Geometry"));
  //
  parameter Real ksi_in = 0.7 "fixed pressure loss coefficient if fluid come in" annotation(
    Dialog(group = "Flow"));
  parameter Real ksi_out = 1.0 "fixed pressure loss coefficient if fluid come out" annotation(
    Dialog(group = "Flow"));
  //
  Medium.BaseProperties medium_a(p = fluidport_a.p, h = inStream(fluidport_a.h_outflow), Xi = inStream(fluidport_a.Xi_outflow)) "medium properties at port a";
  Medium.BaseProperties medium_b(p = fluidport_b.p, h = inStream(fluidport_b.h_outflow), Xi = inStream(fluidport_b.Xi_outflow)) "medium properties at port b";
  //
  Modelica.SIunits.PressureDifference dp;
  Modelica.SIunits.PressureDifference dp_loss;
  Modelica.SIunits.Velocity Vel;
  Modelica.SIunits.MassFlowRate m_flow(displayUnit = "kg/h");
  Modelica.SIunits.Density d;
  Real ksi "pressure loss coefficient";
  //
  Modelica.Fluid.Interfaces.FluidPort_a fluidport_a(replaceable package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_b fluidport_b(replaceable package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
// mass balance
//d = TAeZoSysPro.Aeraulic.Functions.regStep(x = Vel, x_small = 0.01, y1 = medium_a.d, y2 = medium_a.d) ;
  d = if Vel >= 0.0 then medium_a.d else medium_a.d;
  m_flow = d * crossArea * Vel;
// momentum balance
  dp = fluidport_a.p - fluidport_b.p;
  ksi = Functions.regStep(x = Vel, x_small = 0.001, y1 = ksi_in, y2 = ksi_out);
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
    Diagram(coordinateSystem(initialScale = 0.1)),
    Icon(graphics = {Rectangle(origin = {-36, 56}, fillColor = {191, 191, 191}, fillPattern = FillPattern.Cross, lineThickness = 0.5, extent = {{-6, -2}, {10, -28}}), Line(origin = {-26.08, 62.32}, points = {{0, 14}, {0, -8}}, pattern = LinePattern.Dash, thickness = 0.5), Rectangle(origin = {-22, 5}, fillColor = {0, 85, 255}, lineThickness = 0.5, extent = {{-20, 23}, {42, -33}}), Rectangle(origin = {-36, -24}, fillColor = {191, 191, 191}, fillPattern = FillPattern.Cross, lineThickness = 0.5, extent = {{-6, -4}, {10, -32}}), Line(origin = {-42.08, -73.68}, points = {{0, 18}, {0, -14}}, pattern = LinePattern.Dash, thickness = 0.5), Line(origin = {-26.1563, -73.68}, points = {{0, 18}, {0, -14}}, pattern = LinePattern.Dash, thickness = 0.5), Line(origin = {45.98, 28.11}, points = {{-27, 0}, {27, 0}, {27, 0}}, pattern = LinePattern.Dash, thickness = 0.5), Line(origin = {46.36, -27.94}, points = {{-27, 0}, {27, 0}, {27, 0}}, pattern = LinePattern.Dash, thickness = 0.5), Line(origin = {-37, 66}, points = {{-39, 0}, {39, 0}}, color = {0, 85, 255}, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 5), Text(origin = {45, 66}, lineThickness = 0.5, extent = {{-15, 8}, {15, -8}}, textString = "ksi_in %ksi_in",  fontSize = 0 ), Line(origin = {-38.94, -70.43}, rotation = 180, points = {{-39, 0}, {39, 0}}, color = {0, 85, 255}, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 5), Text(origin = {49, -70}, lineThickness = 0.5, extent = {{-15, 8}, {15, -8}}, textString = "ksi_out %ksi_out",  fontSize = 0 ), Text(origin = {-35, 100}, lineThickness = 0.5, extent = {{-15, 8}, {85, -18}}, textString = "%name",  fontSize = 0 ), Line(origin = {-41.8815, 62.0605}, points = {{0, 14}, {0, -8}}, pattern = LinePattern.Dash, thickness = 0.5)}, coordinateSystem(initialScale = 0.1)),
    __OpenModelica_commandLineOptions = "");
end inlet_outlet;
