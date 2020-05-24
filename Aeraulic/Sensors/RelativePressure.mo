within TAeZoSysPro.Aeraulic.Sensors;

model RelativePressure "Ideal relative pressure sensor"
  extends Sensors.BasesClasses.PartialRelativeSensor;

  Modelica.Blocks.Interfaces.RealOutput p_rel(final quantity="Pressure",
                                              final unit="Pa",
                                              displayUnit="bar")
    "Relative pressure signal" annotation (Placement(transformation(
        origin={0,-90},
        extent={{10,-10},{-10,10}},
        rotation=90)));
equation

  // Relative pressure
  p_rel = port_a.p - port_b.p;
  annotation (
    Icon(graphics={
        Line(points={{0,-30},{0,-80}}, color={0,0,127}),
        Text(
          extent={{130,-70},{4,-100}},
          lineColor={0,0,0},
          textString="p_rel")}),
    Documentation(info="<html>
<p>
The relative pressure \"port_a.p - port_b.p\" is determined between
the two ports of this component and is provided as output signal. The
sensor should be connected in parallel with other equipment, no flow
through the sensor is allowed.
</p>
</html>"));
end RelativePressure;
