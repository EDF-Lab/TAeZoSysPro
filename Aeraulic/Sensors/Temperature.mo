within TAeZoSysPro.Aeraulic.Sensors;

model Temperature "Ideal one port temperature sensor"
  replaceable package Medium = Media.MyMedia;
  Interfaces.FlowPort_a port(replaceable package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {0, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput T(final quantity = "ThermodynamicTemperature", final unit = "K", displayUnit = "degC", min = 0) "Temperature in port medium" annotation(
    Placement(transformation(extent = {{60, -10}, {80, 10}})));
equation
  T = port.T;
  port.m_flow = fill(0.0, Medium.nX);
  port.H_flow = 0;
  annotation(
    defaultComponentName = "temperature",
    Documentation(info = "<html>
<p>
This component monitors the temperature of the fluid passing its port.
The sensor is ideal, i.e., it does not influence the fluid.
</p>
</html>"),
    Diagram(graphics = {Line(points = {{0, -70}, {0, -100}}, color = {0, 0, 127}), Ellipse(fillColor = {191, 0, 0}, fillPattern = FillPattern.Solid, lineThickness = 0.5, extent = {{-20, -98}, {20, -60}}, endAngle = 360), Rectangle(lineColor = {191, 0, 0}, fillColor = {191, 0, 0}, fillPattern = FillPattern.Solid, extent = {{-12, 40}, {12, -68}}), Polygon(lineThickness = 0.5, points = {{-12, 40}, {-12, 80}, {-10, 86}, {-6, 88}, {0, 90}, {6, 88}, {10, 86}, {12, 80}, {12, 40}, {-12, 40}}), Line(points = {{-12, 40}, {-12, -64}}, thickness = 0.5), Line(points = {{12, 40}, {12, -64}}, thickness = 0.5), Line(points = {{-40, -20}, {-12, -20}}), Line(points = {{-40, 20}, {-12, 20}}), Line(points = {{-40, 60}, {-12, 60}}), Line(points = {{12, 0}, {60, 0}}, color = {0, 0, 127})}),
    Icon(graphics = {Ellipse(fillColor = {191, 0, 0}, fillPattern = FillPattern.Solid, lineThickness = 0.5, extent = {{-20, -88}, {20, -50}}, endAngle = 360), Rectangle(lineColor = {191, 0, 0}, fillColor = {191, 0, 0}, fillPattern = FillPattern.Solid, extent = {{-12, 50}, {12, -58}}), Polygon(lineThickness = 0.5, points = {{-12, 50}, {-12, 90}, {-10, 96}, {-6, 98}, {0, 100}, {6, 98}, {10, 96}, {12, 90}, {12, 50}, {-12, 50}}), Line(points = {{-12, 50}, {-12, -54}}, thickness = 0.5), Line(points = {{12, 50}, {12, -54}}, thickness = 0.5), Line(points = {{-40, -10}, {-12, -10}}), Line(points = {{-40, 30}, {-12, 30}}), Line(points = {{-40, 70}, {-12, 70}}), Text(extent = {{126, -30}, {6, -60}}, textString = "T"), Text(lineColor = {0, 0, 255}, extent = {{-150, 110}, {150, 150}}, textString = "%name"), Line(points = {{12, 0}, {60, 0}}, color = {0, 0, 127})}),
    __OpenModelica_commandLineOptions = "");
end Temperature;
