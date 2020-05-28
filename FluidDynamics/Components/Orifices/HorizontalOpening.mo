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
  Modelica.SIunits.MassFlowRate m_flow "Aperture flow kg/s";
  Modelica.SIunits.MassFlowRate m_flow_buoyancy "Mass flow rate induced by buoyancy";  
  Modelica.SIunits.Density d;
  Modelica.SIunits.HeatFlowRate Q_flow_buoyancy ;  
  
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
    
 dp_buoyancy = Modelica.Constants.g_n * L_up * max(sum(port_a.d - port_b.d), 0) ;
 m_flow_buoyancy = Cd * A / 2 * sqrt(2*dp_buoyancy*sum(port_a.d));
 Q_flow_buoyancy = m_flow_buoyancy * (h_b-h_a) ;
          
  Vel * d * A * Cd = m_flow ;
  
// Ports handover
  port_a.m_flow = m_flow * Modelica.Fluid.Utilities.regStep(x = dp, x_small = 0.01, y1 = X_a, y2 = X_b);
  port_a.m_flow + port_b.m_flow = fill(0.0, Medium.nX);
  port_a.H_flow = m_flow * Medium.specificEnthalpy_pTX(
    p = if noEvent(dp >= 0.0) then p_a else p_b, 
    T = if noEvent(dp >= 0.0) then port_a.T else port_b.T, 
    X = if noEvent(dp >= 0.0) then X_a else X_b) - Q_flow_buoyancy;
  port_a.H_flow + port_b.H_flow = 0;
  
  annotation(
    Icon(graphics = {Line(origin = {-20, 30}, points = {{-60, -30}, {0, -30}}, thickness = 2), Line(origin = {20, -30}, points = {{0, 30}, {60, 30}}, thickness = 2), Text(origin = {-54, 17}, extent = {{-46, 33}, {94, 13}}, textString = "L_up=%L_up"), Line(origin = {49.9541, 34.6789}, points = {{0, 25}, {0, -31}}, thickness = 0.75, arrow = {Arrow.Filled, Arrow.Filled}), Text(origin = {6, -33}, extent = {{-46, 33}, {34, 13}}, textString = "A=%A"), Text(origin = {6, -63}, extent = {{-46, 33}, {94, 13}}, textString = "L_down=%L_down"), Line(origin = {-49.9541, -27.3945}, points = {{0, 25}, {0, -31}}, thickness = 0.75, arrow = {Arrow.Filled, Arrow.Filled})}, coordinateSystem(initialScale = 0.1)),
    experiment(StartTime = 0, StopTime = 0.01, Tolerance = 1e-06, Interval = 2.00803e-05));
end HorizontalOpening;
