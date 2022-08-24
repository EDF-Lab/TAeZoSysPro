within TAeZoSysPro.HeatTransfer.Components;

model VerticalOpening
  replaceable package Medium = TAeZoSysPro.Media.MyMedia;
  //
  constant Modelica.SIunits.Acceleration g_n = Modelica.Constants.g_n;
  constant Modelica.SIunits.Pressure p = Medium.reference_p "fluid pressure";
  parameter Boolean mass_conservation = true "If true, mass flow profile is assumed symmetrical from either side of the middle of the opening";
  parameter Real Cd = 0.61 "discharge coefficient";
  parameter Modelica.SIunits.CrossSection A = 1 "Opening's section";
  parameter Modelica.SIunits.Length H = 1 "Opening's Height";

  // Internal variable
  Medium.ThermodynamicState state_A;
  Medium.ThermodynamicState state_B;
  Modelica.SIunits.TemperatureDifference dT "port_a.T - port_b.T"; 
  Modelica.SIunits.Density rho_A,rho_B;
  Modelica.SIunits.Density rho_up, rho_down "Upstream density in upper and lower part of the opening";
  Medium.SpecificEnthalpy h_A, h_B;
  Modelica.SIunits.MassFlowRate m_flow_up, m_flow_down "mass flow rate in upper and lower part of the opening";
  Modelica.SIunits.Height HN "Heigh of the point where flow switches in direction (zero flow)";
    
  // Imported components
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port_b annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
//
  state_A = Medium.setState_pTX(p = p, T = port_a.T);
  state_B = Medium.setState_pTX(p = p, T = port_b.T);
//  state_Mean = Medium.setState_pTX(p = p, T = (Heatport_a.T+Heatport_b.T)/2);
  dT = port_a.T - port_b.T;
  rho_A = Medium.density(state_A);
  rho_B = Medium.density(state_B);
  rho_up = smooth(1, if port_a.T >= port_b.T then rho_A else rho_B);
  rho_down = rho_A + rho_B - rho_up;
  h_A = Medium.specificEnthalpy(state_A);
  h_B = Medium.specificEnthalpy(state_B);
  
// quasi static flow assumption. Analytic integration over the height of m_flow(z) = f(dp(z))
  m_flow_up = Cd * A/H * Modelica.Fluid.Utilities.regRoot(
    x = 2 * rho_up * g_n * (rho_B - rho_A),
    delta = 1e-3) * 2/3 * (H-HN)^(3/2);
  m_flow_down = Cd * A/H * Modelica.Fluid.Utilities.regRoot(
    x = 2 * rho_down * g_n * (rho_B - rho_A),
    delta = 1e-3) * 2/3 * (-HN^(3/2));
  
// if mass_conservation then the heigh of the 0 flow is compute to insure that m_flow_up = m_flow_down in absolute value
  HN = if mass_conservation then H / ( (rho_down/rho_up)^(1/3) + 1 ) else H/2;
    
// port handover
  port_a.Q_flow = smooth(0, if sign(port_a.T - port_b.T) > 0 then m_flow_down * (h_B - h_A) else m_flow_up * (h_B - h_A));
  port_b.Q_flow = smooth(0, if sign(port_a.T - port_b.T) > 0 then -m_flow_up * (h_A - h_B) else -m_flow_down * (h_A - h_B));

  
  annotation(
    Icon(graphics = {Line(origin = {0, 69.8886}, points = {{0, 30}, {0, -30}}, thickness = 2), Line(origin = {0, -70}, points = {{0, 30}, {0, -30}}, thickness = 2)}, coordinateSystem(initialScale = 0.1)),
    experiment(StartTime = 0, StopTime = 1000, Tolerance = 1e-06, Interval = 1),
    Documentation(info = 
"<html>
  <head>
    <title>Vertical Opening</title>		
  </head>
	
  <body lang=\"en-UK\">
    <p>
      This module allows to model the net heat flow induces by air movement only from bouyancy through an opening that links two ambiances. 
    </p>

    <p>    
      <a href=\"modelica://TAeZoSysPro/Information/HeatTransfer/Components/build/Demo_vertical_opening_thermal_mode.pdf\">See demonstration</a>.
    </p>
    
    <p>
      When mass conservation is set to true, the height <b>HN</b> where the flow changes in direction is computed to insure that <b>m_flow_up</b> and <b>m_flow_down</b> are equal is absolute value. If not <b>HN</b> is equal to <b>H/2</b>
    </p>
    
</html>"));

end VerticalOpening;