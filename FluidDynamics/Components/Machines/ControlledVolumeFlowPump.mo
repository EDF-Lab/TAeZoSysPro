within TAeZoSysPro.FluidDynamics.Components.Machines;

model ControlledVolumeFlowPump "Pump with controlled volume flow rate"

  replaceable package Medium = TAeZoSysPro.Media.MyMedia ;

  // User defined parameters
  parameter Boolean Fan = false "If true fan icon else pump icon" annotation(Evaluate=true, HideResult=true, choices(checkBox=true)) ;
  parameter Boolean checkValve = false "= true to prevent reverse flow" annotation(
    Dialog(group = "Assumptions"),
    Evaluate = true) ;
  parameter Boolean use_V_flow_set = false "= true to use input signal V_flow_set instead of V_flow_nominal";
  parameter Modelica.SIunits.VolumeFlowRate V_flow_nominal "Nominal volume flow rate, fixed if not use_V_flow_set";
  parameter Modelica.SIunits.Efficiency eta = 0.8 "Isentropic efficiency" ;

// Internal variables
  Modelica.SIunits.VolumeFlowRate V_flow "Volume flow rate at port_a" ;
  Modelica.SIunits.MassFlowRate m_flow "Mass flow rate" ;
  Modelica.SIunits.Power P "Power given to the fluid" ;
  Modelica.SIunits.Density d "Density at port_a";
  Modelica.SIunits.Position head "Pump head";
  Modelica.SIunits.PressureDifference dp "Pressure difference between port_a and port_b" ;
  Medium.ThermodynamicState state "State at inlet" ;
  
  // Imported modules
  Modelica.Blocks.Interfaces.RealInput V_flow_set if use_V_flow_set "Prescribed mass flow rate" annotation (
    Placement(visible = true, transformation(origin = {0, 100}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(extent = {{-20, 80}, {20, 120}}, rotation = -90)));
  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium = Medium, m_flow(min = if not checkValve then -Modelica.Constants.inf else 0)) annotation(
    Placement(visible = true, transformation(origin = {-100, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium = Medium, m_flow(max = if not checkValve then +Modelica.Constants.inf else 0)) annotation(
    Placement(visible = true, transformation(origin = {100, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

protected
  Modelica.Blocks.Interfaces.RealInput V_flow_set_internal "Needed to connect to conditional connector" ;

equation
// Internal connector value when use_m_flow_set = false
  if not use_V_flow_set then
    V_flow_set_internal = V_flow_nominal;
  end if;
  connect(V_flow_set, V_flow_set_internal) annotation(
    Line);

// Get the state at inlet
  state = Medium.setState_phX(p = port_a.p, h = if checkValve then inStream(port_a.h_outflow) else actualStream(port_a.h_outflow));
  
//
  dp = port_a.p - port_b.p ;
  V_flow = V_flow_set_internal ; 
  V_flow = m_flow / d ;
  d = Medium.density(state) ;
  head = -dp/(d*Modelica.Constants.g_n) ; 
  P = -dp*V_flow/eta;

// Ports handover
  // port_a
  port_a.m_flow = m_flow;
  port_a.h_outflow = if checkValve then inStream(port_a.h_outflow) else inStream(port_b.h_outflow) ;
  port_a.Xi_outflow = if checkValve then inStream(port_a.Xi_outflow) else inStream(port_b.Xi_outflow) ;
  port_a.C_outflow = if checkValve then inStream(port_a.C_outflow) else inStream(port_b.C_outflow) ;
  // port_b
  port_a.m_flow + port_b.m_flow = 0.0 ;
  port_b.h_outflow = noEvent(if abs(m_flow)>10*Modelica.Constants.eps then P/m_flow+inStream(port_a.h_outflow) else inStream(port_a.h_outflow));
  port_b.Xi_outflow = inStream(port_a.Xi_outflow) ;
  port_b.C_outflow = inStream(port_a.C_outflow) ;  
     
  annotation(
    defaultComponentName="pump",
    Documentation(info = 
"<html>
  <p>
    This model describes a pump with ideally controlled volume flow rate.
  </p>
  <p>
    The input connectors <code>V_flow_set</code> can optionally be enabled via <code>use_V_flow_set</code> to provide time varying set points.
  </p>
  <p>
    Use this model if the pump characteristics is of secondary interest.
    The actual characteristics can be configured later on for the appropriate rotational speed N.
    Then the model can be replaced with a PrescribedPump.
  </p>
</html>"),
    Icon(graphics = {
      Polygon(
        lineColor = {0, 0, 255}, 
        pattern = LinePattern.None, 
        fillPattern = FillPattern.VerticalCylinder, 
        points = {{-48, -60}, {-72, -100}, {72, -100}, {48, -60}, {-48, -60}}), 
      Rectangle(
        fillColor = {0, 127, 255}, 
        fillPattern = FillPattern.HorizontalCylinder, 
        extent = {{-100, 46}, {100, -46}}), 
      Ellipse(
        visible = Fan,
        lineColor = {0, 0, 127}, 
        fillColor = {255, 255, 255}, 
        fillPattern = FillPattern.Solid, 
        lineThickness = 0.5, 
        extent = {{-80, 80}, {80, -80}}, 
        endAngle = 360), 
      Polygon(
        visible = Fan,
        origin = {0, 39}, 
        fillColor = {182, 182, 182}, 
        fillPattern = FillPattern.Solid, 
        lineThickness = 0.5, 
        points = {{0, -39}, {-12, 35}, {0, 39}, {12, 35}, {0, -39}}), 
      Polygon(
        visible = Fan,
        origin = {40, -1}, 
        rotation = -90, 
        fillColor = {182, 182, 182}, 
        fillPattern = FillPattern.Solid, 
        lineThickness = 0.5, 
        points = {{0, -39}, {-12, 35}, {0, 39}, {12, 35}, {0, -39}}), 
      Polygon(
        visible = Fan,
        origin = {0, -39}, 
        rotation = 180, 
        fillColor = {182, 182, 182}, 
        fillPattern = FillPattern.Solid, 
        lineThickness = 0.5, 
        points = {{0, -39}, {-12, 35}, {0, 39}, {12, 35}, {0, -39}}), 
      Polygon(
        visible = Fan,
        origin = {-40, -1}, 
        rotation = 90, 
        fillColor = {182, 182, 182}, 
        fillPattern = FillPattern.Solid, 
        lineThickness = 0.5, points = {{0, -39}, {-12, 35}, {0, 39}, {12, 35}, {0, -39}}), 
      Ellipse(
        visible = Fan,
        origin = {0, -2}, 
        fillColor = {182, 182, 182}, 
        fillPattern = FillPattern.Sphere, 
        lineThickness = 1, 
        extent = {{-10, -10}, {10, 10}}, 
        endAngle = 360),     
      Ellipse(
        visible = not Fan,
        extent={{-80,80},{80,-80}},
        fillPattern=FillPattern.Sphere,
        fillColor={0,100,199}),
      Polygon(
        visible = not Fan,
        points={{-28,30},{-28,-30},{50,-2},{-28,30}},
        pattern=LinePattern.None,
        fillPattern=FillPattern.HorizontalCylinder,
        fillColor={255,255,255})})) ;

end ControlledVolumeFlowPump;
