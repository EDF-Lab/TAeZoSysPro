within TAeZoSysPro.HeatTransfer.BasesClasses;

model PartialWall
  //customs parameters are defined by user
  parameter TAeZoSysPro.HeatTransfer.Types.ConductionType conduction = TAeZoSysPro.HeatTransfer.Types.ConductionType.Linear "Conduction type";
  parameter Integer n = 5 "Number of layers : 1 to 65535";
  parameter Boolean SteadyState = true "Steady state initialization";
  parameter Modelica.SIunits.Temperature Tinit = 273.15 "Beginning temperature, if not steady state";
  parameter Modelica.SIunits.SpecificHeatCapacity CpW = 0 "Wall specific heat capacity";
  parameter Modelica.SIunits.Density RhoW = 0 "Wall density";
  parameter Modelica.SIunits.ThermalConductivity k = 0 "Wall conductivity";
  parameter Modelica.SIunits.Thickness l = 0 "Material thickness";
  parameter Real add_on(unit = "R+") = 1 "Custom add-on";
  parameter Modelica.SIunits.Area Area = 1 "Wall area" annotation(
    Dialog(group = "properties for planar geometry"));
  parameter Modelica.SIunits.Length Le = 1 "Pipe length" annotation(
    Dialog(group = "properties for cylindric geometry"));
  parameter Modelica.SIunits.Radius Ri = 1 "InternalRadius" annotation(
    Dialog(group = "properties for cylindric geometry"));
  parameter Modelica.SIunits.Conversions.NonSIunits.Angle_deg Degree = 360 "Angle of cylindrical part" annotation(
    Dialog(group = "properties for cylindric geometry"));
  // Variables are declared
  Modelica.SIunits.Energy E;
  // Energy
  //Vectors are built with n and 2n from user parameters, n is the number of layers from 1 to inf. Two thermal resitors by layer thus 2n vector's length
  //Vectors thermal capacitor parameters
protected
  parameter Real[:] massvalues = TAeZoSysPro.HeatTransfer.Functions.mass_fill(Conduction = conduction, RhoWall = RhoW, l = l, A = Area, Length = Le, Rin = Ri, Degree = Degree, N = n) "mass for each layer is importer from the mass_fill function";
  parameter Real[:] cpvalues = fill(CpW, n);
  parameter Boolean[:] SteadyStatevalues = fill(SteadyState, n);
  parameter Modelica.SIunits.Temperature[:] Tinitvalues = fill(Tinit, n);
  //Vectors thermal resistor parameters
  parameter Integer n_2 = 2 * n;
  parameter Real[:] kvalues = fill(k, n_2);
  parameter Real[:] lvalues = fill(l / n_2, n_2);
  parameter Real[:] Avalues = fill(Area, n_2);
  parameter Real[:] Levalues = fill(Le, n_2);
  parameter Real[:] Rivalues = TAeZoSysPro.HeatTransfer.Functions.Ri_fill(l = l, Rin = Ri, N = 2 * n);
  // Internal radius for each layer is calculated
  parameter Real[:] Degreevalues = fill(Degree, n_2);
  parameter Real[:] add_onvalues = fill(add_on, n_2);
  parameter TAeZoSysPro.HeatTransfer.Types.ConductionType[:] conductionvalues = fill(conduction, n_2);
  //Thermal capacitor parameters are declared
  public
  TAeZoSysPro.HeatTransfer.BasesClasses.HeatCapacitor[n] c(Cp = cpvalues, Mass = massvalues, SteadyState = SteadyStatevalues, Tstart = Tinitvalues);
  //Thermal resisotr parameters are declared
  TAeZoSysPro.HeatTransfer.BasesClasses.Conduction[n_2] r(conduction = conductionvalues, k = kvalues, l = lvalues, A = Avalues, L = Levalues, Ri = Rivalues, Angle = Degreevalues, add_on = add_onvalues);
