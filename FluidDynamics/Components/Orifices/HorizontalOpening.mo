within TAeZoSysPro.FluidDynamics.Components.Orifices;

model HorizontalOpening
  import TAeZoSysPro.HeatTransfer.Types.Dynamics ;
  replaceable package Medium = TAeZoSysPro.Media.MyMedia ;
  
  // User defined parameters
  parameter Real Cd = 0.61 "discharge coefficient";
  parameter Modelica.SIunits.CrossSection A = 1 "Opening cross section";
  parameter Modelica.SIunits.Diameter Dh = 1 "Hydraulic diameter";
  parameter Integer N = 5 "Number discrete layer along the height of the opening";  
  parameter Modelica.SIunits.Length NotionalLength = 1e-4 "Opening's thickness";
  parameter Dynamics massDynamics = Dynamics.SteadyStateInitial "Formulation of mass balance";
  parameter Modelica.SIunits.Velocity Vel_start = 0.0 "Start value for velocity, if not steady state";
  
  parameter Modelica.SIunits.Length Alt_a = 1.0 "Altitude of port_a";
  parameter Modelica.SIunits.Length Alt_b = 1.0 "Altitude of port_b";
  parameter Modelica.SIunits.Length Alt_opening = 1.0 "Altitude at the opening center";
    
  // Internal variables
  Modelica.SIunits.Pressure p_a "Pressure at port_a";
  Modelica.SIunits.Pressure p_b "Pressure at port_b";
  Modelica.SIunits.PressureDifference dp_i[N];
  Modelica.SIunits.PressureDifference dp;
  Modelica.SIunits.MassFlowRate m_flow_i[N] ; 
  Modelica.SIunits.Velocity Vel[N] ;   
  Modelica.SIunits.MassFlowRate m_flow "Mass flow rate throught the opening";
  Modelica.SIunits.Density d[N];
  Modelica.SIunits.IsentropicExponent gamma "Isentropic exponent";
  Modelica.SIunits.MachNumber M "Mach number at the opening";
  Medium.ThermodynamicState state, state_a, state_b;
  Integer buoyancy "if density port_a < port_b, buoyancy is taken account and equal to 1 and 0 otherwise";
  
  // Imported modules
  TAeZoSysPro.FluidDynamics.Interfaces.FlowPort_a port_a(redeclare package Medium = Medium) annotation (
    Placement(visible = true, transformation(origin = {-58, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  TAeZoSysPro.FluidDynamics.Interfaces.FlowPort_b port_b(redeclare package Medium = Medium) annotation (
    Placement(visible = true, transformation(origin = {38, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

protected
  parameter Modelica.SIunits.Height H_fluidStream = Dh * Cd ^0.5 "Minimal height between top and bottom flow path";
  Modelica.SIunits.MassFlowRate mX_flow_i[N, Medium.nX] ;
  Modelica.SIunits.SpecificEnthalpy h_a "Specific enthalpy from port_a" ;
  Modelica.SIunits.SpecificEnthalpy h_b "Specific enthalpy from port_b" ;
  parameter Modelica.SIunits.Velocity Vel_small = 0.001 ;  

initial equation
  if massDynamics == Dynamics.SteadyStateInitial then
    der(Vel) = fill(0.0, N);
    
  elseif massDynamics == Dynamics.FixedInitial then
    Vel = fill(Vel_start, N) ;

  end if;
  
equation
//
  state_a = Medium.setState_dTX(d = sum(port_a.d), T = port_a.T, X = port_a.d / sum(port_a.d));
  state_b = Medium.setState_dTX(d = sum(port_b.d), T = port_b.T, X = port_b.d / sum(port_b.d));

// pressure reconstruction
  p_a = Medium.pressure(state_a) + sum(port_a.d) * Modelica.Constants.g_n * (Alt_a-Alt_opening);
  p_b = Medium.pressure(state_b) + sum(port_b.d) * Modelica.Constants.g_n * (Alt_b-Alt_opening);
  dp = p_a - p_b;
  
// specific enthalpy reconstruction
  h_a = Medium.specificEnthalpy(state_a);
  h_b = Medium.specificEnthalpy(state_b);
  
/* 
If the density at the lower altitude is below the density at a higher, in case of low static pressure difference, a crossing flow can occur.
In such a case, the HorizontalOpening is assumed behaves like a VerticalOpening where the its heigh is the hydraulic diameter 
*/
  buoyancy = if sum(port_a.d) < sum(port_b.d) then 1 else 0;
//
  for i in 1:N loop
    dp_i[i] = dp + buoyancy * Modelica.Constants.g_n * (H_fluidStream / 2 - H_fluidStream * (i - 1 / 2) / N) * (sum(port_a.d) - sum(port_b.d));
    d[i] = TAeZoSysPro.FluidDynamics.Utilities.regStep(x = Vel[i], x_small = 1e-10, y1 = sum(port_a.d), y2 = sum(port_b.d));
    if massDynamics == Dynamics.SteadyState then
      dp_i[i] - 1 / 2 * Modelica.Fluid.Utilities.regSquare2(x = Vel[i], x_small = Vel_small, k1 = sum(port_a.d), k2 = sum(port_b.d)) = 0.0;
    else
/* inertial opening */
      dp_i[i] - 1 / 2 * Modelica.Fluid.Utilities.regSquare2(x = Vel[i], x_small = Vel_small, k1 = sum(port_a.d), k2 = sum(port_b.d)) = NotionalLength * d[i] * der(Vel[i]);
    end if;
    m_flow_i[i] = Vel[i] * Cd * A / N * d[i];
  end for;
      
  mX_flow_i = {m_flow_i[i] * TAeZoSysPro.FluidDynamics.Utilities.regStep(
    x = Vel[i], 
    x_small = 1e-14, 
    y1 = port_a.d/sum(port_a.d), 
    y2 = port_b.d/sum(port_b.d) ) for i in 1:N} ;

  m_flow = sum(m_flow_i) ;

// assertion, Mach number has to remain bellow 0.3 to keep the assumption of an uncrompressible flow valid
  state = Medium.setSmoothState(
    x = sum(Vel)/N, 
    x_small = Vel_small, 
    state_a = state_a, 
    state_b = state_b);
  gamma = Medium.isentropicExponent(state);
/* gamma is supposed contant along the flow */
// Mach number calculation: The pressure at the orifice is the downstream node pressure
  M = min(1, (2 / (gamma - 1) * ((min(p_a, p_b) / max(p_a, p_b)) ^ ((1 - gamma) / gamma) - 1)) ^ 0.5);
  assert(M<=0.3,"Mach number > 0.3, the flow becomes compressible. The assumption of uncrompressible flow is not valid", AssertionLevel.warning) ;
  
// Port handover
  port_a.m_flow = {sum(mX_flow_i[:, i]) for i in 1:Medium.nX} ;
  port_a.m_flow + port_b.m_flow = fill(0.0, Medium.nX);
  
//  port_a.H_flow = sum( smooth(0, if dp_i[i] >= 0.0 then m_flow_i[i] * h_a else m_flow_i[i] * h_b) for i in 1:N);
  port_a.H_flow = m_flow_i * TAeZoSysPro.FluidDynamics.Utilities.regStep(
    x = Vel, 
    x_small = 1e-3, 
    y1 = h_a, 
    y2 = h_b);
  port_a.H_flow + port_b.H_flow = 0;
  
  annotation(defaultComponentName="opening",
Documentation(info = "<html>
  <head>
    <title>VerticalOpening</title>
  </head>
	
  <body lang=\"en-UK\">
    <p>
      This components allows to model the mass flow rate through from either static boundary pressure difference or buoyancy effect through a vertical orifice in a wall spliting two ambiances.
    </p>
    
    <p>
      To be considered as an orifice, the depth of the hole in the wall has to remain bellow the hydrodynamic entrance region (Distance between the entrance of the hole and the position where the dynamic boundary layers meet).
      In that case and due to visquous and inertial forces, the current line is not at right angles to the opening but curved. 
      The flow is constricted in the orifice. Consequently, the cross-section of the fluid is not equal to the geometric section of the orifice. 
      the ratio between the fluid passage section and the geometric section is called the discharge coefficient.
      It is assumed to be constant and therefore independent of the flow regime.
    </p>
    
    <p>
      The orifice is split in <b>N</b> number of layers along the vertical axis over an height of the fluid stream. Because of the narrowing of the passage section, the height considered for the fluid stream is not the geometric height but the distance between the lowest and highest current line. For a rectangular opening, the relation derives:
    </p> 
       
    <img	
      src=\"modelica://TAeZoSysPro/Information/FluidDynamics/Components/Orifices/EQ_VerticalOpening1.PNG\"
    />
    
    <p>
      The pressure difference for the layer <b>i</b> derives (index 1 refers to the top of the opening):
    </p>     

    <img	
      src=\"modelica://TAeZoSysPro/Information/FluidDynamics/Components/Orifices/EQ_VerticalOpening2.PNG\"
    />
       
    <p>
      In the flow, all the boundary pressure difference (from static pressure or buoyancy) is converted in kinetic energy.
    </p> 
          
    <img	
      src=\"modelica://TAeZoSysPro/Information/FluidDynamics/Components/Orifices/EQ_VerticalOpening3.PNG\"
    />
    
    <p>
      It is equivalent to have a pressure loss factor equation to one.
    </p>    

    <img	
      src=\"modelica://TAeZoSysPro/Information/FluidDynamics/Components/Orifices/EQ_VerticalOpening4.PNG\"
    />

    <p>
      The Fundamental principle of the dynamics derives:
    </p>
    
    <p>
      Therefore, the relation to compute mass flow rate through the orifice derives:
    </p>
    
    <img	
      src=\"modelica://TAeZoSysPro/Information/FluidDynamics/Components/Orifices/EQ_VerticalOpening5.PNG\"
    />
 		
    <p>	
      <b>Where</b>:
      <ul>
        <li> <code>H_fluidStream</code> is height between the bottom and the top current lines </li>
        <li> <code>H</code> is the geometrical height of the orifice </li>   
        <li> <code>dp</code> is the static pressure difference between port_a.p and port_b.p </li>
        <li> <code>d</code> is the upstream density </li>
        <li> <code>Vel</code> is fluid velocity </li>              
        <li> <code>m_flow_i</code> is the mass flow rate through the layer index <b>i</b></li>
        <li> <code>A</code> is cross section of the orifice </li>
        <li> <code>Cd</code> is the discharge coefficient </li>
      </ul>				
    </p>

    <p>
      To avoid infinite derivative at Vel_i=0, The square is replaced by the function <b>regSquare2</b> of the MSL that replace the square by a polynomial expression to insure a finite derivative. The threshold to switch between the polynom and the square is defined by the parameter <b> Vel_small </b>
    </p>			
  </body>
</html>"),
    Icon(coordinateSystem(initialScale = 0.1), graphics = {Line(origin = {-20, 30}, points = {{-60, -30}, {0, -30}}, thickness = 2), Text(origin = {6, -37}, extent = {{-46, 33}, {34, 13}}, textString = "A=%A"), Line(origin = {-49.9541, -27.3945}, points = {{0, 25}, {0, -31}}, thickness = 0.75, arrow = {Arrow.Filled, Arrow.Filled}), Line(origin = {20, -30}, points = {{0, 30}, {60, 30}}, thickness = 2), Line(origin = {49.9541, 34.6789}, points = {{0, 25}, {0, -31}}, thickness = 0.75, arrow = {Arrow.Filled, Arrow.Filled}), Text(origin = {46, -113}, extent = {{-26, 33}, {54, 13}}, textString = "Alt_a=%Alt_a"), Text(origin = {-74, 67}, extent = {{-26, 33}, {54, 13}}, textString = "Alt_b=%Alt_b"), Text(origin = {-54, -113}, lineColor = {242, 21, 21}, extent = {{-46, 33}, {34, 13}}, textString = "Down"), Text(origin = {66, 67}, lineColor = {242, 21, 21}, extent = {{-46, 33}, {34, 13}}, textString = "Up"), Text(origin = {-42, -7}, extent = {{-38, 33}, {82, 13}}, textString = "Alt_opening=%Alt_opening")}));


end HorizontalOpening;