within TAeZoSysPro.FluidDynamics.Components.Buildings;

model WallLeaks
  package Medium = TAeZoSysPro.Media.MyMedia;
  //
  parameter Modelica.SIunits.Area A "Wall surface area" annotation(
    Dialog(group = "Geometry"));
  parameter Real leakSurfaceRatio(min=0.0, max=1.0) = 1e-4 "ratio of leak surface m²leak / m²wall" annotation(
    Dialog(group = "Geometry"));
  //
  parameter Real ksi(min=1.0) = 1.0 "dynamic pressure loss" annotation(
    Dialog(group = "Flow"));
  parameter Real leakExponent = 1.35 "Exponent for Behavior model of the leak" annotation(
    Dialog(group = "Flow"));
  //
  Modelica.SIunits.PressureDifference dp;
  Modelica.SIunits.MassFlowRate m_flow "Mass flow rate through the leak(s)";
  Modelica.SIunits.Density d, d_a, d_b;
  //
  Modelica.Fluid.Interfaces.FluidPort_a port_a(replaceable package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-100, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(replaceable package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {100, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

protected 
  parameter Modelica.SIunits.PressureDifference dp_small = 0.01;

equation
//
  d_a = Medium.density_phX(p = port_a.p, 
                           h = inStream(port_a.h_outflow), 
                           X = cat(1, inStream(port_a.Xi_outflow), {1 - sum(inStream(port_a.Xi_outflow))})) ;
  
  d_b = Medium.density_phX(p = port_b.p, 
                           h = inStream(port_b.h_outflow), 
                           X = cat(1, inStream(port_b.Xi_outflow), {1 - sum(inStream(port_b.Xi_outflow))})) ;                           

// momentum balance
  dp = port_a.p - port_b.p;
  d = TAeZoSysPro.FluidDynamics.Utilities.regStep(
    x = dp, 
    x_small = dp_small, 
    y1 = d_a, 
    y2 = d_b);
  m_flow = A * leakSurfaceRatio * d * (2/(ksi*d))^(1/leakExponent) * Modelica.Fluid.Utilities.regPow(x = dp, delta = dp_small, a = leakExponent);

// port handover
  port_a.m_flow = m_flow;
  port_a.m_flow + port_b.m_flow = 0.0;
  port_a.h_outflow = inStream(port_b.h_outflow);
  port_b.h_outflow = inStream(port_a.h_outflow);
  port_a.Xi_outflow = inStream(port_b.Xi_outflow);
  port_b.Xi_outflow = inStream(port_a.Xi_outflow);
  port_a.C_outflow = inStream(port_b.C_outflow);
  port_b.C_outflow = inStream(port_a.C_outflow);
  
  annotation(
    Documentation(info=
"<html>
  <head>
    <title>WallLeaks</title>	
  </head>
	
  <body lang=\"en-UK\">
    <p>
      The leaks thought a wall can be due to holes in the wall to let equipments go through the wall(ducts, piping, cables etc) or due to a porous material. </br> 
      The more often the hole for an equipment is filled in back but it can remain non airtight. </br>
      The leaks due to the pore in the material can be negligible regarding hole to let equipments go through the wall and strongly depends on the material of the wall and the coating. 
    </p>
    
    <p>
      In this model of leaks, there is only one equation to model the behavior of the flow resistance. It is rather quadratic to the velocity for an equipment hole and linear to the velocity for the porosities.
    </p>
    
    <p>
      Therefore, in the module, the relation of the of the pressure loss is function of the kinetic energy exponent <b>leakExponent</b>.
    </p>
    
    <img	
      src=\"modelica://TAeZoSysPro/Information/FluidDynamics/Components/Buildings/EQ_WallLeak.PNG\"
    />

    <p>      
      The leak surface area is defined as a fraction of the wall surface equal to <b>leakSurfaceRatio</b>.   
    </p>
    
    <img	
      src=\"modelica://TAeZoSysPro/Information/FluidDynamics/Components/Buildings/EQ_WallLeak2.PNG\"
    />
    				
  </body>
</html>"),
    Diagram,
    Icon(graphics = {Rectangle(origin = {50, 5}, fillColor = {0, 85, 255}, fillPattern = FillPattern.HorizontalCylinder, lineThickness = 0.5, extent = {{-84, 29}, {-24, 23}}), Text(origin = {-42, 113}, lineThickness = 0.5, extent = {{-58, -13}, {142, -35}}, textString = "%name"), Rectangle(origin = {-2, 9}, fillColor = {190, 190, 190}, fillPattern = FillPattern.Cross, lineThickness = 0.5, extent = {{-32, 55}, {28, 25}}), Rectangle(origin = {-2, -27}, fillColor = {190, 190, 190}, fillPattern = FillPattern.Cross, lineThickness = 0.5, extent = {{-32, 55}, {28, 25}}), Rectangle(origin = {50, -31}, fillColor = {0, 85, 255}, fillPattern = FillPattern.HorizontalCylinder, lineThickness = 0.5, extent = {{-84, 29}, {-24, 23}}), Rectangle(origin = {50, -103}, fillColor = {0, 85, 255}, fillPattern = FillPattern.HorizontalCylinder, lineThickness = 0.5, extent = {{-84, 29}, {-24, 23}}), Rectangle(origin = {50, -67}, fillColor = {0, 85, 255}, fillPattern = FillPattern.HorizontalCylinder, lineThickness = 0.5, extent = {{-84, 29}, {-24, 23}}), Rectangle(origin = {-2, -63}, fillColor = {190, 190, 190}, fillPattern = FillPattern.Cross, lineThickness = 0.5, extent = {{-32, 55}, {28, 25}}), Rectangle(origin = {-2, -99}, fillColor = {190, 190, 190}, fillPattern = FillPattern.Cross, lineThickness = 0.5, extent = {{-32, 55}, {28, 25}}), Rectangle(origin = {-2, -135}, fillColor = {190, 190, 190}, fillPattern = FillPattern.Cross, lineThickness = 0.5, extent = {{-32, 55}, {28, 35}})}, coordinateSystem(initialScale = 0.1)),
    __OpenModelica_commandLineOptions = "");

end WallLeaks;
