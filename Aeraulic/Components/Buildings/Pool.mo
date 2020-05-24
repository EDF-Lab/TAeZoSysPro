within TAeZoSysPro.Aeraulic.Components.Buildings;

model Pool
  package Medium = Media.MyMedia;
  parameter Boolean SteadyState = false "Steady state initialization";
  parameter Modelica.SIunits.Temperature Tstart = 293.15 "Medium initial temperature ";
  parameter Modelica.SIunits.Volume Vstart = 1 "Initial volume of Medium in the node";
  parameter Modelica.SIunits.Area S = 1 "liquid node gas interface surface";
  parameter Modelica.SIunits.Emissivity LiquidEmissivity = 1 "Emissivity of the liquid of the interface";
  parameter Boolean FreeConvection = true;
  parameter Modelica.SIunits.Velocity Vel = 0 "air flow velocity at surface";
  // optional use of external values
  parameter Real n_drop = 1e-2 "number of droplet per cm3";
  parameter Real C_drag = 0.47 "Drag coefficient of a sphere at 10^4 < RE < 5*10^5";
  TAeZoSysPro.Aeraulic.BasesClasses.LiquidNode liquidNode1(C_drag = C_drag, S = S, SteadyState = SteadyState, Tstart = Tstart, Vstart = Vstart, n_drop = n_drop) annotation(
    Placement(visible = true, transformation(origin = {-1, -45}, extent = {{-27, -27}, {27, 27}}, rotation = 0)));
  TAeZoSysPro.Aeraulic.BasesClasses.Liq_Gas_Interface liq_Gas_Interface1(A_wall = S, FreeConvection = FreeConvection, LiquidEmissivity = LiquidEmissivity, Vel = Vel) annotation(
    Placement(visible = true, transformation(origin = {-1, 31}, extent = {{-23, -23}, {23, 23}}, rotation = -90)));
  TAeZoSysPro.Aeraulic.Interfaces.FlowPort_b flowPort_Gas(replaceable package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-78, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-74, 78}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  TAeZoSysPro.Aeraulic.Interfaces.FlowPort_a flowPort_Liq(replaceable package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {74, -54}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b heatport_conv annotation(
    Placement(visible = true, transformation(origin = {-38, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-32, 78}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b heatport_rad annotation(
    Placement(visible = true, transformation(origin = {6, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {8, 78}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput Fview annotation(
    Placement(visible = true, transformation(origin = {41, 85}, extent = {{-11, -11}, {11, 11}}, rotation = -90), iconTransformation(origin = {46, 78}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealOutput Awall annotation(
    Placement(visible = true, transformation(origin = {81, 85}, extent = {{-11, -11}, {11, 11}}, rotation = 90), iconTransformation(origin = {80, 78}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatport_pool annotation(
    Placement(visible = true, transformation(origin = {-76, -52}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-102, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(heatport_pool, liquidNode1.Heatport) annotation(
    Line(points = {{-76, -52}, {-46, -52}, {-46, -16}, {-20, -16}, {-20, -26}, {-20, -26}}, color = {191, 0, 0}));
  connect(flowPort_Liq, liquidNode1.flowPort_b) annotation(
    Line(points = {{74, -54}, {48, -54}, {48, 0}, {18, 0}, {18, -26}, {18, -26}}, color = {255, 0, 0}));
  connect(Fview, liq_Gas_Interface1.Fview) annotation(
    Line(points = {{42, 86}, {42, 86}, {42, 8}, {12, 8}, {12, 8}}, color = {0, 0, 127}));
  connect(liq_Gas_Interface1.Awall, Awall) annotation(
    Line(points = {{16, 54}, {80, 54}, {80, 86}, {82, 86}}, color = {0, 0, 127}));
  connect(liq_Gas_Interface1.Heatport_rad, heatport_rad) annotation(
    Line(points = {{6, 54}, {6, 54}, {6, 80}, {6, 80}}, color = {191, 0, 0}));
  connect(liq_Gas_Interface1.Heatport_conv, heatport_conv) annotation(
    Line(points = {{-8, 54}, {-8, 54}, {-8, 66}, {-38, 66}, {-38, 80}, {-38, 80}}, color = {191, 0, 0}));
  connect(liquidNode1.flowPort, flowPort_Gas) annotation(
    Line(points = {{-2, -26}, {0, -26}, {0, -10}, {-78, -10}, {-78, 80}, {-78, 80}}, color = {255, 0, 0}));
  connect(flowPort_Gas, liq_Gas_Interface1.flowPort_b) annotation(
    Line(points = {{-78, 80}, {-78, 80}, {-78, 54}, {-18, 54}, {-18, 54}}, color = {255, 0, 0}));
  connect(liquidNode1.flowPort_b, liq_Gas_Interface1.flowPort_a) annotation(
    Line(points = {{18, -26}, {18, -26}, {18, 0}, {-12, 0}, {-12, 8}, {-12, 8}}, color = {255, 0, 0}));
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
    Icon(graphics = {Rectangle(origin = {-96, 55}, fillPattern = FillPattern.Solid, extent = {{-4, 33}, {4, -39}}), Rectangle(origin = {96, 55}, fillPattern = FillPattern.Solid, extent = {{-4, 33}, {4, -39}}), Ellipse(origin = {15, 21}, fillColor = {0, 85, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-5, 5}, {3, -3}}, endAngle = 360), Rectangle(origin = {-30, -22}, lineColor = {0, 85, 255}, fillColor = {0, 85, 255}, fillPattern = FillPattern.Solid, extent = {{-70, 38}, {130, -78}}), Ellipse(origin = {-75, 5}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-3, 3}, {3, -3}}, endAngle = 360), Ellipse(origin = {-75, -13}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-3, 3}, {3, -3}}, endAngle = 360), Ellipse(origin = {-75, -31}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-3, 3}, {3, -3}}, endAngle = 360), Ellipse(origin = {-47, -31}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-3, 3}, {3, -3}}, endAngle = 360), Ellipse(origin = {-47, -13}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-3, 3}, {3, -3}}, endAngle = 360), Ellipse(origin = {-47, 5}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-3, 3}, {3, -3}}, endAngle = 360), Ellipse(origin = {-47, -49}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-3, 3}, {3, -3}}, endAngle = 360), Ellipse(origin = {-75, -49}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-3, 3}, {3, -3}}, endAngle = 360), Ellipse(origin = {-47, -67}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-3, 3}, {3, -3}}, endAngle = 360), Ellipse(origin = {-75, -67}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-3, 3}, {3, -3}}, endAngle = 360), Ellipse(origin = {-47, -85}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-3, 3}, {3, -3}}, endAngle = 360), Ellipse(origin = {-19, -49}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-3, 3}, {3, -3}}, endAngle = 360), Ellipse(origin = {-19, -67}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-3, 3}, {3, -3}}, endAngle = 360), Ellipse(origin = {-75, -85}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-3, 3}, {3, -3}}, endAngle = 360), Ellipse(origin = {-19, -31}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-3, 3}, {3, -3}}, endAngle = 360), Ellipse(origin = {-19, -13}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-3, 3}, {3, -3}}, endAngle = 360), Ellipse(origin = {-19, 5}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-3, 3}, {3, -3}}, endAngle = 360), Ellipse(origin = {-19, -85}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-3, 3}, {3, -3}}, endAngle = 360), Polygon(origin = {11.09, 25.85}, fillColor = {0, 85, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-1.09366, -1.85355}, {6.90634, -1.85355}, {2.90634, 6.14645}, {-1.09366, -1.85355}}), Polygon(origin = {43.09, 25.85}, fillColor = {0, 85, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-1.09366, -1.85355}, {6.90634, -1.85355}, {2.90634, 6.14645}, {-1.09366, -1.85355}}), Ellipse(origin = {47, 21}, fillColor = {0, 85, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-5, 5}, {3, -3}}, endAngle = 360), Ellipse(origin = {77, 21}, fillColor = {0, 85, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-5, 5}, {3, -3}}, endAngle = 360), Polygon(origin = {73.09, 25.85}, fillColor = {0, 85, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-1.09366, -1.85355}, {6.90634, -1.85355}, {2.90634, 6.14645}, {-1.09366, -1.85355}}), Ellipse(origin = {9, 5}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-3, 3}, {3, -3}}, endAngle = 360), Ellipse(origin = {9, -13}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-3, 3}, {3, -3}}, endAngle = 360), Ellipse(origin = {9, -31}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-3, 3}, {3, -3}}, endAngle = 360), Ellipse(origin = {37, 5}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-3, 3}, {3, -3}}, endAngle = 360), Ellipse(origin = {37, -13}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-3, 3}, {3, -3}}, endAngle = 360), Ellipse(origin = {37, -31}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-3, 3}, {3, -3}}, endAngle = 360), Ellipse(origin = {9, -49}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-3, 3}, {3, -3}}, endAngle = 360), Ellipse(origin = {37, -49}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-3, 3}, {3, -3}}, endAngle = 360), Ellipse(origin = {9, -67}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-3, 3}, {3, -3}}, endAngle = 360), Ellipse(origin = {37, -67}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-3, 3}, {3, -3}}, endAngle = 360), Ellipse(origin = {65, 5}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-3, 3}, {3, -3}}, endAngle = 360), Ellipse(origin = {65, -13}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-3, 3}, {3, -3}}, endAngle = 360), Ellipse(origin = {65, -31}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-3, 3}, {3, -3}}, endAngle = 360), Ellipse(origin = {65, -49}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-3, 3}, {3, -3}}, endAngle = 360), Ellipse(origin = {65, -67}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-3, 3}, {3, -3}}, endAngle = 360), Ellipse(origin = {65, -85}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-3, 3}, {3, -3}}, endAngle = 360), Ellipse(origin = {9, -85}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-3, 3}, {3, -3}}, endAngle = 360), Ellipse(origin = {37, -85}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-3, 3}, {3, -3}}, endAngle = 360), Polygon(origin = {-80.91, 25.85}, fillColor = {0, 85, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-1.09366, -1.85355}, {6.90634, -1.85355}, {2.90634, 6.14645}, {-1.09366, -1.85355}}), Ellipse(origin = {-77, 21}, fillColor = {0, 85, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-5, 5}, {3, -3}}, endAngle = 360), Ellipse(origin = {-45, 21}, fillColor = {0, 85, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-5, 5}, {3, -3}}, endAngle = 360), Polygon(origin = {-48.91, 25.85}, fillColor = {0, 85, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-1.09366, -1.85355}, {6.90634, -1.85355}, {2.90634, 6.14645}, {-1.09366, -1.85355}}), Polygon(origin = {-18.91, 25.85}, fillColor = {0, 85, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-1.09366, -1.85355}, {6.90634, -1.85355}, {2.90634, 6.14645}, {-1.09366, -1.85355}}), Ellipse(origin = {-15, 21}, fillColor = {0, 85, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-5, 5}, {3, -3}}, endAngle = 360), Line(origin = {-64, 37}, points = {{0, -19}, {0, -15}, {2, -13}, {4, -9}, {4, -7}, {2, -3}, {0, -1}, {-2, 1}, {-4, 5}, {-4, 7}, {-2, 11}, {0, 13}}, color = {0, 85, 255}, thickness = 0.5), Line(origin = {-64, 53}, points = {{0, -3}, {0, 3}}, color = {0, 85, 255}, thickness = 0.5, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {-32, 37}, points = {{0, -19}, {0, -15}, {2, -13}, {4, -9}, {4, -7}, {2, -3}, {0, -1}, {-2, 1}, {-4, 5}, {-4, 7}, {-2, 11}, {0, 13}}, color = {0, 85, 255}, thickness = 0.5), Line(origin = {-32, 53}, points = {{0, -3}, {0, 3}}, color = {0, 85, 255}, thickness = 0.5, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {32, 37}, points = {{0, -19}, {0, -15}, {2, -13}, {4, -9}, {4, -7}, {2, -3}, {0, -1}, {-2, 1}, {-4, 5}, {-4, 7}, {-2, 11}, {0, 13}}, color = {0, 85, 255}, thickness = 0.5), Line(origin = {32, 53}, points = {{0, -3}, {0, 3}}, color = {0, 85, 255}, thickness = 0.5, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {0, 37}, points = {{0, -19}, {0, -15}, {2, -13}, {4, -9}, {4, -7}, {2, -3}, {0, -1}, {-2, 1}, {-4, 5}, {-4, 7}, {-2, 11}, {0, 13}}, color = {0, 85, 255}, thickness = 0.5), Line(origin = {0, 53}, points = {{0, -3}, {0, 3}}, color = {0, 85, 255}, thickness = 0.5, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {62, 37}, points = {{0, -19}, {0, -15}, {2, -13}, {4, -9}, {4, -7}, {2, -3}, {0, -1}, {-2, 1}, {-4, 5}, {-4, 7}, {-2, 11}, {0, 13}}, color = {0, 85, 255}, thickness = 0.5), Line(origin = {62, 53}, points = {{0, -3}, {0, 3}}, color = {0, 85, 255}, thickness = 0.5, arrow = {Arrow.None, Arrow.Filled}), Text(origin = {-33, 63}, extent = {{-9, 3}, {9, -3}}, textString = "Conv",  fontSize = 0 ), Text(origin = {9, 63}, extent = {{-9, 3}, {9, -3}}, textString = "Rad",  fontSize = 0 ), Text(origin = {45, 63}, extent = {{-9, 3}, {9, -3}}, textString = "Fview",  fontSize = 0 ), Text(origin = {81, 63}, extent = {{-9, 3}, {9, -3}}, textString = "Awall",  fontSize = 0 )}, coordinateSystem(initialScale = 0.1)),
    experiment(StartTime = 0, StopTime = 7200, Tolerance = 1e-06, Interval = 7.2));
end Pool;
