within TAeZoSysPro.FluidDynamics.Components.Orifices;

model HorizontalOpening
  package Medium = TAeZoSysPro.Media.MyMedia ;
  
  // User defined parameters
  parameter Real Cd = 0.61 "discharge coefficient";
  parameter Modelica.SIunits.CrossSection A = 1 "Opening cross section";
  parameter Modelica.SIunits.Length L_down = 1 "Distance from bottom node";
  parameter Modelica.SIunits.Length L_up = 1 "Distance from top node";
  parameter Modelica.SIunits.Length NotionalLength = 1e-4 "Opening's thickness";
  
  // Internal variables
  Modelica.SIunits.Pressure p_a "Pressure at port_a";
  Modelica.SIunits.Pressure p_b "Pressure at port_b";
  Modelica.SIunits.PressureDifference dp; 
  Modelica.SIunits.Pressure p_down;
  Modelica.SIunits.Pressure p_up;
  Modelica.SIunits.Velocity Vel;
  Modelica.SIunits.MassFlowRate m_flow "Mass flow rate throught the opening"; 
  Modelica.SIunits.Density d;
  Modelica.SIunits.IsentropicExponent gamma "Isentropic exponent";
  Modelica.SIunits.MachNumber M "Mach number at the opening";
  Medium.ThermodynamicState state, state_a, state_b;  
  
  // Imported modules
  TAeZoSysPro.FluidDynamics.Interfaces.FlowPort_a port_a(replaceable package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {0, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  TAeZoSysPro.FluidDynamics.Interfaces.FlowPort_b port_b(replaceable package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {0, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

protected
  Modelica.SIunits.SpecificEnthalpy h_a "Specific enthalpy from port_a" ;
  Modelica.SIunits.SpecificEnthalpy h_b "Specific enthalpy from port_b" ;
  parameter Modelica.SIunits.Velocity Vel_small = 0.001 ; 

initial equation
//  Vel = 0.0;
  
equation
//
  state_a = Medium.setState_dTX(d = sum(port_a.d), T = port_a.T, X = port_a.d / sum(port_a.d) );
  state_b = Medium.setState_dTX(d = sum(port_b.d), T = port_b.T, X = port_b.d / sum(port_b.d) );

// pressure reconstruction
  p_a = Medium.pressure(state_a);
  p_b = Medium.pressure(state_b);
  p_up = p_a + sum(port_a.d) * Modelica.Constants.g_n * L_up;
  p_down = p_b - sum(port_b.d) * Modelica.Constants.g_n * L_down;
  dp = p_up - p_down; 
  
// specific enthalpy reconstruction
  h_a = Medium.specificEnthalpy(state_a);
  h_b = Medium.specificEnthalpy(state_b);  
    
  d = TAeZoSysPro.FluidDynamics.Utilities.regStep(x = Vel, x_small = 1e-14, y1 = sum(port_a.d), y2 = sum(port_b.d));
  dp - 1 / 2 * Modelica.Fluid.Utilities.regSquare2(x = Vel, x_small = Vel_small, k1 = sum(port_a.d), k2 = sum(port_b.d)) = NotionalLength * d * der(Vel);
  m_flow = Vel * A * Cd * d;

// assertion, Mach number has to remain bellow 0.3 to keep the assumption of an uncrompressible flow valid
  state = Medium.setSmoothState(
    x = Vel, 
    x_small = Vel_small, 
    state_a = state_a, 
    state_b = state_b);
  gamma = Medium.isentropicExponent(state) /* gamma is supposed contant along the flow */;
  // Mach number calculation: The pressure at the orifice is the downstream node pressure
  M = min(1, (2 / (gamma - 1) * ((min(p_up, p_down) / max(p_up, p_down)) ^ ((1 - gamma) / gamma) - 1)) ^ 0.5);
  assert(M<=0.3,"Mach number > 0.3, le flow becomes compressible. The assumption of uncrompressible flow is not valid", AssertionLevel.warning) ;
  
// Ports handover
  port_a.m_flow = m_flow * TAeZoSysPro.FluidDynamics.Utilities.regStep(
    x = Vel, 
    x_small = 1e-10, 
    y1 = state_a.X, 
    y2 = state_b.X);
  port_b.m_flow + port_a.m_flow  = fill(0.0, Medium.nX) ;
  port_a.H_flow = smooth(0, if dp >= 0.0 then m_flow * Medium.specificEnthalpy(state_a) else m_flow * Medium.specificEnthalpy(state_b));
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
    			
  </body>
</html>"),
    Icon(graphics = {Line(origin = {-20, 30}, points = {{-60, -30}, {0, -30}}, thickness = 2), Line(origin = {20, -30}, points = {{0, 30}, {60, 30}}, thickness = 2), Text(origin = {-54, 17}, extent = {{-46, 33}, {94, 13}}, textString = "L_up=%L_up"), Line(origin = {49.9541, 34.6789}, points = {{0, 25}, {0, -31}}, thickness = 0.75, arrow = {Arrow.Filled, Arrow.Filled}), Text(origin = {6, -33}, extent = {{-46, 33}, {34, 13}}, textString = "A=%A"), Text(origin = {6, -63}, extent = {{-46, 33}, {94, 13}}, textString = "L_down=%L_down"), Line(origin = {-49.9541, -27.3945}, points = {{0, 25}, {0, -31}}, thickness = 0.75, arrow = {Arrow.Filled, Arrow.Filled})}, coordinateSystem(initialScale = 0.1)),
    experiment(StartTime = 0, StopTime = 0.01, Tolerance = 1e-06, Interval = 2.00803e-05));

end HorizontalOpening;
