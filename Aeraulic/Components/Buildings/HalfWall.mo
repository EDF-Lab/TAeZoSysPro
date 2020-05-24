within TAeZoSysPro.Aeraulic.Components.Buildings;

model HalfWall
  //Media
  replaceable package Medium = TAeZoSysPro.Aeraulic.Media.MyMedia;
  replaceable package Mediumda = TAeZoSysPro.HeatTransfer.Media.MyMedia "dry air medium for convection";
  //customs parameters are defined by user
  parameter Integer N(unit = "Z+*") = 5 "Number of layers : 1 to 65535";
  parameter Modelica.SIunits.Area Awall = 0 "Wall area ";
  parameter Modelica.SIunits.Height Carac_length = 0 "Wall height";
  parameter Modelica.SIunits.Length L = 0 "Wall thickness";
  parameter Modelica.SIunits.SpecificHeatCapacity Cpwall = 0 "Wall specific heat capacity";
  parameter Modelica.SIunits.Density RhoW = 0 "Wall density";
  parameter Modelica.SIunits.ThermalConductivity Kwall = 0 "Wall conductivity";
  parameter Boolean SteadyState = true "Steady state initialization";
  parameter Modelica.SIunits.Temperature Tstart = 273.15 "Beginning temperature, if not steady state";
  parameter Real Bi = 0.005 "Biot Number of first wall layers";
  parameter Modelica.SIunits.CoefficientOfHeatTransfer href = 10 "decoupled h coefficient used for Bi number calculation";
  //
  parameter Boolean FreeConvection = true annotation(
    Dialog(group = "properties for convection"));
  parameter TAeZoSysPro.HeatTransfer.Types.FreeConvectionCorrelation correlation_free = TAeZoSysPro.HeatTransfer.Types.FreeConvectionCorrelation.ChurchillAndChu_vertical_plate "Free convection Correlation" annotation(
    Dialog(group = "properties for convection"));
  parameter TAeZoSysPro.HeatTransfer.Types.ForcedConvectionCorrelation correlation_forced = TAeZoSysPro.HeatTransfer.Types.ForcedConvectionCorrelation.ASHRAE_flat_plate "Forced convection Correlation" annotation(
    Dialog(group = "properties for convection"));
  parameter Modelica.SIunits.Length Pwall = 0 "Perimeter is used for ground and ceiling (optional)" annotation(
    Dialog(group = "properties for convection"));
  parameter Modelica.SIunits.CoefficientOfHeatTransfer hcv = 0 "Constant heat transfer coefficient (optional)" annotation(
    Dialog(group = "properties for convection"));
  parameter Modelica.SIunits.Velocity Vel = 0 "characteristic velocity " annotation(
    Dialog(group = "properties for convection"));
  parameter Real Add_on_conv(unit = "R+") = 1 "Custom add-on for convection" annotation(
    Dialog(group = "properties for convection"));
  parameter Real Add_on_cond(unit = "R+") = 1 "Custom add-on for condensation" annotation(
    Dialog(group = "properties for condensation"));
  //
  parameter Modelica.SIunits.Emissivity Emissivity = 1 "Wall emissivity " annotation(
    Dialog(group = "properties for radiation"));
  parameter Real Add_on_rad(unit = "R+") = 1 "Custom add-on" annotation(
    Dialog(group = "properties for radiation"));
  //
  parameter Modelica.SIunits.Thickness L_Bi = Bi * Kwall / href "First layer thickness";
  // Imported Components
  Interfaces.FlowPort_a flowPort_a(replaceable package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-94, -64}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-78, 74}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  //
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_rad annotation(
    Placement(visible = true, transformation(origin = {-96, 74}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-78, -62}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port_b annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {78, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  //
  Modelica.Blocks.Interfaces.RealInput FviewI annotation(
    Placement(visible = true, transformation(origin = {-90, 46}, extent = {{-12, -12}, {12, 12}}, rotation = 0), iconTransformation(origin = {-79, 3}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput AwallI annotation(
    Placement(visible = true, transformation(origin = {-89, 17}, extent = {{11, -11}, {-11, 11}}, rotation = 0), iconTransformation(origin = {-78, -28}, extent = {{8, -8}, {-8, 8}}, rotation = 0)));
  //
  //
  BasesClasses.dropwiseCondensation latentExchange1(A_wall = Awall, Add_on = Add_on_cond, Fixed_hcv = false, LatentExchangeType = Types.LatentExchangeType.Condensation, hcv = convection1.hcv) annotation(
    Placement(visible = true, transformation(origin = {-2, -70}, extent = {{-14, -14}, {14, 14}}, rotation = 0)));
  HeatTransfer.BasesClasses.Convection convection1(replaceable package Medium = Mediumda, A = Awall, FreeConvection = FreeConvection, Vel = Vel, add_on = Add_on_conv, carac_length = Carac_length, correlation_forced = correlation_forced, correlation_free = correlation_free, h = hcv, perimeter = Pwall) annotation(
    Placement(visible = true, transformation(origin = {-2, -16}, extent = {{12, -12}, {-12, 12}}, rotation = 0)));
  HeatTransfer.BasesClasses.CarrollRadiation carrollRadiation1(A = Awall, add_on = Add_on_rad, emissivity = Emissivity) annotation(
    Placement(visible = true, transformation(origin = {0, 74}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  HeatTransfer.BasesClasses.HeatCapacitor heatCapacitor1(Cp = Cpwall, Mass = if L / N <= L_Bi then RhoW * Awall * L / N else RhoW * Awall * L_Bi, SteadyState = SteadyState, Tstart = Tstart) annotation(
    Placement(visible = true, transformation(origin = {-2, 36}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  HeatTransfer.BasesClasses.PartialWall partialWall1(Area = Awall, CpW = Cpwall, RhoW = RhoW, SteadyState = SteadyState, Tinit = Tstart, add_on = 1, conduction = HeatTransfer.Types.ConductionType.Linear, k = Kwall, l = if L / N <= L_Bi then L - L / N else L - L_Bi, n = N) annotation(
    Placement(visible = true, transformation(origin = {56, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput CondensatedWaterData annotation(
    Placement(visible = true, transformation(origin = {-82, -90}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {-76, -88}, extent = {{8, -8}, {-8, 8}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_conv annotation(
    Placement(visible = true, transformation(origin = {-88, -18}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-78, 36}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
equation
  connect(FviewI, carrollRadiation1.Fview) annotation(
    Line(points = {{-90, 46}, {-40, 46}, {-40, 60}, {10, 60}, {10, 66}, {8, 66}}, color = {0, 0, 127}));
  connect(carrollRadiation1.port_b, port_rad) annotation(
    Line(points = {{-10, 74}, {-98, 74}, {-98, 74}, {-96, 74}}, color = {191, 0, 0}));
  connect(carrollRadiation1.port_a, partialWall1.port_a) annotation(
    Line(points = {{10, 74}, {32, 74}, {32, 0}, {46, 0}, {46, 0}}, color = {191, 0, 0}));
  connect(flowPort_a, latentExchange1.Flowport) annotation(
    Line(points = {{-94, -64}, {-12, -64}, {-12, -70}, {-14, -70}}, color = {255, 0, 0}));
  connect(port_conv, convection1.Heatport_b) annotation(
    Line(points = {{-88, -18}, {-14, -18}, {-14, -16}, {-14, -16}}, color = {191, 0, 0}));
// ports balance
// output
  AwallI = Awall;
  connect(latentExchange1.liquid_water_flow, CondensatedWaterData) annotation(
    Line(points = {{2, -82}, {2, -82}, {2, -90}, {-82, -90}, {-82, -90}}, color = {0, 0, 127}));
  connect(partialWall1.port_b, port_b) annotation(
    Line(points = {{66, 0}, {98, 0}, {98, 0}, {100, 0}}, color = {191, 0, 0}));
  connect(latentExchange1.Heatport, partialWall1.port_a) annotation(
    Line(points = {{10, -70}, {32, -70}, {32, 0}, {46, 0}, {46, 0}}, color = {191, 0, 0}));
  connect(heatCapacitor1.port, partialWall1.port_a) annotation(
    Line(points = {{-2, 26}, {-2, 26}, {-2, 14}, {32, 14}, {32, 0}, {46, 0}, {46, 0}}, color = {191, 0, 0}));
  connect(convection1.Heatport_a, partialWall1.port_a) annotation(
    Line(points = {{10, -16}, {32, -16}, {32, 0}, {46, 0}, {46, 0}}, color = {191, 0, 0}));
  annotation(
    Diagram(graphics = {Rectangle(origin = {48, 0}, fillColor = {218, 218, 218}, fillPattern = FillPattern.Solid, extent = {{-30, 100}, {30, -100}})}, coordinateSystem(initialScale = 0.1)),
    Icon(graphics = {Rectangle(origin = {-1, 0}, fillColor = {132, 132, 132}, fillPattern = FillPattern.Cross, extent = {{-29, 92}, {29, -92}}), Line(origin = {-44, -52}, points = {{10, 6}, {-10, -6}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {-44, -60}, points = {{8, -18}, {-10, -6}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {-48, 40}, points = {{0, 8}, {0, -18}}, color = {0, 0, 255}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {-36, 40}, points = {{0, 8}, {0, -18}}, color = {0, 0, 255}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {-43, 44}, points = {{11, 0}, {-11, 0}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {-43, 30}, points = {{11, 0}, {-11, 0}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Ellipse(origin = {-39, 79}, fillColor = {0, 85, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-5, 5}, {3, -3}}, endAngle = 360), Polygon(origin = {-38, 85.72}, fillColor = {0, 85, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-6, -3.72361}, {2, -3.72361}, {-2, 4.27639}, {-6, -3.72361}}), Text(origin = {-40, -63}, extent = {{-4, 7}, {4, -7}}, textString = "I",  fontSize = 0 ), Polygon(origin = {-41, -97}, fillColor = {0, 85, 255}, fillPattern = FillPattern.Solid, points = {{11, 3}, {7, -3}, {-7, -3}, {-11, 3}, {11, 3}}), Line(origin = {-58.79, -89.21}, points = {{10.7929, -2.79289}, {4.79289, 1.20711}, {-7.20711, 1.20711}}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Polygon(origin = {-38, 69.72}, fillColor = {0, 85, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-6, -3.72361}, {2, -3.72361}, {-2, 4.27639}, {-6, -3.72361}}), Ellipse(origin = {-39, 63}, fillColor = {0, 85, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-5, 5}, {3, -3}}, endAngle = 360), Text(origin = {-49, 3}, extent = {{-9, 7}, {9, -7}}, textString = "Fview",  fontSize = 0 ), Text(origin = {-49, -27}, extent = {{-9, 7}, {9, -7}}, textString = "Awall",  fontSize = 0 ), Ellipse(origin = {-39, -91}, fillColor = {0, 85, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-5, 5}, {3, -3}}, endAngle = 360), Polygon(origin = {-38, -84.28}, fillColor = {0, 85, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-6, -3.72361}, {2, -3.72361}, {-2, 4.27639}, {-6, -3.72361}})}, coordinateSystem(initialScale = 0.1)));
end HalfWall;
