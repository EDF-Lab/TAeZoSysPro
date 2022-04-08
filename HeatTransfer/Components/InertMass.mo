within TAeZoSysPro.HeatTransfer.Components;

model InertMass
  /*                                                                               */
  //Customs parameters are declared
  parameter Boolean SteadyState = true "Steady state initialization";
  parameter Modelica.SIunits.Temperature Tstart = 273.15 "initial temperature";
  parameter Modelica.SIunits.Area Acv = 0 "Convection area";
  parameter Modelica.SIunits.Area Arad = 0 "Radiative area";
  parameter Modelica.SIunits.Height caractLength = 0 "Caracteristic length";
  parameter Modelica.SIunits.Height perimeter = 0 "perimeter";
  parameter Modelica.SIunits.SpecificHeatCapacity Cp = 0 "Specific heat capacity";
  parameter Modelica.SIunits.Mass Mass = 0 "Mass of component";
  parameter Modelica.SIunits.Emissivity Emissivity = 1 "emissivity";
  parameter Real add_on_conv(unit = "R+") = 1 "Custom add-on for convection";
  parameter Real add_on_rad(unit = "R+") = 1 "Custom add-on for radiation";
  parameter TAeZoSysPro.HeatTransfer.Types.FreeConvectionCorrelation correlation_free = TAeZoSysPro.HeatTransfer.Types.FreeConvectionCorrelation.ChurchillAndChu_vertical_plate "Free convection Correlation";
  parameter TAeZoSysPro.HeatTransfer.Types.ForcedConvectionCorrelation correlation_forced = TAeZoSysPro.HeatTransfer.Types.ForcedConvectionCorrelation.ASHRAE_internal_cylinder "Forced convection Correlation";
  parameter Modelica.SIunits.CoefficientOfHeatTransfer h = 0 "Constant heat transfer coefficient (optional)";
  parameter Modelica.SIunits.Velocity Vel = 0 "characteristic velocity ";
  /*                                                                             */
  // Variables
  Modelica.SIunits.Energy Energy;
  // Energy
  //Cabinet power nodes
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b Air_Heatport "To air thermal mass" annotation(
    Placement(visible = true, transformation(origin = {48, 56}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {76, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b Jmrt_Heatport "To J MRT" annotation(
    Placement(visible = true, transformation(origin = {48, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-98, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput Fview_outer annotation(
    Placement(visible = true, transformation(origin = {41, -44}, extent = {{-20, -20}, {20, 20}}, rotation = 180), iconTransformation(origin = {-99, 79}, extent = {{-11, -11}, {11, 11}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput y annotation(
    Placement(visible = true, transformation(origin = {38, -86}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-102, 34}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  // Cabinet power elements
  TAeZoSysPro.HeatTransfer.BasesClasses.Convection convection1(A = Acv, FreeConvection = true, Vel = Vel, add_on = add_on_conv, carac_length = caractLength, correlation_forced = correlation_forced, correlation_free = correlation_free, h = h, perimeter = perimeter) annotation(
    Placement(visible = true, transformation(origin = {-6, 58}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
  TAeZoSysPro.HeatTransfer.BasesClasses.CarrollRadiation carrollRadiation1(A = Arad, add_on = add_on_rad, emissivity = Emissivity) annotation(
    Placement(visible = true, transformation(origin = {-4, 0}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
  TAeZoSysPro.HeatTransfer.BasesClasses.HeatCapacitor C_Inert_Mass(Cp = Cp, Mass = Mass, SteadyState = SteadyState, Tstart = Tstart) annotation(
    Placement(visible = true, transformation(origin = {-70, 28}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

initial equation
  Energy = 0.0;
  
equation
  connect(carrollRadiation1.port_a, C_Inert_Mass.port) annotation(
    Line(points = {{-20, 0}, {-38, 0}, {-38, 28}, {-60, 28}, {-60, 28}}, color = {191, 0, 0}));
  connect(convection1.Heatport_a, C_Inert_Mass.port) annotation(
    Line(points = {{-22, 58}, {-38, 58}, {-38, 28}, {-60, 28}, {-60, 28}}, color = {191, 0, 0}));
  connect(carrollRadiation1.Fview, Fview_outer) annotation(
    Line(points = {{-16, -12}, {-42, -12}, {-42, -44}, {42, -44}, {42, -44}}, color = {0, 0, 127}));
  connect(carrollRadiation1.port_b, Jmrt_Heatport) annotation(
    Line(points = {{12, 0}, {48, 0}, {48, 0}, {48, 0}}, color = {191, 0, 0}));
  connect(convection1.Heatport_b, Air_Heatport) annotation(
    Line(points = {{10, 58}, {50, 58}, {50, 56}, {48, 56}}, color = {191, 0, 0}));
// Output y is set to radiative Area
  y = Arad;
  der(Energy) = C_Inert_Mass.port.Q_flow;
// Energy is calculated
  annotation(
    uses(Modelica(version = "3.2.2")),
    Dialog(group = "Component two"),
    Diagram(coordinateSystem(extent = {{-100, -100}, {80, 100}})),
    Icon(graphics = {Text(origin = {-88, -48}, rotation = -90, extent = {{46, -14}, {-46, 14}}, textString = "J MRT"), Rectangle(fillColor = {184, 51, 11}, fillPattern = FillPattern.Cross, lineThickness = 1, extent = {{-20, 20}, {20, -20}}), Line(origin = {0, 52}, points = {{0, -26}, {0, 20}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {0, -50}, rotation = 180, points = {{0, -26}, {0, 18}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {50, 0}, rotation = -90, points = {{0, -26}, {0, 0}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {-50, 0}, rotation = 90, points = {{0, -26}, {0, 2}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {26, 46}, points = {{-2, -22}, {24, 24}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {26, 0}, points = {{-2, -22}, {26, -74}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {-20, 0}, points = {{-2, -22}, {-36, -76}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {-6, 52}, points = {{-18, -28}, {-48, 16}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {-48, 1}, points = {{-2, 93}, {-2, -95}}, color = {0, 85, 255}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {-36, 1}, points = {{0, 93}, {0, -95}}, color = {0, 85, 255}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {-50, 12}, rotation = 90, points = {{0, -26}, {0, 2}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {-50, -12}, rotation = 90, points = {{0, -26}, {0, 2}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {-68, -26}, rotation = 180, points = {{0, -26}, {12, -26}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {-66, 14}, rotation = 180, points = {{0, -26}, {12, -26}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {-66, -66}, rotation = 180, points = {{0, -26}, {12, -26}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Text(origin = {-62, 92}, extent = {{46, -14}, {-46, 14}}, textString = "Fview"), Text(origin = {-82, 36}, extent = {{46, -14}, {-46, 14}}, textString = "A"), Text(origin = {100, -2}, rotation = 90, extent = {{46, -14}, {-46, 14}}, textString = "Air"), Text(origin = {48, -97}, lineThickness = 0.5, extent = {{-36, 11}, {20, -7}}, textString = "KURY - EDVANCE",  fontSize = 0 )}, coordinateSystem(extent = {{-100, -100}, {80, 100}}, initialScale = 0.1)),
    __OpenModelica_commandLineOptions = "");
end InertMass;