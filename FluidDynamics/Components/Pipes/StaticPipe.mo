within TAeZoSysPro.FluidDynamics.Components.Pipes;

model StaticPipe

  replaceable package Medium = TAeZoSysPro.Media.MyMedia ;
  
  // User defined parameters
  parameter Modelica.SIunits.Area A "Inner cross section area" annotation(
    Dialog(group = "Geometry"));
  parameter Real ksi = 1 "dynamic pressure loss" annotation(
    Dialog(group = "Flow"));
  
  // Internal variables
  Modelica.SIunits.Density d_a "Density if flow positive at port_a" ;
  Modelica.SIunits.Density d_b "Density if flow positive at port_b" ;
  Modelica.SIunits.PressureDifference dp;
  Modelica.SIunits.Velocity Vel;
  Modelica.SIunits.MassFlowRate m_flow "Aperture flow kg/s";
  
  // Imported Modules
  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium = Medium) annotation (
    Placement(visible = true, transformation(origin = {-100, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium = Medium) annotation (
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //
  parameter Modelica.SIunits.PressureDifference dp_small = 0.01;

equation

// mass balance
  d_a = Medium.density_phX(p = port_a.p, 
                           h = inStream(port_a.h_outflow), 
                           X = cat(1, inStream(port_a.Xi_outflow), {1 - sum(inStream(port_a.Xi_outflow))})) ;
  d_b = Medium.density_phX(p = port_b.p, 
                           h = inStream(port_b.h_outflow), 
                           X = cat(1, inStream(port_b.Xi_outflow), {1 - sum(inStream(port_b.Xi_outflow))})) ;

  dp = port_a.p - port_b.p;
  m_flow = A * Modelica.Fluid.Utilities.regRoot2(x = dp,
                                                 x_small = dp_small,
                                                 k1 = 2.0 * d_a / ksi,
                                                 k2 = 2.0 * d_b / ksi) ;
  Vel * d_a * A = m_flow ;

// Ports handover
  port_a.m_flow = m_flow;
  port_a.m_flow + port_b.m_flow = 0.0;
  port_a.h_outflow = inStream(port_b.h_outflow);
  port_b.h_outflow = inStream(port_a.h_outflow);
  port_a.Xi_outflow = inStream(port_b.Xi_outflow);
  port_b.Xi_outflow = inStream(port_a.Xi_outflow);
  
  annotation (defaultComponentName="staticPipe",
Documentation(info ="
<html>
  <head>
    <title>StaticPipe</title>
  </head>
	
  <body lang=\"en-UK\">
    <p>
      This components allows to model the mass flow rate through a pipe from a pressure difference at boundaries and the pressure loss coefficient <b>ksi</b>.
      The flow regime is steady state. 
    </p>
    
    <p>
      ksi expresses how many dynamic pressure is lost. 
      It is assumed to be constant and therefore independent of the flow regime.
    </p>    
    			
    <img	
      src=\"modelica://TAeZoSysPro/Information/FluidDynamics/Components/Pipes/EQ_StaticPipe_ksi.PNG\"
    />

    <p>
      The mass flow rate relation derives:
    </p>

    <img	
      src=\"modelica://TAeZoSysPro/Information/FluidDynamics/Components/Pipes/EQ_StaticPipe_m_flow.PNG\"
    />
 		
    <p>	
      <b>Where</b>:
      <ul>
        <li> <code>dp</code> is the pressure difference between port_a.p and port_b.p </li>
        <li> <code>ksi</code> is the pressure loss coefficient </li>
        <li> <code>d</code> is the upstream density </li>
        <li> <code>Vel</code> is fluid velocity </li>              
        <li> <code>m_flow</code> is the mass flow rate through the pipe </li>
        <li> <code>A</code> is cross section of the pipe </li>
      </ul>				
    </p>

    <p>
      To avoid infinite derivative at dp=0, The square root is replaced by the function <b>regRoot2</b> of the MSL that replace the square root by a polynomial expression to insure a finite derivative. The threshold to switch between the polynom and the square root is <b> abs(dp≤0.1) Pa </b>
    </p>			
  </body>
</html>"),
Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}}), graphics={Rectangle( fillColor = {0, 127, 255}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-100, 44}, {100, -44}})}));
end StaticPipe;
