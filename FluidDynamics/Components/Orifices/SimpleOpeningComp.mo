within TAeZoSysPro.FluidDynamics.Components.Orifices;

model SimpleOpeningComp
  replaceable package Medium = TAeZoSysPro.Media.MyMedia;
  
  // User defined parameters
  parameter Real Cd = 0.61 "discharge coefficient";
  parameter Modelica.SIunits.CrossSection A = 1 "Opening cross section";
  
  // Internal variables
  Modelica.SIunits.PressureDifference dp;
  Modelica.SIunits.Velocity Vel "Velocity at the orifice";
  Modelica.SIunits.Velocity c "Sound velocity";
  Modelica.SIunits.MassFlowRate m_flow "Mass flow rate throught the opening";
  Modelica.SIunits.Density d "density at the orifice";
  
  //  Modelica.SIunits.Density d_comp "Densite au col";
  Modelica.SIunits.AbsolutePressure p_a;
  Modelica.SIunits.AbsolutePressure p_b;
  Modelica.SIunits.IsentropicExponent gamma "isentropic exponent";
  Modelica.SIunits.MachNumber M "Mach number at the orifice";
  Modelica.SIunits.Temperature T "Temperature at the orifice";
  Medium.ThermodynamicState state "State of upstream flow";
  Medium.ThermodynamicState state_a, state_b "States at ports";
  
  // Imported modules
  TAeZoSysPro.FluidDynamics.Interfaces.FlowPort_a port_a(replaceable package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  TAeZoSysPro.FluidDynamics.Interfaces.FlowPort_b port_b(replaceable package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

protected
  Modelica.SIunits.SpecificEnthalpy h_a "Specific enthalpy from port_a" ;
  Modelica.SIunits.SpecificEnthalpy h_b "Specific enthalpy from port_b" ;
  parameter Modelica.SIunits.PressureDifference dp_small = 0.001 ;
  
equation
//
  state_a = Medium.setState_dTX(d = sum(port_a.d), T = port_a.T, X = port_a.d / sum(port_a.d) );
  state_b = Medium.setState_dTX(d = sum(port_b.d), T = port_b.T, X = port_b.d / sum(port_b.d) );  
  state = Medium.setSmoothState(
    x = dp, 
    x_small = dp_small, 
    state_a = state_a, 
    state_b = state_b);

// pressure reconstruction
  p_a = Medium.pressure(state_a);
  p_b = Medium.pressure(state_b);
  dp = p_a - p_b;

// specific enthalpy reconstruction
  h_a = Medium.specificEnthalpy(state_a);
  h_b = Medium.specificEnthalpy(state_b);
  
// gamma is supposed contant along the flow
  gamma = Medium.isentropicExponent(state);
  
// Mach number calculation: The pressure at the orifice is the downstream node pressure
  M = min(1, (2 / (gamma - 1) * ((min(p_a, p_b) / max(p_a, p_b)) ^ ((1 - gamma) / gamma) - 1)) ^ 0.5);
  
// Calculation temperature at the orifice
  T = Medium.temperature(state) / (1 + (gamma - 1) / 2 * M ^ 2);
  
// solution 1: The velocity is computed from the Mach number and the velocity of sound
  c = Medium.velocityOfSound(Medium.setState_pTX(p = min(p_a, p_b), T = T, X = state.X));
  Vel = M * c * sign(dp);
  
// Calculation density at the orifice
  d = Medium.density(state) / (1 + (gamma - 1) / 2 * M ^ 2) ^ (1 / (1 - gamma));
  m_flow = Vel * A * Cd * d;
  
// solution 2: The velocity is computed from the compressible Bernoulli relation
//solution 2.1: more stable around dp = 0 but induces an interation variable
//  2 * gamma / (gamma - 1) * max(p_a, p_b) / Medium.density(state) * (1- (1 + (gamma - 1) / 2 * M ^ 2) ^ (-1)) - Modelica.Fluid.Utilities.regSquare2(
//    x = Vel, 
//    x_small = 0.01, 
//    k1 = 1, 
//    k2 = 1) = 0.0 ;
//solution 2.0: infinite derivative at dp = 0    
//  Vel = sign(dp) * sqrt(2 * gamma / (gamma - 1) * max(p_a, p_b) / Medium.density(state) * (1- (1 + (gamma - 1) / 2 * M ^ 2) ^ (-1)) )  ;    

//Blocking mass flow calculation
//  m_flow_blocked = sign(dp) * max(pa, pb) * (gamma / r / T0) ^ 0.5 * Ar * Cd * ((gamma + 1) / 2) ^ ((1 + gamma) / 2 / (1 - gamma)) "From Barre Saint Venant and Hugoniot";


// Port handover
  port_a.m_flow = m_flow * TAeZoSysPro.FluidDynamics.Utilities.regStep(
    x = dp, 
    x_small = dp_small, 
    y1 = state_a.X, 
    y2 = state_b.X);
  port_a.m_flow + port_b.m_flow = fill(0.0, Medium.nX);
  port_a.H_flow = smooth(0, if dp >= 0.0 then m_flow * Medium.specificEnthalpy(state_a) else m_flow * Medium.specificEnthalpy(state_b));
  port_a.H_flow + port_b.H_flow = 0;
  
  annotation(defaultComponentName="SimpleOpeningComp",
Documentation(info ="
<html>
  <head>
    <title>SimpleOpeningComp</title>
  </head>
	
  <body lang=\"en-UK\">
    
    <p>
      This components allows to model the mass flow rate of a compressible flow (Mach >0.3) through an orifice in a wall spliting two ambiances at different pressure.
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
      The flow upstream the orifice is assumed to behave like a Laval nozzle (Adiabatic and isentropic tranformation of a perfect gas).
    </p>

    <img	
      src=\"modelica://TAeZoSysPro/Information/FluidDynamics/Components/Orifices/EQ_SimpleOpeningComp1.PNG\"
    />
    
    <p>
      From the perfect gas law and the isentropic transformation of a perfect gas.
    </p>    

    <img	
      src=\"modelica://TAeZoSysPro/Information/FluidDynamics/Components/Orifices/EQ_SimpleOpeningComp2.PNG\"
    />
    
    <p>
      The relations for the pression and density along a current line derive:
    </p>
    
    <img	
      src=\"modelica://TAeZoSysPro/Information/FluidDynamics/Components/Orifices/EQ_SimpleOpeningComp3.PNG\"
    />

    <img	
      src=\"modelica://TAeZoSysPro/Information/FluidDynamics/Components/Orifices/EQ_SimpleOpeningComp4.PNG\"
    />

    <p>
      It is assumed that the pressure in the opening is the downstream node pressure. Knowing pressure ratio, the Mach number <b>M</b> is deduced. Therefore, le velocity is computed from the Mach number and the velocity of sound at the opening.
    </p>
    
    <img	
      src=\"modelica://TAeZoSysPro/Information/FluidDynamics/Components/Orifices/EQ_SimpleOpeningComp5.PNG\"
    />
 
    <p>
      If the function to compute the velocity of sound gives weirds results (Because of a presence of condensing phase ...), the velocity can be determined from the relation bellow. <br>
      The conservation of the energy between the energy resulting from the work of the forces of pressure, internal energy and kinetic energy results in the relation of bernoulli:
    </p> 
          
    <img	
      src=\"modelica://TAeZoSysPro/Information/FluidDynamics/Components/Orifices/EQ_SimpleOpeningComp6.PNG\"
    />
    
    <p>
      It is equivalent to have a pressure loss factor equation to one.
      Therefore, the relation to compute mass flow rate through the orifice derives:
    </p>    

    <img	
      src=\"modelica://TAeZoSysPro/Information/FluidDynamics/Components/Orifices/EQ_SimpleOpeningComp7.PNG\"
    />
 		
    <p>	
      <b>Where</b>:
      <ul>
        <li> the index <sub>0</sub> reference to the generation conditions (side port_a if p_a > p_b and the reverse otherwise) </li>
        <li> <code>cp</code> is the specific heat capacity at constant pressure </li> 
        <li> <code>T</code> is the temperature </li> 
        <li> <code>M</code> is the Mach number </li>        
        <li> <code>c</code> is the velocity of sound </li>
        <li> <code>γ</code> is the isentropic exponent (cp/cv) </li>
        <li> <code>p</code> is the pressure </li>
        <li> <code>d</code> is the upstream density </li>
        <li> <code>Vel</code> is fluid velocity </li>              
        <li> <code>m_flow</code> is the mass flow rate through opening</li>
        <li> <code>A</code> is cross section of the orifice </li>
        <li> <code>Cd</code> is the discharge coefficient </li>
      </ul>				
    </p>
			
  </body>
</html>"),
    Icon(graphics = {Line(origin = {0, 50}, points = {{0, 30}, {0, -30}}, thickness = 2), Line(origin = {0, -50}, points = {{0, 30}, {0, -30}}, thickness = 2), Text(origin = {-43, 88}, extent = {{-57, 12}, {143, -8}}, textString = "%name"), Text(origin = {16, -113}, extent = {{-116, 33}, {84, 13}}, textString = "A=%A"), Polygon(lineColor = {255, 255, 255}, fillColor = {150, 150, 150}, fillPattern = FillPattern.VerticalCylinder, points = {{-60, -60}, {-60, -50}, {-60, 50}, {-60, 60}, {0, 4}, {60, 60}, {60, 50}, {60, -50}, {60, -60}, {0, -4}, {-60, -60}}, smooth = Smooth.Bezier), Text(origin = {2, 1}, extent = {{-40, 11}, {40, -9}}, textString = "Laval nozzle")}, coordinateSystem(initialScale = 0.1)),
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-06, Interval = 0.002));

end SimpleOpeningComp;
