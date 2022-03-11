within TAeZoSysPro.HeatTransfer.Components;

model CabinetPower
  // Media
  replaceable package Medium = TAeZoSysPro.HeatTransfer.Media.MyMedia;
  //Customs parameters are declared
  parameter Modelica.SIunits.Power P1 = 0 "Cabinet heat power";
  parameter Boolean VariableHeatLoad = false "Activation of variable heat loads input";
  parameter Boolean SteadyState = true "Steady state initialization";
  parameter Modelica.SIunits.Temp_K Tempinit = 293.15 "Beginning temperature";
  //Emitter
  //
  parameter Boolean FreeConvection_internal = true "free convection with cabinet inside air";
  parameter Boolean FreeConvection_external = true "free convection with surrounding air";
  parameter TAeZoSysPro.HeatTransfer.Types.FreeConvectionCorrelation correlation_free_internal = TAeZoSysPro.HeatTransfer.Types.FreeConvectionCorrelation.ChurchillAndChu_vertical_plate "Free internal convection Correlation";
  parameter TAeZoSysPro.HeatTransfer.Types.ForcedConvectionCorrelation correlation_forced_internal = TAeZoSysPro.HeatTransfer.Types.ForcedConvectionCorrelation.ASHRAE_flat_plate "Forced internal convection Correlation";
  parameter TAeZoSysPro.HeatTransfer.Types.FreeConvectionCorrelation correlation_free_external = TAeZoSysPro.HeatTransfer.Types.FreeConvectionCorrelation.ChurchillAndChu_vertical_plate "Free external convection Correlation";
  parameter TAeZoSysPro.HeatTransfer.Types.ForcedConvectionCorrelation correlation_forced_external = TAeZoSysPro.HeatTransfer.Types.ForcedConvectionCorrelation.ASHRAE_flat_plate "Forced external convection Correlation";
  parameter Modelica.SIunits.Velocity Vel_internal = 0 "velocity for internal forced convection (optionnal)";
  parameter Modelica.SIunits.Velocity Vel_external = 0 "velocity for external forced convection (optionnal)";
  //
  parameter Modelica.SIunits.Area A1 = 0 "Convection area emitter" annotation(
    Dialog(group = "Emitter"));
  parameter Modelica.SIunits.Area A5 = 0 "Radiative area emitter" annotation(
    Dialog(group = "Emitter"));
  parameter Modelica.SIunits.Height L1 = 0 "Caracteristic length emitter" annotation(
    Dialog(group = "Emitter"));
  parameter Modelica.SIunits.SpecificHeatCapacity Cp1 = 0 "Specific heat capacity of emitter" annotation(
    Dialog(group = "Emitter"));
  parameter Modelica.SIunits.Mass Mass1 = 0 "Mass of emitter" annotation(
    Dialog(group = "Emitter"));
  parameter Real E1(unit = "R+*") = 1 "emitter emissivity" annotation(
    Dialog(group = "Emitter"));
  // assembly
  parameter Modelica.SIunits.Area A3 = 0 "Internal area assembly " annotation(
    Dialog(group = "Assembly"));
  parameter Modelica.SIunits.Area A2 = 0 "Convection outer area assembly " annotation(
    Dialog(group = "Assembly"));
  parameter Modelica.SIunits.Area A4 = 0 "Radiative outer area assembly" annotation(
    Dialog(group = "Assembly"));
  parameter Modelica.SIunits.Height L2 = 0 "Caracteristic length assembly" annotation(
    Dialog(group = "Assembly"));
  parameter Modelica.SIunits.SpecificHeatCapacity Cp2 = 0 "Specific heat capacity of assembly" annotation(
    Dialog(group = "Assembly"));
  parameter Modelica.SIunits.Mass Mass2 = 0 "Mass of assembly" annotation(
    Dialog(group = "Assembly"));
  parameter Real E2(unit = "R+*") = 1 "Assembly internal emissivity" annotation(
    Dialog(group = "Assembly"));
  parameter Real E3(unit = "R+*") = 1 "Assembly outer emissivity" annotation(
    Dialog(group = "Assembly"));
  parameter Real add_on(unit = "R+") = 1 "Custom add-on";
  // Internal Variable
  Modelica.SIunits.Energy Energy;
  // Imported components
  Modelica.Blocks.Interfaces.RealInput Heatload_Variable if VariableHeatLoad annotation(
    Placement(visible = true, transformation(origin = {-117, 16}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {42, -100}, extent = {{-18, -18}, {18, 18}}, rotation = 90)));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow1 annotation(
    Placement(visible = true, transformation(origin = {-71, 16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  //
  Modelica.Thermal.HeatTransfer.Components.BodyRadiation bodyRadiation2(Gr = A5 * (1 / E1 + A5 / A3 * (1 / E2 - 1)) ^ (-1)) annotation(
    Placement(visible = true, transformation(origin = {-2, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  TAeZoSysPro.HeatTransfer.BasesClasses.CarrollRadiation carrollRadiation1(A = A4, add_on = 1, emissivity = E3) annotation(
    Placement(visible = true, transformation(origin = {62, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  //
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port_conv "To air thermal mass" annotation(
    Placement(visible = true, transformation(origin = {100, 28}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port_rad "To J MRT" annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-98, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port_hood annotation(
    Placement(visible = true, transformation(origin = {46, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {99, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  //
  Modelica.Blocks.Interfaces.RealInput Fview_outer annotation(
    Placement(visible = true, transformation(origin = {105, -34}, extent = {{-20, -20}, {20, 20}}, rotation = 180), iconTransformation(origin = {-99, 79}, extent = {{-11, -11}, {11, 11}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput y annotation(
    Placement(visible = true, transformation(origin = {106, -64}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-102, 34}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  // Cabinet power elements
  TAeZoSysPro.HeatTransfer.BasesClasses.HeatCapacitor C_Heat_Source(Cp = Cp1, Mass = Mass1, SteadyState = SteadyState, Tstart = Tempinit) annotation(
    Placement(visible = true, transformation(origin = {-51, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  TAeZoSysPro.HeatTransfer.BasesClasses.HeatCapacitor C_Casing(Cp = Cp2, Mass = Mass2, SteadyState = SteadyState, Tstart = Tempinit) annotation(
    Placement(visible = true, transformation(origin = {31, -28}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  //
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor Inlet_Air_Temperature annotation(
    Placement(visible = true, transformation(origin = {57.5, 51.5}, extent = {{-5.5, -5.5}, {5.5, 5.5}}, rotation = 180)));
  TAeZoSysPro.HeatTransfer.BasesClasses.ConvectionHood ConvectionHood_Heat_Source(replaceable package Medium = Medium, A = A1, FreeConvection = FreeConvection_internal, Vel = Vel_internal, add_on = add_on, carac_length = L1, correlation_forced = correlation_forced_internal, correlation_free = correlation_free_internal) annotation(
    Placement(visible = true, transformation(origin = {-59, 64}, extent = {{-10, 10}, {10, -10}}, rotation = 90)));
  TAeZoSysPro.HeatTransfer.BasesClasses.ConvectionHood Convectionhood_Casing_Internal(replaceable package Medium = Medium, A = A3, FreeConvection = FreeConvection_internal, Vel = Vel_internal, add_on = add_on, carac_length = L2, correlation_forced = correlation_forced_internal, correlation_free = correlation_free_internal) annotation(
    Placement(visible = true, transformation(origin = {26, 64}, extent = {{-10, 10}, {10, -10}}, rotation = 90)));
  TAeZoSysPro.HeatTransfer.BasesClasses.Convection Convection_Casing_Outer(replaceable package Medium = Medium, A = A2, FreeConvection = FreeConvection_external, Vel = Vel_external, add_on = add_on, carac_length = L2, correlation_forced = correlation_forced_external, correlation_free = correlation_free_external) annotation(
    Placement(visible = true, transformation(origin = {57, 28}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

initial equation
  Energy = 0.0;

equation
  connect(bodyRadiation2.port_a, C_Heat_Source.port) annotation(
    Line(points = {{-12, 0}, {-50, 0}, {-50, -20}, {-51, -20}}, color = {191, 0, 0}, thickness = 1));
  connect(prescribedHeatFlow1.port, C_Heat_Source.port) annotation(
    Line(points = {{-61, 16}, {-60, 16}, {-60, 0}, {-50, 0}, {-50, -20}, {-51, -20}}, color = {191, 0, 0}, thickness = 1));
  connect(Inlet_Air_Temperature.port, port_conv) annotation(
    Line(points = {{63, 52}, {81, 52}, {81, 28}, {100, 28}, {100, 28}}, color = {191, 0, 0}, thickness = 1));
  connect(carrollRadiation1.port_b, port_rad) annotation(
    Line(points = {{72, 0}, {99, 0}, {99, 0}, {100, 0}}, color = {191, 0, 0}, thickness = 1));
  connect(Convection_Casing_Outer.Heatport_b, port_conv) annotation(
    Line(points = {{67, 28}, {101, 28}, {101, 28}, {100, 28}}, color = {191, 0, 0}, thickness = 1));
  connect(Convectionhood_Casing_Internal.Heatport_b, port_hood) annotation(
    Line(points = {{26, 74}, {26, 74}, {26, 86}, {46, 86}, {46, 90}}, color = {191, 0, 0}, thickness = 1));
  connect(ConvectionHood_Heat_Source.Heatport_b, port_hood) annotation(
    Line(points = {{-59, 74}, {-59, 74}, {-59, 86}, {46, 86}, {46, 90}}, color = {191, 0, 0}, thickness = 1));
  connect(Convection_Casing_Outer.Heatport_a, C_Casing.port) annotation(
    Line(points = {{47, 28}, {31, 28}, {31, -18}, {31, -18}}, color = {191, 0, 0}, thickness = 1));
  connect(Inlet_Air_Temperature.T, ConvectionHood_Heat_Source.TairInlet) annotation(
    Line(points = {{52, 52}, {-37, 52}, {-37, 66}, {-51, 66}, {-51, 66}}, color = {0, 0, 127}));
  connect(Inlet_Air_Temperature.T, Convectionhood_Casing_Internal.TairInlet) annotation(
    Line(points = {{52, 52}, {44, 52}, {44, 66}, {34, 66}, {34, 66}}, color = {0, 0, 127}));
  connect(Convectionhood_Casing_Internal.Heatport_a, C_Casing.port) annotation(
    Line(points = {{26, 54}, {26, 54}, {26, 34}, {31, 34}, {31, -18}, {31, -18}}, color = {191, 0, 0}, thickness = 1));
  connect(ConvectionHood_Heat_Source.Heatport_a, C_Heat_Source.port) annotation(
    Line(points = {{-59, 54}, {-59, 54}, {-59, 34}, {-50, 34}, {-50, -20}, {-51, -20}}, color = {191, 0, 0}, thickness = 1));
  connect(carrollRadiation1.port_a, bodyRadiation2.port_b) annotation(
    Line(points = {{52, 0}, {8, 0}, {8, 0}, {8, 0}}, color = {191, 0, 0}, thickness = 1));
  if not VariableHeatLoad then
    prescribedHeatFlow1.Q_flow = P1;
  else
    prescribedHeatFlow1.Q_flow = Heatload_Variable;
  end if;
// Cabinet power connections
  connect(Fview_outer, carrollRadiation1.Fview) annotation(
    Line(points = {{105, -34}, {54, -34}, {54, -8}, {54, -8}}, color = {0, 0, 127}, thickness = 1));
  connect(C_Casing.port, bodyRadiation2.port_b) annotation(
    Line(points = {{31, -18}, {31, -18}, {31, 0}, {8, 0}, {8, 0}}, color = {191, 0, 0}, thickness = 1));
// Output y is set to A2 : Outer area component two
  y = A4;
  der(Energy) = port_hood.Q_flow + port_conv.Q_flow + port_rad.Q_flow;
// Energy is calculated
  annotation(
    uses(Modelica(version = "3.2.2")),
    Dialog(group = "Component two"),
    Diagram(coordinateSystem(grid = {1, 2}, initialScale = 0.1), graphics = {Rectangle(origin = {-56.5, -3}, fillColor = {222, 222, 222}, fillPattern = FillPattern.Solid, lineThickness = 1, extent = {{-39.5, 93}, {39.5, -93}}), Rectangle(origin = {50.5, -3}, fillColor = {222, 222, 222}, fillPattern = FillPattern.Solid, lineThickness = 1, extent = {{-39.5, 93}, {39.5, -93}}), Text(origin = {-56, -81}, lineThickness = 1, extent = {{-35, -11}, {35, 11}}, textString = "Emitter",  fontSize = 0 ), Text(origin = {54.5, -80}, lineThickness = 1, extent = {{-42.5, -8}, {36.5, 6}}, textString = "Assembly",  fontSize = 0 ), Text(origin = {73.5, 80}, lineThickness = 1, extent = {{-42.5, -8}, {13.5, 2}}, textString = "Hood node")}),
    Icon(graphics = {Text(origin = {-28, -110}, extent = {{46, -14}, {-46, 14}}, textString = "Heat Load"), Rectangle(lineThickness = 2, extent = {{-60, 80}, {60, -80}}), Text(origin = {-88, -48}, rotation = -90, extent = {{46, -14}, {-46, 14}}, textString = "J MRT"), Rectangle(fillColor = {184, 51, 11}, fillPattern = FillPattern.Cross, lineThickness = 1, extent = {{-20, 20}, {20, -20}}), Line(origin = {0, 52}, points = {{0, -26}, {0, 20}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {0, -50}, rotation = 180, points = {{0, -26}, {0, 18}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {50, 0}, rotation = -90, points = {{0, -26}, {0, 0}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {-50, 0}, rotation = 90, points = {{0, -26}, {0, 2}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {26, 46}, points = {{-2, -22}, {24, 24}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {26, 0}, points = {{-2, -22}, {26, -74}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {-20, 0}, points = {{-2, -22}, {-36, -76}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {-6, 52}, points = {{-18, -28}, {-48, 16}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {-48, 1}, points = {{-2, 93}, {-2, -95}}, color = {0, 85, 255}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {-36, 1}, points = {{0, 93}, {0, -95}}, color = {0, 85, 255}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {-50, 12}, rotation = 90, points = {{0, -26}, {0, 2}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {-50, -12}, rotation = 90, points = {{0, -26}, {0, 2}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {92, 0}, rotation = -90, points = {{0, -26}, {0, 2}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {86, 13}, points = {{0, 67}, {0, -95}}, color = {0, 85, 255}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {74, 13}, points = {{0, 67}, {0, -95}}, color = {0, 85, 255}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {92, 20}, rotation = -90, points = {{0, -26}, {0, 2}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {92, -20}, rotation = -90, points = {{0, -26}, {0, 2}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {-68, -26}, rotation = 180, points = {{0, -26}, {12, -26}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {-66, 14}, rotation = 180, points = {{0, -26}, {12, -26}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {-66, -66}, rotation = 180, points = {{0, -26}, {12, -26}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Text(origin = {-62, 92}, extent = {{46, -14}, {-46, 14}}, textString = "Fview"), Text(origin = {-82, 36}, extent = {{46, -14}, {-46, 14}}, textString = "A"), Text(origin = {108, 66}, rotation = 90, extent = {{46, -14}, {-46, 14}}, textString = "Hood"), Rectangle(origin = {4, 3}, extent = {{-104, -103}, {96, 97}}), Text(origin = {110, -32}, rotation = 90, extent = {{46, -14}, {-46, 14}}, textString = "Air"), Text(origin = {60, 93}, lineThickness = 0.5, extent = {{-22, 7}, {20, -5}}, textString = "KURY - EDVANCE",  fontSize = 0 )}, coordinateSystem(initialScale = 0.1)));
end CabinetPower;
