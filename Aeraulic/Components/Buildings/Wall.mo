within TAeZoSysPro.Aeraulic.Components.Buildings;

model Wall
  //Media
  replaceable package Medium = Media.MyMedia;
  replaceable package Mediumda = HeatTransfer.Media.MyMedia "dry air medium for convection";
  // Parameters are defined by user
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
  parameter HeatTransfer.Types.FreeConvectionCorrelation correlation_free = HeatTransfer.Types.FreeConvectionCorrelation.ChurchillAndChu_vertical_plate "Free convection Correlation for wall I" annotation(
    Dialog(group = "properties for convection"));
  parameter HeatTransfer.Types.ForcedConvectionCorrelation correlation_forced = HeatTransfer.Types.ForcedConvectionCorrelation.ASHRAE_flat_plate "Forced convection Correlation" annotation(
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
  parameter Modelica.SIunits.Emissivity Emissivity = 0 "Wall emissivity " annotation(
    Dialog(group = "properties for radiation"));
  parameter Real Add_on_rad(unit = "R+") = 1 "Custom add-on for radiation" annotation(
    Dialog(group = "properties for radiation"));
  //
  parameter Modelica.SIunits.Thickness L_Bi = Bi * Kwall / href "First layer thickness";
  //
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a_conv annotation(
    Placement(visible = true, transformation(origin = {-90, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-76, 38}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a_rad annotation(
    Placement(visible = true, transformation(origin = {-90, 76}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-76, -60}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port_b_conv annotation(
    Placement(visible = true, transformation(origin = {90, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {74, 38}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port_b_rad annotation(
    Placement(visible = true, transformation(origin = {90, 76}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {74, -62}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Interfaces.FlowPort_a flowPort_a(replaceable package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-90, -56}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-76, 74}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Interfaces.FlowPort_b flowPort_b(replaceable package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {90, -58}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {74, 74}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput FviewI annotation(
    Placement(visible = true, transformation(origin = {-95, 47}, extent = {{-11, -11}, {11, 11}}, rotation = 0), iconTransformation(origin = {-76, 2}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput FviewII annotation(
    Placement(visible = true, transformation(origin = {95, 47}, extent = {{11, -11}, {-11, 11}}, rotation = 0), iconTransformation(origin = {74, 2}, extent = {{8, -8}, {-8, 8}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput AwallI annotation(
    Placement(visible = true, transformation(origin = {-95, 19}, extent = {{11, -11}, {-11, 11}}, rotation = 0), iconTransformation(origin = {-76, -28}, extent = {{8, -8}, {-8, 8}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput AwallII annotation(
    Placement(visible = true, transformation(origin = {95, 21}, extent = {{-11, -11}, {11, 11}}, rotation = 0), iconTransformation(origin = {74, -28}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput CondensatedWaterDataI annotation(
    Placement(visible = true, transformation(origin = {-94, -84}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {-76, -88}, extent = {{8, -8}, {-8, 8}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput CondensatedWaterDataII annotation(
    Placement(visible = true, transformation(origin = {94, -84}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {74, -88}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  HeatTransfer.BasesClasses.Convection convection1(replaceable package Medium = Mediumda, A = Awall, FreeConvection = FreeConvection, add_on = Add_on_conv, carac_length = Carac_length, correlation_forced = correlation_forced, correlation_free = correlation_free, h = hcv, perimeter = Pwall, Vel = Vel) annotation(
    Placement(visible = true, transformation(origin = {-42, -20}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  HeatTransfer.BasesClasses.Convection convection2(replaceable package Medium = Mediumda, A = Awall, FreeConvection = FreeConvection, Vel = Vel, add_on = Add_on_conv, carac_length = Carac_length, correlation_forced = correlation_forced, correlation_free = if correlation_free == HeatTransfer.Types.FreeConvectionCorrelation.Ceiling then HeatTransfer.Types.FreeConvectionCorrelation.Ground elseif correlation_free == HeatTransfer.Types.FreeConvectionCorrelation.Ground then HeatTransfer.Types.FreeConvectionCorrelation.Ceiling else correlation_free, h = hcv, perimeter = Pwall) annotation(
    Placement(visible = true, transformation(origin = {44, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  HeatTransfer.BasesClasses.CarrollRadiation carrollRadiation1(A = Awall, add_on = Add_on_rad, emissivity = Emissivity) annotation(
    Placement(visible = true, transformation(origin = {-42, 76}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  HeatTransfer.BasesClasses.CarrollRadiation carrollRadiation2(A = Awall, add_on = Add_on_rad, emissivity = Emissivity) annotation(
    Placement(visible = true, transformation(origin = {40, 76}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  HeatTransfer.BasesClasses.PartialWall partialWall1(Area = Awall, CpW = Cpwall, RhoW = RhoW, SteadyState = SteadyState, Tinit = Tstart, conduction = HeatTransfer.Types.ConductionType.Linear, k = Kwall, l = if L / N <= L_Bi then L - 2 * L / N else L - 2 * L_Bi, n = N) annotation(
    Placement(visible = true, transformation(origin = {0, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  BasesClasses.dropwiseCondensation latentExchange1(A_wall = Awall, Add_on = Add_on_cond, Fixed_hcv = false, LatentExchangeType = Types.LatentExchangeType.Condensation, hcv = convection1.hcv) annotation(
    Placement(visible = true, transformation(origin = {-44, -56}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  BasesClasses.dropwiseCondensation latentExchange2(A_wall = Awall, Add_on = Add_on_cond, Fixed_hcv = false, LatentExchangeType = Types.LatentExchangeType.Condensation, hcv = convection2.hcv) annotation(
    Placement(visible = true, transformation(origin = {46, -58}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  HeatTransfer.BasesClasses.HeatCapacitor heatCapacitor1(Cp = Cpwall, Mass = if L / N <= L_Bi then RhoW * Awall * L / N else RhoW * Awall * L_Bi, SteadyState = SteadyState, Tstart = Tstart) annotation(
    Placement(visible = true, transformation(origin = {-38, 24}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  HeatTransfer.BasesClasses.HeatCapacitor heatCapacitor2(Cp = Cpwall, Mass = if L / N <= L_Bi then RhoW * Awall * L / N else RhoW * Awall * L_Bi, SteadyState = SteadyState, Tstart = Tstart) annotation(
    Placement(visible = true, transformation(origin = {40, 24}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(latentExchange2.liquid_water_flow, CondensatedWaterDataII) annotation(
    Line(points = {{44, -66}, {44, -66}, {44, -84}, {94, -84}, {94, -84}}, color = {0, 0, 127}));
  connect(latentExchange1.liquid_water_flow, CondensatedWaterDataI) annotation(
    Line(points = {{-42, -64}, {-42, -64}, {-42, -84}, {-94, -84}, {-94, -84}}, color = {0, 0, 127}));
  connect(flowPort_b, latentExchange2.Flowport) annotation(
    Line(points = {{90, -58}, {54, -58}, {54, -58}, {54, -58}}, color = {255, 0, 0}));
  connect(convection2.Heatport_b, port_b_conv) annotation(
    Line(points = {{54, -20}, {90, -20}, {90, -20}, {90, -20}}, color = {191, 0, 0}));
  connect(latentExchange1.Flowport, flowPort_a) annotation(
    Line(points = {{-52, -56}, {-90, -56}, {-90, -56}, {-90, -56}}, color = {255, 0, 0}));
  connect(convection1.Heatport_b, port_a_conv) annotation(
    Line(points = {{-52, -20}, {-90, -20}, {-90, -20}, {-90, -20}}, color = {191, 0, 0}));
  connect(FviewII, carrollRadiation2.Fview) annotation(
    Line(points = {{95, 47}, {32, 47}, {32, 68}}, color = {0, 0, 127}));
  connect(carrollRadiation2.port_b, port_b_rad) annotation(
    Line(points = {{50, 76}, {88, 76}, {88, 76}, {90, 76}}, color = {191, 0, 0}));
  connect(latentExchange2.Heatport, partialWall1.port_b) annotation(
    Line(points = {{38, -58}, {16, -58}, {16, 4}, {10, 4}, {10, 4}}, color = {191, 0, 0}));
  connect(convection2.Heatport_a, partialWall1.port_b) annotation(
    Line(points = {{34, -20}, {16, -20}, {16, 4}, {10, 4}, {10, 4}}, color = {191, 0, 0}));
  connect(heatCapacitor2.port, partialWall1.port_b) annotation(
    Line(points = {{40, 14}, {40, 14}, {40, 4}, {10, 4}, {10, 4}}, color = {191, 0, 0}));
  connect(carrollRadiation2.port_a, partialWall1.port_b) annotation(
    Line(points = {{30, 76}, {16, 76}, {16, 4}, {10, 4}, {10, 4}}, color = {191, 0, 0}));
  connect(latentExchange1.Heatport, partialWall1.port_a) annotation(
    Line(points = {{-36, -56}, {-16, -56}, {-16, 4}, {-10, 4}, {-10, 4}}, color = {191, 0, 0}));
  connect(convection1.Heatport_a, partialWall1.port_a) annotation(
    Line(points = {{-32, -20}, {-16, -20}, {-16, 4}, {-10, 4}, {-10, 4}}, color = {191, 0, 0}));
  connect(heatCapacitor1.port, partialWall1.port_a) annotation(
    Line(points = {{-38, 14}, {-38, 14}, {-38, 4}, {-10, 4}, {-10, 4}}, color = {191, 0, 0}));
  connect(carrollRadiation1.port_a, partialWall1.port_a) annotation(
    Line(points = {{-32, 76}, {-16, 76}, {-16, 4}, {-10, 4}, {-10, 4}}, color = {191, 0, 0}));
  connect(FviewI, carrollRadiation1.Fview) annotation(
    Line(points = {{-94, 48}, {-34, 48}, {-34, 68}, {-34, 68}}, color = {0, 0, 127}));
  connect(port_a_rad, carrollRadiation1.port_b) annotation(
    Line(points = {{-90, 76}, {-52, 76}, {-52, 76}, {-52, 76}}, color = {191, 0, 0}));
  AwallI = Awall;
  AwallII = Awall;
  annotation(
    Diagram(coordinateSystem(initialScale = 0.1), graphics = {Rectangle(origin = {-1, 0}, fillColor = {206, 206, 206}, fillPattern = FillPattern.Solid, extent = {{-21, 100}, {23, -100}})}),
    Icon(graphics = {Rectangle(origin = {-1, 0}, fillColor = {132, 132, 132}, fillPattern = FillPattern.Cross, extent = {{-29, 92}, {29, -92}}), Line(origin = {-44, -52}, points = {{10, 6}, {-10, -6}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {-44, -60}, points = {{8, -18}, {-10, -6}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {-48, 40}, points = {{0, 8}, {0, -18}}, color = {0, 0, 255}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {-36, 40}, points = {{0, 8}, {0, -18}}, color = {0, 0, 255}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {-43, 44}, points = {{11, 0}, {-11, 0}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {-43, 30}, points = {{11, 0}, {-11, 0}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Ellipse(origin = {-39, 79}, fillColor = {0, 85, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-5, 5}, {3, -3}}, endAngle = 360), Polygon(origin = {-38, 85.72}, fillColor = {0, 85, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-6, -3.72361}, {2, -3.72361}, {-2, 4.27639}, {-6, -3.72361}}), Text(origin = {-40, -63}, extent = {{-4, 7}, {4, -7}}, textString = "I",  fontSize = 0 ), Polygon(origin = {-41, -97}, fillColor = {0, 85, 255}, fillPattern = FillPattern.Solid, points = {{11, 3}, {7, -3}, {-7, -3}, {-11, 3}, {11, 3}}), Line(origin = {-58.79, -89.21}, points = {{10.7929, -2.79289}, {4.79289, 1.20711}, {-7.20711, 1.20711}}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Polygon(origin = {-38, 69.72}, fillColor = {0, 85, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-6, -3.72361}, {2, -3.72361}, {-2, 4.27639}, {-6, -3.72361}}), Ellipse(origin = {-39, 63}, fillColor = {0, 85, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-5, 5}, {3, -3}}, endAngle = 360), Text(origin = {-49, 3}, extent = {{-9, 7}, {9, -7}}, textString = "FviewI",  fontSize = 0 ), Text(origin = {-49, -27}, extent = {{-9, 7}, {9, -7}}, textString = "AwallI",  fontSize = 0 ), Ellipse(origin = {-39, -91}, fillColor = {0, 85, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-5, 5}, {3, -3}}, endAngle = 360), Polygon(origin = {-38, -84.28}, fillColor = {0, 85, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-6, -3.72361}, {2, -3.72361}, {-2, 4.27639}, {-6, -3.72361}}), Line(origin = {34, 40}, points = {{0, 8}, {0, -18}}, color = {0, 0, 255}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Ellipse(origin = {39, 63}, fillColor = {0, 85, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-5, 5}, {3, -3}}, endAngle = 360), Polygon(origin = {40, 69.72}, fillColor = {0, 85, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-6, -3.72361}, {2, -3.72361}, {-2, 4.27639}, {-6, -3.72361}}), Polygon(origin = {40, 85.72}, fillColor = {0, 85, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-6, -3.72361}, {2, -3.72361}, {-2, 4.27639}, {-6, -3.72361}}), Ellipse(origin = {39, 79}, fillColor = {0, 85, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-5, 5}, {3, -3}}, endAngle = 360), Text(origin = {45, 3}, extent = {{-9, 7}, {9, -7}}, textString = "FviewII",  fontSize = 0 ), Text(origin = {45, -27}, extent = {{-9, 7}, {9, -7}}, textString = "AwallII",  fontSize = 0 ), Text(origin = {40, -63}, extent = {{-4, 7}, {4, -7}}, textString = "II",  fontSize = 0 ), Polygon(origin = {40, -84.28}, fillColor = {0, 85, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-6, -3.72361}, {2, -3.72361}, {-2, 4.27639}, {-6, -3.72361}}), Ellipse(origin = {39, -91}, fillColor = {0, 85, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-5, 5}, {3, -3}}, endAngle = 360), Line(origin = {46, 40}, points = {{0, 8}, {0, -18}}, color = {0, 0, 255}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {35.21, -89.21}, points = {{10.7929, -2.79289}, {16.7929, 1.20711}, {28.7929, 1.20711}}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Polygon(origin = {37, -97}, fillColor = {0, 85, 255}, fillPattern = FillPattern.Solid, points = {{11, 3}, {7, -3}, {-7, -3}, {-11, 3}, {11, 3}}), Line(origin = {19, 44}, points = {{11, 0}, {33, 0}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {19, 30}, points = {{11, 0}, {33, 0}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {22, -52}, points = {{10, 6}, {30, -6}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {24, -60}, points = {{8, -18}, {28, -6}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.None, Arrow.Filled})}, coordinateSystem(initialScale = 0.1)));
end Wall;
