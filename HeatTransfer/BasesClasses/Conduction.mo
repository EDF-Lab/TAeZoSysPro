within TAeZoSysPro.HeatTransfer.BasesClasses;
model Conduction
  encapsulated type ConductionType = enumeration(
      Linear
           "linear conduction",
      Radial
           "cylindric conduction") "Enumeration defining the type of conduction";

  //
  extends Modelica.Thermal.HeatTransfer.Interfaces.Element1D;

  // User defined parameters
  parameter Real add_on = 1 "Custom add-on";
  parameter Modelica.SIunits.ThermalConductivity k = 0 "Thermal conductivity" annotation (
  Dialog(group="Thermal properties"));
  parameter ConductionType conduction = ConductionType.Linear annotation (
  Dialog(group="Geometrical properties"));
  parameter Modelica.SIunits.Thickness Th = 0 "Material thickness" annotation (
  Dialog(group="Geometrical properties"));
  parameter Modelica.SIunits.Area A = 0 "Cross section (if linear conduction)" annotation (
  Dialog(group="Geometrical properties"));
  parameter Modelica.SIunits.Length L = 0 "Cylinder length (if cylindric conduction)" annotation (
  Dialog(group="Geometrical properties"));
  parameter Modelica.SIunits.Radius Ri = 0 "Internal radius(if cylindric conduction)" annotation (
  Dialog(group="Geometrical properties"));
  parameter Modelica.SIunits.Conversions.NonSIunits.Angle_deg Angle = 360 "Angle of cylindrical part (if cylindric conduction)" annotation (
  Dialog(group="Geometrical properties"));

  // Internal variables
  Modelica.SIunits.Energy E "Energy passed throught the component";

initial equation
  E = 0.0;

equation

  if conduction == ConductionType.Radial then
    Q_flow = add_on * (Modelica.SIunits.Conversions.from_deg(Angle) * L * k) / log((Ri + Th) / Ri) * dT;

  elseif conduction == ConductionType.Linear then
    Q_flow = add_on * k * (A / Th) * dT;

  end if;

  der(E) = Q_flow;

  annotation (
    Documentation(info = "
<html>
  <head>
    <title>Conduction</title>
    <style type=\"text/css\">
      *       { font-size: 10pt; font-family: Arial,sans-serif; }
      code    { font-size:  9pt; font-family: Courier,monospace;}
      h4      { font-size: 14pt; font-weight: bold; color: rgb(32,32,32); }
    </style>
    <meta http-equiv=\"Content-Type\" content=\"text/html;charset=utf-8\">
  </head>
  
  <body>
    <p>
      This components links the heat flow to a gradient of temperature within a solid material thanks to the Fourier's law.  
    </p>
    
    <p>
      The module allows via the <b>conduction</b> enumeration variable to select beween linear condution model or cylindric. </br>    
      The basic constitutive equation for <b>linear</b> conduction is :
    </p>
    
    <img
      alt=\"equation for linear conduction\" 
      src=\"modelica://TAeZoSysPro/Information/HeatTransfer/BasesClasses/EQ_Conduction_linear.PNG\" 
    />
    
    <p>     
      The basic constitutive equation for <b>cylindric</b> conduction is :
    </p>
            
    <img 
      alt=\"equation for cylindric conduction\"
      src=\"modelica://TAeZoSysPro/Information/HeatTransfer/BasesClasses/EQ_Conduction_cylindric.PNG\" 
        />

    <p>
      Where :
      <ul>
        <li> Q_flow is the thermal flux throughing connector port_a to connector port_b </li>
        <li> dT is the temperature difference (port_a.T - port_b.T) on both side of the length segment equal to the thickness </li>
        <li> add_on is a user paramater to adjust if needed the Heat flow to the temperature difference dT </li>
        <li> A is the cross section (for linear) </li>
        <li> Th is the thickness of material </li>
        <li> k is thermal conductivity </li>
        <li> Ri is the internal radius (for cylindric) </li>
        <li> Angle is the revolution angle of the cylinder (from 0 to 360° for cylindric) </li>
        <li> L is the longitudinal length of the cylinder (for cylindric) </li>   
      </ul>
    </p>        

  </body>
  
</html>"),
    Diagram,
  Icon(graphics={  Line(origin = {20, 61}, points = {{0, 19}}), Line(origin = {13, 75}, points = {{-13, 3}}), Rectangle(origin = {-3, -1}, fillColor = {156, 156, 156},
            fillPattern =                                                                                                                                                             FillPattern.Cross, extent = {{-37, 101}, {43, -99}}), Line(origin = {-9, 78}, points = {{-47, 0}, {71, 0}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {2, 0}, points = {{-58, 0}, {60, 0}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {2, -76}, points = {{-58, 0}, {60, 0}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.None, Arrow.Filled})}, coordinateSystem(initialScale = 0.1)),
  __OpenModelica_commandLineOptions = "");
end Conduction;
