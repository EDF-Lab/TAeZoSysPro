within TAeZoSysPro.HeatTransfer.Sensors;

model Density "Ideal one port density sensor"
  replaceable package Medium = TAeZoSysPro.Media.MyMedia ;
  extends Modelica.Icons.RotationalSensor;
  Modelica.Blocks.Interfaces.RealOutput d(final quantity="Density",
                                          final unit="kg/m3",
                                          min=0) "Density in port medium"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  TAeZoSysPro.HeatTransfer.Interfaces.HeatPort_a port annotation(
    Placement(visible = true, transformation(origin = {0, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput p(final quantity="Absolute pressure",
                                          final unit="Pa",
                                          min=0) "Absolute pressure in port medium" annotation(
    Placement(visible = true, transformation(origin = {-100, -2}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  d = Medium.density_pTX(p = p, T = port.T, X = Medium.X_default);
  port.Q_flow = 0.0 ;
annotation (
  Icon(coordinateSystem(initialScale = 0.1), graphics = {Line(points = {{0, -70}, {0, -100}}, color = {0, 0, 127}), Text(lineColor = {0, 0, 255}, extent = {{-150, 80}, {150, 120}}, textString = "%name"), Text(origin = {4, 2},extent = {{156, -23}, {56, -61}}, textString = "d"), Line(points = {{70, 0}, {100, 0}}, color = {0, 0, 127}), Text(origin = {-216, 82}, extent = {{156, -23}, {56, -61}}, textString = "p")}),
  Documentation(info="
<html>
  <p>
    This model outputs the density of the fluid from the port tempeature and the input of pressure.
    The sensor is ideal, i.e. it does not influence the fluid.
  </p>
</html>"),
  Diagram(coordinateSystem(initialScale = 0.1)));
end Density;
