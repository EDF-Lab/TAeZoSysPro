within TAeZoSysPro.HeatTransfer.Functions.FreeConvection;

function vertical_plate_Recknagel
  extends Modelica.Icons.Function;

  input Modelica.SIunits.TemperatureDifference dT "Difference temperature between plate and fluid" ;
  input Modelica.SIunits.Temperature T_mean "Mean temperature between plate and fluid" ;
  output Modelica.SIunits.CoefficientOfHeatTransfer h_cv "Convective heat transfer coefficient";

algorithm

  h_cv := 9.7 * (abs(dT) / T_mean) ^ (1 / 3);

  annotation(Documentation(info = "
<html>
	<head>
	  <title>vertical_plate_Recknagel</title>
	  <meta http-equiv=\"Content-Type\" content=\"text/html;charset=utf-8\">
	</head>

	<body>
	  <p>
        The following Recknagel correlation is pratical for a vertical plate in rest environment (no forced convection). </br>
        The formula is picked from Recknagel 5th edition
	  </p>

	  <img 
        src=\"modelica://TAeZoSysPro/Information/HeatTransfer/Functions/FreeConvection/EQ_vertical_plate_Recknagel.png\" />

	  <p>
	  The range for which the correlation is given is unknown.
	  </p>

	  <p>
		Where :
		<ul>
		  <li> &Delta;T is the temperature difference between a wall and the fluid </li>
		  <li> T<sub>Wall</sub> is the wall temperature (In celsius ? kelvin?) </li>
		  <li> T<sub>Fluid</sub> is the fluid temperature (In celsius ? kelvin?) </li> </li>
		</ul>
	  </p>	

	</body>
</html>"),
    Diagram(coordinateSystem(grid = {1, 1})));
end vertical_plate_Recknagel;
