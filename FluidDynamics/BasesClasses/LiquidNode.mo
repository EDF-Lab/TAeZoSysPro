within TAeZoSysPro.FluidDynamics.BasesClasses;

model LiquidNode
  // additionnal package
  import Modelica.Fluid.Types;
  import Modelica.Fluid.Types.Dynamics;
  import SI = Modelica.SIunits;
  // Medium declaration
  replaceable package Medium = Modelica.Media.Water.WaterIF97_ph;
  replaceable package MediumGas = Modelica.Media.Air.MoistAir;
  Medium.BaseProperties medium(preferredMediumStates = if energyDynamics == Dynamics.SteadyState and massDynamics == Dynamics.SteadyState then false else true);
  //User defined parameters
  // Assumptions
  parameter Types.Dynamics energyDynamics = Dynamics.FixedInitial "Formulation of energy balance" annotation(
    Dialog(tab = "Assumptions", group = "Dynamics"));
  parameter Types.Dynamics massDynamics = Dynamics.FixedInitial "Formulation of mass balance" annotation(
    Dialog(tab = "Assumptions", group = "Dynamics"));
  final parameter Types.Dynamics substanceDynamics = massDynamics "Formulation of substance balance" annotation(
    Dialog(tab = "Assumptions", group = "Dynamics"));
  final parameter Types.Dynamics traceDynamics = massDynamics "Formulation of trace substance balance" annotation(
    Dialog(tab = "Assumptions", group = "Dynamics"));
  // Fixed start value
  parameter SI.AbsolutePressure p_start = 101325 "Initial absolute static pressure" annotation(
    Dialog(tab = "Initialization"));
  parameter SI.Temperature T_start = 293.15 "Initial temperature" annotation(
    Dialog(tab = "Initialization"));
  parameter Medium.MassFraction X_start[Medium.nX] = Medium.X_default ;
  parameter Modelica.SIunits.NumberDensityOfMolecules n_bubbles = 150 * 1e6 "Number density of bubble in node" ;
  parameter SI.Area A = 0 "Interface surface Area" annotation(
    Dialog(group = "Geometrical properties"));
  parameter SI.Volume V_start = 0 "Initial volume" annotation(
    Dialog(group = "Geometrical properties"));
  //
  parameter Integer nPorts = 1 "Number of fluidport" annotation(
    Dialog(connectorSizing = true));

// Internal variables
  SI.Enthalpy H "Medium enthalpy";
  SI.SpecificEnthalpy h_bubble "Medium specific enthalpy at bubble point ";
  SI.SpecificEnthalpy h_dew "Medium specific enthalpy at dew point ";
  SI.SpecificEnthalpy h "Medium specific enthalpy";  
//
  SI.Mass m "Medium mass";
  SI.Mass mXi[Medium.nXi] "Masses of independent components in the fluid";
  SI.MassFraction Xg "Medium mass fraction of gas";
  SI.Mass[Medium.nC] mC "Masses of trace substances in the fluid";
  SI.Volume V;
  SI.Velocity Vel "Velocity of bubble";
  SI.Diameter d_bubble "Diameter of bubble";
  SI.Density d_sat "Density of bubble";  
