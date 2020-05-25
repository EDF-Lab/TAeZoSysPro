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
  Modelica.SIunits.MassFlowRate m_flow "Aperture flow kg/s";
  Modelica.SIunits.Density d;
  
  // Imported modules
  TAeZoSysPro.FluidDynamics.Interfaces.FlowPort_a port_a(replaceable package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-58, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-52, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  TAeZoSysPro.FluidDynamics.Interfaces.FlowPort_b port_b(replaceable package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {38, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {54, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

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
    x = dp, x_small = 0.01, 
    y1 = sum(port_a.d), 
    y2 = sum(port_b.d));
    
  m_flow = Cd * A * Modelica.Fluid.Utilities.regRoot2(
    x = dp, x_small = 0.1, 
    k1 = 2.0 * sum(port_a.d), 
    k2 = 2.0 * sum(port_b.d));
  
  Vel * d * A = m_flow ;
  
// Port handover
  port_a.m_flow = m_flow * Modelica.Fluid.Utilities.regStep(
    x = dp, 
    x_small = 0.01, 
    y1 = X_a, 
    y2 = X_b);
  port_a.m_flow + port_b.m_flow = fill(0.0, Medium.nX);
  
  port_a.H_flow = m_flow * Medium.specificEnthalpy_pTX(
    p = if noEvent(dp >= 0.0) then p_a else p_b, 
    T = if noEvent(dp >= 0.0) then port_a.T else port_b.T, 
    X = if noEvent(dp >= 0.0) then X_a else X_b);
  port_a.H_flow + port_b.H_flow = 0;
  
  annotation(
    Icon(graphics = {Line(origin = {0, 50}, points = {{0, 30}, {0, -30}}, thickness = 2), Line(origin = {0, -50}, points = {{0, 30}, {0, -30}}, thickness = 2), Text(origin = {16, -113}, extent = {{-116, 33}, {84, 13}}, textString = "A=%A"), Text(origin = {-43, 88}, extent = {{-57, 12}, {143, -8}}, textString = "%name")}, coordinateSystem(initialScale = 0.1)));
end SimpleOpening;
