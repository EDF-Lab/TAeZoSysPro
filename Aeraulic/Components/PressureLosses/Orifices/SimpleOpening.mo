within TAeZoSysPro.Aeraulic.Components.PressureLosses.Orifices;

model SimpleOpening
  /*
                                                                                                  This block determines the mass exchange through an aperture:
                                                                                                  The aperture can be ans static aperture or a burst membrane
                                                                                                  */
  package Medium = Media.MyMedia;
  //
  parameter Boolean SteadyState = false "Steady state initialization";
  parameter Real Cd = 0.61 "discharge coefficient";
  parameter Modelica.SIunits.PressureDifference dP_burst = 0 "Membrane pressure rupture";
  parameter Modelica.SIunits.CrossSection Ae = 1 "Aperture section";
  parameter Modelica.SIunits.Length NotionalLength = 0.1 "Opening's thickness";
  parameter Boolean BurstMembrane = false;
  Modelica.SIunits.CrossSection Ar(start = 0.0) "opened surface";
  Modelica.SIunits.PressureDifference dp;
  Modelica.SIunits.Velocity Vel(start = 0.1);
  Modelica.SIunits.MassFlowRate m_flow "Aperture flow kg/s";
  Modelica.SIunits.Density d;
  //ports
  TAeZoSysPro.Aeraulic.Interfaces.FlowPort_a Flowport_a(replaceable package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-58, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-52, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  TAeZoSysPro.Aeraulic.Interfaces.FlowPort_b Flowport_b(replaceable package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {38, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {54, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
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
  dp = sum(Flowport_a.pi) - sum(Flowport_b.pi);
// transition without event
  if abs(dp) > dP_burst and BurstMembrane or not BurstMembrane or Ar > 0.0 then
    Ar = Ae;
  else
    Ar = 0;
  end if;
// if the user wants no intertial term
//  if NotionalLength == 0.0 then
//    der(d*Vel) = 0 ;
//  end if ;
//solution 1 with a polynomial solution arround Vel = 0 ;
  d = Functions.regStep(x = Vel, x_small = 0.01, y1 = sum(Flowport_a.di), y2 = sum(Flowport_b.di));
  dp - 1 / 2 * Modelica.Fluid.Utilities.regSquare2(x = Vel, x_small = 0.01, k1 = sum(Flowport_a.di), k2 = sum(Flowport_b.di)) = NotionalLength * d * der(Vel);
  m_flow = Vel * Ar * Cd * d;
//mass flow through ports
  Flowport_a.m_flow = m_flow * Functions.regStep(x = Vel, x_small = 0.01, y1 = X_a, y2 = X_b);
  Flowport_a.m_flow + Flowport_b.m_flow = fill(0.0, Medium.nX);
  Flowport_a.H_flow = m_flow * Functions.regStep(x = Vel, x_small = 0.01, y1 = Flowport_a.h, y2 = Flowport_b.h);
  Flowport_a.H_flow + Flowport_b.H_flow = 0;
  annotation(
    Icon(graphics = {Line(origin = {0, 50}, points = {{0, 30}, {0, -30}}, thickness = 2), Line(origin = {0, -50}, points = {{0, 30}, {0, -30}}, thickness = 2), Text(origin = {16, -113}, extent = {{-46, 33}, {24, 13}}, textString = "Ae=%Ae",  fontSize = 0 ), Text(origin = {-43, 88}, extent = {{-27, 12}, {123, -6}}, textString = "dP_burst=%dP_burst",  fontSize = 0 )}, coordinateSystem(initialScale = 0.1)));
end SimpleOpening;
