within TAeZoSysPro.Aeraulic.Components.PressureLosses.Orifices;

model HorizontalOpening
  package Medium = Media.MyMedia;
  //
  parameter Boolean SteadyState = false "Steady state initialization";
  parameter Real Cd = 0.61 "discharge coefficient";
  parameter Modelica.SIunits.CrossSection Ae = 1 "Aperture section";
  parameter Modelica.SIunits.Length L_down = 1 "air node bottom height";
  parameter Modelica.SIunits.Length L_up = 1 "air node up height";
  parameter Modelica.SIunits.Length NotionalLength = 0.1 "Opening's thickness";
  // Internal variables
  Modelica.SIunits.PressureDifference dp;
  Modelica.SIunits.Pressure p_down;
  Modelica.SIunits.Pressure p_up;
  Modelica.SIunits.Velocity Vel;
  Modelica.SIunits.MassFlowRate m_flow "Aperture flow kg/s";
  Modelica.SIunits.Density d;
  // Imported components
  Interfaces.FlowPort_a Flowport_a(replaceable package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-32, 14}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, 62}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Interfaces.FlowPort_b Flowport_b(replaceable package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {42, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
protected
  Modelica.SIunits.MassFraction[Medium.nX] X_a "Mass fraction vector at port a";
  Modelica.SIunits.MassFraction[Medium.nX] X_b "Mass fraction vector at port b";
initial equation
  if SteadyState then
    der(Vel) = 0;
  else
    Vel = 0;
  end if;
equation
//
  X_a = 1 / sum(Flowport_a.di) * Flowport_a.di;
  X_b = 1 / sum(Flowport_b.di) * Flowport_b.di;
//
  p_up = sum(Flowport_a.pi) + sum(Flowport_a.di) * Modelica.Constants.g_n * L_up;
  p_down = sum(Flowport_b.pi) - sum(Flowport_b.di) * Modelica.Constants.g_n * L_down;
  dp = p_up - p_down;
//solution 1 with a polynomial solution arround Vel = 0 ;
  d = Functions.regStep(x = Vel, x_small = 1e-14, y1 = sum(Flowport_a.di), y2 = sum(Flowport_b.di));
  dp - 1 / 2 * Modelica.Fluid.Utilities.regSquare2(x = Vel, x_small = 1e-3, k1 = sum(Flowport_a.di), k2 = sum(Flowport_b.di)) = NotionalLength * d * der(Vel);
  m_flow = Vel * Ae * Cd * d;
//mass flow through ports
  Flowport_a.m_flow = m_flow * Functions.regStep(x = Vel, x_small = 1e-14, y1 = X_a, y2 = X_b);
  Flowport_a.m_flow + Flowport_b.m_flow = fill(0.0, Medium.nX);
  Flowport_a.H_flow = m_flow * Functions.regStep(x = Vel, x_small = 1e-4, y1 = Flowport_a.h, y2 = Flowport_b.h);
  Flowport_a.H_flow + Flowport_b.H_flow = 0;
  annotation(
    Icon(graphics = {Line(origin = {-20, 30}, points = {{-60, -30}, {0, -30}}, thickness = 2), Line(origin = {20, -30}, points = {{0, 30}, {60, 30}}, thickness = 2), Text(origin = {-16, 7}, extent = {{-46, 33}, {54, 13}}, textString = "L_up=%L_up",  fontSize = 0 ), Line(origin = {40, 35}, points = {{0, 25}, {0, -31}}, thickness = 0.75, arrow = {Arrow.Filled, Arrow.Filled}), Text(origin = {50, 55}, extent = {{-46, 33}, {54, 13}}, textString = "Ae=%Ae",  fontSize = 0 ), Text(origin = {6, -53}, extent = {{-46, 33}, {92, 13}}, textString = "L_down=%L_down",  fontSize = 0 ), Line(origin = {-40, -29}, points = {{0, 25}, {0, -31}}, thickness = 0.75, arrow = {Arrow.Filled, Arrow.Filled})}, coordinateSystem(initialScale = 0.1)),
    experiment(StartTime = 0, StopTime = 0.01, Tolerance = 1e-06, Interval = 2.00803e-05));
end HorizontalOpening;
