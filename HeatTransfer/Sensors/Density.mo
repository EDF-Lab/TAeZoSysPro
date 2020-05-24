within TAeZoSysPro.HeatTransfer.Sensors;

model Density "Ideal one port density sensor"
  extends Modelica.Icons.RotationalSensor;
  replaceable package Medium = TAeZoSysPro.HeatTransfer.Media.MyMedia "Medium in the sensor";
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port annotation(
    Placement(visible = true, transformation(origin = {-26, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, -98}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput d(final quantity = "Density", final unit = "kg/m3", displayUnit = "kg/m3", min = 0) "Density in port medium" annotation(
    Placement(transformation(extent = {{100, -10}, {120, 10}})));
equation
  d = Medium.density(Medium.setState_pTX(p = Medium.reference_p, T = port.T));
  port.Q_flow = 0;
  annotation(
    defaultComponentName = "density",
    Icon(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -100}, {100, 100}}), graphics = {Line(points = {{0, -70}, {0, -100}}, color = {0, 0, 127}), Text(extent = {{-150, 80}, {150, 120}}, textString = "%name", lineColor = {0, 0, 255}), Text(extent = {{154, -31}, {56, -61}}, lineColor = {0, 0, 0}, textString = "d"), Line(points = {{70, 0}, {100, 0}}, color = {0, 0, 127})}),
    Documentation(info = "<html>
<p>
This component monitors the density of the fluid passing its port.
The sensor is ideal, i.e., it does not influence the fluid.
</p>

</html>"));
end Density;
