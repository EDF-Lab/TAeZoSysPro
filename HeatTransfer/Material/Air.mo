within TAeZoSysPro.HeatTransfer.Material;

model Air
  // Medium is declared
  replaceable package Medium = Modelica.Media.Air.ReferenceAir.Air_pT;
  Medium.BaseProperties medium(p = p);
  // Parameters are defined by user
  parameter Modelica.SIunits.Pressure p = Medium.reference_p "Constant pressure";
  parameter Modelica.SIunits.Volume V = 1 "Air node volume [m3]";
  parameter Boolean SteadyState = true "Steady state initialization";
  parameter Modelica.SIunits.Temperature Tstart = 273.15 "Start value for temperature, if not steady state";
  Modelica.SIunits.Energy E;
  Modelica.SIunits.Mass m;
  Modelica.SIunits.Temperature T;
  Real cp;
  //Port component is defined here
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, -4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
initial equation
// Initialization of the model
  if SteadyState then
    der(medium.T) = 0;
// If user has choosen steady state then temperature derivative is equal to 0
  else
    medium.T = Tstart;
// if user has not choosen steady state then temperature is set to initial temperature
  end if;
equation
//
  T = medium.T;
  cp = medium.h / (T - 273.15);
// Mass balance
  m = medium.d * V;
// Energy balance
  der(m*medium.h) = port_a.Q_flow;
  der(E) = port_a.Q_flow;
// Heat flow through port_a is calcualted
// Port handover
  port_a.T = T;
  annotation(
    Icon(graphics = {Ellipse(lineColor = {85, 85, 255}, fillColor = {85, 170, 255}, fillPattern = FillPattern.Solid, extent = {{100, 100}, {-100, -100}}, endAngle = 360), Text(origin = {24, -43}, extent = {{28, 17}, {-74, -51}}, textString = "V=%V m3", fontName = "MS Shell Dlg 2")}, coordinateSystem(initialScale = 0.1)),
    uses(Modelica(version = "3.2.2")),
    Diagram(coordinateSystem(grid = {1, 2})),
    experiment(StartTime = 0, StopTime = 864000, Tolerance = 1e-06, Interval = 865.731));
end Air;
