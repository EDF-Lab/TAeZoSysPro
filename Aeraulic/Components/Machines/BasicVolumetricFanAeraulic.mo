within TAeZoSysPro.Aeraulic.Components.Machines;

model BasicVolumetricFanAeraulic
  package Medium = TAeZoSysPro.Aeraulic.Media.MyMedia;
  //
  Modelica.SIunits.PressureDifference dp;
  parameter Modelica.SIunits.VolumeFlowRate VolumetricFlow(displayUnit = "m3/h") = 1;
  parameter Boolean Use_inlet_flowrate = false;
  Modelica.SIunits.MassFlowRate m_flow "Aperture flow kg/s";
  Modelica.SIunits.Density d;
  Modelica.SIunits.Power PowerAeraulic;
  Modelica.SIunits.VolumeFlowRate VolumetricFlow_fan(displayUnit = "m3/h");
  Real FanAeraulicEfficiency = 0.8;
  //ports
  TAeZoSysPro.Aeraulic.Interfaces.FlowPort_a Flowport_a(replaceable package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-58, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  TAeZoSysPro.Aeraulic.Interfaces.FlowPort_b Flowport_b(replaceable package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {38, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput u annotation(
    Placement(visible = true, transformation(origin = {-90, 38}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-76, 58}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
protected
  Modelica.SIunits.MassFraction[Medium.nX] X_a "Mass fraction vector at port a";
  Modelica.SIunits.MassFraction[Medium.nX] X_b "Mass fraction vector at port b";
equation
//
  X_a = 1 / sum(Flowport_a.di) * Flowport_a.di;
  X_b = 1 / sum(Flowport_b.di) * Flowport_b.di;
//
  VolumetricFlow_fan = if Use_inlet_flowrate then u else VolumetricFlow;
  if not Use_inlet_flowrate then
    u = 0;
  end if;
  dp = sum(Flowport_b.pi) - sum(Flowport_a.pi);
  PowerAeraulic = dp * VolumetricFlow_fan / FanAeraulicEfficiency;
  d = sum(Flowport_a.di);
  m_flow = VolumetricFlow_fan * d;
//mass flow through ports
//  Flowport_a.m_flow = m_flow * Functions.regStep(x=Vel, x_small=0.01, y1=X_a, y2=X_b) ;
  Flowport_a.m_flow = m_flow * X_a;
  Flowport_a.m_flow + Flowport_b.m_flow = fill(0.0, Medium.nX);
  Flowport_a.H_flow = m_flow * Flowport_a.h;
  Flowport_a.H_flow + Flowport_b.H_flow + PowerAeraulic = 0;
  annotation(
    Icon(graphics = {Ellipse(origin = {2, 0}, lineThickness = 1.5, extent = {{-64, 66}, {64, -66}}, endAngle = 360), Polygon(origin = {8.67, -0.01}, lineThickness = 1.5, points = {{-56.6729, 40.0052}, {-56.6729, -39.9948}, {57.3271, -1.99483}, {-56.6729, 40.0052}}), Text(origin = {-85, 29}, extent = {{-21, 7}, {21, -7}}, textString = "m3/s",  fontSize = 0 )}),
    Diagram(coordinateSystem(extent = {{-100, -80}, {100, 80}})),
    __OpenModelica_commandLineOptions = "");
end BasicVolumetricFanAeraulic;
