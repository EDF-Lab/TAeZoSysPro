within TAeZoSysPro.FluidDynamics.Components.Orifices;

model HorizontalOpening
  package Medium = Modelica.Media.Air.MoistAir ;
  
  // User defined parameters
  parameter Real Cd = 0.61 "discharge coefficient";
  parameter Modelica.SIunits.CrossSection A = 1 "Opening cross section";
  parameter Modelica.SIunits.Length L_down = 1 "Distance from bottom node";
  parameter Modelica.SIunits.Length L_up = 1 "Distance from top node";

  // Internal variables
  Modelica.SIunits.Pressure p_a "Pressure at port_a";
  Modelica.SIunits.Pressure p_b "Pressure at port_b";
  Modelica.SIunits.PressureDifference dp;
  Modelica.SIunits.PressureDifference dp_buoyancy ;  
  Modelica.SIunits.Pressure p_down;
  Modelica.SIunits.Pressure p_up;
  Modelica.SIunits.Velocity Vel;
  Modelica.SIunits.MassFlowRate m_flow "Mass flow rate throught the opening";
  Modelica.SIunits.MassFlowRate m_flow_buoyancy "Mass flow rate induced by buoyancy";  
  Modelica.SIunits.Density d;
  Modelica.SIunits.HeatFlowRate Q_flow_buoyancy ;
  Modelica.SIunits.IsentropicExponent gamma "Isentropic exponent";
  Modelica.SIunits.MachNumber M "Mach number at the opening";
  Medium.ThermodynamicState state ;  
  
  // Imported modules
  TAeZoSysPro.FluidDynamics.Interfaces.FlowPort_a port_a(replaceable package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {0, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  TAeZoSysPro.FluidDynamics.Interfaces.FlowPort_b port_b(replaceable package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {0, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

protected
  Modelica.SIunits.MassFraction[Medium.nX] X_a "Mass fraction vector at port a";
  Modelica.SIunits.MassFraction[Medium.nX] X_b "Mass fraction vector at port b";
  Modelica.SIunits.SpecificEnthalpy h_a "Specific enthalpy from port_a" ;
  Modelica.SIunits.SpecificEnthalpy h_b "Specific enthalpy from port_b" ; 
  
equation
//
  X_a = 1 / sum(port_a.d) * port_a.d;
  X_b = 1 / sum(port_b.d) * port_b.d;
  h_a = Medium.specificEnthalpy_pTX(p = p_a, T = port_a.T, X = X_a );
  h_b = Medium.specificEnthalpy_pTX(p = p_b, T = port_b.T, X = X_b );
  
// pressure reconstruction
  p_a = sum(port_a.d ./ Medium.MMX) * Modelica.Constants.R * port_a.T;
  p_b = sum(port_b.d ./ Medium.MMX) * Modelica.Constants.R * port_b.T;
  p_up = p_a + sum(port_a.d) * Modelica.Constants.g_n * L_up;
  p_down = p_b - sum(port_b.d) * Modelica.Constants.g_n * L_down;
  dp = p_up - p_down;
  

  d = TAeZoSysPro.FluidDynamics.Utilities.regStep(
    x = dp, 
    x_small = 0.01, 
    y1 = sum(port_a.d), 
    y2 = sum(port_b.d));

  m_flow = Cd * A * TAeZoSysPro.FluidDynamics.Utilities.regRoot2(
    x = dp, 
    x_small = 0.01, 
    k1 = 2.0 * sum(port_a.d), 
    k2 = 2.0 * sum(port_b.d));

// assertion, Mach number has to remain bellow 0.3 to keep the assumption of an uncrompressible flow valid
  state = Medium.setSmoothState(
    x = dp, 
    x_small = 0.01, 
    state_a = Medium.setState_pTX(p = p_a, T = port_a.T, X = X_a), 
    state_b = Medium.setState_pTX(p = p_b, T = port_b.T, X = X_b));
  gamma = Medium.isentropicExponent(state) /* gamma is supposed contant along the flow */;
  // Mach number calculation: The pressure at the orifice is the downstream node pressure
  M = min(1, (2 / (gamma - 1) * ((min(p_up, p_down) / max(p_up, p_down)) ^ ((1 - gamma) / gamma) - 1)) ^ 0.5);
  assert(M<=0.3,"Mach number > 0.3, le flow becomes compressible. The assumption of uncrompressible flow is not valid", AssertionLevel.warning) ;

// Calculation of the mass and heat flow induced by buoyancy difference    
  dp_buoyancy = Modelica.Constants.g_n * L_up * max(sum(port_a.d - port_b.d), 0) ;
  m_flow_buoyancy = TAeZoSysPro.FluidDynamics.Utilities.regStep(
    x = abs(dp) - dp_buoyancy, 
    x_small = 0.1, 
    y1 = 0.0, 
    y2 = Cd * A / 2 * sqrt(2*dp_buoyancy*sum(port_a.d))); 
  Q_flow_buoyancy = m_flow_buoyancy * (h_a-h_b) ;
          
  Vel * d * A * Cd = m_flow ;
  
// Ports handover
  port_a.m_flow = m_flow * TAeZoSysPro.FluidDynamics.Utilities.regStep(x = dp, x_small = 0.01, y1 = X_a, y2 = X_b) + m_flow_buoyancy * (X_a - X_b);
  port_b.m_flow + port_a.m_flow  = fill(0.0, Medium.nX) ;
  port_a.H_flow = m_flow * Medium.specificEnthalpy_pTX(
    p = if noEvent(dp >= 0.0) then p_a else p_b, 
    T = if noEvent(dp >= 0.0) then port_a.T else port_b.T, 
    X = if noEvent(dp >= 0.0) then X_a else X_b) + Q_flow_buoyancy ;
  port_b.H_flow + port_a.H_flow = 0.0 ;
  
  annotation(defaultComponentName="horizontalOpening",
Documentation(info ="
<html>
  <head>
    <title>HorizontalOpening</title>
  </head>
	
  <body lang=\"en-UK\">
    <p>
      This components allows to model the mass flow rate through from either static boundary pressure difference or buoyancy effect through a horizontal orifice in a wall spliting two ambiances.
      The flow regime is steady state. 
    </p>
    
    <p>
      To be considered as an orifice, the depth of the hole in the wall has to remain bellow the hydrodynamic entrance region (Distance between the entrance of the hole and the position where the dynamic boundary layers meet).
      In that case and due to visquous and inertial forces, the current line is not at right angles to the opening but curved. 
      The flow is constricted in the orifice. Consequently, the cross-section of the fluid is not equal to the geometric section of the orifice. 
      the ratio between the fluid passage section and the geometric section is called the discharge coefficient.
      It is assumed to be constant and therefore independent of the flow regime.
    </p>
    
    <p>
      The static pressure of the boundary nodes to which the ports are connected is corrected from pressure induced by the fluid column above the opening for the port_a and bellow for the port_b. The static pressure difference at the boundaries of orifice derives:
    </p> 
       
    <img	
      src=\"modelica://TAeZoSysPro/Information/FluidDynamics/Components/Orifices/EQ_HorizontalOpening1.PNG\"
    />
       
    <p>
      In the flow, all the boundary pressure difference is converted in kinetic energy.
    </p> 
          
    <img	
      src=\"modelica://TAeZoSysPro/Information/FluidDynamics/Components/Orifices/EQ_HorizontalOpening2.PNG\"
    />
    
    <p>
      It is equivalent to have a pressure loss factor equation to one.
      Therefore, the relation to compute mass flow rate through the orifice derives:
    </p>    

    <img	
      src=\"modelica://TAeZoSysPro/Information/FluidDynamics/Components/Orifices/EQ_HorizontalOpening3.PNG\"
    />
    
    <p>
      At this step, nothings prevents to have a configuration where a light fluid (in therm of density) being on the bottom part of the opening and a heavier fluid on the top. 
      In reality in such, a small instalibity at the interface of the fluids would lead to a start of mixing. 
      That mixing would self accelerate to lead to ascending column of light fluid and descending a heavy fluid.  
    </p>
    
    <p>
      To model the mass transport by buoyancy, let's first determine the pressure difference induced a column of heavy and light fluid. 
      It assumed that the height of the fluid columns is the height above the opening <b>L_up</b>.
      In reality, the height is clearlly smaller when mixing starts but in steady state it can be more.
      Anyway, this kind a flow is clearlly three dimensionals thus it requires assumptions to be modelled with a one dimensional approach.
    </p>

    <img	
      src=\"modelica://TAeZoSysPro/Information/FluidDynamics/Components/Orifices/EQ_HorizontalOpening4.PNG\"
    />
    
    <p>
      Then the mass flow rate is computed with the same assumptions thant previously and with the assumption that a half the flow cross section 'sees' the descending flow and the other half the ascending. 
      However, when the static pressure difference <b>dp</b> is heigher then pressure difference induced by buoyancy <b>dp_buoyancy</b>, then the mixing does not occurs since the flow is one dimensional.
      In such case, the mass flow rate induced by buoyancy is set to zero.
    </p>    

    <img	
      src=\"modelica://TAeZoSysPro/Information/FluidDynamics/Components/Orifices/EQ_HorizontalOpening5.PNG\"
    />

    <p>
      It is supposed the mass flow rate induced by buoyancy between the ports is balanced.
      In reality, a flow imbalance would induce a rise in static pressure in one of the nodes which would result in a mass exchange to rebalance the pressures. 
      So the assumption of balanced mass flows is not too false. <\br>   
      Knowing the mass flow rate and the state at both ports, the enthalpy balance derives:  
    </p>

    <img	
      src=\"modelica://TAeZoSysPro/Information/FluidDynamics/Components/Orifices/EQ_HorizontalOpening6.PNG\"
    />
 		
    <p>	
      <b>Where</b>:
      <ul>
        <li> <code>L_up</code> is the vertical distance between the centre of the node above the orifice and the orifice </li>
        <li> <code>L_down</code> is the vertical distance between the centre of the node bellow the orifice and the orifice </li>  
        <li> <code>dp</code> is the static pressure difference between top and bottom part of the orifice </li>
        <li> <code>d</code> is the upstream density </li>
        <li> <code>Vel</code> is fluid velocity </li>              
        <li> <code>m_flow_i[i]</code> is the mass flow rate through the layer index <b>i</b></li>
        <li> <code>A</code> is cross section of the orifice </li>
        <li> <code>Cd</code> is the discharge coefficient </li>
        <li> <code>dp_buoyancy</code> is the pressure difference induced the weight difference between a light and heavy fluid column </li>
        <li> <code>m_flow_buoyancy</code> is mass flow rate induced by the stack effect </li>
        <li> <code>Q_flow_buoyancy</code> is heat flow balance from the ascending and descending flow </li>
      </ul>				
    </p>

    <p>
      To avoid infinite derivative at dp_i=0, The square root (for m_flow calculation only) is replaced by the function <b>regRoot2</b> of the MSL that replace the square root by a polynomial expression to insure a finite derivative. The threshold to switch between the polynom and the square root is <b> abs(dp≤0.01) Pa </b>
    </p>			
  </body>
</html>"),
    Icon(graphics = {Line(origin = {-20, 30}, points = {{-60, -30}, {0, -30}}, thickness = 2), Line(origin = {20, -30}, points = {{0, 30}, {60, 30}}, thickness = 2), Text(origin = {-54, 17}, extent = {{-46, 33}, {94, 13}}, textString = "L_up=%L_up"), Line(origin = {49.9541, 34.6789}, points = {{0, 25}, {0, -31}}, thickness = 0.75, arrow = {Arrow.Filled, Arrow.Filled}), Text(origin = {6, -33}, extent = {{-46, 33}, {34, 13}}, textString = "A=%A"), Text(origin = {6, -63}, extent = {{-46, 33}, {94, 13}}, textString = "L_down=%L_down"), Line(origin = {-49.9541, -27.3945}, points = {{0, 25}, {0, -31}}, thickness = 0.75, arrow = {Arrow.Filled, Arrow.Filled})}, coordinateSystem(initialScale = 0.1)),
    experiment(StartTime = 0, StopTime = 0.01, Tolerance = 1e-06, Interval = 2.00803e-05));

end HorizontalOpening;
