within TAeZoSysPro.HeatTransfer.Components;

model HalfWall
  //Media
  replaceable package Medium = TAeZoSysPro.HeatTransfer.Media.MyMedia;
  //customs parameters are defined by user
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
  //
  parameter Modelica.SIunits.Emissivity Emissivity = 0 "Wall emissivity " annotation(
    Dialog(group = "properties for radiation"));
  parameter Real Add_on(unit = "R+") = 1 "Custom add-on" annotation(
    Dialog(group = "properties for radiation"));
  //
  // Components inside wall are defined
  TAeZoSysPro.HeatTransfer.BasesClasses.PartialWall partialWall1(Area = Awall, CpW = Cpwall, RhoW = RhoW, SteadyState = SteadyState, Tinit = Tstart, add_on = 1, conduction = TAeZoSysPro.HeatTransfer.Types.ConductionType.Linear, k = Kwall, l = if L / N <= L_Bi then L - L / N else L - L_Bi, n = N) annotation(
    Placement(visible = true, transformation(origin = {6.5, 0.5}, extent = {{-29.5, -29.5}, {29.5, 29.5}}, rotation = 0)));
  TAeZoSysPro.HeatTransfer.BasesClasses.Convection convection1(replaceable package Medium = Medium, A = Awall, FreeConvection = FreeConvection, Vel = Vel, add_on = Add_on, carac_length = Carac_length, correlation_forced = correlation_forced, correlation_free = correlation_free, h = hcv, perimeter = Pwall) annotation(
    Placement(visible = true, transformation(origin = {-47, 56}, extent = {{-18, -18}, {18, 18}}, rotation = 180)));
  TAeZoSysPro.HeatTransfer.BasesClasses.CarrollRadiation carrollRadiation1(A = Awall, add_on = Add_on, emissivity = Emissivity) annotation(
    Placement(visible = true, transformation(origin = {-54.5, -54.5}, extent = {{-22.5, -22.5}, {22.5, 22.5}}, rotation = 180)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a_conv annotation(
    Placement(visible = true, transformation(origin = {-101, 56}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-90, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a_rad annotation(
    Placement(visible = true, transformation(origin = {-101, -54}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-90, -76}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput AwallI annotation(
    Placement(visible = true, transformation(origin = {-100, 18}, extent = {{-10, -10}, {10, 10}}, rotation = 180), iconTransformation(origin = {-93, -31}, extent = {{-7, -7}, {7, 7}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput FviewI annotation(
    Placement(visible = true, transformation(origin = {-100, -8}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-93, -1}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port_b annotation(
    Placement(visible = true, transformation(origin = {99, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {90, -4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  /*                                                      */
  BasesClasses.HeatCapacitor Surface_mass_I(Cp = Cpwall, Mass = if L / N <= L_Bi then RhoW * Awall * L / N else RhoW * Awall * L_Bi, SteadyState = SteadyState, Tstart = Tstart) annotation(
    Placement(visible = true, transformation(origin = {-52, 16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
protected
  parameter Modelica.SIunits.Thickness L_Bi = Bi * Kwall / href "First layer thickness";

equation

  connect(port_a_rad, carrollRadiation1.port_b) annotation(
    Line(points = {{-101, -54}, {-77, -54}, {-77, -54}, {-77, -54}}, color = {191, 0, 0}));
  connect(port_a_conv, convection1.Heatport_b) annotation(
    Line(points = {{-101, 56}, {-64, 56}, {-64, 56}, {-65, 56}}, color = {191, 0, 0}));
  connect(FviewI, carrollRadiation1.Fview) annotation(
    Line(points = {{-100, -8}, {-36, -8}, {-36, -36}, {-36, -36}}, color = {0, 0, 127}));
  connect(partialWall1.port_b, port_b) annotation(
    Line(points = {{35, 0}, {100, 0}, {100, 2}, {99, 2}}, color = {191, 0, 0}));
  connect(Surface_mass_I.port, partialWall1.port_a) annotation(
    Line(points = {{-52, 6}, {-52, 6}, {-52, 0}, {-22, 0}, {-22, 0}}, color = {191, 0, 0}));
  connect(carrollRadiation1.port_a, partialWall1.port_a) annotation(
    Line(points = {{-32, -54}, {-22, -54}, {-22, 0}, {-22, 0}}, color = {191, 0, 0}));
  connect(convection1.Heatport_a, partialWall1.port_a) annotation(
    Line(points = {{-29, 56}, {-22, 56}, {-22, 0}, {-22, 0}}, color = {191, 0, 0}));
  AwallI = Awall;
//output y is set to Awall and it can be connected to FviewCalculator
  annotation(
    Diagram(coordinateSystem(grid = {1, 2}, initialScale = 0.1), graphics = {Rectangle(origin = {3.5, -1}, fillColor = {218, 218, 218}, fillPattern = FillPattern.Solid, lineThickness = 1, extent = {{-42.5, 101}, {36.5, -99}})}),
    Icon(graphics = {Rectangle(origin = {11, 9}, fillColor = {191, 191, 191}, fillPattern = FillPattern.Cross, lineThickness = 1, extent = {{-53, 75}, {73, -109}}), Line(origin = {-59, -63}, points = {{13, -33}, {-13, -17}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {-63, -57}, rotation = 90, points = {{3, -17}, {-15, 9}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {-70, 50}, points = {{0, 30}, {0, -30}}, color = {0, 0, 255}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {-52, 50}, points = {{0, 30}, {0, -30}}, color = {0, 0, 255}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {-61, 68}, points = {{17, 0}, {-17, 0}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {-61, 34}, points = {{17, 0}, {-17, 0}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Text(origin = {-91, 75}, lineThickness = 1, extent = {{-7, 7}, {7, -7}}, textString = "Air"), Text(origin = {-91, -51}, lineThickness = 1, extent = {{-7, 7}, {7, -7}}, textString = "Jmrt"), Text(origin = {-43, -74}, lineThickness = 1, extent = {{13, 6}, {-31, -12}}, textString = "I"), Text(origin = {-67, -1}, lineThickness = 1, extent = {{-7, 7}, {9, -5}}, textString = "FviewI"), Text(origin = {-65, -33}, lineThickness = 1, extent = {{-7, 7}, {7, -5}}, textString = "Awall"), Text(origin = {59, 95}, lineThickness = 0.5, extent = {{-27, 7}, {27, -7}}, textString = "KURY - EDVANCE",  fontSize = 0 )}, coordinateSystem(initialScale = 0.1)),
    experiment(StartTime = 0, StopTime = 3600, Tolerance = 1e-06, Interval = 36));
end HalfWall;
