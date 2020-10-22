within TAeZoSysPro.FluidDynamics.Components.Machines.BaseClasses;

partial model PartialPump "Base model for pumps"
  // Import of libraries
  import Modelica.Constants;

  replaceable package Medium = TAeZoSysPro.Media.MyMedia ;

// User defined parameter
  parameter Boolean checkValve = false "= true to prevent reverse flow" annotation(
    Dialog(group = "Assumptions"),
    Evaluate = true) ;
  parameter Modelica.SIunits.Conversions.NonSIunits.AngularVelocity_rpm N_nominal "Nominal rotational speed for flow characteristic" annotation(
  Dialog(group="Characteristics"));
  parameter Medium.Density d_nominal = Medium.density_pTX(Medium.p_default, Medium.T_default, Medium.X_default) "Nominal fluid density for characteristic" annotation(
  Dialog(group="Characteristics"));
  parameter Boolean use_powerCharacteristic = false "Use powerCharacteristic (vs. efficiencyCharacteristic)" annotation( 
  Evaluate=true,Dialog(group="Characteristics"));


// Characteristic curves
  replaceable function flowCharacteristic = Modelica.Fluid.Machines.BaseClasses.PumpCharacteristics.baseFlow "Head vs. V_flow characteristic at nominal speed and density" annotation(Dialog(group="Characteristics"), choicesAllMatching=true);
  
  replaceable function powerCharacteristic = Modelica.Fluid.Machines.BaseClasses.PumpCharacteristics.quadraticPower (
       V_flow_nominal={0,0,0},W_nominal={0,0,0})
      "Power consumption vs. V_flow at nominal speed and density"
    annotation(Dialog(group="Characteristics", enable = use_powerCharacteristic),
               choicesAllMatching=true);  
  
  replaceable function efficiencyCharacteristic =
    Modelica.Fluid.Machines.BaseClasses.PumpCharacteristics.constantEfficiency(eta_nominal = 0.8) constrainedby
      Modelica.Fluid.Machines.BaseClasses.PumpCharacteristics.baseEfficiency
      "Efficiency vs. V_flow at nominal speed and density"
    annotation(Dialog(group="Characteristics",enable = not use_powerCharacteristic),
               choicesAllMatching=true);
   
