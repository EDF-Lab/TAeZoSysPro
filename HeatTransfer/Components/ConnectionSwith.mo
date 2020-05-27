within TAeZoSysPro.HeatTransfer.Components;

model ConnectionSwith
  Modelica.Blocks.Interfaces.BooleanInput Control annotation(
    Placement(visible = true, transformation(origin = { 0, 100}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {0, 100}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a annotation(
    Placement(visible = true, transformation(origin = {-99, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-102, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port_b1 annotation(
    Placement(visible = true, transformation(origin = {98, 64}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port_b2 annotation(
    Placement(visible = true, transformation(origin = {98, -62}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {98, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation

  if Control == true  then /* port_a is connected to port_b1, port_b2 has a zero flow equation */
    port_b1.T = port_a.T;
    port_b1.Q_flow + port_a.Q_flow = 0.0;
    port_b2.Q_flow = 0;
    
  else /* port_a is connected to port_b2, port_b1 has a zero flow equation */
    port_b2.T = port_a.T;
    port_b2.Q_flow + port_a.Q_flow = 0.0;
    port_b1.Q_flow = 0;
  
end if ;

  annotation(
    Documentation(info = "
<html>
  <head>
    <title>ConnectionSwith</title>
  </head>
	
  <body lang=\"en-UK\">
	
    <p>
      This module allows a dynamic connection between heartports. 
      If the boolean input <b>Control</b> is set to true, <b>port_a</b> is connnected to <b>port_b1</b> and <b>port_b2</b> otherwise. 
      The <b>port_b1</b> or <b>port_b2</b> which is not connected becomes adiabatic (its <b>Q_flow</b>	variable is set to 0). 
      Therefore and to achieved the correct number of independant equations, alls the port have to be connected. </br>
      The connection has only as role to allow heat flow exchange.
    </p>
		
    <p>
      As example, this module is used with the CabinetPower module where the <b>port_a</b> the the CabinetConnector is connected to the <b>hood</b> of the CabinetPower. 
      If the hood is swithed off, the heat from the cabinet is released to the surrounding air. 
      To that is requires a dynamic	connection with either the hood and the surrounding air.			
    </p>
		
  </body>
</html>"),
    Diagram(coordinateSystem(grid = {1, 1})),
    Icon(graphics = {Rectangle(origin = {0, 1}, lineThickness = 1, extent = {{-100, 99}, {100, -101}}), Line(origin = {-58.6794, -0.73282}, points = {{-37, 0}, {11, 0}}, color = {255, 0, 0}, thickness = 1), Ellipse(origin = {-44, 0}, fillColor = {255, 0, 0}, fillPattern = FillPattern.Solid, lineThickness = 1, extent = {{2, -2}, {-2, 2}}, endAngle = 360), Ellipse(origin = {40, 50}, fillColor = {255, 0, 0}, fillPattern = FillPattern.Solid, lineThickness = 1, extent = {{2, -2}, {-2, 2}}, endAngle = 360), Line(origin = {68, 50}, points = {{-28, 0}, {28, 0}, {28, 0}}, color = {255, 0, 0}, thickness = 1), Line(origin = {-1, 10}, points = {{-43, -10}, {37, 40}}, color = {255, 0, 0}, thickness = 1), Line(origin = {0, 15.5}, points = {{0, 64.5}, {0, 12.5}, {0, 28.5}}, color = {255, 0, 255}, thickness = 1), Text(origin = {61, 60}, lineThickness = 1, extent = {{35, 20}, {-45, 0}}, textString = "Control = true"), Ellipse(origin = {40, -50}, fillColor = {255, 0, 0}, fillPattern = FillPattern.Solid, lineThickness = 1, extent = {{2, -2}, {-2, 2}}, endAngle = 360), Line(origin = {68.3817, -50.3206}, points = {{-28, 0}, {28, 0}, {28, 0}}, color = {255, 0, 0}, thickness = 1), Text(origin = {61, -78}, lineThickness = 1, extent = {{35, 20}, {-45, 0}}, textString = "Control = false"), Text(origin = {-35, 80}, lineColor = {255, 0, 255}, fillColor = {255, 0, 255}, lineThickness = 1, extent = {{35, 20}, {-45, 0}}, textString = "Control")}, coordinateSystem(initialScale = 0.1)));
end ConnectionSwith;
