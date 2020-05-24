within TAeZoSysPro.HeatTransfer.Components;

model Wall
  //Media
  replaceable package Medium = TAeZoSysPro.HeatTransfer.Media.MyMedia;
  // Parameters are defined by user
  parameter Integer N = 5 "Number of layers : 1 to 65535";
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
  parameter TAeZoSysPro.HeatTransfer.Types.FreeConvectionCorrelation correlation_free = TAeZoSysPro.HeatTransfer.Types.FreeConvectionCorrelation.ChurchillAndChu_vertical_plate "Free convection Correlation for wall I" annotation(
    Dialog(group = "properties for convection"));
  parameter TAeZoSysPro.HeatTransfer.Types.ForcedConvectionCorrelation correlation_forced = TAeZoSysPro.HeatTransfer.Types.ForcedConvectionCorrelation.ASHRAE_flat_plate "Forced convection Correlation" annotation(
    Dialog(group = "properties for convection"));
  parameter Modelica.SIunits.Length Pwall = 0 "Perimeter is used for ground and ceiling (optional)" annotation(
    Dialog(group = "properties for convection"));
  parameter Modelica.SIunits.CoefficientOfHeatTransfer hcvI = 0 "Constant heat transfer coefficient (optional)" annotation(
    Dialog(group = "properties for convection"));
  parameter Modelica.SIunits.CoefficientOfHeatTransfer hcvII = hcvI "Constant heat transfer coefficient (optional)" annotation(
    Dialog(group = "properties for convection"));
  parameter Modelica.SIunits.Velocity VelI = 0 "characteristic velocity " annotation(
    Dialog(group = "properties for convection"));
  parameter Modelica.SIunits.Velocity VelII = VelI "characteristic velocity " annotation(
    Dialog(group = "properties for convection"));
  //
  parameter Modelica.SIunits.Emissivity Emissivity = 0 "Wall emissivity " annotation(
    Dialog(group = "properties for radiation"));
  parameter Real Add_on_conv(unit = "R+") = 1 "Custom add-on" annotation(
    Dialog(group = "properties for radiation"));
  parameter Real Add_on_rad(unit = "R+") = 1 "Custom add-on" annotation(
    Dialog(group = "properties for radiation"));
  //
  // Imported components
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a_conv annotation(
    Placement(visible = true, transformation(origin = {-99, 56}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 54}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port_b_conv annotation(
    Placement(visible = true, transformation(origin = {97, 56}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {96, 52}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a_rad annotation(
    Placement(visible = true, transformation(origin = {-99, -56}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, -76}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port_b_rad annotation(
    Placement(visible = true, transformation(origin = {100, -58}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, -78}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  //
  Modelica.Blocks.Interfaces.RealInput FviewI annotation(
    Placement(visible = true, transformation(origin = {-90.5, -16.5}, extent = {{-9.5, -9.5}, {9.5, 9.5}}, rotation = 0), iconTransformation(origin = {-99, 9}, extent = {{-11, -11}, {11, 11}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput FviewII annotation(
    Placement(visible = true, transformation(origin = {89, -14}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {96, 8}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  //
  Modelica.Blocks.Interfaces.RealOutput AwallI annotation(
    Placement(visible = true, transformation(origin = {-90, 14}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {-100, -28}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput AwallII annotation(
    Placement(visible = true, transformation(origin = {90, 16}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {96, -32}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  //
  TAeZoSysPro.HeatTransfer.BasesClasses.CarrollRadiation carrollRadiation2(A = Awall, add_on = Add_on_rad, emissivity = Emissivity) annotation(
    Placement(visible = true, transformation(origin = {56.5, -56.5}, extent = {{-22.5, -22.5}, {22.5, 22.5}}, rotation = 0)));
  TAeZoSysPro.HeatTransfer.BasesClasses.CarrollRadiation carrollRadiation1(A = Awall, add_on = Add_on_rad, emissivity = Emissivity) annotation(
    Placement(visible = true, transformation(origin = {-54.5, -54.5}, extent = {{-22.5, -22.5}, {22.5, 22.5}}, rotation = 180)));
  // There is "If" with WallMod because when one plate is Ceiling the opposite one is Ground
  TAeZoSysPro.HeatTransfer.BasesClasses.Convection convection1(replaceable package Medium = Medium, A = Awall, FreeConvection = FreeConvection, Vel = VelI, add_on = Add_on_conv, carac_length = Carac_length, correlation_forced = correlation_forced, correlation_free = correlation_free, h = hcvI, perimeter = Pwall) annotation(
    Placement(visible = true, transformation(origin = {-52, 56}, extent = {{18, -18}, {-18, 18}}, rotation = 0)));
  TAeZoSysPro.HeatTransfer.BasesClasses.Convection convection2(replaceable package Medium = Medium, A = Awall, FreeConvection = FreeConvection, Vel = VelII, add_on = Add_on_conv, carac_length = Carac_length, correlation_forced = correlation_forced, correlation_free = if correlation_free == TAeZoSysPro.HeatTransfer.Types.FreeConvectionCorrelation.Ceiling then TAeZoSysPro.HeatTransfer.Types.FreeConvectionCorrelation.Ground elseif correlation_free == TAeZoSysPro.HeatTransfer.Types.FreeConvectionCorrelation.Ground then TAeZoSysPro.HeatTransfer.Types.FreeConvectionCorrelation.Ceiling else correlation_free, h = hcvII, perimeter = Pwall) annotation(
    Placement(visible = true, transformation(origin = {53, 56}, extent = {{-18, -18}, {18, 18}}, rotation = 0)));
  //
  TAeZoSysPro.HeatTransfer.BasesClasses.HeatCapacitor Surface_mass_I(Cp = Cpwall, Mass = if L / N <= L_Bi then RhoW * Awall * L / N else RhoW * Awall * L_Bi, SteadyState = SteadyState, Tstart = Tstart) annotation(
    Placement(visible = true, transformation(origin = {-53, 18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  TAeZoSysPro.HeatTransfer.BasesClasses.HeatCapacitor Surface_mass_II(Cp = Cpwall, Mass = if L / N <= L_Bi then RhoW * Awall * L / N else RhoW * Awall * L_Bi, SteadyState = SteadyState, Tstart = Tstart) annotation(
    Placement(visible = true, transformation(origin = {57, 18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  //
  TAeZoSysPro.HeatTransfer.BasesClasses.PartialWall partialWall1(Area = Awall, CpW = Cpwall, RhoW = RhoW, SteadyState = SteadyState, Tinit = Tstart, conduction = TAeZoSysPro.HeatTransfer.Types.ConductionType.Linear, k = Kwall, l = if L / N <= L_Bi then L - 2 * L / N else L - 2 * L_Bi, n = N) annotation(
    Placement(visible = true, transformation(origin = {2, 1.33227e-15}, extent = {{-22, -22}, {22, 22}}, rotation = 0)));
  //
protected
  parameter Modelica.SIunits.Thickness L_Bi = Bi * Kwall / href "First layer thickness";
equation
  connect(carrollRadiation2.port_b, port_b_rad) annotation(
    Line(points = {{79, -56.5}, {100, -56.5}, {100, -58}}, color = {191, 0, 0}));
  connect(FviewII, carrollRadiation2.Fview) annotation(
    Line(points = {{89, -14}, {37, -14}, {37, -38.5}, {38.5, -38.5}}, color = {0, 0, 127}));
  connect(carrollRadiation2.port_a, partialWall1.port_b) annotation(
    Line(points = {{34, -56.5}, {23, -56.5}, {23, 0}, {24, 0}}, color = {191, 0, 0}));
  connect(port_a_rad, carrollRadiation1.port_b) annotation(
    Line(points = {{-99, -56}, {-77, -56}, {-77, -54}, {-77, -54}}, color = {191, 0, 0}));
  connect(convection2.Heatport_b, port_b_conv) annotation(
    Line(points = {{71, 56}, {98, 56}, {98, 56}, {97, 56}}, color = {191, 0, 0}));
  connect(port_a_conv, convection1.Heatport_b) annotation(
    Line(points = {{-99, 56}, {-71, 56}, {-71, 56}, {-70, 56}}, color = {191, 0, 0}));
  connect(FviewI, carrollRadiation1.Fview) annotation(
    Line(points = {{-90, -16}, {-35, -16}, {-35, -36}, {-36, -36}}, color = {0, 0, 127}));
  connect(Surface_mass_II.port, partialWall1.port_b) annotation(
    Line(points = {{57, 8}, {57, 8}, {57, 0}, {24, 0}, {24, 0}}, color = {191, 0, 0}));
  connect(convection2.Heatport_a, partialWall1.port_b) annotation(
    Line(points = {{35, 56}, {23, 56}, {23, 0}, {24, 0}}, color = {191, 0, 0}));
  connect(Surface_mass_I.port, partialWall1.port_a) annotation(
    Line(points = {{-53, 8}, {-53, 8}, {-53, 0}, {-20, 0}, {-20, 0}}, color = {191, 0, 0}));
  connect(carrollRadiation1.port_a, partialWall1.port_a) annotation(
    Line(points = {{-32, -54}, {-20, -54}, {-20, 0}, {-20, 0}}, color = {191, 0, 0}));
  connect(convection1.Heatport_a, partialWall1.port_a) annotation(
    Line(points = {{-34, 56}, {-20, 56}, {-20, 0}, {-20, 0}}, color = {191, 0, 0}));
  AwallI = Awall;
  AwallII = Awall;
  annotation(
    Diagram(coordinateSystem(grid = {1, 2}, initialScale = 0.1), graphics = {Rectangle(origin = {3.5, -1}, fillColor = {218, 218, 218}, fillPattern = FillPattern.Solid, lineThickness = 1, extent = {{-42.5, 101}, {36.5, -99}})}),
    Icon(graphics = {Rectangle(origin = {11, 9}, fillColor = {191, 191, 191}, fillPattern = FillPattern.Cross, lineThickness = 1, extent = {{-53, 75}, {29, -109}}), Line(origin = {-59, -63}, points = {{13, -33}, {-13, -17}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {-63, -57}, rotation = 90, points = {{3, -17}, {-15, 9}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {56, -92}, points = {{-12, -6}, {16, 8}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {54, -62}, points = {{-12, 8}, {16, -12}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {-70, 50}, points = {{0, 30}, {0, -30}}, color = {0, 0, 255}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {-52, 50}, points = {{0, 30}, {0, -30}}, color = {0, 0, 255}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {52, 50}, points = {{0, 30}, {0, -30}}, color = {0, 0, 255}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {70, 50}, points = {{0, 30}, {0, -30}}, color = {0, 0, 255}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {-61, 68}, points = {{17, 0}, {-17, 0}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {-61, 34}, points = {{17, 0}, {-17, 0}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {61, 68}, rotation = 180, points = {{17, 0}, {-17, 0}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {61, 34}, rotation = 180, points = {{17, 0}, {-17, 0}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Text(origin = {-91, 75}, lineThickness = 1, extent = {{-7, 7}, {7, -7}}, textString = "Air"), Text(origin = {89, 75}, lineThickness = 1, extent = {{-7, 7}, {7, -7}}, textString = "Air"), Text(origin = {-91, -51}, lineThickness = 1, extent = {{-7, 7}, {7, -7}}, textString = "Jmrt"), Text(origin = {89, -57}, lineThickness = 1, extent = {{-7, 7}, {7, -7}}, textString = "Jmrt"), Text(origin = {59, -74}, lineThickness = 1, extent = {{13, 6}, {-31, -12}}, textString = "II"), Text(origin = {-43, -74}, lineThickness = 1, extent = {{13, 6}, {-31, -12}}, textString = "I"), Text(origin = {-73, 7}, lineThickness = 1, extent = {{-7, 7}, {9, -5}}, textString = "FviewI"), Text(origin = {61, 7}, lineThickness = 1, extent = {{-7, 7}, {11, -3}}, textString = "FviewII"), Text(origin = {-73, -29}, lineThickness = 1, extent = {{-7, 7}, {7, -5}}, textString = "Awall"), Text(origin = {63, -33}, lineThickness = 1, extent = {{-7, 7}, {7, -5}}, textString = "Awall"), Text(origin = {67, 93}, lineThickness = 0.5, extent = {{-41, 9}, {25, -5}}, textString = "KURY - EDVANCE",  fontSize = 0 )}, coordinateSystem(initialScale = 0.1)));
end Wall;