// C need to be added here because unlike for Xi, which has medium.Xi,there is no variable medium.C
  Medium.ExtraProperty C[Medium.nC] "Trace substance mixture content";
  //
  SI.MassFlowRate m_flow_bubble "Mass flow of leaving bubble";  
  SI.MassFlowRate mb_flow "Mass flows across boundaries";
  SI.MassFlowRate[Medium.nXi] mbXi_flow "Substance mass flows across boundaries";
  Medium.MassFlowRate ports_mXi_flow[nPorts, Medium.nXi];
  Medium.ExtraPropertyFlowRate[Medium.nC] mbC_flow "Trace substance mass flows across boundaries";
  SI.EnthalpyFlowRate Hb_flow "Enthalpy flow across boundaries or energy source/sink";
  SI.HeatFlowRate Qb_flow "Heat flow across boundaries or energy source/sink";
  //
  // Imported modules
  Modelica.Fluid.Interfaces.FluidPorts_a fluidPort[nPorts](redeclare each package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{-10, -40}, {10, 40}}, rotation = 0), iconTransformation(origin = {50, 90}, extent = {{-10, -40}, {10, 40}}, rotation = -90)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort annotation(
    Placement(visible = true, transformation(origin = {0, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-70, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  TAeZoSysPro.FluidDynamics.Interfaces.FlowPort_b flowPort_b(redeclare package Medium = MediumGas) annotation(
    Placement(visible = true, transformation(origin = {-12, 84}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-24, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

protected
  Real[Medium.nC] mC_scaled(min = fill(Modelica.Constants.eps, Medium.nC)) "Scaled masses of trace substances in the fluid";
  parameter Medium.ExtraProperty C_start[Medium.nC](quantity=Medium.extraPropertiesNames) = Medium.C_default;

initial equation
// initialization of balances
//Energy
  if energyDynamics == Dynamics.FixedInitial then
    medium.T = T_start;
  elseif energyDynamics == Dynamics.SteadyStateInitial then
    der(medium.T) = 0;
  end if;

  m = V_start * medium.d ;
//Substances
  if substanceDynamics == Dynamics.FixedInitial then
    medium.Xi = X_start[1:Medium.nXi];
  elseif substanceDynamics == Dynamics.SteadyStateInitial then
    der(medium.Xi) = zeros(Medium.nXi);
  end if;
//Traces
  if traceDynamics == Dynamics.FixedInitial then
    mC_scaled = m * C_start[1:Medium.nC] ./ Medium.C_nominal;
  elseif traceDynamics == Dynamics.SteadyStateInitial then
    der(mC_scaled) = zeros(Medium.nC);
  end if;
equation
  medium.p = sum(flowPort_b.d ./ MediumGas.MMX) * Modelica.Constants.R * flowPort_b.T;
// Saturation properties
  h_bubble = Medium.bubbleEnthalpy(medium.sat);
  h_dew = Medium.dewEnthalpy(medium.sat);
// Total quantities
  m = V * medium.d;
  mXi = m * medium.Xi;
  H = m * medium.h;
  mC = m * C;
// Boiling
  h = medium.h;
  h_dew * Xg + (1 - Xg) * h_bubble = h;
  d_sat = Medium.dewDensity(medium.sat) ;
//
  Modelica.Constants.pi * d_bubble ^ 3 / 6 = max(Xg, 0.0) * medium.d / d_sat / n_bubbles;
// quasi static flow: viscous friction force( Stocke's law) + bouyancy force = 0
  Vel = Modelica.Constants.g_n * d_bubble ^ 2 / (18 * Medium.dynamicViscosity(Medium.setDewState(medium.sat)));
  m_flow_bubble = Vel * A * (n_bubbles * Modelica.Constants.pi / 6 * d_bubble ^ 3) * d_sat;
  flowPort_b.H_flow = -m_flow_bubble * h_dew ; 
  flowPort_b.m_flow[1] = -m_flow_bubble ;
  flowPort_b.m_flow[2] = 0.0 ;
  
// Boundary flow quantities
  for i in 1:nPorts loop
    ports_mXi_flow[i, :] = fluidPort[i].m_flow * actualStream(fluidPort[i].Xi_outflow);
  end for;
  
  for j in 1:Medium.nXi loop
    mbXi_flow[j] = sum(ports_mXi_flow[:, j]);
  end for;
  
  mb_flow = sum(fluidPort.m_flow) - m_flow_bubble  ;
  Qb_flow = heatPort.Q_flow;
  Hb_flow = sum(fluidPort.m_flow .* actualStream(fluidPort.h_outflow)) - m_flow_bubble * h_dew ;
// Balance equations
// Energy
  if energyDynamics == Dynamics.SteadyState then
    0 = Hb_flow + Qb_flow;
  else
    der(H) = Hb_flow + Qb_flow;
  end if;
// Mass
  if massDynamics == Dynamics.SteadyState then
    0 = mb_flow;
  else
    der(m) = mb_flow;
  end if;
// Independant masses
  if substanceDynamics == Dynamics.SteadyState then
    zeros(Medium.nXi) = mbXi_flow;
  else
    der(mXi) = mbXi_flow;
  end if;
// Trace masses
  if traceDynamics == Dynamics.SteadyState then
    zeros(Medium.nC) = mbC_flow;
  else
    der(mC_scaled) = mbC_flow ./ Medium.C_nominal;
  end if;
  mC = mC_scaled .* Medium.C_nominal;
// port handovers
// fluidPorts
  for i in 1:nPorts loop
    fluidPort[i].p = medium.p;
    fluidPort[i].h_outflow = medium.h;
    fluidPort[i].Xi_outflow = medium.Xi;
  end for;
// heatPort
  heatPort.T = medium.T;
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
    Icon(graphics = {Rectangle(origin = {-96, 55}, fillPattern = FillPattern.Solid, extent = {{-4, 33}, {4, -35}}), Rectangle(origin = {96, 55}, fillPattern = FillPattern.Solid, extent = {{-4, 33}, {4, -35}}), Ellipse(origin = {13, 25}, fillColor = {0, 85, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-5, 5}, {3, -3}}, endAngle = 360), Rectangle(origin = {-30, -22}, lineColor = {0, 85, 255}, fillColor = {0, 85, 255}, fillPattern = FillPattern.Solid, extent = {{-70, 42}, {130, -78}}), Ellipse(origin = {-75, 5}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-3, 3}, {3, -3}}, endAngle = 360), Ellipse(origin = {-75, -13}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-3, 3}, {3, -3}}, endAngle = 360), Ellipse(origin = {-75, -31}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-3, 3}, {3, -3}}, endAngle = 360), Ellipse(origin = {-47, -31}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-3, 3}, {3, -3}}, endAngle = 360), Ellipse(origin = {-47, -13}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-3, 3}, {3, -3}}, endAngle = 360), Ellipse(origin = {-47, 5}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-3, 3}, {3, -3}}, endAngle = 360), Ellipse(origin = {-47, -49}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-3, 3}, {3, -3}}, endAngle = 360), Ellipse(origin = {-75, -49}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-3, 3}, {3, -3}}, endAngle = 360), Ellipse(origin = {-47, -67}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-3, 3}, {3, -3}}, endAngle = 360), Ellipse(origin = {-75, -67}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-3, 3}, {3, -3}}, endAngle = 360), Ellipse(origin = {-47, -85}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-3, 3}, {3, -3}}, endAngle = 360), Ellipse(origin = {-19, -49}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-3, 3}, {3, -3}}, endAngle = 360), Ellipse(origin = {-19, -67}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-3, 3}, {3, -3}}, endAngle = 360), Ellipse(origin = {-75, -85}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-3, 3}, {3, -3}}, endAngle = 360), Ellipse(origin = {-19, -31}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-3, 3}, {3, -3}}, endAngle = 360), Ellipse(origin = {-19, -13}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-3, 3}, {3, -3}}, endAngle = 360), Ellipse(origin = {-19, 5}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-3, 3}, {3, -3}}, endAngle = 360), Ellipse(origin = {-19, -85}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-3, 3}, {3, -3}}, endAngle = 360), Polygon(origin = {9.09, 29.85}, fillColor = {0, 85, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-1.09366, -1.85355}, {6.90634, -1.85355}, {2.90634, 6.14645}, {-1.09366, -1.85355}}), Polygon(origin = {41.09, 29.85}, fillColor = {0, 85, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-1.09366, -1.85355}, {6.90634, -1.85355}, {2.90634, 6.14645}, {-1.09366, -1.85355}}), Ellipse(origin = {45, 25}, fillColor = {0, 85, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-5, 5}, {3, -3}}, endAngle = 360), Ellipse(origin = {75, 25}, fillColor = {0, 85, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-5, 5}, {3, -3}}, endAngle = 360), Polygon(origin = {71.09, 29.85}, fillColor = {0, 85, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-1.09366, -1.85355}, {6.90634, -1.85355}, {2.90634, 6.14645}, {-1.09366, -1.85355}})}, coordinateSystem(initialScale = 0.1)));
end LiquidNode;
