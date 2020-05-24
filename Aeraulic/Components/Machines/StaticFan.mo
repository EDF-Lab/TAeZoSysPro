within TAeZoSysPro.Aeraulic.Components.Machines;

model StaticFan
  replaceable package Medium = TAeZoSysPro.Aeraulic.Media.MyMedia;
  extends PumpCurveFitting ;
  //
  parameter Modelica.SIunits.IsentropicExponent gamma = 1.4 "isentropic exponent";
  parameter Modelica.SIunits.Efficiency n_is = 0.8 "isentropic efficiency";
  //
  Medium.BaseProperties medium_a(p = fluidport_a.p, h = inStream(fluidport_a.h_outflow), Xi = inStream(fluidport_a.Xi_outflow)) "medium properties at port a";
  Medium.BaseProperties medium_b(p = fluidport_b.p, h = inStream(fluidport_b.h_outflow), Xi = inStream(fluidport_b.Xi_outflow)) "medium properties at port b";
  //
  Modelica.SIunits.PressureDifference dp;
  Modelica.SIunits.Density d;
  Modelica.SIunits.SpecificEnthalpy h_is "isentropic out specific enthalpy";
  Modelica.SIunits.SpecificEnthalpy h_out "output specific enthalpy";
  Modelica.SIunits.Power P_meca "Mechanical power";
  Modelica.SIunits.Power P_meca_incomp "Mechanical power for uncompressible fluid";
  Modelica.SIunits.MassFlowRate m_flow(displayUnit = "kg/h");
  Modelica.SIunits.VolumeFlowRate Qv_flow(start = Table[integer(N / 2), 1], displayUnit = "m3/h");
  Modelica.Fluid.Interfaces.FluidPort_a fluidport_a(replaceable package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-98, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-96, 0}, extent = {{-12, -12}, {12, 12}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_b fluidport_b(replaceable package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 84}, extent = {{-12, -12}, {12, 12}}, rotation = 0)));
equation
  d = if m_flow >= 0.0 then medium_a.d else medium_a.d;
  Qv_flow = m_flow / d;
//momentum balance
  dp = fluidport_a.p - fluidport_b.p;
//  dp + a * Qv_flow * Qv_flow + b * Qv_flow + c = 0.0;
  dp + sum({Coeff[j] .* Qv_flow ^ (j - 1) for j in 1:OrderPolyFitting + 1}) = 0.0;
//power balance
  h_is = medium_a.h + gamma / (gamma - 1) * medium_a.R * medium_a.T * ((fluidport_b.p / fluidport_a.p) ^ ((gamma - 1) / gamma) - 1);
  n_is = (h_is - medium_a.h) / (h_out - medium_a.h);
  P_meca = m_flow * (h_out - medium_a.h);
  P_meca_incomp = abs(Qv_flow * dp);
// port handover
  fluidport_a.m_flow = m_flow;
  fluidport_a.m_flow + fluidport_b.m_flow = 0.0;
  fluidport_a.h_outflow = inStream(fluidport_b.h_outflow);
  fluidport_b.h_outflow = h_out;
  fluidport_a.Xi_outflow = inStream(fluidport_b.Xi_outflow);
  fluidport_b.Xi_outflow = inStream(fluidport_a.Xi_outflow);
  annotation(
    Icon(graphics = {Ellipse(origin = {4, 0}, lineThickness = 1, extent = {{-100, -100}, {100, 100}}, endAngle = 360), Ellipse(origin = {4, 0}, lineColor = {182, 182, 182}, lineThickness = 1, extent = {{-98, -98}, {98, 98}}, endAngle = 360), Polygon(origin = {48.28, 19.95}, fillColor = {182, 182, 182}, fillPattern = FillPattern.Solid, points = {{-44.2764, -19.9472}, {43.7236, -19.9472}, {43.7236, -19.9472}, {45.7236, -7.9472}, {45.7236, -7.94721}, {45.7236, 0.0527902}, {43.7236, 8.05279}, {39.7236, 14.0528}, {35.7236, 20.0528}, {35.7236, 20.0528}, {35.7236, 20.0528}, {-44.2764, -19.9472}}), Polygon(origin = {-39.72, -20.05}, rotation = 180, fillColor = {182, 182, 182}, fillPattern = FillPattern.Solid, points = {{-44.2764, -19.9472}, {43.7236, -19.9472}, {43.7236, -19.9472}, {45.7236, -7.9472}, {45.7236, -7.94721}, {45.7236, 0.0527902}, {43.7236, 8.05279}, {39.7236, 14.0528}, {35.7236, 20.0528}, {35.7236, 20.0528}, {35.7236, 20.0528}, {-44.2764, -19.9472}}), Polygon(origin = {-15.72, 43.95}, rotation = 90, fillColor = {182, 182, 182}, fillPattern = FillPattern.Solid, points = {{-44.2764, -19.9472}, {43.7236, -19.9472}, {43.7236, -19.9472}, {45.7236, -7.9472}, {45.7236, -7.94721}, {45.7236, 0.0527902}, {43.7236, 8.05279}, {39.7236, 14.0528}, {35.7236, 20.0528}, {35.7236, 20.0528}, {35.7236, 20.0528}, {-44.2764, -19.9472}}), Polygon(origin = {24.28, -44.05}, rotation = -90, fillColor = {182, 182, 182}, fillPattern = FillPattern.Solid, points = {{-44.2764, -19.9472}, {43.7236, -19.9472}, {43.7236, -19.9472}, {45.7236, -7.9472}, {45.7236, -7.94721}, {45.7236, 0.0527902}, {43.7236, 8.05279}, {39.7236, 14.0528}, {35.7236, 20.0528}, {35.7236, 20.0528}, {35.7236, 20.0528}, {-44.2764, -19.9472}}), Ellipse(origin = {4, 0}, fillColor = {182, 182, 182}, fillPattern = FillPattern.Sphere, lineThickness = 1, extent = {{-10, -10}, {10, 10}}, endAngle = 360), Line(origin = {-99.916, 27.4046}, points = {{-33, 0}, {33, 0}}, color = {0, 85, 255}, thickness = 0.5, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 5), Line(origin = {94.6338, 105.802}, points = {{-33, 0}, {33, 0}}, color = {0, 85, 255}, thickness = 0.5, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 5), Rectangle(origin = {54, 84}, lineColor = {255, 255, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, lineThickness = 0.5, extent = {{-48, 16}, {48, -16}}), Line(origin = {53, 83.96}, points = {{-47, 16.0432}, {47, 16.0432}, {47, -15.9568}, {25, -15.9568}}, thickness = 1), Line(origin = {51, 81.83}, points = {{-45, 16.1708}, {47, 16.1708}, {47, -11.8292}, {21, -11.8292}, {25, -15.8292}}, color = {182, 182, 182}, thickness = 1), Line(origin = {-101.336, -0.9771}, points = {{7, -20}, {-9, -20}, {-9, 22}, {7, 22}}, thickness = 1), Line(origin = {-106.16, -7.31}, points = {{10.9961, -12}, {-1.00386, -12}, {-1.00386, 26}, {10.9961, 26}}, color = {181, 181, 181}, thickness = 1)}, coordinateSystem(initialScale = 0.05, extent = {{-110, -110}, {110, 110}})),
    __OpenModelica_commandLineOptions = "");
end StaticFan;
