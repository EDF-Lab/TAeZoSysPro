within TAeZoSysPro.Aeraulic.Interfaces;

connector FlowPort_a "Filled flow port (used upstream)"
  extends FlowPort;
  annotation(
    Documentation(info = "<html>
Same as FlowPort, but icon allows to differentiate direction of flow.
</html>"),
    Icon(coordinateSystem(initialScale = 0.1), graphics = {Rectangle(lineColor = {0, 85, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Ellipse(lineColor = {0, 0, 255}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid, extent = {{-98, 98}, {98, -98}}, endAngle = 360)}),
    Diagram(coordinateSystem(initialScale = 0.1), graphics = {Rectangle(lineColor = {0, 85, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-50, 50}, {50, -50}}), Ellipse(lineColor = {0, 0, 255}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid, extent = {{-48, 48}, {48, -48}}, endAngle = 360), Text(lineColor = {0, 0, 255}, extent = {{-100, 110}, {100, 50}}, textString = "%name")}));
end FlowPort_a;
