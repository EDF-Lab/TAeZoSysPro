within TAeZoSysPro.HeatTransfer.Functions.ForcedConvection;

function crossFlow_cylinder_ASHRAE
  extends Modelica.Icons.Function;

  input Modelica.SIunits.PrandtlNumber Pr;
  input Modelica.SIunits.ReynoldsNumber Re;
  output Modelica.SIunits.NusseltNumber Nu;                                                                                  

algorithm

  Nu := 0.3 + 0.62 * Re ^ (1 / 2) * Pr ^ (1 / 3) / (1 + (0.4 / Pr) ^ (2 / 3)) ^ (1 / 4) * (1 + (Re / 282000) ^ (5 / 8)) ^ (4 / 5);

  annotation(
    Diagram(coordinateSystem(grid = {1, 1})),
    Documentation(info = "
    <html>
	<head>
	  <title>crossFlow_cylinder_ASHRAE</title>
	  <meta http-equiv=\"Content-Type\" content=\"text/html;charset=utf-8\">
	</head>

	<body>
	  <p>
	  The following Churchill and Bernstein (1977) is applicable for an external cross flow over a cylinder. </br>
	  The formula is picked from the ASHRAE guide (2005) chapter 3 table 9 equation T9.13
	  </p>

	  <img src=\"modelica://TAeZoSysPro/Information/HeatTransfer/Functions/ForcedConvection/EQ_crossFlow_cylinder_ASHRAE.png\" />

	  <p>
		Where :
		<ul>
		  <li> Nu is the Nusselt number </li>
		  <li> Re is the Reynolds number </li>
		  <li> Pr is the Prandtl number </li>
		</ul>
	  </p>	

	</body>
</html>"));

end crossFlow_cylinder_ASHRAE;
