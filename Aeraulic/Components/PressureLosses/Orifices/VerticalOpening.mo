within TAeZoSysPro.Aeraulic.Components.PressureLosses.Orifices;

model VerticalOpening
  package Medium = Media.MyMedia;
  //
  parameter Boolean SteadyState = false "Steady state initialization";
  parameter Real Cd = 0.61 "discharge coefficient";
  parameter Modelica.SIunits.CrossSection Ae = 1 "Opening's section";
  parameter Modelica.SIunits.Length H = 1 "Opening's Height";
  parameter Modelica.SIunits.Length NotionalLength = 0.1 "Opening's thickness";
  parameter Integer nc = 10 "number of layer in opening";
  Modelica.SIunits.PressureDifference dp;
  Modelica.SIunits.MassFlowRate m_flow "mass flow rate flowing through the aperture";
  //flow port
  TAeZoSysPro.Aeraulic.Interfaces.FlowPort_a Flowport_a(replaceable package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-36, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-36, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  TAeZoSysPro.Aeraulic.Interfaces.FlowPort_b Flowport_b(replaceable package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {34, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {34, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.SIunits.MassFlowRate[nc] mi_flow "elementary mass flow rate flowing through the aperture";
protected
  Modelica.SIunits.PressureDifference[nc] dpi;
  Modelica.SIunits.Density d[nc];
  Modelica.SIunits.Velocity[nc] Vel;
  Modelica.SIunits.MassFlowRate[nc, Medium.nX] miX "elementary mass flow rate peer species";
  Modelica.SIunits.SpecificEnthalpy[nc] Hi;
  Modelica.SIunits.MassFraction[Medium.nX] X_a "Mass fraction vector at port a";
  Modelica.SIunits.MassFraction[Medium.nX] X_b "Mass fraction vector at port b";
initial equation
  if SteadyState then
    der(Vel) = fill(0.0, nc);
  else
    Vel = fill(0.0, nc);
  end if;
equation
//
  X_a = 1 / sum(Flowport_a.di) * Flowport_a.di;
  X_b = 1 / sum(Flowport_b.di) * Flowport_b.di;
//
  dp = sum(Flowport_a.pi) - sum(Flowport_b.pi);
  for i in 1:nc loop
    dpi[i] = dp + Modelica.Constants.g_n * (H / 2 - H * (i - 1 / 2) / nc) * (sum(Flowport_a.di) - sum(Flowport_b.di));
    d[i] = Functions.regStep(x = Vel[i], x_small = 1e-14, y1 = sum(Flowport_a.di), y2 = sum(Flowport_b.di));
    dpi[i] - 1 / 2 * Modelica.Fluid.Utilities.regSquare2(x = Vel[i], x_small = 1e-3, k1 = sum(Flowport_a.di), k2 = sum(Flowport_b.di)) = NotionalLength * d[i] * der(Vel[i]);
// elementary mass balance
    mi_flow[i] = Vel[i] * Cd * Ae / nc * d[i];
    miX[i, :] = mi_flow[i] * Functions.regStep(x = Vel[i], x_small = 1e-14, y1 = X_a, y2 = X_b);
    Hi[i] = mi_flow[i] * Functions.regStep(x = Vel[i], x_small = 1e-3, y1 = Flowport_a.h, y2 = Flowport_b.h);
  end for;
  m_flow = sum(Flowport_a.m_flow);
//mass flow through port
  Flowport_a.m_flow = {sum(miX[:, i]) for i in 1:Medium.nX};
  Flowport_a.m_flow + Flowport_b.m_flow = fill(0.0, Medium.nX);
//
  Flowport_a.H_flow = sum(Hi);
  Flowport_a.H_flow + Flowport_b.H_flow = 0;
  annotation(
    Icon(graphics = {Line(origin = {0, 50}, points = {{0, 30}, {0, -30}}, thickness = 2), Line(origin = {0, -50}, points = {{0, 30}, {0, -30}}, thickness = 2), Text(origin = {39, 66}, extent = {{-27, 12}, {53, -38}}, textString = "H=%H", fontName = "MS Shell Dlg 2"), Text(origin = {56, -57}, extent = {{-46, 33}, {36, -25}}, textString = "Ae=%Ae", fontName = "MS Shell Dlg 2")}, coordinateSystem(initialScale = 0.1)),
    experiment(StartTime = 0, StopTime = 1000, Tolerance = 1e-06, Interval = 1));
end VerticalOpening;
