within TAeZoSysPro.Aeraulic.BasesClasses;

model dropwiseCondensation
  // medium declaration
  replaceable package Medium = Media.MyMedia;
  //medium properties
  Medium.ThermodynamicState State_infinite;
  // Internal parameters
  parameter Modelica.SIunits.Area A_wall = 1 "Wall surface area";
  parameter Real h(unit = "W/(m2.K)") = 4 "convective heat exchange coefficient";
  parameter Real Add_on = 1 "add on mass transfer coefficient";
  parameter Boolean Fixed_hcv = true;
  parameter Types.LatentExchangeType LatentExchangeType = Types.LatentExchangeType.Condensation;
  Real hcv(unit = "W/(m2.K)") "convective heat exchange coefficient";
  Real BetaV "mass transfer coefficient";
  // Variables declaration
  Modelica.SIunits.MassFlowRate m_flow_cond;
  Modelica.SIunits.SpecificHeatCapacityAtConstantPressure cp "Medium Specific Heat Capacity At Constant Pressure";
  Modelica.SIunits.SpecificEnthalpy h_steam_sat_wall "Medium enthalpy of steam at wall condition (if evaporation)";
  Modelica.SIunits.SpecificEnthalpy h_steam_room "Medium enthalpy of steam in moist air";
  Modelica.SIunits.Pressure p_steam_sat_wall "Steam pressure at wall condition";
  // Component imported
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b Heatport annotation(
    Placement(visible = true, transformation(origin = {50, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput liquid_water_flow annotation(
    Placement(visible = true, transformation(origin = {0, -50}, extent = {{10, -10}, {-10, 10}}, rotation = 90), iconTransformation(origin = {28, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 270)));
  Interfaces.FlowPort_a Flowport(replaceable package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-50, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
// fill state record
  State_infinite = Medium.ThermodynamicState(pi = Flowport.pi, T = Flowport.T, di = Flowport.di, hi = Flowport.hi);
  cp = Medium.specificHeatCapacityCp(State_infinite);
  p_steam_sat_wall = Media.MoistAir.saturationPressure(Heatport.T);
  h_steam_sat_wall = Medium.enthalpyOfCondensingGas(p = p_steam_sat_wall, T = Heatport.T);
  h_steam_room = Medium.enthalpyOfCondensingGas(p = State_infinite.pi[Medium.Water], T = State_infinite.T);
  if Fixed_hcv then
    hcv = h;
  end if;
//
  BetaV = Add_on * hcv / (sum(State_infinite.di) * cp);
  if LatentExchangeType == Types.LatentExchangeType.Condensation then
    Flowport.H_flow = m_flow_cond * h_steam_room;
    if State_infinite.pi[Medium.Water] > p_steam_sat_wall then
      m_flow_cond = BetaV * A_wall * Medium.MMX[Medium.Water] / Modelica.Constants.R / State_infinite.T * (State_infinite.pi[Medium.Water] - p_steam_sat_wall);
    else
// no condensation possible
      m_flow_cond = 0;
    end if;
  elseif LatentExchangeType == Types.LatentExchangeType.Evaporation then
    Flowport.H_flow = m_flow_cond * h_steam_sat_wall;
    if State_infinite.pi[Medium.Water] < p_steam_sat_wall then
      m_flow_cond = BetaV * A_wall * Medium.MMX[Medium.Water] / Modelica.Constants.R / State_infinite.T * (State_infinite.pi[Medium.Water] - p_steam_sat_wall);
    else
// no evaporation possible
      m_flow_cond = 0;
    end if;
  elseif LatentExchangeType == Types.LatentExchangeType.EvapAndCond then
    Flowport.H_flow = if State_infinite.pi[Medium.Water] > p_steam_sat_wall then m_flow_cond * h_steam_room else m_flow_cond * h_steam_sat_wall;
/*noEvent*/
    m_flow_cond = BetaV * A_wall * Medium.MMX[Medium.Water] / Modelica.Constants.R / State_infinite.T * (State_infinite.pi[Medium.Water] - p_steam_sat_wall);
  else
    m_flow_cond = 0;
// user has chosen nothing thus nothing happens
    Flowport.H_flow = 0;
  end if;
//wall heat gain due to condensation
  Heatport.Q_flow = -m_flow_cond * Medium.enthalpyOfVaporization(p_steam_sat_wall);
//Output condensation data
  liquid_water_flow = m_flow_cond;
//  liquid_water_flow[2] = Heatport.T;
//flowPort balance
  Flowport.m_flow[Medium.Water] = m_flow_cond;
  Flowport.m_flow[Medium.Air] = 0;
  annotation(
    Diagram,
    Icon(graphics = {Rectangle(origin = {10, -1}, fillColor = {136, 136, 136}, fillPattern = FillPattern.Cross, extent = {{-10, 81}, {42, -77}}), Ellipse(origin = {-29, 46}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid, extent = {{-11, 34}, {9, 14}}, endAngle = 360), Line(origin = {75, 60}, points = {{-15, 0}, {15, 0}}, color = {255, 0, 0}, thickness = 2.5, arrow = {Arrow.Filled, Arrow.Filled}), Line(origin = {75, -40}, points = {{-15, 0}, {15, 0}}, color = {255, 0, 0}, thickness = 2.5, arrow = {Arrow.Filled, Arrow.Filled}), Line(origin = {75, 40}, points = {{-15, 0}, {15, 0}}, color = {255, 0, 0}, thickness = 2.5, arrow = {Arrow.Filled, Arrow.Filled}), Line(origin = {75, -60}, points = {{-15, 0}, {15, 0}}, color = {255, 0, 0}, thickness = 2.5, arrow = {Arrow.Filled, Arrow.Filled}), Ellipse(origin = {-29, 6}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid, extent = {{-11, 34}, {9, 14}}, endAngle = 360), Ellipse(origin = {-29, 26}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid, extent = {{-11, 34}, {9, 14}}, endAngle = 360), Ellipse(origin = {-29, -74}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid, extent = {{-11, 34}, {9, 14}}, endAngle = 360), Ellipse(origin = {-29, -54}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid, extent = {{-11, 34}, {9, 14}}, endAngle = 360), Ellipse(origin = {-29, -34}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid, extent = {{-11, 34}, {9, 14}}, endAngle = 360), Ellipse(origin = {-29, -14}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid, extent = {{-11, 34}, {9, 14}}, endAngle = 360), Ellipse(origin = {-29, -94}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid, extent = {{-11, 34}, {9, 14}}, endAngle = 360), Line(origin = {-29, 70}, points = {{-21, 0}, {19, 0}}, color = {0, 0, 255}, thickness = 2, arrow = {Arrow.Filled, Arrow.Filled}), Line(origin = {-29, 30}, points = {{-21, 0}, {19, 0}}, color = {0, 0, 255}, thickness = 2, arrow = {Arrow.Filled, Arrow.Filled}), Line(origin = {-29, 50}, points = {{-21, 0}, {19, 0}}, color = {0, 0, 255}, thickness = 2, arrow = {Arrow.Filled, Arrow.Filled}), Line(origin = {-29, -50}, points = {{-21, 0}, {19, 0}}, color = {0, 0, 255}, thickness = 2, arrow = {Arrow.Filled, Arrow.Filled}), Line(origin = {-29, -30}, points = {{-21, 0}, {19, 0}}, color = {0, 0, 255}, thickness = 2, arrow = {Arrow.Filled, Arrow.Filled}), Line(origin = {-29, -10}, points = {{-21, 0}, {19, 0}}, color = {0, 0, 255}, thickness = 2, arrow = {Arrow.Filled, Arrow.Filled}), Line(origin = {-29, 10}, points = {{-21, 0}, {19, 0}}, color = {0, 0, 255}, thickness = 2, arrow = {Arrow.Filled, Arrow.Filled}), Line(origin = {-29, -70}, points = {{-21, 0}, {19, 0}}, color = {0, 0, 255}, thickness = 2, arrow = {Arrow.Filled, Arrow.Filled})}, coordinateSystem(initialScale = 0.1)),
    experiment(StartTime = 0, StopTime = 3600, Tolerance = 1e-06, Interval = 3.6));
end dropwiseCondensation;
