within TAeZoSysPro.Aeraulic.Components.Buildings;

model InertMass
  // Medias
  replaceable package Medium = Media.MyMedia;
  replaceable package Mediumda = HeatTransfer.Media.MyMedia "dry air medium for convection";
  // Customs parameters are declared
  parameter Boolean FreeConvection = true;
  parameter Boolean SteadyState = true "Steady state initialization";
  parameter Modelica.SIunits.Temperature Tstart = 293.15 "Beginning temperature";
  parameter Modelica.SIunits.Area Acv = 0 "Convection area";
  parameter Modelica.SIunits.Area Arad = 0 "Radiative area";
  parameter Modelica.SIunits.Height L1 = 0 "Caracteristic length";
  parameter HeatTransfer.Types.FreeConvectionCorrelation correlation_free = HeatTransfer.Types.FreeConvectionCorrelation.ChurchillAndChu_vertical_plate "Free convection Correlation";
  parameter HeatTransfer.Types.ForcedConvectionCorrelation correlation_forced = HeatTransfer.Types.ForcedConvectionCorrelation.ASHRAE_internal_cylinder "Forced convection Correlation";
  parameter Modelica.SIunits.Velocity Vel = 0 "characteristic velocity ";
  parameter Modelica.SIunits.SpecificHeatCapacity Cp1 = 0 "Specific heat capacity";
  parameter Modelica.SIunits.Mass Mass1 = 0 "Mass of component";
  parameter Real E1(unit = "R+*") = 0 "emissivity";
  parameter Modelica.SIunits.CoefficientOfHeatTransfer hcv = 0 "Constant heat transfer coefficient (optional)";
  parameter Modelica.SIunits.Length Pmass = 0 "Perimeter is used for ground and ceiling (optional)";
  parameter Real Add_on_conv(unit = "R+") = 1 "Custom add-on for convection";
  parameter Real Add_on_cond(unit = "R+") = 1 "Custom add-on for condensation";
  //
  // Variables
  Modelica.SIunits.Energy Energy;
  // Energy
  //Cabinet power nodes
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port_conv "To air thermal mass" annotation(
    Placement(visible = true, transformation(origin = {30, 24}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port_rad "To J MRT" annotation(
    Placement(visible = true, transformation(origin = {30, -34}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput Fview annotation(
    Placement(visible = true, transformation(origin = {35, -58}, extent = {{-20, -20}, {20, 20}}, rotation = 180), iconTransformation(origin = {41, 101}, extent = {{11, -11}, {-11, 11}}, rotation = 90)));
  // Cabinet power elements
  BasesClasses.dropwiseCondensation latentExchange1(A_wall = Acv, Add_on = Add_on_cond, Fixed_hcv = false, LatentExchangeType = Types.LatentExchangeType.Condensation, hcv = convection1.hcv) annotation(
    Placement(visible = true, transformation(origin = {-10, 86}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Interfaces.FlowPort_a flowPort_a(replaceable package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {30, 86}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {102, -62}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput CondensatedWaterData annotation(
    Placement(visible = true, transformation(origin = {36, 52}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 270)));
  Modelica.Blocks.Interfaces.RealOutput Awall annotation(
    Placement(visible = true, transformation(origin = {36, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-60, 100}, extent = {{12, -12}, {-12, 12}}, rotation = -90)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a annotation(
    Placement(visible = true, transformation(origin = {-88, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  HeatTransfer.BasesClasses.Convection convection1(replaceable package Medium = Mediumda, A = Acv, FreeConvection = FreeConvection, Vel = Vel, add_on = Add_on_conv, carac_length = L1, correlation_forced = correlation_forced, correlation_free = correlation_free, h = hcv, perimeter = Pmass) annotation(
    Placement(visible = true, transformation(origin = {-8, 24}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  HeatTransfer.BasesClasses.CarrollRadiation carrollRadiation2(A = Arad, emissivity = E1) annotation(
    Placement(visible = true, transformation(origin = {-8, -34}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  HeatTransfer.BasesClasses.HeatCapacitor C_Inert_Mass(Cp = Cp1, Mass = Mass1, SteadyState = SteadyState, Tstart = Tstart) annotation(
    Placement(visible = true, transformation(origin = {-46, -56}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
equation
  connect(Fview, carrollRadiation2.Fview) annotation(
    Line(points = {{36, -58}, {-16, -58}, {-16, -42}, {-16, -42}}, color = {0, 0, 127}));
  connect(carrollRadiation2.port_b, port_rad) annotation(
    Line(points = {{2, -34}, {28, -34}, {28, -34}, {30, -34}}, color = {191, 0, 0}));
  connect(convection1.Heatport_b, port_conv) annotation(
    Line(points = {{2, 24}, {30, 24}, {30, 24}, {30, 24}}, color = {191, 0, 0}));
  connect(latentExchange1.liquid_water_flow, CondensatedWaterData) annotation(
    Line(points = {{-12, 78}, {-12, 78}, {-12, 52}, {36, 52}, {36, 52}}, color = {0, 0, 127}));
  connect(latentExchange1.Flowport, flowPort_a) annotation(
    Line(points = {{-2, 86}, {30, 86}, {30, 86}, {30, 86}}, color = {255, 0, 0}));
  connect(port_a, C_Inert_Mass.port) annotation(
    Line(points = {{-88, -30}, {-46, -30}, {-46, -46}, {-46, -46}}, color = {191, 0, 0}));
  connect(latentExchange1.Heatport, C_Inert_Mass.port) annotation(
    Line(points = {{-18, 86}, {-46, 86}, {-46, -46}, {-46, -46}}, color = {191, 0, 0}));
  connect(convection1.Heatport_a, C_Inert_Mass.port) annotation(
    Line(points = {{-18, 24}, {-46, 24}, {-46, -46}, {-46, -46}}, color = {191, 0, 0}));
  connect(carrollRadiation2.port_a, C_Inert_Mass.port) annotation(
    Line(points = {{-18, -34}, {-46, -34}, {-46, -46}, {-46, -46}}, color = {191, 0, 0}));
// Output y is set to radiative Area
  Awall = Arad;
  der(Energy) = C_Inert_Mass.port.Q_flow;
// Energy is calculated
  annotation(
    uses(Modelica(version = "3.2.2")),
    Dialog(group = "Component two"),
    Diagram,
    Icon(graphics = {Text(origin = {126, 16}, rotation = 180, extent = {{46, -14}, {6, 6}}, textString = "J MRT"), Rectangle(fillColor = {184, 51, 11}, fillPattern = FillPattern.Cross, lineThickness = 1, extent = {{-20, 20}, {20, -20}}), Line(origin = {0, 52}, points = {{0, -26}, {0, 20}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {0, -50}, rotation = 180, points = {{0, -26}, {0, 18}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {50, 0}, rotation = -90, points = {{0, -26}, {0, -4}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {-50, 0}, rotation = 90, points = {{0, -26}, {0, 2}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {26, 46}, points = {{-2, -22}, {24, 24}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {26, 0}, points = {{-2, -22}, {26, -74}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {-20, 0}, points = {{-2, -22}, {-36, -76}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {-6, 52}, points = {{-18, -28}, {-48, 16}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Text(origin = {48, 78}, extent = {{34, -6}, {-46, 14}}, textString = "Fview"), Text(origin = {-54, 76}, extent = {{34, -6}, {-46, 14}}, textString = "A"), Text(origin = {126, 86}, extent = {{-6, -6}, {-46, 14}}, textString = "Air"), Text(origin = {8, -86}, extent = {{34, -6}, {-46, 14}}, textString = "Condensation_data"), Text(origin = {126, -42}, rotation = 180, extent = {{46, -14}, {6, 6}}, textString = "Cond"), Text(origin = {-74, 16}, extent = {{-6, -6}, {-46, 14}}, textString = "Mass")}),
    __OpenModelica_commandLineOptions = "");
end InertMass;