// Internal variables
  Modelica.SIunits.VolumeFlowRate V_flow "Volume flow rate at port_a" ;
  Modelica.SIunits.MassFlowRate m_flow "Mass flow rate" ;
  Modelica.SIunits.Power P "Power given to the fluid" ;
  Modelica.SIunits.Density d "Density at port_a";
  Modelica.SIunits.Position head "Pump head";
  Modelica.SIunits.PressureDifference dp "Pressure difference between port_a and port_b" ;
  Modelica.SIunits.Efficiency eta "Isentropic efficiency" ;
  Modelica.SIunits.Conversions.NonSIunits.AngularVelocity_rpm N "Shaft rotational speed";
  Medium.ThermodynamicState state "State at inlet" ;
  // Imported components
  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium = Medium, m_flow(min = if not checkValve then -Constants.inf else 0)) annotation(
    Placement(visible = true, transformation(origin = {-100, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium = Medium, m_flow(max = if not checkValve then +Constants.inf else 0)) annotation(
    Placement(visible = true, transformation(origin = {100, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  constant Modelica.SIunits.Acceleration g = Constants.g_n ;
equation
// Temporary variables
  
// Get the state at inlet
  state = Medium.setState_phX(p = port_a.p, h = if checkValve then inStream(port_a.h_outflow) else actualStream(port_a.h_outflow));
//
  dp = port_a.p - port_b.p ;
  V_flow = m_flow / d ;
  d = Medium.density(state) ;
  head = -dp/(d*g) ;
  head = (N/N_nominal)^2*flowCharacteristic(V_flow*N_nominal/N) ;
  //V_flow = flowCharacteristic(head) ;  

// Power consumption
  if use_powerCharacteristic then
    P = (N/N_nominal)^2*(d/d_nominal)*powerCharacteristic(V_flow*(N_nominal/N));
    eta = -dp*V_flow/P;
  else
    eta = efficiencyCharacteristic(V_flow*(N_nominal/N)) ;
    P = -dp*V_flow/eta ;
  end if;

// Ports handover
  // port_a
  port_a.m_flow = m_flow;
  port_a.h_outflow = if checkValve then inStream(port_a.h_outflow) else inStream(port_b.h_outflow) ;
  port_a.Xi_outflow = if checkValve then inStream(port_a.Xi_outflow) else inStream(port_b.Xi_outflow) ;
  port_a.C_outflow = if checkValve then inStream(port_a.C_outflow) else inStream(port_b.C_outflow) ;
  // port_b
  port_a.m_flow + port_b.m_flow = 0.0 ;
  P = m_flow * (port_b.h_outflow - inStream(port_a.h_outflow)) ;
  port_b.Xi_outflow = inStream(port_a.Xi_outflow) ;
  port_b.C_outflow = inStream(port_a.C_outflow) ;

  annotation(
    Icon(coordinateSystem(initialScale = 0.1), graphics = {Rectangle(fillColor = {0, 127, 255}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-100, 46}, {100, -46}}), Polygon(lineColor = {0, 0, 255}, pattern = LinePattern.None, fillPattern = FillPattern.VerticalCylinder, points = {{-48, -60}, {-72, -100}, {72, -100}, {48, -60}, {-48, -60}}), Ellipse(fillColor = {0, 100, 199}, fillPattern = FillPattern.Sphere, extent = {{-80, 80}, {80, -80}}, endAngle = 360), Polygon(fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.HorizontalCylinder, points = {{-28, 30}, {-28, -30}, {50, -2}, {-28, 30}})}),
    Documentation(info = "
<html>
  <p>
    This is the base model for pumps strongly inspired from the PartialPump of Modelica Standard Library (MSL).
  </p>
  
  <p>
    The pump model is based on the theory of kinematic similarity: the pump characteristics are given for nominal operating conditions (rotational speed and fluid density), and then adapted to actual operating condition, according to the similarity equations.
  </p>

  <img
    src = \"modelica://TAeZoSysPro/Information/FluidDynamics/Components/Machines/EQ_PartialPump.png\"
  />

  <p>
    <strong>Pump characteristics</strong>
  </p>
  
  <p> 
    The nominal hydraulic characteristic (head vs. volume flow rate) is given by the replaceable function <code>flowCharacteristic</code>.
  </p>
  
  <p> 
    The pump energy balance can be specified in two alternative ways:
  </p>
  
  <ul>
    <li><code>use_powerCharacteristic = false</code> (default option): the replaceable function <code>efficiencyCharacteristic</code> (efficiency vs. volume flow rate in nominal conditions) is used to determine the efficiency, and then the power consumption.
    The default is a constant efficiency of 0.8.</li>
    <li><code>use_powerCharacteristic = true</code>: the replaceable function <code>powerCharacteristic</code> (power consumption vs. volume flow rate in nominal conditions) is used to determine the power consumption, and then the efficiency.
    Use <code>powerCharacteristic</code> to specify a non-zero power consumption for zero flow rate.</li>
  </ul>
  
  <p>
    Several functions are provided in the package <code>PumpCharacteristics</code> of the TAeZoSysPro library or the MSL to specify the characteristics as a function of some operating points at nominal conditions.
  </p>
  <p>
    Depending on the value of the <code>checkValve</code> parameter, the model either supports reverse flow conditions, or includes a built-in check valve to avoid flow reversal.
  </p>

  <p>
    <strong>Dynamics options</strong>
  </p>
  
  <p>
    The pump dynamic is quasistatic.
    No mass or energy are stored.
  </p>

<p>
  <strong>Heat transfer</strong>
</p>

<p>
  The pump is adiabatic.
</p>

<p><strong>Diagnostics of Cavitation</strong></p>
<p>The replaceable Monitoring submodel can be configured to PumpMonitoringNPSH,
in order to compute the Net Positive Suction Head available and check for cavitation,
provided a two-phase medium model is used (see Advanced tab).
</p>
</html>", revisions = "<html>
<ul>
<li><em>8 Jan 2013</em>
  by R&uuml;diger Franke:<br>
  moved NPSH diagnostics from PartialPump to replaceable sub-model PumpMonitoring.PumpMonitoringNPSH (see ticket #646)</li>
<li><em>Dec 2008</em>
  by R&uuml;diger Franke:<br>
  <ul>
  <li>Replaced simplified mass and energy balances with rigorous formulation (base class PartialLumpedVolume)</li>
  <li>Introduced optional HeatTransfer model defining Qb_flow</li>
  <li>Enabled events when the checkValve is operating to support the opening of a discrete valve before port_a</li>
  </ul></li>
<li><em>31 Oct 2005</em>
  by <a href=\"mailto:francesco.casella@polimi.it\">Francesco Casella</a>:<br>
     Model added to the Fluid library</li>
</ul>
</html>"));

end PartialPump;
