within TAeZoSysPro.Aeraulic.Components.PressureLosses.Pipes;

model AdiabaticStaticPipe
  replaceable package Medium = TAeZoSysPro.Aeraulic.Media.MyMedia;
  //
  //  parameter Boolean                   isCircular = true "= true if cross sectional area is circular" annotation(Dialog(group="Geometry"));
  //  parameter Modelica.SIunits.Diameter diameter "Diameter of circular pipe" annotation(Dialog(group="Geometry"));
  parameter Modelica.SIunits.Length length = 1 "pipe" annotation(
    Dialog(group = "Geometry"));
  parameter Modelica.SIunits.Area crossArea "Inner cross section area" annotation(
    Dialog(group = "Geometry"));
  //  parameter Modelica.SIunits.Length   perimeter=Modelica.Constants.pi*diameter "Inner perimeter" annotation(Dialog(group="Geometry"));
  parameter Modelica.SIunits.Length z_a = 0 "altitude of a point" annotation(
    Dialog(group = "Geometry"));
  parameter Modelica.SIunits.Length z_b = 0 "altitude of b point" annotation(
    Dialog(group = "Geometry"));
  //
  parameter Real ksi_fixed "fixed pressure loss coefficient" annotation(
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
    Placement(visible = true, transformation(origin = {-100, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_b fluidport_b(replaceable package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {100, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
initial equation
//  der(Vel) = 0.0;
equation
// mass balance
//d = TAeZoSysPro.Aeraulic.Functions.regStep(x = Vel, x_small = 0.01, y1 = medium_a.d, y2 = medium_a.d) ;
  d = if Vel >= 0.0 then medium_a.d else medium_a.d;
  m_flow = d * crossArea * Vel;
// momentum balance
  dp = fluidport_a.p - fluidport_b.p;
  ksi = ksi_fixed;
  dp_loss = 1 / 2 * ksi * d * Modelica.Fluid.Utilities.regSquare2(x = Vel, x_small = 0.001, k1 = 1, k2 = 1);
  dp + d * Modelica.Constants.g_n * (z_a - z_b) - dp_loss = 0.0;
/*length * d * der(Vel)*/
// port handover
  fluidport_a.m_flow = m_flow;
  fluidport_a.m_flow + fluidport_b.m_flow = 0.0;
  fluidport_a.h_outflow = inStream(fluidport_b.h_outflow) + Modelica.Constants.g_n * (z_a - z_b);
  fluidport_b.h_outflow = inStream(fluidport_a.h_outflow) - Modelica.Constants.g_n * (z_a - z_b);
  fluidport_a.Xi_outflow = inStream(fluidport_b.Xi_outflow);
  fluidport_b.Xi_outflow = inStream(fluidport_a.Xi_outflow);
  annotation(
    Diagram,
    Icon(graphics = {Rectangle(origin = {0, -1}, fillColor = {0, 85, 255}, lineThickness = 0.5, extent = {{-84, 29}, {84, -29}}), Text(origin = {-42, 103}, lineThickness = 0.5, extent = {{-8, -15}, {92, -49}}, textString = "%name"), Text(origin = {-110, -23}, lineThickness = 0.5, extent = {{-8, -15}, {36, -31}}, textString = "Alt a %z_a m",  fontSize = 0 ), Text(origin = {84, -23}, lineThickness = 0.5, extent = {{-8, -15}, {36, -31}}, textString = "Alt b %z_b m",  fontSize = 0 )}, coordinateSystem(initialScale = 0.1)),
    __OpenModelica_commandLineOptions = "");
end AdiabaticStaticPipe;