within TAeZoSysPro.HeatTransfer.Components;

model Pipe_waterModeled
  /*
                                                                          The block allows to determine the heat load exchange from a pipe to its environment through its walls.
                                                                          The mass balance and the momentum equation are not solved here. Only heat exchanges are investigated. 
                                                                          Hypotheses :
                                                                          - The water is not modeled thus have no inertia
                                                                          - The water convective temperature is arythmetic mean of the inlet and outlet water temperature
                                                                          - The phase changes are not considered
                                                                          
                                                                          The water outlet temperature is determined from an energy balance between the pipe inlet heat flux and 
                                                                          the total heat losses along the pipe.
                                                                          */
  package Medium_external = Modelica.Media.Air.ReferenceAir.Air_pT;
  package Medium_internal = Modelica.Media.Water.WaterIF97_pT(Region = 1);
  // general parameters
  parameter Modelica.SIunits.Length Le = 0 "Pipe length";
  parameter Boolean SteadyState = true "Steady state initialization";
  parameter Modelica.SIunits.Temperature Tinit = 273.15 "Beginning temperature, if not steady state";
  parameter Boolean Insulation = true "Insulation presence";
  parameter Modelica.SIunits.VolumeFlowRate Qv = 0 "Fluid Volume flow rate";
  // parameter for sub-elements
  // for tube capacity
  parameter Modelica.SIunits.SpecificHeatCapacity CpTube = 540 "Tube (steel) specific heat capacity" annotation(
    Dialog(group = "tube capacity properties"));
  parameter Modelica.SIunits.Density RhoTube(displayUnit = "kg/m3") = 7780 "Tube (steel) density" annotation(
    Dialog(group = "tube capacity properties"));
  parameter Modelica.SIunits.Radius Ri_tube = 0 "Internal tube radius" annotation(
    Dialog(group = "tube capacity properties"));
  parameter Modelica.SIunits.Thickness l_tube = 0 "External tube radius" annotation(
    Dialog(group = "tube capacity properties"));
  // for PartialWall_Cylindrical : material = MineralFibre ( library BuildSysPro => Utilities => Data => Solid )
  parameter Integer n(unit = "Z+*") = 5 "Number of layers : 1 to 65535" annotation(
    Dialog(group = "Insulation properties"));
  parameter Modelica.SIunits.SpecificHeatCapacity CpInsu = 920 "Insulation specific heat capacity" annotation(
    Dialog(group = "Insulation properties"));
  parameter Modelica.SIunits.Density RhoInsu(displayUnit = "kg/m3") = 18 "Insulation density" annotation(
    Dialog(group = "Insulation properties"));
  parameter Modelica.SIunits.ThermalConductivity k_Insu = 0.036 "Insulation conductivity" annotation(
    Dialog(group = "Insulation properties"));
  parameter Modelica.SIunits.Thickness l_Insu = 0 "ExternalRadius : m" annotation(
    Dialog(group = "Insulation wall properties"));
  // for Carrollradiation
  parameter Real add_on_carrollNode(unit = "R+") = 1 "Custom add-on" annotation(
    Dialog(group = "Radiation properties"));
  parameter Modelica.SIunits.Emissivity emissivity = 0 "Emissivity of Insulation(if insulation=true) or tube(if insulation=false) " annotation(
    Dialog(group = "Radiation properties"));
  // for external convection
  parameter TAeZoSysPro.HeatTransfer.Types.FreeConvectionCorrelation correlation_external = TAeZoSysPro.HeatTransfer.Types.FreeConvectionCorrelation.ChurchillAndChu_vertical_plate "Free convection Correlation" annotation(
    Dialog(group = "External convection properties"));
  parameter Real add_on_external_convection(unit = "R+") = 1 "Custom add-on" annotation(
    Dialog(group = "External convection properties"));
  parameter Modelica.SIunits.CoefficientOfHeatTransfer h_external = 0 "Constant heat transfer coefficient (optional)" annotation(
    Dialog(group = "External convection properties"));
  // for internal convection
  parameter TAeZoSysPro.HeatTransfer.Types.ForcedConvectionCorrelation correlation_internal = TAeZoSysPro.HeatTransfer.Types.ForcedConvectionCorrelation.ASHRAE_internal_cylinder "Forced convection Correlation" annotation(
    Dialog(group = "Internal convection properties"));
  parameter Real add_on_internal_convection(unit = "R+") = 1 "Custom add-on" annotation(
    Dialog(group = "Internal convection properties"));
  parameter Modelica.SIunits.CoefficientOfHeatTransfer h_internal = 0 "Constant heat transfer coefficient (optional)" annotation(
    Dialog(group = "Internal convection properties"));
  // internal
  // Sub-elements involved
  TAeZoSysPro.HeatTransfer.BasesClasses.PartialWall D_Insulation(conduction = TAeZoSysPro.HeatTransfer.Types.ConductionType.Radial, CpW = CpTube, Le = Le, RhoW = RhoTube, l = if not Insulation then 1 else l_Insu, Ri = Ri_tube + l_tube, SteadyState = if not Insulation then false else SteadyState, Tinit = Tinit, add_on = 1, k = k_Insu, n = n) annotation(
    Placement(visible = true, transformation(origin = {-1, 23}, extent = {{-17, -17}, {17, 17}}, rotation = 90)));
  TAeZoSysPro.HeatTransfer.BasesClasses.CarrollRadiation C_External_radiation(add_on = add_on_carrollNode, A = A_external, emissivity = emissivity) annotation(
    Placement(visible = true, transformation(origin = {-35, 65}, extent = {{-15, -15}, {15, 15}}, rotation = 90)));
  TAeZoSysPro.HeatTransfer.BasesClasses.Convection B_External_convection(redeclare package Medium = Medium_external, FreeConvection = true, A = A_external, carac_length = if not Insulation then 2 * (Ri_tube + l_tube) else 2 * (Ri_tube + l_tube + l_Insu), add_on = add_on_external_convection, correlation_free = correlation_external, h = h_external) annotation(
    Placement(visible = true, transformation(origin = {35, 65}, extent = {{-15, -15}, {15, 15}}, rotation = 90)));
  TAeZoSysPro.HeatTransfer.BasesClasses.Convection B_Internal_convection(redeclare package Medium = Medium_internal, FreeConvection = false, A = A_internal, carac_length = 2 * Ri_tube, add_on = add_on_internal_convection, correlation_forced = correlation_internal, h = h_internal, Vel = Qv / CrossSection_tube) annotation(
    Placement(visible = true, transformation(origin = {0, -42}, extent = {{-10, -10}, {10, 10}}, rotation = 270)));
  TAeZoSysPro.HeatTransfer.BasesClasses.HeatCapacitor E_Tube_capacitor(Cp = CpTube, Mass = MassTube, SteadyState = SteadyState, Tstart = Tinit) annotation(
    Placement(visible = true, transformation(origin = {30, -10}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow A_Internal_convection_power annotation(
    Placement(visible = true, transformation(origin = {0, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  // Port variables
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a annotation(
    Placement(visible = true, transformation(origin = {70, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {82, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port_b annotation(
    Placement(visible = true, transformation(origin = {-70, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-84, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port_b1 annotation(
    Placement(visible = true, transformation(origin = {70, 88}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {70, 86}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port_b2 annotation(
    Placement(visible = true, transformation(origin = {-70, 88}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-70, 86}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput F_Fview annotation(
    Placement(visible = true, transformation(origin = {-80, -20}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {39, -73}, extent = {{-15, -15}, {15, 15}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput F_Awall = A_external annotation(
    Placement(visible = true, transformation(origin = {-80, 20}, extent = {{20, -20}, {-20, 20}}, rotation = 0), iconTransformation(origin = {-39, -75}, extent = {{-15, -15}, {15, 15}}, rotation = 270)));
  Modelica.SIunits.Temperature T_Fluid "Mean temperature of water in the pipe";
protected
  parameter Modelica.SIunits.Area CrossSection_tube = Modelica.Constants.pi * ((Ri_tube + l_tube) ^ 2 - Ri_tube ^ 2) "Tube area (cross section)";
  parameter Modelica.SIunits.Mass MassTube = RhoTube * CrossSection_tube * Le "Mass of tube";
  parameter Modelica.SIunits.Area A_external = if Insulation then 2 * Modelica.Constants.pi * (Ri_tube + l_tube + l_Insu) * Le else 2 * Modelica.Constants.pi * (Ri_tube + l_tube) * Le "External area of the insulation/tube ";
  parameter Modelica.SIunits.Area A_internal = 2 * Modelica.Constants.pi * Ri_tube * Le "Internal area of the tube ";
initial equation
  if SteadyState then
    der(T_Fluid) = 0;
// If user has choosen steady state then temperature derivative is equal to 0
  else
    T_Fluid = Tinit;
// if user has not choosen steady state then temperature is set to initial temperature
  end if;
equation
  if Insulation then
    connect(D_Insulation.port_b, B_External_convection.Heatport_a);
    connect(D_Insulation.port_b, C_External_radiation.port_a);
    connect(D_Insulation.port_a, E_Tube_capacitor.port);
  else
    connect(E_Tube_capacitor.port, B_External_convection.Heatport_a);
    connect(E_Tube_capacitor.port, C_External_radiation.port_a);
  end if;
  connect(port_b1, B_External_convection.Heatport_b) annotation(
    Line(points = {{70, 88}, {34, 88}, {34, 80}, {36, 80}}, color = {191, 0, 0}));
  connect(port_b2, C_External_radiation.port_b) annotation(
    Line(points = {{-70, 88}, {-34, 88}, {-34, 80}, {-34, 80}}, color = {191, 0, 0}));
  connect(F_Fview, C_External_radiation.Fview) annotation(
    Line(points = {{-80, -20}, {-22, -20}, {-22, 54}, {-22, 54}}, color = {0, 0, 127}));
  connect(B_Internal_convection.Heatport_a, E_Tube_capacitor.port) annotation(
    Line(points = {{0, -32}, {0, -32}, {0, -10}, {20, -10}, {20, -10}}, color = {191, 0, 0}));
  connect(A_Internal_convection_power.port, B_Internal_convection.Heatport_b) annotation(
    Line(points = {{0, -70}, {0, -70}, {0, -52}, {0, -52}}, color = {191, 0, 0}));
// equipotentiality
  B_Internal_convection.Heatport_b.T = T_Fluid;
// energy conservation
  B_Internal_convection.d * (Modelica.Constants.pi * Ri_tube ^ 2 * Le) * B_Internal_convection.cp * der(T_Fluid) = Qv * B_Internal_convection.d * B_Internal_convection.cp * (port_a.T - T_Fluid) - A_Internal_convection_power.Q_flow;
// Internal_convection_power.Q_flow > 0 with the convention of the component internal convention
  port_a.Q_flow = 0;
  port_b.Q_flow = Qv * B_Internal_convection.d * B_Internal_convection.cp * (port_b.T - T_Fluid);
// pipe comments
  annotation(
    Icon(graphics = {Rectangle(origin = {11, 31}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Backward, extent = {{-91, 29}, {69, -13}}), Rectangle(origin = {-30, -26}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Backward, extent = {{-50, 10}, {110, -30}}), Text(origin = {-71, 69}, extent = {{-15, 5}, {15, -5}}, textString = "CarrollNode",  fontSize = 0 ), Text(origin = {70, 68}, extent = {{-8, 4}, {8, -4}}, textString = "Air",  fontSize = 0 ), Text(origin = {67, -75}, extent = {{-15, 7}, {13, -5}}, textString = "Fview",  fontSize = 0 ), Text(origin = {-60, -78}, extent = {{-20, 16}, {10, -6}}, textString = "Awall",  fontSize = 0 ), Line(origin = {0, 40}, points = {{0, -30}, {0, 30}}, color = {255, 0, 0}, thickness = 2, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {0, -38}, points = {{0, 30}, {0, -30}}, color = {255, 0, 0}, thickness = 2, arrow = {Arrow.None, Arrow.Filled}), Text(origin = {51, -96}, lineThickness = 0.5, extent = {{-11, 6}, {45, -6}}, textString = "KURY - EDVANCE",  fontSize = 0 ), Ellipse(origin = {-2, 2}, lineColor = {0, 170, 255}, fillColor = {170, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Sphere, lineThickness = 0.5, extent = {{-10, 10}, {14, -12}}, endAngle = 360)}, coordinateSystem(initialScale = 0.1)),
    Documentation(info = "<html>
<head>
<title>The Modelica License 2</title>
<style type=\"text/css\">
*       { font-size: 10pt; font-family: Arial,sans-serif; }
code    { font-size:  9pt; font-family: Courier,monospace;}
h1      { font-size: 20pt; font-weight: bold; color: rgb(32,32,32); }
h2      { font-size: 18pt; font-weight: bold; color: rgb(32,32,32); }
h3      { font-size: 16pt; font-weight: bold; color: rgb(32,32,32); }
h4      { font-size: 14pt; font-weight: bold; color: rgb(32,32,32); }
h5      { font-size: 12pt; font-weight: bold; color: rgb(32,32,32); }
h6      { font-size: 10pt; font-weight: bold; color: rgb(32,32,32); }




</style>
<meta http-equiv=\"Content-Type\" content=\"text/html;charset=utf-8\">
</head>
<body>

<h1>MON TITRE niveau 1 ICI</h1> 
<h2>MON TITRE niveau 2 ICI</h2>
<h3>MON TITRE niveau 3 ICI</h3>
<h4>MON TITRE niveau 4 ICI</h4>
<h5>MON TITRE niveau 5 ICI</h5>
<h6>MON TITRE niveau 6 ICI</h6>

<h1> Thermal Pipe </h1>  

This is a generic model to determine the heat loads (positiv of negative) exchange from a pipe to its environment through its walls. The mass balance and the momentum equation are not solved here. The mass flow rate
Only heat exchanges are investigated. 
Hypotheses :
- The water is not modeled thus have no inertia
- The water convective temperature is arythmetic mean of the inlet and outlet water temperature
- The phase changes are not considered

The water outlet temperature is determined from an energy balance between the pipe inlet heat flux and 
the total heat losses along the pipe.

</body>
</html>"));
end Pipe_waterModeled;
