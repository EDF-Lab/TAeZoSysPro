within TAeZoSysPro.HeatTransfer.Interfaces;

connector RealVectorInput = input Real "Real input connector used for vector of connectors" annotation(
  defaultComponentName = "u",
  Icon(graphics = {Ellipse(lineColor = {0, 0, 127}, fillColor = {0, 0, 127}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}, endAngle = 360)}),
  Diagram(graphics = {Text(lineColor = {0, 0, 127}, extent = {{-10, 85}, {-10, 60}}, textString = "%name"), Ellipse(lineColor = {0, 0, 127}, fillColor = {0, 0, 127}, fillPattern = FillPattern.Solid, extent = {{-50, 50}, {50, -50}}, endAngle = 360)}),
  Documentation(info = "<html>
<p>
Real input connector that is used for a vector of connectors,
for example <a href=\"modelica://Modelica.Blocks.Interfaces.PartialRealMISO\">PartialRealMISO</a>,
and has therefore a different icon as RealInput connector.
</p>
</html>"),
  __OpenModelica_commandLineOptions = "");
