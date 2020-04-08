within TAeZoSysPro.HeatTransfer.Components;

block FviewCalculator
  
  parameter Integer N = 3 ;
  Modelica.Blocks.Interfaces.RealVectorInput A_wall[N] annotation(
      Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-100, -4}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealVectorOutput[N] F_view annotation(
      Placement(visible = true, transformation(origin = {100, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
equation
  
  when initial() then
    if N==2 then // face to face surfaces
      F_view = fill(min(A_wall)*1*(1/A_wall[1] + 1/A_wall[2]), 2) ;
    else
      F_view = Functions.fviewFunction(A_wall) ;
    end if ;
      
  end when ;
  
  annotation(Diagram(coordinateSystem(grid = {2, 2})),
           Icon(graphics = {Ellipse(origin = {0, -2}, lineColor = {0, 0, 127}, fillColor = {0, 0, 127}, fillPattern = FillPattern.Solid, lineThickness = 1, extent = {{-15, -15}, {15, 15}}, endAngle = 360), Line(origin = {-50, 45}, points = {{-50, 45}, {50, -45}}, color = {0, 0, 127}, thickness = 1), Line(origin = {-50, 29}, points = {{-50, 29}, {50, -29}}, color = {0, 0, 127}, thickness = 1), Line(origin = {-50, 14}, points = {{-50, 14}, {50, -14}}, color = {0, 0, 127}, thickness = 1), Line(origin = {-50, -1}, points = {{-50, -1}, {50, 1}}, color = {0, 0, 127}, thickness = 1), Line(origin = {-50, -45}, points = {{-50, -45}, {50, 45}, {50, 45}}, color = {0, 0, 127}, thickness = 1), Line(origin = {-50.42, -31.19}, points = {{-49.575, -30.8116}, {50.425, 31.1884}, {48.425, 31.1884}}, color = {0, 0, 127}, thickness = 1), Line(origin = {-50, -16}, points = {{-50, -16}, {50, 16}}, color = {0, 0, 127}, thickness = 1), Line(origin = {40, 46}, points = {{-40, -46}, {60, 46}}, color = {0, 0, 127}, thickness = 1), Line(origin = {40, 29}, points = {{-40, -29}, {60, 31}}, color = {0, 0, 127}, thickness = 1), Line(origin = {38.53, 13.84}, points = {{-40.5268, -13.8396}, {61.4732, 14.1604}, {61.4732, 14.1604}}, color = {0, 0, 127}, thickness = 1), Line(origin = {40, -1}, points = {{-40, 1}, {60, -1}}, color = {0, 0, 127}, thickness = 1), Line(origin = {40, -16}, points = {{-40, 16}, {60, -16}, {60, -16}}, color = {0, 0, 127}, thickness = 1), Line(origin = {40.65, -31.69}, points = {{-40.6518, 31.6924}, {59.3482, -30.3076}, {59.3482, -30.3076}}, color = {0, 0, 127}, thickness = 1), Line(origin = {41, -46}, points = {{-41, 46}, {59, -46}}, color = {0, 0, 127}, thickness = 1), Rectangle(lineColor = {0, 0, 127}, lineThickness = 1, extent = {{-100, 100}, {100, -100}}), Text(origin = {17, -62}, lineThickness = 1, extent = {{-71, -38}, {45, 18}}, textString = "View Factor", fontSize = 15), Text(origin = {-79, 52}, lineThickness = 1, extent = {{-67, -38}, {-17, -14}}, textString = "Awall", fontSize = 12), Text(origin = {165, 56}, lineThickness = 1, extent = {{-67, -38}, {-17, -14}}, textString = "Fview", fontSize = 12)}, coordinateSystem(initialScale = 0.1)),
           Documentation(info = "
<html>
  <head>
    <title>FviewCalculator</title>
	<style type=\"text/css\">
		*       { font-size: 10pt; font-family: Arial,sans-serif; }
		code    { font-size:  9pt; font-family: Courier,monospace;}
		h6      { font-size: 10pt; font-weight: bold; color: green; }
		h5      { font-size: 11pt; font-weight: bold; color: green; }
		h4      { font-size: 13pt; font-weight: bold; color: green; }
		address {                  font-weight: normal}
		td      { solid #000; vertical-align:top; }
		th      { solid #000; vertical-align:top; font-weight: bold; }
		table   { solid #000; border-collapse: collapse;}
    </style>
		
  </head>
	
  <body lang=\"en-UK\">
    <p>
      This components computes the view factor (or called form factor) from the input Areas and with the Carrol's method. 
      To summarize, this method allows to calculate the value of the view factor without knowing the detailed geometry (civil work) but just with the knowing of the value of all the areas. 
      The Carroll's method requires the following hypotheses:
      
      <ul>
        <li> All surfaces are visible to each other (see theoretical note for details) </li>
        <li> A surface area does not have to theorically exceed 50% of the total area. In the module, the value of 48% is used rather than 50% as margin </li>
      </ul>
      
      This last assumption is impossible to verify when there are only two surfaces. 
      Therefore an other method than the Carroll node is used and detailed bellow:
    </p>

    <p>			
      <h5> When the total number of surface ≥ 3 </h5>
    </p>
    
    <p>			
      The Carroll's method assumes that all the surface does not exchange between them, but only with a fictional node called the Carroll's Node. 
      The following figure allow to visualize the change in the representation of the problem for three surfaces (The left scheme is the classical scheme and the right is the carroll's scheme where MRT means the Mean Radiant Temperature).
    </p>
    
    <img	
      src=\"modelica://TAeZoSysPro/Information/HeatTransfer/Components/FIG_FviewCalculator.PNG\"	width = \"600\"
    /> 

    <p>			 
      The formula of the F_view factor derives to an heuristic relation: <br/>
    </p>
    			
    <img	
      src=\"modelica://TAeZoSysPro/Information/HeatTransfer/Components/EQ_FviewCalculator.PNG\"	
    />
		
    <p>		
      <h5> When the total number of surface = 2 </h5>
    </p>

    <p>    			
      It is considered face to face surfaces where the real fview factor (f<sub>a->b</sub>) of the smallest surface is one. 
      Therefore the calculation of the fview factor for the carrol node components derives: <br/>
    </p>
    
    <img	
      src=\"modelica://TAeZoSysPro/Information/HeatTransfer/Components/EQ_FviewCalculator2.PNG\"	
    />			
					
    <p>
      <b>Where :</b>
      <ul>
        <li> F_view<sub>i or k</sub> is a view factor
        <li> A_wall<sub>i or k</sub> is a surface area </li>
      </ul>
    </p>

    <p>
      This heuristic relation is solved iteratively within the embedded function <b>fviewFunction</b>. 
      The convergence criteria (the value of <b>tolerance</b>) is performed on the residuals wich are defined as the norm between the difference vector Fview at iteration N and iteration N-1.
    </p>		
			
	</body>
</html> "),defaultComponentPrefixes="inner",
           defaultComponentName="fviewCalculator");

end FviewCalculator;
