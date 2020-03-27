within TAeZoSysPro.HeatTransfer.Functions.FreeConvection;

function horizontal_cylinder_ASHRAE

  extends Modelica.Icons.Function;

  input Modelica.SIunits.PrandtlNumber Pr;
  input Modelica.SIunits.RayleighNumber Ra; 
  output Modelica.SIunits.NusseltNumber Nu;

algorithm

  Nu := (0.6 + 0.387 * Ra ^ (1 / 6) / (1 + (0.559 / Pr) ^ (9 / 16)) ^ (8 / 27)) ^ 2;
  
  assert(not(Ra < 10^9), "the Rayleigh number <10^9 is out of the range of the correlation", level = AssertionLevel.warning) ;
  assert(not(Ra > 10^13), "the Rayleigh number >10^13 is out of the range of the correlation", level = AssertionLevel.warning) ;
  
  annotation(Documentation(info = "<html>
<head>
  <title>horizontal_cylinder_ASHRAE</title>
  <meta http-equiv=\"Content-Type\" content=\"text/html;charset=utf-8\">
</head>

<body>
  <p>
  The following Churchill and Chu correlation is pratical for an horizontal cylinder in rest environment (no forced convection). </br>
  The formula is picked from the ASHRAE guide chapter 3 table 10 equation T10.10
  </p>

  <img 
    src=\"modelica://TAeZoSysPro/Information/HeatTransfer/Functions/FreeConvection/EQ_horizontal_cylinder_ASHRAE.png\" />

  <p>
  The correlation is given for a Rayleigh number 10<sup>9</sup> < Ra < 10<sup>13</sup>.
  </p>

  <p>
    Where :
    <ul>
      <li> Nu is the Nusselt number </li>
      <li> Ra is the Rayleigh number </li>
      <li> Pr is the Prandtl number </li>
    </ul>
  </p>	

</body>
</html>"),
    Diagram(coordinateSystem(grid = {1, 1})));

end horizontal_cylinder_ASHRAE;
