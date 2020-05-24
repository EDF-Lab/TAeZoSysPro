within TAeZoSysPro.Aeraulic.Components.PressureLosses.Orifices;

model SimpleOpeningComp
  package Medium = TAeZoSysPro.Aeraulic.Media.MyMedia;
  //
  parameter Boolean SteadyState = false "Steady state initialization";
  parameter Real Cd = 0.61 "discharge coefficient";
  parameter Modelica.SIunits.PressureDifference dP_burst = 0 "Membrane pressure rupture";
  parameter Modelica.SIunits.CrossSection Ae = 1 "Aperture section";
  parameter Modelica.SIunits.Length NotionalLength = 0.1 "Opening's thickness";
  parameter Boolean BurstMembrane = false;
  Modelica.SIunits.CrossSection Ar(start = 0.0) "opened surface";
  Modelica.SIunits.PressureDifference dp;
  Modelica.SIunits.Velocity Vel;
  Modelica.SIunits.MassFlowRate m_flow "Aperture flow kg/s";
  Modelica.SIunits.MassFlowRate m_flow_subsonic "Subsonic compressible mass flow kg/s";
  Modelica.SIunits.MassFlowRate m_flow_blocked "Blocking sonic mass flow kg/s";
  Modelica.SIunits.Density d;
  Modelica.SIunits.Density d_comp "Densite au col";
  Modelica.SIunits.AbsolutePressure pa;
  Modelica.SIunits.AbsolutePressure pb;
  Modelica.SIunits.IsentropicExponent gamma;
  Modelica.SIunits.MachNumber M(start = 0.5);
  Modelica.SIunits.SpecificHeatCapacity r;
  Modelica.SIunits.Temperature T0;
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
  pa = sum(Flowport_a.pi);
  pb = sum(Flowport_b.pi);
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
//gamma and r calculation
//gamma = if dp > 0 then
//            Medium.Cp(Flowport_a.di)/Medium.Cv(Flowport_a.di)
//          else Medium.Cp(Flowport_b.di)/Medium.Cv(Flowport_b.di) ;
  gamma = TAeZoSysPro.Aeraulic.Functions.regStep(x = Vel, x_small = 0.01, y1 = Medium.Cp(Flowport_a.di) / Medium.Cv(Flowport_a.di), y2 = Medium.Cp(Flowport_b.di) / Medium.Cv(Flowport_b.di));
//  T0 = if dp > 0 then
//        Flowport_a.T
//       else Flowport_b.T ;
  T0 = TAeZoSysPro.Aeraulic.Functions.regStep(x = Vel, x_small = 0.01, y1 = Flowport_a.T, y2 = Flowport_b.T);
//  r = if dp > 0 then
//        Modelica.Constants.R *sum(X_a ./ Medium.MMX)
//      else  Modelica.Constants.R *sum(X_b ./ Medium.MMX) ;
  r = Modelica.Constants.R * TAeZoSysPro.Aeraulic.Functions.regStep(x = Vel, x_small = 0.01, y1 = sum(X_a ./ Medium.MMX), y2 = sum(X_b ./ Medium.MMX));
//solution 1 with a polynomial solution arround Vel = 0 ;
//Mach number calculation
  M = min(1, (2 / (gamma - 1) * ((min(pa, pb) / max(pa, pb)) ^ ((1 - gamma) / gamma) - 1)) ^ 0.5);
  d = TAeZoSysPro.Aeraulic.Functions.regStep(x = Vel, x_small = 0.01, y1 = sum(Flowport_a.di), y2 = sum(Flowport_b.di));
  d_comp = d * (1 + (gamma - 1) / 2 * M ^ 2) ^ (-1 / (gamma - 1));
//  dp - 1/2 * Modelica.Fluid.Utilities.regSquare2(x=Vel, x_small=0.1, k1=d_comp, k2=d_comp) = NotionalLength * d_comp * der(Vel);
  sign(dp) * gamma / (gamma - 1) * max(pa, pb) / d * (1 - (max(pa, pb) / min(pa, pb)) ^ ((1 - gamma) / gamma)) - 0.5 * Modelica.Fluid.Utilities.regSquare2(x = Vel, x_small = 0.1, k1 = 1, k2 = 1) = NotionalLength * der(Vel);
// gamma/(gamma-1) * max(pa,pb)/d*(1-(max(pa,pb)/min(pa,pb))^((1-gamma)/gamma)) = 0.5*Vel*Vel;
  m_flow_subsonic = Vel * Ar * Cd * d_comp;
//Blocking mass flow calculation
  m_flow_blocked = sign(dp) * max(pa, pb) * (gamma / r / T0) ^ 0.5 * Ar * Cd * ((gamma + 1) / 2) ^ ((1 + gamma) / 2 / (1 - gamma)) "From Barre Saint Venant and Hugoniot";
//Mass flow selection (sonic blocking)
  m_flow = TAeZoSysPro.Aeraulic.Functions.regStep(x = M - 1 + 0.01, x_small = 0.01, y1 = m_flow_blocked, y2 = m_flow_subsonic);
//mass flow through ports
  Flowport_a.m_flow = m_flow * TAeZoSysPro.Aeraulic.Functions.regStep(x = Vel, x_small = 0.01, y1 = X_a, y2 = X_b);
  Flowport_a.m_flow + Flowport_b.m_flow = fill(0.0, Medium.nX);
  Flowport_a.H_flow = m_flow * TAeZoSysPro.Aeraulic.Functions.regStep(x = Vel, x_small = 0.01, y1 = Flowport_a.h, y2 = Flowport_b.h);
  Flowport_a.H_flow + Flowport_b.H_flow = 0;
  annotation(
    Icon(graphics = {Line(origin = {0, 50}, points = {{0, 30}, {0, -30}}, thickness = 2), Line(origin = {0, -50}, points = {{0, 30}, {0, -30}}, thickness = 2), Text(origin = {16, -113}, extent = {{-46, 33}, {24, 13}}, textString = "Ae=%Ae",  fontSize = 0 ), Text(origin = {-43, 88}, extent = {{-27, 12}, {123, -6}}, textString = "dP_burst=%dP_burst",  fontSize = 0 )}, coordinateSystem(initialScale = 0.1)));
end SimpleOpeningComp;
