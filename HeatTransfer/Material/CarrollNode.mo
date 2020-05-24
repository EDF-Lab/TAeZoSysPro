within TAeZoSysPro.HeatTransfer.Material;

model CarrollNode
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a annotation(
    Placement(visible = true, transformation(origin = {2, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  port_a.Q_flow = 0;
  annotation(
    Diagram(coordinateSystem(grid = {1, 2})),
    Icon(graphics = {Ellipse(lineColor = {255, 0, 0}, extent = {{-75, -75}, {75, 75}}, endAngle = 360), Ellipse(lineColor = {255, 0, 0}, lineThickness = 1, extent = {{-60, -60}, {60, 60}}, endAngle = 360), Ellipse(lineColor = {255, 0, 0}, lineThickness = 1.75, extent = {{-45, -45}, {45, 45}}, endAngle = 360), Line(origin = {-20, 20}, rotation = 45, points = {{0, 9}, {0, -9}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.Filled, Arrow.Filled}), Line(origin = {20, 20}, rotation = -45, points = {{0, 9}, {0, -9}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.Filled, Arrow.Filled}), Line(origin = {20, -20}, rotation = 225, points = {{0, 9}, {0, -9}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.Filled, Arrow.Filled}), Line(origin = {-20, -20}, rotation = 135, points = {{0, 9}, {0, -9}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.Filled, Arrow.Filled})}, coordinateSystem(initialScale = 0.1)));
end CarrollNode;
