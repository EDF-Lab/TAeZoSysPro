within TAeZoSysPro.FluidDynamics.Components.Orifices;

model OpeningAnalytic
  replaceable package Medium = TAeZoSysPro.Media.MyMedia ;
  
  // User defined parameters
  parameter Real Cd = 0.61 "discharge coefficient";
  parameter Modelica.SIunits.CrossSection A = 1 "Opening cross section";
  parameter Modelica.SIunits.Height H = 1 "Opening's Height";   
  parameter Modelica.SIunits.Length Alt_a = 1.0 "Altitude of port_a";
  parameter Modelica.SIunits.Length Alt_b = 1.0 "Altitude of port_b";
  parameter Modelica.SIunits.Length Alt_opening = 1.0 "Altitude at the opening center";
    
  // Internal variables
  Modelica.SIunits.Pressure p_a "Pressure of node connected to port_a";
  Modelica.SIunits.Pressure p_b "Pressure of node connected to port_b";
  Modelica.SIunits.PressureDifference dp;   
  Modelica.SIunits.Density rho_A,rho_B;
  Medium.Density[Medium.nX] rho_up, rho_down "Upstream density in upper and lower part of the opening";
  Medium.MassFraction[Medium.nX] X_up, X_down;
  Modelica.SIunits.Height HN "Heigh of the point where flow switches in direction (zero flow)";
  Medium.ThermodynamicState state_a, state_b;
  Modelica.SIunits.MassFlowRate m_flow_up, m_flow_down "mass flow rate in upper and lower part of the opening";
  
  // Imported modules
  TAeZoSysPro.FluidDynamics.Interfaces.FlowPort_a port_a(redeclare package Medium = Medium) annotation (
    Placement(visible = true, transformation(origin = {-58, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  TAeZoSysPro.FluidDynamics.Interfaces.FlowPort_b port_b(redeclare package Medium = Medium) annotation (
    Placement(visible = true, transformation(origin = {38, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

protected
  Modelica.SIunits.SpecificEnthalpy h_a "Specific enthalpy from port_a" ;
  Modelica.SIunits.SpecificEnthalpy h_b "Specific enthalpy from port_b" ;
  parameter Modelica.SIunits.Velocity Vel_small = 0.001 ;
  constant Modelica.SIunits.Acceleration g = Modelica.Constants.g_n "Gravitational acceleration";  
  
equation
//
  state_a = Medium.setState_dTX(d = sum(port_a.d), T = port_a.T, X = port_a.d / sum(port_a.d));
  state_b = Medium.setState_dTX(d = sum(port_b.d), T = port_b.T, X = port_b.d / sum(port_b.d));

// pressure reconstruction
  p_a = Medium.pressure(state_a) + sum(port_a.d) * g * (Alt_a-Alt_opening);
  p_b = Medium.pressure(state_b) + sum(port_b.d) * g * (Alt_b-Alt_opening);
  dp = p_a - p_b;
  
// specific enthalpy reconstruction
  h_a = Medium.specificEnthalpy(state_a);
  h_b = Medium.specificEnthalpy(state_b);
  
// density
  rho_A = sum(port_a.d);
  rho_B = sum(port_b.d);

// upsteam density
  rho_up = smooth(1, if dp - (sum(port_a.d) - sum(port_b.d)) * g * (H - HN) > 0 then port_a.d else port_b.d);
  rho_down = port_a.d + port_b.d - rho_up;
  
// upstream mass fraction
  X_up = rho_up / sum(rho_up);
  X_down = port_a.d/rho_A + port_b.d/rho_B - X_up;
  
// altidude of change in direction of flow (if change happens)
  HN = min(max(dp / ((rho_A - rho_B) * g) + H/2, 0), H);

// m_flow = f(dp, Δρ, ΔH)
  m_flow_up = Cd * A/H * sqrt(2 * sum(rho_up)) * ( Modelica.Fluid.Utilities.regRoot(x=dp, delta=1e-3) * (H - HN) - Modelica.Fluid.Utilities.regRoot(x=(rho_A - rho_B) * g, delta=1e-3) * 2/3 * (H-HN)^(3/2) );
  m_flow_down = Cd * A/H * sqrt(2 * sum(rho_down)) * ( Modelica.Fluid.Utilities.regRoot(x=dp, delta=1e-3) * (- HN) - Modelica.Fluid.Utilities.regRoot(x=(rho_A - rho_B) * g, delta=1e-3) * 2/3 * (-HN^(3/2)) );
  
// Port handover
  port_a.m_flow = m_flow_up * X_up + m_flow_down * X_down ;
  port_a.m_flow + port_b.m_flow = fill(0.0, Medium.nX);
  
  port_a.H_flow = semiLinear(m_flow_up, h_a + g * (Alt_a - Alt_b), h_b - g * (Alt_a - Alt_b));
  port_a.H_flow + port_b.H_flow = 0;
  
  annotation(
    Icon(graphics = {Line(origin = {0, 69.8886}, points = {{0, 30}, {0, -30}}, thickness = 2), Line(origin = {0, -70}, points = {{0, 30}, {0, -30}}, thickness = 2)}, coordinateSystem(initialScale = 0.1)),
    experiment(StartTime = 0, StopTime = 1000, Tolerance = 1e-06, Interval = 1),
    Documentation(info = "<html>
  <head>
    <title>Opening</title>
  </head>
	
  <body lang=\"en-UK\">
    <p>
      This components allows to model the mass flow rate through from either static boundary pressure difference or buoyancy effect through a vertical orifice in a wall spliting two ambiances.
    </p>
    
    <p>
      To be considered as an orifice, the depth of the hole in the wall has to remain bellow the hydrodynamic entrance region (Distance between the entrance of the hole and the position where the dynamic boundary layers meet).
    </p>

    <p>    
      <a href=\"modelica://TAeZoSysPro/Information/FluidDynamics/Components/Orifices/build/Demo_opening_aerodynamic.pdf\">See demonstration</a>.
    </p>   
</html>"));

end OpeningAnalytic;