within TAeZoSysPro.HeatTransfer.Utilities;

model ThreeWaysDamper
  Modelica.Blocks.Interfaces.RealOutput wayOutletA annotation(
    Placement(visible = true, transformation(origin = {104, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100.5, -0.5}, extent = {{-19.5, -19.5}, {19.5, 19.5}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput wayOutletB annotation(
    Placement(visible = true, transformation(origin = {-4, -88}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-1.42109e-14, -100}, extent = {{-19, -19}, {19, 19}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput wayInlet annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-101, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput ratioInletToWayB annotation(
    Placement(visible = true, transformation(origin = {-4, 78}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {0, 94}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
equation
  wayOutletA = (1 - ratioInletToWayB) * wayInlet;
  wayOutletB = ratioInletToWayB * wayInlet;
  annotation(
    Icon(graphics = {Text(origin = {31, -90}, extent = {{-13, 6}, {13, -6}}, textString = "WayB",  fontSize = 0 ), Polygon(origin = {-15.15, 68}, fillPattern = FillPattern.Solid, points = {{-49.8536, -42}, {-49.8536, -100}, {15.1464, -68}, {-49.8536, -42}}), Polygon(origin = {14.8536, -68}, rotation = 180, points = {{-49.8536, -42}, {-49.8536, -100}, {15.1464, -68}, {-49.8536, -42}}), Polygon(origin = {-68.1464, -15}, rotation = 90, points = {{-49.8536, -42}, {-49.8536, -100}, {15.1464, -68}, {-49.8536, -42}}), Line(origin = {-81.5, 25.5}, points = {{16.5, -25.5}, {-0.5, -25.5}}, thickness = 2), Line(origin = {25.5, -65.5}, rotation = -90, points = {{16.5, -25.5}, {-0.5, -25.5}}, thickness = 2), Line(origin = {65.5, 25.5}, points = {{16.5, -25.5}, {-0.5, -25.5}}, thickness = 2), Rectangle(origin = {0, 51.5}, lineThickness = 1, extent = {{-20, 14.5}, {20, -14.5}}), Line(origin = {0, 36}, points = {{0, 1}, {0, -36}}, thickness = 1), Text(origin = {84, 33}, extent = {{-13, 6}, {13, -6}}, textString = "WayA",  fontSize = 0 ), Text(origin = {-81, 32}, extent = {{-13, 6}, {13, -6}}, textString = "Inlet",  fontSize = 0 )}, coordinateSystem(grid = {1, 1}, initialScale = 0.1)),
    __OpenModelica_commandLineOptions = "",
    Diagram(coordinateSystem(grid = {1, 1}, initialScale = 0.1)));
end ThreeWaysDamper;
