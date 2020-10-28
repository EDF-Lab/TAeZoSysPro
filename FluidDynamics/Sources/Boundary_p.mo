within TAeZoSysPro.FluidDynamics.Sources;

model Boundary_p "Boundary with prescribed pressure"
  replaceable package Medium = Modelica.Media.Water.WaterIF97_ph 
    "Medium model within the source" annotation (choicesAllMatching=true);
  parameter Integer nPorts=0 "Number of ports" annotation(Dialog(connectorSizing=true));
  parameter Boolean use_p_in = false
    "Get the pressure from the input connector"
    annotation(Evaluate=true, HideResult=true, choices(checkBox=true));
  parameter Medium.AbsolutePressure p = Medium.p_default
    "Fixed value of pressure"
    annotation (Dialog(enable = not use_p_in));
  Modelica.Blocks.Interfaces.RealInput p_in if use_p_in
    "Prescribed boundary pressure" annotation (
    Placement(visible = true, transformation(extent = {{-140, 60}, {-100, 100}}, rotation = 0), iconTransformation(extent = {{-140, -18}, {-100, 22}}, rotation = 0)));

  Modelica.Fluid.Interfaces.FluidPorts_b ports[nPorts](
    redeclare each package Medium = Medium) annotation(
    Placement(transformation(extent={{90,40},{110,-40}})));

protected
  Modelica.Blocks.Interfaces.RealInput p_in_internal
    "Needed to connect to conditional connector";

equation
  connect(p_in, p_in_internal);
  if not use_p_in then
    p_in_internal = p;
  end if;
  for i in 1:nPorts loop
     ports[i].p          = p_in_internal;
     ports[i].m_flow     = 0.0;
     ports[i].h_outflow  = inStream(ports[i].h_outflow);
     ports[i].Xi_outflow = inStream(ports[i].Xi_outflow);
     ports[i].C_outflow  = inStream(ports[i].C_outflow);
  end for;

  annotation (defaultComponentName="boundary_p", 
    Documentation(info="<html>
<p>
Component to set the pressure at ports. The m_flow is set to zero. The 'outflow' properties are set to 'inStream' properties.
</p>
<p>
This component is mainly used to set the pressure of a liquid node
</p>

</html>"),
    Icon(coordinateSystem(
            preserveAspectRatio=true,
            extent={{-100,-100},{100,100}}), graphics={Ellipse(fillColor = {0, 127, 255}, fillPattern = FillPattern.Sphere, extent = {{-100, 100}, {100, -100}}, endAngle = 360),
            Text(lineColor = {0, 0, 255}, extent = {{-150, 120}, {150, 160}}, textString = "%name"),
            Text(origin = {-4, -72},extent = {{-152, 134}, {-68, 94}}, textString = "p")}));
end Boundary_p;
