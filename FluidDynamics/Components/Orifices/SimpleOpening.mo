within TAeZoSysPro.FluidDynamics.Components.Orifices;

model SimpleOpening 

  replaceable package Medium = TAeZoSysPro.Media.MyMedia ;
  // User defined parameters
  parameter Real Cd = 0.61 "discharge coefficient";
  parameter Modelica.SIunits.CrossSection A = 1 "Opening cross section";
  parameter Modelica.SIunits.Length NotionalLength = 0.1 "Opening's thickness";
  
  // Internal variables
  Modelica.SIunits.Pressure p_a "Pressure at port_a";
  Modelica.SIunits.Pressure p_b "Pressure at port_b";
  Modelica.SIunits.PressureDifference dp;
  Modelica.SIunits.Velocity Vel;
  Modelica.SIunits.MassFlowRate m_flow "Mass flow rate through the opening";
  Modelica.SIunits.Density d;
  Modelica.SIunits.IsentropicExponent gamma "Isentropic exponent";
  Modelica.SIunits.MachNumber M "Mach number at the opening";
  Medium.ThermodynamicState state, state_a, state_b;  
  
  // Imported modules
  TAeZoSysPro.FluidDynamics.Interfaces.FlowPort_a port_a(replaceable package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-58, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  TAeZoSysPro.FluidDynamics.Interfaces.FlowPort_b port_b(replaceable package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {38, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

protected
  Modelica.SIunits.SpecificEnthalpy h_a "Specific enthalpy from port_a" ;
  Modelica.SIunits.SpecificEnthalpy h_b "Specific enthalpy from port_b" ;
  parameter Modelica.SIunits.Velocity Vel_small = 0.001 ;

equation
//
  state_a = Medium.setState_dTX(d = sum(port_a.d), T = port_a.T, X = port_a.d / sum(port_a.d) );
  state_b = Medium.setState_dTX(d = sum(port_b.d), T = port_b.T, X = port_b.d / sum(port_b.d) );

// pressure reconstruction
  p_a = Medium.pressure(state_a);
  p_b = Medium.pressure(state_b);
  dp = p_a - p_b;
  
// specific enthalpy reconstruction
  h_a = Medium.specificEnthalpy(state_a);
  h_b = Medium.specificEnthalpy(state_b);
  
//
  d = TAeZoSysPro.FluidDynamics.Utilities.regStep(
    x = Vel, 
    x_small = Vel_small, 
    y1 = sum(port_a.d), 
    y2 = sum(port_b.d));
    
  NotionalLength * d * der(Vel) = dp - 1 / 2 * Modelica.Fluid.Utilities.regSquare2(
    x = Vel, 
    x_small = Vel_small, 
    k1 = sum(port_a.d), 
    k2 = sum(port_b.d));
    
  m_flow = Vel * A * Cd * d;
  
// assertion, Mach number has to remain bellow 0.3 to keep the assumption of an uncrompressible flow valid
  state = Medium.setSmoothState(
    x = Vel, 
    x_small = Vel_small, 
    state_a = state_a, 
    state_b = state_b);
  gamma = Medium.isentropicExponent(state) /* gamma is supposed contant along the flow */;
  // Mach number calculation: The pressure at the orifice is the downstream node pressure
  M = min(1, (2 / (gamma - 1) * ((min(p_a, p_b) / max(p_a, p_b)) ^ ((1 - gamma) / gamma) - 1)) ^ 0.5);
  assert(M<=0.3,"Mach number > 0.3, le flow becomes compressible. The assumption of uncrompressible flow is not valid", AssertionLevel.warning) ;
  
// Port handover
  port_a.m_flow = m_flow * TAeZoSysPro.FluidDynamics.Utilities.regStep(
    x = Vel, 
    x_small = Vel_small, 
    y1 = state_a.X, 
    y2 = state_b.X);
  port_a.m_flow + port_b.m_flow = fill(0.0, Medium.nX);
  
//  port_a.H_flow = smooth(0, if dp >= 0.0 then m_flow * Medium.specificEnthalpy(state_a) else m_flow * Medium.specificEnthalpy(state_b));
  port_a.H_flow = m_flow * TAeZoSysPro.FluidDynamics.Utilities.regStep(
    x = Vel, 
    x_small = 1e-4, 
    y1 = h_a, 
    y2 = h_b);
  port_a.H_flow + port_b.H_flow = 0;
  
  annotation(defaultComponentName="simpleOpening",
Documentation(info ="
<html>
  <head>
    <title>SimpleOpening</title>
  </head>
	
  <body lang=\"en-UK\">
    <p>
      This components allows to model the mass flow rate through an orifice in a wall spliting two ambiances at different pressure. 
    </p>
    
    <p>
      To be considered as an orifice, the depth of the hole in the wall has to remain bellow the hydrodynamic entrance region (Distance between the entrance of the hole and the position where the dynamic boundary layers meet).
      In that case and due to visquous and inertial forces, the current line is not at right angles to the opening but curved. 
      The flow is constricted in the orifice. Consequently, the cross-section of the fluid is not equal to the geometric section of the orifice. 
      the ratio between the fluid passage section and the geometric section is called the discharge coefficient.
      It is assumed to be constant and therefore independent of the flow regime.
    </p>
    
    <p>
      In the flow, all the boundary pressure difference is converted in kinetic energy at steady state. 
      It is equivalent to have a pressure loss factor equation to one.
    </p>    
    			
    <img	
      src=\"modelica://TAeZoSysPro/Information/FluidDynamics/Components/Orifices/EQ_SimpleOpening1.PNG\"
    />

    <p>
      The Fundamental principle of the dynamics derives:
    </p>

    <img	
      src=\"modelica://TAeZoSysPro/Information/FluidDynamics/Components/Orifices/EQ_SimpleOpening2.PNG\"
    />

    <p>
      The mass flow rate relation derives:
    </p>

    <img	
      src=\"modelica://TAeZoSysPro/Information/FluidDynamics/Components/Orifices/EQ_SimpleOpening3.PNG\"
    />
 		
    <p>	
      <b>Where</b>:
      <ul>
        <li> <code>dp</code> is the pressure difference between port_a.p and port_b.p </li>
        <li> <code>d</code> is the upstream density </li>
        <li> <code>Vel</code> is fluid velocity </li>              
        <li> <code>m_flow</code> is the mass flow rate through the orifice </li>
        <li> <code>A</code> is cross section of the orifice </li>
        <li> <code>Cd</code> is the discharge coefficient </li>
      </ul>				
    </p>

    <p>
      To avoid infinite derivative at Vel=0, The square is replaced by the function <b>regSquare2</b> of the MSL that replace the square by a polynomial expression to insure a finite derivative. The threshold to switch between the polynom and the square is defined by the parameter <b> Vel_small </b>
    </p>			
  </body>
</html>"),
    Icon(graphics = {Line(origin = {0, 50}, points = {{0, 30}, {0, -30}}, thickness = 2), Line(origin = {0, -50}, points = {{0, 30}, {0, -30}}, thickness = 2), Text(origin = {16, -113}, extent = {{-116, 33}, {84, 13}}, textString = "A=%A"), Text(origin = {-43, 88}, extent = {{-57, 12}, {143, -8}}, textString = "%name"), Line(origin = {-1, 27.24}, points = {{-39, 12.7571}, {-19, -7.24287}, {1, -15.2429}, {21, -7.24287}, {41, 12.7571}}, pattern = LinePattern.Dash, arrow = {Arrow.Filled, Arrow.Filled}, smooth = Smooth.Bezier), Line(origin = {1.02, -27.23}, rotation = 180, points = {{-39, 12.7571}, {-19, -7.24287}, {1, -15.2429}, {21, -7.24287}, {41, 12.7571}}, pattern = LinePattern.Dash, arrow = {Arrow.Filled, Arrow.Filled}, smooth = Smooth.Bezier), Line(points = {{-40, 0}, {40, 0}}, pattern = LinePattern.Dash, arrow = {Arrow.Filled, Arrow.Filled})}),
    Diagram);

end SimpleOpening;
