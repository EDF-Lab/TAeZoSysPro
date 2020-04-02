within TAeZoSysPro.HeatTransfer.BasesClasses;

model CarrollNode

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a annotation(
    Placement(visible = true, transformation(origin = {2, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation

  port_a.Q_flow = 0;
  
  annotation(
    Diagram(coordinateSystem(grid = {2, 2})),
    Icon(graphics = {Ellipse(lineColor = {255, 0, 0}, extent = {{-99, -99}, {99, 99}}, endAngle = 360), Ellipse(lineColor = {255, 0, 0}, lineThickness = 1, extent = {{-80, -80}, {80, 80}}, endAngle = 360), Ellipse(lineColor = {255, 0, 0}, lineThickness = 1.75, extent = {{-51, -51}, {51, 51}}, endAngle = 360), Line(origin = {-20, 20}, rotation = 45, points = {{0, 9}, {0, -9}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.Filled, Arrow.Filled}), Line(origin = {20, 19.6794}, rotation = -45, points = {{0, 9}, {0, -9}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.Filled, Arrow.Filled}), Line(origin = {20, -20}, rotation = 225, points = {{0, 9}, {0, -9}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.Filled, Arrow.Filled}), Line(origin = {-20.3206, -20.9618}, rotation = 135, points = {{0, 9}, {0, -9}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.Filled, Arrow.Filled})}, coordinateSystem(initialScale = 0.1)),
    Documentation(info="
<html>
  <head>
    <title>CarrollNode</title>		
  </head>
	
  <body lang=\"en-UK\">
    <p>
      The <b>CarrollNode</b> is a composant only used for a better graphical representation. 
      With the carroll method to treat radiative exchanges, all the surfaces exchange with a fictive node (see figure bellow).
      To avoid to connect all the <b>CarrollRadiation</b> modules together to get the ficitve node, there are all connected to the CarrollNode module. 
      It is less confusing for the understanding of the user than multiple graphical connections everywhere. </br>
      By flow conservation, this node has a zero flow balance at its heat port. 
      Therefore, the temperature of its heat port is the Mean Radiant Temperature (MRT). 
      This node corresponds to the 'Jmrt' point on the figure bellow (picked up from the FviewCalculator description) </br>  
    </p>
    		
    <img	
      src=\"modelica://TAeZoSysPro/Information/HeatTransfer/BasesClasses/FIG_FviewCalculator.PNG\"
      width = \"600\"
    />
    								
  </body>
</html>") );

end CarrollNode;
