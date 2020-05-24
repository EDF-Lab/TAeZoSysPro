within TAeZoSysPro.HeatTransfer.BasesClasses;

model HeatCapacitor "KI_SFL Lumped thermal element storing heat"
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port annotation(
    Placement(visible = true, transformation(origin = {0, -98}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, -98}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  // User defined parameters :
  parameter Modelica.SIunits.SpecificHeatCapacity Cp = 0 "Specific heat capacity of element";
  parameter Modelica.SIunits.Mass Mass = 0 "Mass of element";
  parameter Boolean SteadyState = true "Steady state initialization";
  parameter Modelica.SIunits.Temperature Tstart = 273.15 "Start value for temperature, if not steady state";
  /*                                                            */
  // Variables
  Modelica.SIunits.HeatCapacity C "Heat capacity of element (= cp*m)";
  Modelica.SIunits.Temperature T "Temperature of element";
  Modelica.SIunits.Energy E "Energy storage";
  /*                                                             */
  //Initial equation
initial equation
  E = 0;
// Energy at time 0 second is equal to 0J
  if SteadyState then
    der(T) = 0;
// If user has choosen steady state then temperature derivative is equal to 0
  else
    T = Tstart;
// if user has not choosen steady state then temperature is set to initial temperature
  end if;
/*                                                            */
equation
  T = port.T;
  C = Cp * Mass;
  C * der(T) = port.Q_flow;
// Classical heat capacitance equation
  der(E) = port.Q_flow;
// Energy
  annotation(
    Icon(coordinateSystem(initialScale = 0.1), graphics = {Text(origin = {0, -2},lineColor = {0, 0, 255}, extent = {{-150, 110}, {150, 70}}, textString = "%name"), Polygon(lineColor = {160, 160, 164}, fillColor = {192, 192, 192}, fillPattern = FillPattern.Solid, points = {{0, 67}, {-20, 63}, {-40, 57}, {-52, 43}, {-58, 35}, {-68, 25}, {-72, 13}, {-76, -1}, {-78, -15}, {-76, -31}, {-76, -43}, {-76, -53}, {-70, -65}, {-64, -73}, {-48, -77}, {-30, -83}, {-18, -83}, {-2, -85}, {8, -89}, {22, -89}, {32, -87}, {42, -81}, {54, -75}, {56, -73}, {66, -61}, {68, -53}, {70, -51}, {72, -35}, {76, -21}, {78, -13}, {78, 3}, {74, 15}, {66, 25}, {54, 33}, {44, 41}, {36, 57}, {26, 65}, {0, 67}}), Polygon(fillColor = {160, 160, 164}, fillPattern = FillPattern.Solid, points = {{-58, 35}, {-68, 25}, {-72, 13}, {-76, -1}, {-78, -15}, {-76, -31}, {-76, -43}, {-76, -53}, {-70, -65}, {-64, -73}, {-48, -77}, {-30, -83}, {-18, -83}, {-2, -85}, {8, -89}, {22, -89}, {32, -87}, {42, -81}, {54, -75}, {42, -77}, {40, -77}, {30, -79}, {20, -81}, {18, -81}, {10, -81}, {2, -77}, {-12, -73}, {-22, -73}, {-30, -71}, {-40, -65}, {-50, -55}, {-56, -43}, {-58, -35}, {-58, -25}, {-60, -13}, {-60, -5}, {-60, 7}, {-58, 17}, {-56, 19}, {-52, 27}, {-48, 35}, {-44, 45}, {-40, 57}, {-58, 35}}), Text(extent = {{-69, 7}, {71, -24}}, textString = "%C"), Text(origin = {84, -95}, lineThickness = 0.5, extent = {{-66, 7}, {16, -7}}, textString = "KURY - EDVANCE",  fontSize = 0 )}),
    Diagram(coordinateSystem(preserveAspectRatio = true, extent = {{-100, -100}, {100, 100}}), graphics = {Polygon(points = {{0, 67}, {-20, 63}, {-40, 57}, {-52, 43}, {-58, 35}, {-68, 25}, {-72, 13}, {-76, -1}, {-78, -15}, {-76, -31}, {-76, -43}, {-76, -53}, {-70, -65}, {-64, -73}, {-48, -77}, {-30, -83}, {-18, -83}, {-2, -85}, {8, -89}, {22, -89}, {32, -87}, {42, -81}, {54, -75}, {56, -73}, {66, -61}, {68, -53}, {70, -51}, {72, -35}, {76, -21}, {78, -13}, {78, 3}, {74, 15}, {66, 25}, {54, 33}, {44, 41}, {36, 57}, {26, 65}, {0, 67}}, lineColor = {160, 160, 164}, fillColor = {192, 192, 192}, fillPattern = FillPattern.Solid), Polygon(points = {{-58, 35}, {-68, 25}, {-72, 13}, {-76, -1}, {-78, -15}, {-76, -31}, {-76, -43}, {-76, -53}, {-70, -65}, {-64, -73}, {-48, -77}, {-30, -83}, {-18, -83}, {-2, -85}, {8, -89}, {22, -89}, {32, -87}, {42, -81}, {54, -75}, {42, -77}, {40, -77}, {30, -79}, {20, -81}, {18, -81}, {10, -81}, {2, -77}, {-12, -73}, {-22, -73}, {-30, -71}, {-40, -65}, {-50, -55}, {-56, -43}, {-58, -35}, {-58, -25}, {-60, -13}, {-60, -5}, {-60, 7}, {-58, 17}, {-56, 19}, {-52, 27}, {-48, 35}, {-44, 45}, {-40, 57}, {-58, 35}}, lineColor = {0, 0, 0}, fillColor = {160, 160, 164}, fillPattern = FillPattern.Solid), Ellipse(extent = {{-6, -1}, {6, -12}}, lineColor = {255, 0, 0}, fillColor = {191, 0, 0}, fillPattern = FillPattern.Solid), Text(extent = {{11, 13}, {50, -25}}, lineColor = {0, 0, 0}, textString = "T"), Line(points = {{0, -12}, {0, -96}}, color = {255, 0, 0})}),
    Documentation(info = "<html></html>"));
end HeatCapacitor;
