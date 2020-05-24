within TAeZoSysPro.HeatTransfer.BasesClasses;

model Conduction
  extends Modelica.Thermal.HeatTransfer.Interfaces.Element1D;
  parameter TAeZoSysPro.HeatTransfer.Types.ConductionType conduction = TAeZoSysPro.HeatTransfer.Types.ConductionType.Linear;
  parameter Modelica.SIunits.ThermalConductivity k = 0 "Thermal conductivity";
  parameter Modelica.SIunits.Thickness l = 0 "Material thickness";
  parameter Modelica.SIunits.Area A = 0 "Cross section (if linear conduction)";
  parameter Modelica.SIunits.Length L = 0 "Cylinder length (if cylindric conduction)";
  parameter Modelica.SIunits.Radius Ri = 0 "Internal radius(if cylindric conduction)";
  parameter Modelica.SIunits.Conversions.NonSIunits.Angle_deg Angle = 360 "Angle of cylindrical part (if cylindric conduction)";
  parameter Real add_on(unit = "R+") = 1 "Custom add-on";
equation
//Heat flow throught ports are calculated
  if conduction == TAeZoSysPro.HeatTransfer.Types.ConductionType.Radial then
    Q_flow = add_on * (Modelica.SIunits.Conversions.from_deg(Angle) * L * k) / log((Ri + l) / Ri) * dT;
  elseif conduction == TAeZoSysPro.HeatTransfer.Types.ConductionType.Linear then
    Q_flow = add_on * k * (A / l) * dT;
//Heat flow throught ports are calculated
  end if;
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
This is a model of Cylindric heat conduction governed by the Fourier's law.	The basic constitutive equation for convection is : </br>
Q_flow = add_on*Angle*L*dT*k /Ln(Re / Ri) ; </br>
Q_flow: Heat flow rate from connector 'solid' (e.g., a pipe wall) to another one 
</p>

<p>
Where :
<ul>
<li> add_on is a user paramater to adjust if needed the Thermal flux </li>
<li> Angle is the revolution angle (from 0 to 360°) </li>
<li> Q_flow is the thermal flux throughing from one connector to the other </li>
<li> L is the longitudinal length </li>
<li> dT is the temperature difference the 2 ports (boundaries) </li>
<li> k is thermal conductivity </li>			
<li> Re and Ri are respectivelly the external and internal radius </li>
</ul>
</p>	

<p>
The followings hypotheses are made:
<ul>
<li> <Strong>Hypothesis 1:</Strong> The thermal conductivity is isotropic </li>
<li> <Strong>Hypothesis 2:</Strong> The Cylindric part is homogeneous </li>
<li> <Strong>Hypothesis 3:</Strong> The cylinder is supposed sufficently long to consider that the heat flux has only one radial component</li>
</ul>		
</p>

</body>
</html>"),
    Diagram,
    Icon(coordinateSystem(initialScale = 0.1), graphics = {Text(origin = {69, -92}, extent = {{-28, 5}, {28, -5}}, textString = "KURY - EDVANCE"), Line(origin = {20, 61}, points = {{0, 19}}), Line(origin = {13, 75}, points = {{-13, 3}}), Rectangle(origin = {-3, -1}, fillColor = {156, 156, 156}, fillPattern = FillPattern.Cross, extent = {{-35, 95}, {41, -95}}), Line(origin = {-9, 78}, points = {{-47, 0}, {71, 0}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {2, 0}, points = {{-58, 0}, {60, 0}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {2, -76}, points = {{-58, 0}, {60, 0}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.None, Arrow.Filled})}));
end Conduction;
