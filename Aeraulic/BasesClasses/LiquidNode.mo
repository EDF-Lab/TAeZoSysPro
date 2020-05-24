within TAeZoSysPro.Aeraulic.BasesClasses;

model LiquidNode
  // medium declaration
  replaceable package Medium = Modelica.Media.Water.WaterIF97_ph;
  //medium properties
  Medium.BaseProperties medium;
  //-----
  // Internal parameters
  // gas node initial properties
  parameter Boolean SteadyState = false "Steady state initialization";
  parameter Modelica.SIunits.Temperature Tstart = 293.15 "Medium initial temperature ";
  parameter Modelica.SIunits.Volume Vstart = 1 "Initial volume of Medium in the node";
  parameter Modelica.SIunits.Area S = 1 "liquid node gas interface surface";
  // optional use of external values
  parameter Real n_drop = 1e-2 "number of droplet per cm3";
  parameter Real C_drag = 0.47 "Drag coefficient of a sphere at 10^4 < RE < 5*10^5";
  //
  constant Modelica.SIunits.Density dsteam = 0.59 "density of steam bubbles";
  //-----
  // variable declaration
  Modelica.SIunits.Temperature T "Medium temperature ";
  //
  Modelica.SIunits.Pressure p "absolute medium pressure";
  //
  Modelica.SIunits.SpecificEnthalpy h "Medium specific enthalpy ";
  Modelica.SIunits.SpecificEnthalpy h_bubble "Medium specific enthalpy at bubble point ";
  Modelica.SIunits.SpecificEnthalpy h_dew "Medium specific enthalpy at dew point ";
  //
  Modelica.SIunits.Mass m "Medium mass";
  //
  Modelica.SIunits.MassFlowRate m_flow_boiling "Mass flow rate bubble production";
  Modelica.SIunits.MassFlowRate m_flow_bubble "Mass flow rate bubble evacuation";
  //
  Real Xg;
  Modelica.SIunits.MassFraction XgIfBoiling;
  //
  Modelica.SIunits.Volume V;
  //
  Modelica.SIunits.Diameter d_bubble(start = 0) "bublle diameter";
  //
  Modelica.SIunits.Velocity V_bubble(start = 0) "Velocity of a fog's droplet";
  //-----
  //Components inported
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a Heatport annotation(
    Placement(visible = true, transformation(origin = {46, -12}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-70, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  /* Water_Input[1] = mass flow rate of water (from wall condensation or recovery system)
                                                                                   Water_Input[2] = temperature of water (from wall condensation or recovery system) */
  //-----
  TAeZoSysPro.Aeraulic.Interfaces.FlowPort_a flowPort(replaceable package Medium = Media.MyMedia) annotation(
    Placement(visible = true, transformation(origin = {0, 38}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  TAeZoSysPro.Aeraulic.Interfaces.FlowPort_b flowPort_b(replaceable package Medium = Media.MyMedia) annotation(
    Placement(visible = true, transformation(origin = {2, 72}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {68, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
initial equation
  m = Modelica.Media.Water.WaterIF97_base.density_pT(p = sum(flowPort.pi), T = Tstart, region = 1) * Vstart;
  medium.T = Tstart;
//medium.h = Medium.specificEnthalpy_pT(p = sum(flowPort.pi), T = Tstart, phase = 1, region = 1);
equation
// Shorter variable
  p = sum(flowPort.pi);
  p = medium.p;
  h = medium.h;
  T = medium.T;
//-----
// Saturation study
  h_bubble = Medium.bubbleEnthalpy(medium.sat);
  h_dew = Medium.dewEnthalpy(medium.sat);
//-----
// Mass balance
  der(m) = m_flow_bubble + flowPort_b.m_flow[Media.MyMedia.Water];
  der(XgIfBoiling * m) = m_flow_boiling + m_flow_bubble;
// the bubble volume is neglected in density to minimize the volume of water
  m = Medium.density_pT(p = p, T = T, region = 1) * V;
//-----
//Two phase calculation
// fraction of gas
  h_dew * Xg + (1 - Xg) * h_bubble = h;
  XgIfBoiling = noEvent(if Xg > 0 then Xg else 0);
//Modelica.Fluid.Utilities.regStep(x = Xg, x_small = Modelica.Constants.small, y1 = Xg, y2 =0);
// bubble size calculation
  m * XgIfBoiling = 0.6 * n_drop * 1e6 * V * 4 / 3 * Modelica.Constants.pi * (d_bubble / 2) ^ 3;
// momentum conservation => weight = friction
  V_bubble ^ 2 = d_bubble / 3 * 1 / 0.4 * Modelica.Constants.g_n;
// mass flow rate of leaving bubbles
  m_flow_bubble = -V_bubble * S * (n_drop * 1e6 * Modelica.Constants.pi / 6 * d_bubble ^ 3) * dsteam;
// Energy balance
  der(m * h) = m_flow_bubble * h_dew + Heatport.Q_flow + flowPort_b.H_flow;
//-----
// Port handover
//Heatport
  Heatport.T = T;
//flowPort to gas nodeflowport
  flowPort.m_flow[Media.MyMedia.Water] = m_flow_bubble;
  flowPort.m_flow[Media.MyMedia.Air] = 0;
  flowPort.H_flow = m_flow_bubble * h_dew;
//flowPort to interface
  flowPort_b.T = T;
  flowPort_b.pi[Media.MyMedia.Water] = p;
  flowPort_b.pi[Media.MyMedia.Air] = 0;
  flowPort_b.di[Media.MyMedia.Water] = medium.d;
  flowPort_b.di[Media.MyMedia.Air] = 0;
  flowPort_b.hi[Media.MyMedia.Water] = h;
/* careful h is claculated using IF97 relations and not Media.MyMedia ones */
  flowPort_b.hi[Media.MyMedia.Air] = 0;
  flowPort_b.h = h;
/* careful h is claculated using IF97 relations and not Media.MyMedia ones */
//-----
//Icon and comments
//-----
  annotation(
    Documentation(info = "
<html>
<head>
<title>The Modelica License 2</title>
<style type=\"text/css\">
*       { font-size: 10pt; font-family: Arial,sans-serif; }
code    { font-size:  9pt; font-family: Courier,monospace;}
h1      { font-size: 20pt; font-weight: bold; color: rgb(32,32,32); }
h2      { font-size: 18pt; font-weight: bold; color: rgb(32,32,32); }
h3      { font-size: 16pt; font-weight: bold; color: rgb(32,32,32); }
h4      { font-size: 14pt; font-weight: bold; color: rgb(32,32,32); }
h5      { font-size: 12pt; font-weight: bold; color: rgb(32,32,32); }
h6      { font-size: 10pt; font-weight: bold; color: rgb(32,32,32); }
</style>

<meta http-equiv=\"Content-Type\" content=\"text/html;charset=utf-8\">
</head>

<!-- balise p pour paragraphe -->
<!-- balise br pour sauter une ligne -->
<!-- balise em pour italique ou plutot mettre en valeur -->

<body>
<p>

This model represents a pool containing a liquid water mass. The interface with its environment is treated through 3 ports. </br>
One thermal port for only heat exchanges. The power could come from, for example :
<ul>
<li> An internal heating or cooling power </li>
<li> The condensation or evaporation at the water surface</li>
<li> The convection at water surface or with the container </li>
</ul>

One fluidport for mass exchange with an air node. It has been added to transfer the steam from the boiling to the air node. </br>

One input vector to allow an water inlet from an external input. The first component of the input vector is the mass flow rate and
the second is the water temperature. This input could represent for exemple :
<ul>
<li> a flow a pumping system </li>
<li> a flow from the wall condensation that flows to the pool  </li>
</ul>		
</p>

<p>
To model the pool, the followings hypotheses are made:
<ul>
<li> <Strong>Hypothesis 1:</Strong> The fluid coming from the inlet vector is only liquid water </li>
<li> <Strong>Hypothesis 2:</Strong> The solidification of the water is not treated </li>
<li> <Strong>Hypothesis 3:</Strong> The specific heat capacity at constant pressure and at constant volume are the same for the liquid water </li>			

</ul>		
</p>

<p>		
The basic constitutive equations for the pool is : </br>
m = medium.d * V </br>
der(m) = m_flow_boiling + Water_Input_internal[1] </br>
m * LiquidWater.cp * der(T) - m_flow_boiling*LiquidWater.LHea = Heatport.Q_flow + Water_Input_internal[1] * LiquidWater.cp * (Water_Input_internal[2] - T ) </br>

The match with the saturation condition are made with the following condition : </br>
if /*noEvent*/(T > Tsat) and /*noEvent*/(m_flow_boiling &#8804 0) then </br>
der(T) = der(Tsat) </br>
else </br>
m_flow_boiling = 0 </br>
end if </br>		
</p>
</body>		
</html>"),
    Icon(graphics = {Rectangle(origin = {-96, 55}, fillPattern = FillPattern.Solid, extent = {{-4, 33}, {4, -35}}), Rectangle(origin = {96, 55}, fillPattern = FillPattern.Solid, extent = {{-4, 33}, {4, -35}}), Text(origin = {-51, 42}, extent = {{-25, 6}, {25, -6}}, textString = "Connect to gas node",  fontSize = 0 ), Line(origin = {5, 51}, points = {{-33, -5}, {-19, 5}}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Text(origin = {57, 42}, extent = {{-23, 6}, {25, -6}}, textString = "Connect to others",  fontSize = 0 ), Line(origin = {75, 51}, points = {{-25, -5}, {-19, 5}}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Ellipse(origin = {13, 25}, fillColor = {0, 85, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-5, 5}, {3, -3}}, endAngle = 360), Rectangle(origin = {-30, -22}, lineColor = {0, 85, 255}, fillColor = {0, 85, 255}, fillPattern = FillPattern.Solid, extent = {{-70, 42}, {130, -78}}), Ellipse(origin = {-75, 5}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-3, 3}, {3, -3}}, endAngle = 360), Ellipse(origin = {-75, -13}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-3, 3}, {3, -3}}, endAngle = 360), Ellipse(origin = {-75, -31}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-3, 3}, {3, -3}}, endAngle = 360), Ellipse(origin = {-47, -31}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-3, 3}, {3, -3}}, endAngle = 360), Ellipse(origin = {-47, -13}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-3, 3}, {3, -3}}, endAngle = 360), Ellipse(origin = {-47, 5}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-3, 3}, {3, -3}}, endAngle = 360), Ellipse(origin = {-47, -49}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-3, 3}, {3, -3}}, endAngle = 360), Ellipse(origin = {-75, -49}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-3, 3}, {3, -3}}, endAngle = 360), Ellipse(origin = {-47, -67}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-3, 3}, {3, -3}}, endAngle = 360), Ellipse(origin = {-75, -67}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-3, 3}, {3, -3}}, endAngle = 360), Ellipse(origin = {-47, -85}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-3, 3}, {3, -3}}, endAngle = 360), Ellipse(origin = {-19, -49}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-3, 3}, {3, -3}}, endAngle = 360), Ellipse(origin = {-19, -67}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-3, 3}, {3, -3}}, endAngle = 360), Ellipse(origin = {-75, -85}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-3, 3}, {3, -3}}, endAngle = 360), Ellipse(origin = {-19, -31}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-3, 3}, {3, -3}}, endAngle = 360), Ellipse(origin = {-19, -13}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-3, 3}, {3, -3}}, endAngle = 360), Ellipse(origin = {-19, 5}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-3, 3}, {3, -3}}, endAngle = 360), Ellipse(origin = {-19, -85}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-3, 3}, {3, -3}}, endAngle = 360), Polygon(origin = {9.09, 29.85}, fillColor = {0, 85, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-1.09366, -1.85355}, {6.90634, -1.85355}, {2.90634, 6.14645}, {-1.09366, -1.85355}}), Polygon(origin = {41.09, 29.85}, fillColor = {0, 85, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-1.09366, -1.85355}, {6.90634, -1.85355}, {2.90634, 6.14645}, {-1.09366, -1.85355}}), Ellipse(origin = {45, 25}, fillColor = {0, 85, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-5, 5}, {3, -3}}, endAngle = 360), Ellipse(origin = {75, 25}, fillColor = {0, 85, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-5, 5}, {3, -3}}, endAngle = 360), Polygon(origin = {71.09, 29.85}, fillColor = {0, 85, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-1.09366, -1.85355}, {6.90634, -1.85355}, {2.90634, 6.14645}, {-1.09366, -1.85355}})}, coordinateSystem(initialScale = 0.1)),
    experiment(StartTime = 0, StopTime = 7200, Tolerance = 1e-06, Interval = 7.2));
end LiquidNode;
