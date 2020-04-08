within TAeZoSysPro.HeatTransfer.Components;

model FanVentilation
  replaceable package Medium = Modelica.Media.Air.ReferenceAir.Air_pT "Medium in the component";
  
  // User defined parameters
  parameter Boolean Use_External_MassFlow = false;
  parameter Modelica.SIunits.Power Q_flow_aero_nominal = 0 "Fan power given to fluid at nominal conditions";
  parameter Modelica.SIunits.VolumeFlowRate V_flow_nominal = 0 "Volume flow rate at nominal conditions";
  
  // Internal variables
  Modelica.SIunits.Power Q_flow_aero "Fan power given to fluid";
  Modelica.SIunits.SpecificHeatCapacity cp "Mean specific heat capacity" ;
  Modelica.SIunits.Density d ;
  Modelica.SIunits.MassFlowRate m_flow ;
  Modelica.SIunits.Energy E "Energy passed throught the component" ;
  //
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port_b annotation(
    Placement(visible = true, transformation(origin = {0, 98}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a annotation(
    Placement(visible = true, transformation(origin = {-1, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-101, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput m_flow_input if Use_External_MassFlow annotation(
    Placement(visible = true, transformation(origin = {-106, 78}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-100, 84}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput V_flow_input if not Use_External_MassFlow  annotation(
    Placement(visible = true, transformation(origin = {-106, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-100, -86}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

initial equation
  E = 0.0 ;

equation

  cp = Medium.specificHeatCapacityCp(Medium.setState_pTX(p = Medium.reference_p, T = (port_a.T + port_b.T)/2));
  
  d = Medium.density_pT(p = Medium.reference_p, T = port_a.T);
  
  if  Use_External_MassFlow then
    m_flow = m_flow_input ;
  else
    m_flow = V_flow_input * d ;
  end if;

// Fan power
  Q_flow_aero = Q_flow_aero_nominal * ((m_flow / d) / V_flow_nominal)^2 ;

// Energy balance
  port_b.Q_flow = m_flow * cp * (port_b.T - port_a.T) - Q_flow_aero ;
  der(E) = port_b.Q_flow ; 
   
// ports handover
  port_a.Q_flow = 0;
  
  annotation(
    Diagram(coordinateSystem(grid = {2, 2}, initialScale = 0.1)),
    Icon(graphics = {Ellipse(lineThickness = 1, extent = {{-100, -100}, {100, 100}}, endAngle = 360), Ellipse(lineColor = {182, 182, 182}, lineThickness = 2, extent = {{-98, -98}, {98, 98}}, endAngle = 360), Polygon(origin = {44.28, 19.95}, fillColor = {182, 182, 182}, fillPattern = FillPattern.Solid, points = {{-44.2764, -19.9472}, {43.7236, -19.9472}, {43.7236, -19.9472}, {45.7236, -7.9472}, {45.7236, -7.94721}, {45.7236, 0.0527902}, {43.7236, 8.05279}, {39.7236, 14.0528}, {35.7236, 20.0528}, {35.7236, 20.0528}, {35.7236, 20.0528}, {-44.2764, -19.9472}}), Polygon(origin = {-43.72, -20.05}, rotation = 180, fillColor = {182, 182, 182}, fillPattern = FillPattern.Solid, points = {{-44.2764, -19.9472}, {43.7236, -19.9472}, {43.7236, -19.9472}, {45.7236, -7.9472}, {45.7236, -7.94721}, {45.7236, 0.0527902}, {43.7236, 8.05279}, {39.7236, 14.0528}, {35.7236, 20.0528}, {35.7236, 20.0528}, {35.7236, 20.0528}, {-44.2764, -19.9472}}), Polygon(origin = {-19.72, 43.95}, rotation = 90, fillColor = {182, 182, 182}, fillPattern = FillPattern.Solid, points = {{-44.2764, -19.9472}, {43.7236, -19.9472}, {43.7236, -19.9472}, {45.7236, -7.9472}, {45.7236, -7.94721}, {45.7236, 0.0527902}, {43.7236, 8.05279}, {39.7236, 14.0528}, {35.7236, 20.0528}, {35.7236, 20.0528}, {35.7236, 20.0528}, {-44.2764, -19.9472}}), Polygon(origin = {20.28, -44.05}, rotation = -90, fillColor = {182, 182, 182}, fillPattern = FillPattern.Solid, points = {{-44.2764, -19.9472}, {43.7236, -19.9472}, {43.7236, -19.9472}, {45.7236, -7.9472}, {45.7236, -7.94721}, {45.7236, 0.0527902}, {43.7236, 8.05279}, {39.7236, 14.0528}, {35.7236, 20.0528}, {35.7236, 20.0528}, {35.7236, 20.0528}, {-44.2764, -19.9472}}), Ellipse(fillColor = {182, 182, 182}, fillPattern = FillPattern.Sphere, lineThickness = 1, extent = {{-10, -10}, {10, 10}}, endAngle = 360), Text(origin = {-82, 85}, extent = {{-10, 7}, {24, -7}}, textString = "[kg / s]", fontSize = 6), Text(origin = {-82, -81}, extent = {{-10, 5}, {26, -13}}, textString = "[m3 / s]", fontSize = 6)}, coordinateSystem(initialScale = 0.1)),
    Documentation(info = "
<html>
  <head>
    <title>Ventilation</title>	
  </head>
  
  <body lang=\"en-UK\">
	
    <p>
      This components computes the heat flow balance between the heat flow from the supply ventilation where fan in present between inlet conditions and the blowing in the control volume and the exhaust assuming steady pressure balance thus steady mass flow balance.
    </p>
        
    <p> 
      Beacause of the thermal mode only, it assumes that the inlet mass flow rate is always equal to the outlet (the dynamic mass balance is reached generally much faster that the thermal balance). 
      The exhaust temperature is the temperature at port_b and the supply at port_a. 
    </p>
    
    <p> 
      It is assumed that the fan curve pressure vs volume flow rate is linear to the volume flow rate.
      The aeraulic power is the product of the pressure difference at the boundary of the fan and the volume flow rate a suction. 
    </p>

	<img	
      src=\"modelica://TAeZoSysPro/Information/HeatTransfer/Components/EQ_FanVentilation_aero.png\" 
	/>
    
    <p>
      The enthalpy flow balance to the volume that receive mass derives:
    </p>	
    		
	<img	
      src=\"modelica://TAeZoSysPro/Information/HeatTransfer/Components/EQ_FanVentilation.PNG\" 
      width=\"500\"
	/>
	
	<p>
      <b>Where :</b>
      <ul>
        <li> <b>∆p_fan</b> is pressure difference at fan boundaries </li>
        <li> <b>a</b> a is the proportionality coefficient between the pressure difference and the flow </li>
        <li> <b>V_flow</b> is the volume flow rate at fan suction </li>
        <li> <b>H_flow</b> is the enthalpy flow rate </li>      
        <li> <b>m_flow</b> is the mass flow rate </li>
        <li> <b>h</b> is the specific enthalpy </li>
        <li> <b>cp</b> is the specific heat capacity </li>
        <li> <b>T</b> is the temperature </li>
      </ul>
    </p>
          
    <p>
      It is supposed that the specific heat capacity varies linearly with the temperature therefore the mean specific capacity is the specific capacity at the mean temperature.
    </p>			
			
  </body>
</html> 
    "));

end FanVentilation;
