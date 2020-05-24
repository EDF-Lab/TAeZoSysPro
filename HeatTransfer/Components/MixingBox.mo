within TAeZoSysPro.HeatTransfer.Components;

model MixingBox
  replaceable package Medium = Modelica.Media.Air.ReferenceAir.Air_pT;
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a WayA annotation(
    Placement(visible = true, transformation(origin = {-93, 35}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-86, 1}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a WayB annotation(
    Placement(visible = true, transformation(origin = {31, -54}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {18, -62}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b Outlet annotation(
    Placement(visible = true, transformation(origin = {94, 25}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {86, 1}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput WayA_MassFlow annotation(
    Placement(visible = true, transformation(origin = {-92, 4}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-85, 37}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput WayB_MassFlow annotation(
    Placement(visible = true, transformation(origin = {-25, -77}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-17, -62}, extent = {{-10, 10}, {10, -10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput Outlet_MassFlow annotation(
    Placement(visible = true, transformation(origin = {84, 1}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {86, 41}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.SIunits.SpecificHeatCapacity cpWayA;
  Modelica.SIunits.SpecificHeatCapacity cpWayB;
  Modelica.SIunits.Temperature Tmix "mixing temperature";
protected
  Medium.ThermodynamicState stateWayA;
  Medium.ThermodynamicState stateWayB;
equation
  stateWayA = Medium.setState_pTX(p = Medium.reference_p, T = WayA.T);
  stateWayB = Medium.setState_pTX(p = Medium.reference_p, T = WayB.T);
//
  cpWayA = Medium.specificHeatCapacityCp(stateWayA);
  cpWayB = Medium.specificHeatCapacityCp(stateWayB);
//
  Tmix = (WayA_MassFlow * cpWayA * WayA.T + WayB_MassFlow * cpWayB * WayB.T) / (WayA_MassFlow * cpWayA + WayB_MassFlow * cpWayB);
  Outlet.Q_flow = (WayA_MassFlow * cpWayA + WayB_MassFlow * cpWayB) * (Outlet.T - Tmix);
  Outlet_MassFlow = WayA_MassFlow + WayB_MassFlow;
//
  WayA.Q_flow = 0;
  WayB.Q_flow = 0;
  annotation(
    Icon(graphics = {Text(origin = {47, -35}, extent = {{-13, 6}, {13, -6}}, textString = "WayB",  fontSize = 0 ), Polygon(origin = {-15.15, 91}, fillColor = {255, 0, 0}, fillPattern = FillPattern.Solid, points = {{-49.8536, -40}, {-49.8536, -100}, {15.1464, -68}, {-49.8536, -40}}), Polygon(origin = {14.8536, -45}, rotation = 180, points = {{-49.8536, -36}, {-49.8536, -96}, {15.1464, -68}, {-49.8536, -36}}), Polygon(origin = {-68.15, 8}, rotation = 90, fillColor = {255, 0, 0}, fillPattern = FillPattern.Solid, points = {{-49.8536, -42}, {-49.8536, -96}, {15.1464, -68}, {-49.8536, -42}}), Line(origin = {-81.5, 48.5}, points = {{16.5, -25.5}, {-0.5, -25.5}}, thickness = 2), Line(origin = {25.5, -42.5}, rotation = -90, points = {{16.5, -25.5}, {-0.5, -25.5}}, thickness = 2), Line(origin = {65.5, 48.5}, points = {{16.5, -25.5}, {-0.5, -25.5}}, thickness = 2), Text(origin = {-82, 60}, extent = {{-13, 6}, {13, -6}}, textString = "WayA",  fontSize = 0 ), Text(origin = {82, 59}, extent = {{-13, 6}, {13, -6}}, textString = "Outlet",  fontSize = 0 ), Line(origin = {-31.5, 48}, points = {{-15.5, 0}, {15.5, 0}}, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {23.5, 48}, points = {{-15.5, 0}, {15.5, 0}}, arrow = {Arrow.None, Arrow.Filled}), Text(origin = {56.5, 93}, lineThickness = 0.5, extent = {{-16.5, 8}, {16.5, -8}}, textString = "KURY - EDVANCE",  fontSize = 0 ), Line(origin = {-33.5535, -25.5497}, rotation = 90, points = {{-15.5, 0}, {15.5, 0}}, arrow = {Arrow.None, Arrow.Filled})}, coordinateSystem(grid = {1, 1}, initialScale = 0.1)),
    __OpenModelica_commandLineOptions = "",
    Diagram(coordinateSystem(grid = {1, 1}, initialScale = 0.1)));
end MixingBox;
