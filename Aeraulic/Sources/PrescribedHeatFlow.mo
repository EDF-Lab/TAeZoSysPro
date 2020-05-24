within TAeZoSysPro.Aeraulic.Sources;

model PrescribedHeatFlow "Prescribed heat flow boundary condition"
  Modelica.Blocks.Interfaces.RealInput Q_flow(unit = "W") annotation(
    Placement(transformation(origin = {-100, 0}, extent = {{20, -20}, {-20, 20}}, rotation = 180)));
  Interfaces.FlowPort_b port(replaceable package Medium = Media.MyMedia) annotation(
    Placement(transformation(extent = {{90, -10}, {110, 10}})));
equation
  port.H_flow = -Q_flow;
  port.m_flow = fill(0.0, port.Medium.nX) annotation(
    Icon(coordinateSystem(preserveAspectRatio = true, extent = {{-100, -100}, {100, 100}}), graphics = {Line(points = {{-60, -20}, {40, -20}}, color = {191, 0, 0}, thickness = 0.5), Line(points = {{-60, 20}, {40, 20}}, color = {191, 0, 0}, thickness = 0.5), Line(points = {{-80, 0}, {-60, -20}}, color = {191, 0, 0}, thickness = 0.5), Line(points = {{-80, 0}, {-60, 20}}, color = {191, 0, 0}, thickness = 0.5), Polygon(points = {{40, 0}, {40, 40}, {70, 20}, {40, 0}}, lineColor = {191, 0, 0}, fillColor = {191, 0, 0}, fillPattern = FillPattern.Solid), Polygon(points = {{40, -40}, {40, 0}, {70, -20}, {40, -40}}, lineColor = {191, 0, 0}, fillColor = {191, 0, 0}, fillPattern = FillPattern.Solid), Rectangle(extent = {{70, 40}, {90, -40}}, lineColor = {191, 0, 0}, fillColor = {191, 0, 0}, fillPattern = FillPattern.Solid), Text(extent = {{-150, 100}, {150, 60}}, textString = "%name", lineColor = {0, 0, 255})}),
    Documentation(info = "<html>
<p>
This model allows a specified amount of heat flow rate to be \"injected\"
into a thermal system at a given port.  The amount of heat
is given by the input signal Q_flow into the model. The heat flows into the
component to which the component PrescribedHeatFlow is connected,
if the input signal is positive.
</p>

</html>"),
    Diagram(coordinateSystem(preserveAspectRatio = true, extent = {{-100, -100}, {100, 100}}), graphics = {Line(points = {{-60, -20}, {68, -20}}, color = {191, 0, 0}, thickness = 0.5), Line(points = {{-60, 20}, {68, 20}}, color = {191, 0, 0}, thickness = 0.5), Line(points = {{-80, 0}, {-60, -20}}, color = {191, 0, 0}, thickness = 0.5), Line(points = {{-80, 0}, {-60, 20}}, color = {191, 0, 0}, thickness = 0.5), Polygon(points = {{60, 0}, {60, 40}, {90, 20}, {60, 0}}, lineColor = {191, 0, 0}, fillColor = {191, 0, 0}, fillPattern = FillPattern.Solid), Polygon(points = {{60, -40}, {60, 0}, {90, -20}, {60, -40}}, lineColor = {191, 0, 0}, fillColor = {191, 0, 0}, fillPattern = FillPattern.Solid)}));
  annotation(
    Diagram(coordinateSystem(initialScale = 0.1), graphics = {Line(origin = {-11.2, 10.8}, points = {{-68.7964, -10.7964}, {-50.7964, 11.2036}, {69.2036, 11.2036}}, color = {255, 0, 0}, thickness = 0.5), Polygon(origin = {70.76, 22}, lineColor = {255, 0, 0}, fillColor = {255, 0, 0}, fillPattern = FillPattern.Solid, points = {{-12.762, 16}, {-12.762, -16}, {13.238, 0}, {-12.762, 16}}), Line(origin = {-11.1, -7.89}, points = {{-68.8969, 7.88639}, {-50.8969, -14.1136}, {69.1031, -14.1136}}, color = {255, 0, 0}, thickness = 0.5), Polygon(origin = {70.76, -22}, lineColor = {255, 0, 0}, fillColor = {255, 0, 0}, fillPattern = FillPattern.Solid, lineThickness = 0.5, points = {{-12.762, 16}, {-12.762, -16}, {13.238, 0}, {-12.762, 16}})}),
    Icon(coordinateSystem(initialScale = 0.1), graphics = {Line(origin = {-20.19, 13.81}, points = {{-59.809, -13.809}, {-41.809, 14.191}, {68.191, 14.191}}, color = {255, 0, 0}, thickness = 0.5), Polygon(origin = {58.77, 26}, lineColor = {255, 0, 0}, fillColor = {255, 0, 0}, fillPattern = FillPattern.Solid, points = {{-10.7684, 16}, {-10.7684, -12}, {13.2316, 2}, {-10.7684, 16}}), Line(origin = {-21.04, -6.81}, points = {{-58.9636, 6.80638}, {-40.9636, -21.1936}, {69.0364, -21.1936}}, color = {255, 0, 0}, thickness = 0.5), Polygon(origin = {58.77, -30}, lineColor = {255, 0, 0}, fillColor = {255, 0, 0}, fillPattern = FillPattern.Solid, points = {{-10.7684, 16}, {-10.7684, -12}, {13.2316, 2}, {-10.7684, 16}}), Rectangle(origin = {81, 0}, lineColor = {255, 0, 0}, fillColor = {255, 0, 0}, fillPattern = FillPattern.Solid, lineThickness = 0.5, extent = {{-9, 46}, {9, -46}})}));
end PrescribedHeatFlow;
