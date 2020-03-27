within TAeZoSysPro.HeatTransfer.Functions.ForcedConvection;

function internal_pipe_ASHRAE

  extends Modelica.Icons.Function;
  
  input Modelica.SIunits.PrandtlNumber Pr;
  input Modelica.SIunits.ReynoldsNumber Re;
  input Modelica.SIunits.TemperatureDifference dT; 
  output Modelica.SIunits.NusseltNumber Nu;
  
protected
  Real n "reynolds exponent" ;
  
algorithm
// non declarative algorithmic
//cooling or heating mode selection
/* 
- Twall > T mean fluid => heating mode
- Twall < T mean fluid => cooling mode  
*/
  if dT > 0 then
    /* heating mode */
    n := 0.4;
  elseif dT < 0 then
    /* cooling mode */
    n := 0.3;
  else
    /* unknown mode */
    n := 0.35;
  end if;

  Nu := 0.023 * Re ^ (4 / 5) * Pr ^ n;
  
  assert(not(Re < 10^4), "The Reynolds number < 10^4 is out of the range of the correlation", level = AssertionLevel.warning) ;

  annotation(
    Documentation(info = "
    <html>
	<head>
	  <title>internal_flow_pipe_ASHRAE</title>
	  <meta http-equiv=\"Content-Type\" content=\"text/html;charset=utf-8\">
	</head>

	<body>
	  <p>
        The following Dittus and Boelter (1930) correlation is applicable for a fully turbulent internal flows in pipes. </br> 
        The formula is picked from the ASHRAE guide chapter 3 table 9 equation T9.5 and 9.6
	  </p>

	  <img src=\"modelica://TAeZoSysPro/Information/HeatTransfer/Functions/ForcedConvection/EQ_internal_pipe_ASHRAE.png\" />

	  <p>
        The correlation is given for a Reynolds number Re > 10<sup>4</sup>.
	  </p>
	  <p>
        The value of the exponent over the Prandtl number depends on whether the pipe wall is warmer or colder than the fluid.
        If the pipe is warmer (heating mode),<code> n = 4 </code> and <code> n = 3 </code> (cooling mode) otherwise.
	  </p>

	  <p>
		Where :
		<ul>
		  <li> Nu is the Nusselt number </li>
		  <li> Re is the Reynolds number </li>
		  <li> Pr is the Prandtl number </li>
		  <li> DeltaT is the temperature difference between the wall and the fluid </li>
		</ul>
	  </p>	

	</body>
</html>"),
    Diagram(coordinateSystem(grid = {1, 1})));

end internal_pipe_ASHRAE ;
