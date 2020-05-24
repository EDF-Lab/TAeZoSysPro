within TAeZoSysPro.Aeraulic.BasesClasses;

model Liq_Gas_Interface
  // medium declaration
  package Medium = Media.MyMedia;
  package Mediumda = HeatTransfer.Media.MyMedia;
  //medium properties
  Medium.ThermodynamicState State_gas_node;
  // Internal parameters
  parameter Modelica.SIunits.Area A_wall = 1 "Wall surface area";
  parameter Modelica.SIunits.Emissivity LiquidEmissivity = 1 "Emissivity of the liquid of the interface";
  parameter Boolean FreeConvection = true;
  parameter Modelica.SIunits.Velocity Vel = 0 "air flow velocity at surface";
  parameter Real Add_on = 1 "add on mass transfer coefficient";
  // Variables declaration
  Real BetaV "mass transfer coefficient";
  //
  Modelica.SIunits.MassFlowRate m_flow_cond;
  //
  Modelica.SIunits.SpecificHeatCapacityAtConstantPressure cp "Medium Specific Heat Capacity At Constant Pressure";
  //
  Modelica.SIunits.SpecificEnthalpy h_steam_room "Medium enthalpy of steam in moist air";
  Modelica.SIunits.SpecificEnthalpy h_steam_sat_wall "Medium enthalpy of steam at wall condition (if evaporation)";
  //
  Modelica.SIunits.Pressure p_steam_sat_wall "Steam pressure at wall condition";
  // Component imported
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b Heatport_conv annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, -28}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  TAeZoSysPro.Aeraulic.Interfaces.FlowPort_a flowPort_a(replaceable package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {74, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  TAeZoSysPro.HeatTransfer.BasesClasses.Convection Convection(replaceable package Medium = Mediumda, A = A_wall, FreeConvection = FreeConvection, Vel = Vel, carac_length = A_wall ^ 0.5, correlation_forced = HeatTransfer.Types.ForcedConvectionCorrelation.ASHRAE_flat_plate, correlation_free = HeatTransfer.Types.FreeConvectionCorrelation.Ground, perimeter = A_wall ^ 0.5) annotation(
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  TAeZoSysPro.Aeraulic.Interfaces.FlowPort_b flowPort_b(replaceable package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-90, -66}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, -76}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b Heatport_rad annotation(
    Placement(visible = true, transformation(origin = {-100, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  TAeZoSysPro.HeatTransfer.BasesClasses.CarrollRadiation carrollRadiation1(A = A_wall, emissivity = LiquidEmissivity) annotation(
    Placement(visible = true, transformation(origin = {0, 50}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature prescribedTemperature annotation(
    Placement(visible = true, transformation(origin = {38, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput Fview annotation(
    Placement(visible = true, transformation(origin = {-98, 82}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {97, 55}, extent = {{13, -13}, {-13, 13}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput Awall annotation(
    Placement(visible = true, transformation(origin = {91, 77}, extent = {{-13, -13}, {13, 13}}, rotation = 0), iconTransformation(origin = {-100, 76}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
equation
  connect(Fview, carrollRadiation1.Fview) annotation(
    Line(points = {{-98, 82}, {32, 82}, {32, 42}, {8, 42}, {8, 42}}, color = {0, 0, 127}));
  connect(prescribedTemperature.port, carrollRadiation1.port_a) annotation(
    Line(points = {{28, 0}, {20, 0}, {20, 50}, {10, 50}, {10, 50}}, color = {191, 0, 0}));
  connect(prescribedTemperature.port, Convection.Heatport_a) annotation(
    Line(points = {{28, 0}, {10, 0}, {10, 0}, {10, 0}}, color = {191, 0, 0}));
  connect(Convection.Heatport_b, Heatport_conv) annotation(
    Line(points = {{-10, 0}, {-100, 0}, {-100, 0}, {-100, 0}}, color = {191, 0, 0}));
  connect(Heatport_rad, carrollRadiation1.port_b) annotation(
    Line(points = {{-100, 50}, {-10, 50}, {-10, 50}, {-10, 50}}, color = {191, 0, 0}));
//
  Awall = A_wall;
// fill state record
  State_gas_node = Medium.ThermodynamicState(pi = flowPort_b.pi, T = flowPort_b.T, di = flowPort_b.di, hi = flowPort_b.hi);
//
  cp = Medium.specificHeatCapacityCp(State_gas_node);
//
  p_steam_sat_wall = Media.MoistAir.saturationPressure(flowPort_a.T);
//
  h_steam_room = Medium.enthalpyOfCondensingGas(p = State_gas_node.pi[Medium.Water], T = State_gas_node.T);
  h_steam_sat_wall = Medium.enthalpyOfCondensingGas(p = p_steam_sat_wall, T = flowPort_a.T);
//
  BetaV = Convection.hcv / (sum(State_gas_node.di) * cp);
  m_flow_cond = BetaV * A_wall * Medium.MMX[Medium.Water] / Modelica.Constants.R / State_gas_node.T * (State_gas_node.pi[Medium.Water] - p_steam_sat_wall);
// ports handover
  prescribedTemperature.T = flowPort_a.T;
//Ports mass balance
  flowPort_b.m_flow[Medium.Water] = m_flow_cond;
  flowPort_b.m_flow[Medium.Air] = 0;
  flowPort_b.m_flow + flowPort_a.m_flow = fill(0.0, Medium.nX);
//Ports energy balance
  flowPort_b.H_flow = if State_gas_node.pi[Medium.Water] >= p_steam_sat_wall then m_flow_cond * h_steam_room else m_flow_cond * h_steam_sat_wall;
  flowPort_a.H_flow + flowPort_b.H_flow + prescribedTemperature.port.Q_flow = 0;
  annotation(
    Diagram(graphics = {Text(origin = {13, -33}, extent = {{-25, 11}, {25, -11}}, textString = "Flux from radiation, convection and latent exchange",  fontSize = 0 ), Line(origin = {49, -53}, points = {{-13, 13}, {13, -13}}, arrow = {Arrow.None, Arrow.Filled})}, coordinateSystem(initialScale = 0.1)),
    Icon(graphics = {Rectangle(origin = {20, 19}, lineColor = {255, 255, 255}, fillColor = {0, 170, 255}, fillPattern = FillPattern.Solid, extent = {{-10, 57}, {10, -97}}), Text(origin = {-71, 2}, rotation = 90, extent = {{-31, -12}, {29, -30}}, textString = "Gas node",  fontSize = 0 ), Text(origin = {49, 24}, rotation = 90, extent = {{-53, 8}, {7, -10}}, textString = "Liquid node",  fontSize = 0 ), Line(origin = {-2, -8}, points = {{0, 28}, {0, -10}}, color = {0, 0, 255}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {-16, -8}, points = {{0, 28}, {0, -10}}, color = {0, 0, 255}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {-41, 10}, points = {{47, 0}, {15, 0}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {-41, -6}, points = {{47, 0}, {15, 0}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Ellipse(origin = {5, -74}, lineColor = {0, 85, 255}, fillColor = {0, 85, 255}, fillPattern = FillPattern.Solid, extent = {{-11, 34}, {-3, 26}}, endAngle = 360), Polygon(origin = {-2.94, -39.22}, lineColor = {0, 85, 255}, fillColor = {0, 85, 255}, fillPattern = FillPattern.Solid, points = {{-3.05832, -2.77735}, {4.94168, -2.77735}, {0.941683, 5.22265}, {-3.05832, -2.77735}}), Line(origin = {-6.79, -66}, points = {{14.7929, 0}, {10.7929, 4}, {6.79289, 4}, {-1.20711, -4}, {-5.20711, -4}, {-9.20711, 0}, {-15.2071, 0}}, color = {0, 85, 255}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 5), Line(origin = {-7, 44}, points = {{15, -6}, {-13, 6}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {-7, 54}, points = {{15, 18}, {-13, 6}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Text(origin = {-2, 55}, extent = {{-6, 5}, {6, -5}}, textString = "I",  fontSize = 0 ), Text(origin = {87, 78}, extent = {{-7, 6}, {7, -6}}, textString = "Fview",  fontSize = 0 ), Text(origin = {-71, 76}, extent = {{-7, 6}, {7, -6}}, textString = "Awall",  fontSize = 0 ), Text(origin = {-71, 30}, extent = {{-7, 6}, {7, -6}}, textString = "Rad",  fontSize = 0 ), Text(origin = {-71, -28}, extent = {{-7, 6}, {7, -6}}, textString = "Conv",  fontSize = 0 )}, coordinateSystem(initialScale = 0.1)));
end Liq_Gas_Interface;
