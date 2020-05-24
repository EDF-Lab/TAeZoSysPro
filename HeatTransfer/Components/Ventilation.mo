within TAeZoSysPro.HeatTransfer.Components;

model Ventilation
  replaceable package Medium = TAeZoSysPro.HeatTransfer.Media.MyMedia "Medium in the component";
  //
  parameter Boolean Use_External_MassFlow = false;
  parameter Boolean Use_External_VolumeFlow = false;
  parameter Modelica.SIunits.VolumeFlowRate Qfluid = 0 "Constant Volume flow rate";
  parameter Modelica.SIunits.Power P_aero = 0 " fan power(always positiv) given to the fluid";
  // Output port
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port_b annotation(
    Placement(visible = true, transformation(origin = {0, 98}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  // Input port
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a annotation(
    Placement(visible = true, transformation(origin = {-1, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-101, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput Qm_fluid if Use_External_MassFlow annotation(
    Placement(visible = true, transformation(origin = {-106, 78}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-100, 84}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput Qv_fluid if Use_External_VolumeFlow annotation(
    Placement(visible = true, transformation(origin = {-106, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-100, -86}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  // Variables are defined
  Modelica.SIunits.Temperature Tin;
  // Room 1 Air temperature
  Modelica.SIunits.Temperature Tsupply;
  // Room 2 Air temperature
  Modelica.SIunits.SpecificHeatCapacity cp;
  //
  Modelica.SIunits.Density d;
  //
  Modelica.SIunits.MassFlowRate m_flow;
equation
  cp = Medium.specificHeatCapacityCp(Medium.setState_pTX(p = Medium.reference_p, T = port_a.T));
  d = Medium.density_pT(p = Medium.reference_p, T = port_a.T);
  if not Use_External_MassFlow and not Use_External_VolumeFlow then
    m_flow = Qfluid * d;
  elseif Use_External_MassFlow then
    m_flow = Qm_fluid;
  elseif Use_External_VolumeFlow then
    m_flow = Qv_fluid * d;
  end if;
  Tin = port_a.T;
  port_a.Q_flow = 0;
  if m_flow <> 0.0 then
    P_aero = m_flow * cp * (Tsupply - Tin);
  else
    Tsupply = port_b.T;
  end if;
  port_b.Q_flow = m_flow * cp * (port_b.T - Tsupply) ;
  annotation(
    Diagram(coordinateSystem(grid = {1, 2}, initialScale = 0.1)),
    Icon(graphics = {Ellipse(lineThickness = 1, extent = {{-100, -100}, {100, 100}}, endAngle = 360), Ellipse(lineColor = {182, 182, 182}, lineThickness = 2, extent = {{-98, -98}, {98, 98}}, endAngle = 360), Polygon(origin = {44.28, 19.95}, fillColor = {182, 182, 182}, fillPattern = FillPattern.Solid, points = {{-44.2764, -19.9472}, {43.7236, -19.9472}, {43.7236, -19.9472}, {45.7236, -7.9472}, {45.7236, -7.94721}, {45.7236, 0.0527902}, {43.7236, 8.05279}, {39.7236, 14.0528}, {35.7236, 20.0528}, {35.7236, 20.0528}, {35.7236, 20.0528}, {-44.2764, -19.9472}}), Polygon(origin = {-43.72, -20.05}, rotation = 180, fillColor = {182, 182, 182}, fillPattern = FillPattern.Solid, points = {{-44.2764, -19.9472}, {43.7236, -19.9472}, {43.7236, -19.9472}, {45.7236, -7.9472}, {45.7236, -7.94721}, {45.7236, 0.0527902}, {43.7236, 8.05279}, {39.7236, 14.0528}, {35.7236, 20.0528}, {35.7236, 20.0528}, {35.7236, 20.0528}, {-44.2764, -19.9472}}), Polygon(origin = {-19.72, 43.95}, rotation = 90, fillColor = {182, 182, 182}, fillPattern = FillPattern.Solid, points = {{-44.2764, -19.9472}, {43.7236, -19.9472}, {43.7236, -19.9472}, {45.7236, -7.9472}, {45.7236, -7.94721}, {45.7236, 0.0527902}, {43.7236, 8.05279}, {39.7236, 14.0528}, {35.7236, 20.0528}, {35.7236, 20.0528}, {35.7236, 20.0528}, {-44.2764, -19.9472}}), Polygon(origin = {20.28, -44.05}, rotation = -90, fillColor = {182, 182, 182}, fillPattern = FillPattern.Solid, points = {{-44.2764, -19.9472}, {43.7236, -19.9472}, {43.7236, -19.9472}, {45.7236, -7.9472}, {45.7236, -7.94721}, {45.7236, 0.0527902}, {43.7236, 8.05279}, {39.7236, 14.0528}, {35.7236, 20.0528}, {35.7236, 20.0528}, {35.7236, 20.0528}, {-44.2764, -19.9472}}), Ellipse(fillColor = {182, 182, 182}, fillPattern = FillPattern.Sphere, lineThickness = 1, extent = {{-10, -10}, {10, 10}}, endAngle = 360), Text(origin = {-76, 89}, extent = {{-10, 5}, {16, -11}}, textString = "[kg / s]",  fontSize = 0 ), Text(origin = {-76, -81}, extent = {{-10, 5}, {16, -11}}, textString = "[m3 / s]",  fontSize = 0 ), Text(origin = {63, -98}, lineThickness = 0.5, extent = {{27, 10}, {-15, -6}}, textString = "KURY - EDVANCE",  fontSize = 0 )}, coordinateSystem(initialScale = 0.1)));
end Ventilation;