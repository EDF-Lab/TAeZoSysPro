within TAeZoSysPro.HeatTransfer.Functions.ForcedConvection;

function flat_plate_ASHRAE
  extends Modelica.Icons.Function;

  input Modelica.SIunits.PrandtlNumber Pr;
  input Modelica.SIunits.ReynoldsNumber Re;
  output Modelica.SIunits.NusseltNumber Nu;                                                                                  

algorithm

  Nu := 0.037 * Re ^ (4 / 5) * Pr ^ (1 / 3);

  assert(not(Re < 5*10^5), "The Reynolds number < 5x10^5 is out of the range of the correlation", level = AssertionLevel.warning) ;

  annotation(
    Diagram(coordinateSystem(grid = {1, 1})),
    Documentation(info = "
<html>
  <head>
    <title>flat_plate_ASHRAE</title>
    <meta http-equiv=\"Content-Type\" content=\"text/html;charset=utf-8\">
  </head>

  <body>
    <p>
      The following correlation is applicable for a flat plate with a turbulent boundary layer. </br>
      The formula is picked from the ASHRAE guide (2005) chapter 3 table 9 equation T9.11
	</p>

	<img 
      src=\"modelica://TAeZoSysPro/Information/HeatTransfer/Functions/ForcedConvection/EQ_flat_plate_ASHRAE.png\" 
    />

    <p>
      Where :
      <ul>
        <li> Nu is the Nusselt number </li>
        <li> Re is the Reynolds number </li>
        <li> Pr is the Prandtl number </li>
      </ul>
    </p>

    <p>
      The correlation is given for a Reynolds number Re > 5x10<sup>5</sup>.
    </p>	  

  </body>
</html>"));

end flat_plate_ASHRAE;
