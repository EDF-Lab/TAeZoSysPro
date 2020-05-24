within TAeZoSysPro.Aeraulic.Sensors.BasesClasses;

model PartialRelativeSensor
  "Partial component to model a sensor that measures the difference between two potential variables"
  extends Modelica.Icons.TranslationalSensor;
  replaceable package Medium =
    Modelica.Media.Interfaces.PartialMedium "Medium in the sensor"  annotation (
      choicesAllMatching = true);

  Modelica.Fluid.Interfaces.FluidPort_a port_a(m_flow(min=0),
                                redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(m_flow(min=0),
                                redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{110,-12},{90,8}}), iconTransformation(extent={{110,-10},{90,10}})));

equation
  // Zero flow equations for connectors
  port_a.m_flow = 0;
  port_b.m_flow = 0;

  // No contribution of specific quantities
  port_a.h_outflow = Medium.h_default;
  port_b.h_outflow = Medium.h_default;
  port_a.Xi_outflow = Medium.X_default[1:Medium.nXi];
  port_b.Xi_outflow = Medium.X_default[1:Medium.nXi];
  //port_a.C_outflow  = zeros(Medium.nC);
  //port_b.C_outflow  = zeros(Medium.nC);

  annotation (
    Icon(graphics={
        Line(points={{-100,0},{-70,0}}, color={0,127,255}),
        Line(points={{70,0},{100,0}}, color={0,127,255}),
        Text(
          extent={{-150,40},{150,80}},
          textString="%name",
          lineColor={0,0,255}),
        Line(
          points={{32,3},{-58,3}},
          color={0,128,255}),
        Polygon(
          points={{22,18},{62,3},{22,-12},{22,18}},
          lineColor={0,128,255},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid)}),
    Documentation(info="<html>
<p>
The relative pressure \"port_a.p - port_b.p\" is determined between
the two ports of this component and is provided as output signal. The
sensor should be connected in parallel with other equipment, no flow
through the sensor is allowed.
</p>
</html>"));
end PartialRelativeSensor;
