within TAeZoSysPro.HeatTransfer.Components;

block FviewCalculator
  
  /******************************/
  function fviewcalculator
    input Real[:] Awall;
    output Real[:] Fview;

    protected
    Real tolerance=1e-5 "convergence criteria of residual that stops the iteration process";
    Real Fview_pre[:] "Fview at iteration N-1";
    Real AwallFviewSum "sum of the product Sk*Fk";
    Real residual "norm 2 of vector of the difference (Fview-Fview_pre)";
    Integer iter "number of iterations";
    Boolean MaxSurf "chercker that the maximal surface remain under 48% of the total surface";

  algorithm
  
    for A in Awall loop
      if A > sum(Awall)*0.48 then
        MaxSurf := true ;
      end if ;
    end for ;
 
    assert(MaxSurf,"At least one surface is greater than 48% of total surface, Fview factor not calculated\n", AssertionLevel.error);
// initialisation
    iter := 0;
    Fview := ones(size(Awall,1)) ;
    residual := 10*tolerance ;
// loop
    while residual > tolerance and iter < 1000 loop
      AwallFviewSum := 0.0;
      residual := 0.0;
      Fview_pre := Fview;
      AwallFviewSum := Awall * Fview;
      for j in 1:size(Awall, 1) loop
        Fview[j] := 1 / (1 - Fview[j] * Awall[j] / AwallFviewSum);
      end for;
      residual := Modelica.Math.Vectors.norm(v = Fview - Fview_pre, p = 2);
      iter := iter + 1;
    end while;
      
      Modelica.Utilities.Streams.print("iteration to converge on Fview: "+String(iter)) ;
      
      assert(not(iter==1000),"The convergence criteria on view factors is not achieved\n", AssertionLevel.warning);
  
  end fviewcalculator;
  /******************************/
  
  parameter Integer N = 3 ;
  Modelica.Blocks.Interfaces.RealVectorInput Awall[N] annotation(
      Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-100, -4}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealVectorOutput[N] Fview annotation(
      Placement(visible = true, transformation(origin = {100, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  equation
  
when initial() then
    if N==2 then // face to face surfaces
      Fview = fill(min(Awall)*1*(1/Awall[1] + 1/Awall[2]), 2) ;
    else
      Fview = fviewcalculator(Awall) ;
    end if ;

end when ;
  
  annotation(
    Diagram(coordinateSystem(grid = {1, 1})),
    Icon(graphics = {Ellipse(origin = {0, -2}, lineColor = {0, 0, 127}, fillColor = {0, 0, 127}, fillPattern = FillPattern.Solid, lineThickness = 1, extent = {{-15, -15}, {15, 15}}, endAngle = 360), Line(origin = {-50, 45}, points = {{-50, 45}, {50, -45}}, color = {0, 0, 127}, thickness = 1), Line(origin = {-50, 29}, points = {{-50, 29}, {50, -29}}, color = {0, 0, 127}, thickness = 1), Line(origin = {-50, 14}, points = {{-50, 14}, {50, -14}}, color = {0, 0, 127}, thickness = 1), Line(origin = {-50, -1}, points = {{-50, -1}, {50, 1}}, color = {0, 0, 127}, thickness = 1), Line(origin = {-50, -45}, points = {{-50, -45}, {50, 45}, {50, 45}}, color = {0, 0, 127}, thickness = 1), Line(origin = {-50.42, -31.19}, points = {{-49.575, -30.8116}, {50.425, 31.1884}, {48.425, 31.1884}}, color = {0, 0, 127}, thickness = 1), Line(origin = {-50, -16}, points = {{-50, -16}, {50, 16}}, color = {0, 0, 127}, thickness = 1), Line(origin = {40, 46}, points = {{-40, -46}, {60, 46}}, color = {0, 0, 127}, thickness = 1), Line(origin = {40, 29}, points = {{-40, -29}, {60, 31}}, color = {0, 0, 127}, thickness = 1), Line(origin = {38.53, 13.84}, points = {{-40.5268, -13.8396}, {61.4732, 14.1604}, {61.4732, 14.1604}}, color = {0, 0, 127}, thickness = 1), Line(origin = {40, -1}, points = {{-40, 1}, {60, -1}}, color = {0, 0, 127}, thickness = 1), Line(origin = {40, -16}, points = {{-40, 16}, {60, -16}, {60, -16}}, color = {0, 0, 127}, thickness = 1), Line(origin = {40.65, -31.69}, points = {{-40.6518, 31.6924}, {59.3482, -30.3076}, {59.3482, -30.3076}}, color = {0, 0, 127}, thickness = 1), Line(origin = {41, -46}, points = {{-41, 46}, {59, -46}}, color = {0, 0, 127}, thickness = 1), Rectangle(lineColor = {0, 0, 127}, lineThickness = 1, extent = {{-100, 100}, {100, -100}}), Text(origin = {17, -62}, lineThickness = 1, extent = {{-67, -38}, {41, 18}}, textString = "View Factor"), Text(origin = {-79, 52}, lineThickness = 1, extent = {{-67, -38}, {-17, -14}}, textString = "Awall",  fontSize = 0 ), Text(origin = {165, 56}, lineThickness = 1, extent = {{-67, -38}, {-17, -14}}, textString = "Fview",  fontSize = 0 )}, coordinateSystem(initialScale = 0.1)),
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
			This components computes the view factor (or called form factor) from the input Areas and with the Carrol's method. To summarize, this method allows to calculate the value of the view
			factor without knowing the detailed geometry (civil work) but just with the knowing of the value of all the areas. The Carrol's method requires the following hypotheses:
			<ul>
				<li> All surfaces are visible to each other (see theoretical note for details) </li>
				<li> A surface area does not have to theorically exceed 50% of the total area. In the module, the value of 48% is used rather than 50% as margin </li>
			</ul>
			This last assumption is impossible to verify for there are only two surfaces. Therefore an other method than the Carroll node is used and detailed bellow:
			
			<h5>
				when the total number of surface ≥ 3
			</h5>
			
			Carrol's method assumes that all the surface does not exchange between them, but only with a fictional node called the Carrol's Node. The following figure allow to visualize the change
			in the representation of the problem for three surfaces (The left scheme is the classical scheme and the right is the carrol's scheme where MRT means the Mean Radiant Temperature).

			<img	
				src=\"//Atlas.edf.fr/co/FiEDVANCE/190-sof-uk.020/720-TCYV.017/08 - Common Data/Modelica/03 - HTML modules description/TAeZoSysPro/HeatTransfer/Components/FIG_FviewCalculator.PNG\"	width = \"800\"
			/> <br/>
			 
			The formula of the fview factor derives to an heuristic relation: <br/>
			
			<img	
				src=\"//Atlas.edf.fr/co/FiEDVANCE/190-sof-uk.020/720-TCYV.017/08 - Common Data/Modelica/03 - HTML modules description/TAeZoSysPro/HeatTransfer/Components/EQ_FviewCalculator.PNG\"	
			/>
		
		
			<h5>
				when the total number of surface = 2
			</h5>
			
			It is considered face to face surfaces where the real fview factor (f<sub>a->b</sub>) of the smallest surface is one. Therefore the calculation of the fview factor for the carrol node 
			components derives: <br/>

			<img	
				src=\"//Atlas.edf.fr/co/FiEDVANCE/190-sof-uk.020/720-TCYV.017/08 - Common Data/Modelica/03 - HTML modules description/TAeZoSysPro/HeatTransfer/Components/EQ_FviewCalculator2.PNG\"	
			/>			
			
		</p>
		
		<p>
			<b>Where :</b>
				<ul>
					<li> Fview<sub>i or k</sub> is a view factor
					<li> Awall<sub>i or k</sub> is a surface area </li>
				</ul>
		</p>

		<p>
			This heuristic relation is solved iteratively within the embedded function <b>fviewcalculator</b>. The convergence criteria (the value of <b>tolerance</b>) is performed on the residuals
			wich are defined as the norm between the difference vector Fview at iteration N and iteration N-1.
		</p>		
			
	</body>
</html> "));
end FviewCalculator;