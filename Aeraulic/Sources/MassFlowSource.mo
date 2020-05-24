within TAeZoSysPro.Aeraulic.Sources;

model MassFlowSource
  // medium declaration
  package Medium = Media.MyMedia;
  // Internal parameters
  // Fluid output properties
  parameter Modelica.SIunits.SpecificEnthalpy h_out = 0 " enthalpy";
  parameter Modelica.SIunits.MassFraction[Medium.nX] X_input = {1, 0};
  parameter Modelica.SIunits.MassFlowRate m_flow_out = 0 "Mass flow rate";
  // optional use of external values
  parameter Boolean Use_External_m_flow = false "Use an input for m_flow";
  parameter Boolean Use_External_h = false "Use an input for h_out";
  //Components inported
  Modelica.Blocks.Interfaces.RealInput m_flow_input if Use_External_m_flow annotation(
    Placement(visible = true, transformation(origin = {-72, 56}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-85, 69}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput h_input if Use_External_h annotation(
    Placement(visible = true, transformation(origin = {-60, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-85, -79}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  Interfaces.FlowPort_a Flowport(replaceable package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-48, -12}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
protected
  Modelica.SIunits.MassFlowRate m_flow_input_internal;
  Modelica.SIunits.SpecificEnthalpy h_input_internal;
equation
// external of internal variable values
  if not Use_External_m_flow then
    m_flow_input_internal = m_flow_out;
  else
    m_flow_input_internal = m_flow_input;
  end if;
  if not Use_External_h then
    h_input_internal = h_out;
  else
    h_input_internal = h_input;
  end if;
// Ports mass balance
  Flowport.m_flow = if m_flow_input_internal > 0.0 then -m_flow_input_internal * X_input else -m_flow_input_internal * 1 / sum(Flowport.di) * Flowport.di;
// Port energy and mass fraction balance
  Flowport.H_flow = if m_flow_input_internal > 0.0 then -m_flow_input_internal * h_input_internal else -m_flow_input_internal * Flowport.h;
  annotation(
    Icon(coordinateSystem(initialScale = 0.1), graphics = {Text(origin = {-62, 91}, extent = {{-18, 9}, {42, -11}}, textString = "m_flow_input",  fontSize = 0 ), Polygon(origin = {-14.28, 40}, fillPattern = FillPattern.Solid, points = {{0.2764, 20}, {0.2764, -102}, {100.276, -40}, {0.2764, 20}}), Ellipse(origin = {22, 42}, extent = {{-72, 26}, {64, -112}}, endAngle = 360), Text(origin = {-62, -59}, extent = {{-18, 9}, {22, -11}}, textString = "h_input",  fontSize = 0 )}));
end MassFlowSource;
