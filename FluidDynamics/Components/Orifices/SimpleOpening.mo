within TAeZoSysPro.FluidDynamics.Components.Orifices;

model SimpleOpening 

  replaceable package Medium = Modelica.Media.Air.MoistAir ;
  // User defined parameters
  parameter Real Cd = 0.61 "discharge coefficient";
  parameter Modelica.SIunits.CrossSection A = 1 "Opening cross section";
  
  // Internal variables
  Modelica.SIunits.Pressure p_a "Pressure at port_a";
  Modelica.SIunits.Pressure p_b "Pressure at port_b";
  Modelica.SIunits.PressureDifference dp;
  Modelica.SIunits.Velocity Vel;
  Modelica.SIunits.MassFlowRate m_flow "Mass flow rate through the opening";
  Modelica.SIunits.Density d;
  Modelica.SIunits.IsentropicExponent gamma "Isentropic exponent";
  Modelica.SIunits.MachNumber M "Mach number at the opening";
  Medium.ThermodynamicState state ;  
  
  // Imported modules
  TAeZoSysPro.FluidDynamics.Interfaces.FlowPort_a port_a(replaceable package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-58, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  TAeZoSysPro.FluidDynamics.Interfaces.FlowPort_b port_b(replaceable package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {38, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

protected
  Modelica.SIunits.MassFraction[Medium.nX] X_a "Mass fraction vector at port a";
  Modelica.SIunits.MassFraction[Medium.nX] X_b "Mass fraction vector at port b";

equation
//
  X_a = 1 / sum(port_a.d) * port_a.d;
  X_b = 1 / sum(port_b.d) * port_b.d;
// pressure reconstruction
  p_a = sum(port_a.d ./ Medium.MMX) * Modelica.Constants.R * port_a.T;
  p_b = sum(port_b.d ./ Medium.MMX) * Modelica.Constants.R * port_b.T;
  dp = p_a - p_b;
//
  d = Modelica.Fluid.Utilities.regStep(
    x = dp, 
    x_small = 0.01, 
    y1 = sum(port_a.d), 
    y2 = sum(port_b.d));
    
  m_flow = Cd * A * Modelica.Fluid.Utilities.regRoot2(
    x = dp, x_small = 0.01, 
    k1 = 2.0 * sum(port_a.d), 
    k2 = 2.0 * sum(port_b.d));
  
  Vel * d * A * Cd = m_flow ;

// assertion, Mach number has to remain bellow 0.3 to keep the assumption of an uncrompressible flow valid
  state = Medium.setSmoothState(
    x = dp, 
    x_small = 0.01, 
    state_a = Medium.setState_pTX(p = p_a, T = port_a.T, X = X_a), 
    state_b = Medium.setState_pTX(p = p_b, T = port_b.T, X = X_b));
  gamma = Medium.isentropicExponent(state) /* gamma is supposed contant along the flow */;
  // Mach number calculation: The pressure at the orifice is the downstream node pressure
  M = min(1, (2 / (gamma - 1) * ((min(p_a, p_b) / max(p_a, p_b)) ^ ((1 - gamma) / gamma) - 1)) ^ 0.5);

assert(M<=0.3,"Mach number > 0.3, le flow becomes compressible. The assumption of uncrompressible flow is not valid", AssertionLevel.warning) ;
  
// Port handover
  port_a.m_flow = m_flow * Modelica.Fluid.Utilities.regStep(x = dp, x_small = 0.01, y1 = X_a, y2 = X_b);
  port_a.m_flow + port_b.m_flow = fill(0.0, Medium.nX);
  
  port_a.H_flow = m_flow * Medium.specificEnthalpy_pTX(
    p = if noEvent(dp >= 0.0) then p_a else p_b, 
    T = if noEvent(dp >= 0.0) then port_a.T else port_b.T, 
    X = if noEvent(dp >= 0.0) then X_a else X_b);
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
      In the flow, all the boundary pressure difference is converted in kinetic energy. 
      It is equivalent to have a pressure loss factor equation to one.
      Therefore, the relation to compute mass flow rate through the orifice derives:
    </p>    
    			
    <img	
      src=\"modelica://TAeZoSysPro/Information/FluidDynamics/Components/Orifices/EQ_SimpleOpening1.PNG\"
    />

    <p>
      The mass flow rate relation derives:
    </p>

    <img	
      src=\"modelica://TAeZoSysPro/Information/FluidDynamics/Components/Orifices/EQ_SimpleOpening2.PNG\"
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
      To avoid infinite derivative at dp=0, The square root is replaced by the function <b>regRoot2</b> of the MSL that replace the square root by a polynomial expression to insure a finite derivative. The threshold to switch between the polynom and the square root is <b> abs(dp≤0.01) Pa </b>
    </p>			
  </body>
</html>"),
    Icon(graphics = {Line(origin = {0, 50}, points = {{0, 30}, {0, -30}}, thickness = 2), Line(origin = {0, -50}, points = {{0, 30}, {0, -30}}, thickness = 2), Text(origin = {16, -113}, extent = {{-116, 33}, {84, 13}}, textString = "A=%A"), Text(origin = {-43, 88}, extent = {{-57, 12}, {143, -8}}, textString = "%name"), Line(origin = {-1, 27.24}, points = {{-39, 12.7571}, {-19, -7.24287}, {1, -15.2429}, {21, -7.24287}, {41, 12.7571}}, pattern = LinePattern.Dash, arrow = {Arrow.Filled, Arrow.Filled}, smooth = Smooth.Bezier), Line(origin = {1.02, -27.23}, rotation = 180, points = {{-39, 12.7571}, {-19, -7.24287}, {1, -15.2429}, {21, -7.24287}, {41, 12.7571}}, pattern = LinePattern.Dash, arrow = {Arrow.Filled, Arrow.Filled}, smooth = Smooth.Bezier), Line(points = {{-40, 0}, {40, 0}}, pattern = LinePattern.Dash, arrow = {Arrow.Filled, Arrow.Filled})}),
    Diagram);

end SimpleOpening;
