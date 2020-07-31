within TAeZoSysPro.FluidDynamics.Components.Filters;

model Filter
  //
  replaceable package Medium = Modelica.Media.Air.SimpleAir ;
  
  // User defined parameters
  parameter Real K(unit = "m3/s/Pa") = V_flow_nominal / dp_nominal "linear pressure loss coefficient" annotation(
    Dialog(group = "Flow"));
  parameter Modelica.SIunits.Pressure dp_nominal "Nominal pressure drop" annotation(
  Dialog(group="Nominal operating point"));
  parameter Modelica.SIunits.VolumeFlowRate V_flow_nominal "Nominal volume flowrate" annotation(
  Dialog(group="Nominal operating point"));
  
  // Internal variables
  Modelica.SIunits.PressureDifference dp;
  Modelica.SIunits.MassFlowRate m_flow "Aperture flow kg/s";
  Modelica.SIunits.Density d;
  
  // Imported modules
  Modelica.Fluid.Interfaces.FluidPort_a port_a(replaceable package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(replaceable package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

protected

equation
  //
  d = smooth(0, noEvent(
    if dp<0 then 
      Medium.density(Medium.setState_phX(port_a.p, port_a.h_outflow, port_a.Xi_outflow)) 
    else 
      Medium.density(Medium.setState_phX(port_b.p, port_b.h_outflow, port_b.Xi_outflow)) ) ) ;

// momentum balance
  dp = port_a.p - port_b.p;
  m_flow = d * K * dp  ;

// port handover
  port_a.m_flow = m_flow;
  port_a.m_flow + port_b.m_flow = 0.0;
  port_a.h_outflow = inStream(port_b.h_outflow);
  port_b.h_outflow = inStream(port_a.h_outflow);
  port_a.Xi_outflow = inStream(port_b.Xi_outflow);
  port_b.Xi_outflow = inStream(port_a.Xi_outflow);
  
  annotation(defaultComponentName="filter",
Documentation(info ="
<html>
  <head>
    <title>Filter</title>
  </head>
	
  <body lang=\"en-UK\">
    <p>
      This components models the mass flow rate through a filter from a pressure difference at boundaries and nominal sizing point.
      The flow regime is steady state. 
    </p>
    
    <p>
      The mathematical model under this component derives from the integrated Darcy law for a compressible fluid.
      In that law, the flow is supposed to linearly vary with the pressure difference. 
      Knowing the pressure drop and the flow (m3/s) at an operating (or nominal) point, all the other working points can be guessed from the product of the ratio of the current pressure drop over the nominal pressure and the nominal volume flow rate.
    </p>    
    			
    <img	
      src=\"modelica://TAeZoSysPro/Information/FluidDynamics/Components/Filters/EQ_Filter.PNG\"
    />
    
    <p>
      The mass flow rate relation derives:
    </p> 
       
    <img	
      src=\"modelica://TAeZoSysPro/Information/FluidDynamics/Components/Filters/EQ_Filter2.PNG\"
    />
 		
    <p>	
      <b>Where</b>:
      <ul>
        <li> <code>dp</code> is the boundary pressure difference between port_a.p and port_b.p </li>
        <li> <code>k</code> is the permeability </li> 
        <li> <code>μ</code> is the dynamic viscosity </li>
        <li> <code>A</code> is inlet cross section </li>
        <li> <code>L</code> is length of the sample units </li>                               
        <li> <code>K</code> is a kind of linear the pressure loss coefficient (or hydraulic conductance) </li>
        <li> <code>d</code> is the upstream density </li>             
        <li> <code>m_flow</code> is the mass flow rate induced by convection </li>
      </ul>				
    </p>
		
  </body>
</html>"),
    Icon(graphics = {Line(origin = {4, 70}, points = {{-78, 0}, {78, 0}}, pattern = LinePattern.Dash, thickness = 0.5), Line(origin = {4.38168, -70.5038}, points = {{-78, 0}, {78, 0}}, pattern = LinePattern.Dash, thickness = 0.5), Rectangle(origin = {7, 0}, fillColor = {170, 255, 127}, fillPattern = FillPattern.Solid, lineThickness = 0.5, extent = {{-37, 70}, {25, -70}}), Line(origin = {1, 0}, points = {{-31, 70}, {31, 54}, {-31, 38}, {31, 24}, {-31, 6}, {31, -8}, {-31, -26}, {31, -38}, {-31, -56}, {31, -70}}, thickness = 0.5), Text(origin = {-35, 91}, lineThickness = 0.5, extent = {{-65, 9}, {135, -9}}, textString = "%name")}, coordinateSystem(initialScale = 0.1)));

end Filter;