public
  //Port variable
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a annotation(
    Placement(visible = true, transformation(origin = {-98, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-98, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port_b annotation(
    Placement(visible = true, transformation(origin = {98, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {98, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
initial equation
// Energy at time 0 second is equal to 0J
  E = 0;
equation
//Equation are declared, only connection are declared because physical equations are inside capacitors and resistors models
  connect(r[1].port_a, port_a);
// The fisrt thermal resistor is connected to the wall port A (in port)
  connect(r[n_2].port_b, port_b);
// The last thermal resistor is connected to the wall port B (out port)
  for i in 1:n loop
    connect(c[i].port, r[2 * i - 1].port_b);
// thermal capacitors are connected to the port B of thermal resistor whilst i equal n
  end for;
  for i in 2:n_2 loop
    connect(r[i - 1].port_b, r[i].port_a);
// Thermal resistors are connected each other whilst i equal 2n
  end for;
// Energy is calculated
  der(E) = port_a.Q_flow;
// pipe comments
  annotation(
    Documentation(info = "<html>
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
<body>

<p>
This is a model that represents a partial cylindrical wall. It is composed of an internal mass surrounded by two conductive resistances. The
wall is decomposed in N layers. The thickness of each layer (the radius difference) is constant. functions compute the mass, the internal
radius and the external radius of each layer. The temperature is determined at the centre of each layer.	
</p>

<p>
The followings hypotheses are made:
<ul>
<li> <Strong>Hypothesis 1:</Strong> No internal Heat power generation </li>
</ul>		
</p>	

</body>
</html>"),uses(Modelica(version = "3.2.2")),
    Icon(graphics = {Line(origin = {-90, 0}, points = {{-10, 0}, {20, 0}}, thickness = 1), Rectangle(origin = {-60, -1}, lineThickness = 1, extent = {{10, -3}, {-10, 5}}), Rectangle(origin = {-20, -1}, lineThickness = 1, extent = {{10, -3}, {-10, 5}}), Rectangle(origin = {20, -1}, lineThickness = 1, extent = {{10, -3}, {-10, 5}}), Rectangle(origin = {60, -1}, lineThickness = 1, extent = {{10, -3}, {-10, 5}}), Line(origin = {80, 0}, points = {{-10, 0}, {20, 0}}, thickness = 1), Line(origin = {-40, -10}, points = {{0, 10}, {0, -10}}, thickness = 1), Line(points = {{-10, 0}, {10, 0}}, thickness = 1), Line(origin = {40, 0}, points = {{-10, 0}, {10, 0}}, thickness = 1), Line(origin = {-40, 0}, points = {{-10, 0}, {10, 0}}, thickness = 1), Line(origin = {-40, -20}, points = {{-10, 0}, {10, 0}}, thickness = 1), Line(origin = {-40, -26}, points = {{-10, 0}, {10, 0}}, thickness = 1), Line(origin = {0, -20}, points = {{-10, 0}, {10, 0}}, thickness = 1), Line(origin = {0, -26}, points = {{-10, 0}, {10, 0}}, thickness = 1), Line(origin = {40, -20}, points = {{-10, 0}, {10, 0}}, thickness = 1), Line(origin = {40, -26}, points = {{-10, 0}, {10, 0}}, thickness = 1), Line(origin = {0, -10}, points = {{0, 10}, {0, -10}}, thickness = 1), Line(origin = {40, -10}, points = {{0, 10}, {0, -10}}, thickness = 1), Line(origin = {-40, -36}, points = {{0, 10}, {0, -4}}, thickness = 1), Line(origin = {0, -36}, points = {{0, 10}, {0, -4}}, thickness = 1), Line(origin = {40, -36}, points = {{0, 10}, {0, -4}}, thickness = 1), Line(origin = {-38, -40}, points = {{-10, 0}, {6, 0}}, thickness = 1), Line(origin = {-34, -44}, points = {{-10, 0}, {-2, 0}}, thickness = 1), Line(origin = {2, -40}, points = {{-10, 0}, {6, 0}}, thickness = 1), Line(origin = {42, -40}, points = {{-10, 0}, {6, 0}}, thickness = 1), Line(origin = {6, -44}, points = {{-10, 0}, {-2, 0}}, thickness = 1), Line(origin = {46, -44}, points = {{-10, 0}, {-2, 0}}, thickness = 1), Rectangle(fillColor = {229, 229, 229}, lineThickness = 1, extent = {{-80, 80}, {80, -80}}), Text(origin = {68, -93}, extent = {{-28, 5}, {28, -5}}, textString = "KURY - EDVANCE")}, coordinateSystem(initialScale = 0.1)));
end PartialWall;
