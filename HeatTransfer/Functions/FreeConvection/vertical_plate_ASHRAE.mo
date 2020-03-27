within TAeZoSysPro.HeatTransfer.Functions.FreeConvection;

function vertical_plate_ASHRAE
  extends Modelica.Icons.Function;

  input Modelica.SIunits.PrandtlNumber Pr;
  input Modelica.SIunits.RayleighNumber Ra; 
  output Modelica.SIunits.NusseltNumber Nu;

algorithm

// the following code were used for avoiding the extrapolation of correlation
  //Nu_down := 0.68 + 0.67 * Ra^(1 / 4) / ( 1 + (0.492/Pr)^(9/16) )^(4/9) ;
  //Nu_up := (0.825 + 0.387 * Ra ^ (1 / 6) / (1 + (0.492 / Pr) ^ (9 / 16)) ^ (8 / 27)) ^ 2;
  //Nu := Modelica.Fluid.Utilities.regStep(x = Ra_1-Ra, x_small = x_small, y1 = Nu_down, y2 = Nu_up) ;
  
  Nu := (0.825 + 0.387 * Ra ^ (1 / 6) / (1 + (0.492 / Pr) ^ (9 / 16)) ^ (8 / 27)) ^ 2;
  

  assert(not(Ra < 10^9), "the Rayleigh number < 10^9 is out of the range of the correlation. => Correlation extrapolated ", level = AssertionLevel.warning) ;
  assert(not(Ra > 10^13), "the Rayleigh number > 10^12 is out of the range of the correlation", level = AssertionLevel.warning) ;
  
  annotation(Documentation(info = "<html>
<head>
  <title>vertical_plate_ASHRAE</title>
  <meta http-equiv=\"Content-Type\" content=\"text/html;charset=utf-8\">
</head>

<body>
  <p>
    The following Churchill and Chu correlation is pratical for a vertical plate in rest environment (no forced convection). </br>
    The formula is picked from the ASHRAE guide chapter 3 table 10 equations T10.3
  </p>

  <img src=\"modelica://TAeZoSysPro/Information/HeatTransfer/Functions/FreeConvection/EQ_vertical_plate_ASHRAE.png\"  />

  <p>
    The correlations is given for a Rayleigh number 10<sup>9</sup> < Ra < 10<sup>12</sup>. 
    A other correlation is suitable for 10<sup>-1</sup> < Ra < 10<sup>9</sup> with the equation T10.2 but the connection at Ra = 10<sup>9</sup> between the correlation is too discontinuous. 
    Therefore the correlation T10.3 is extended to range 10<sup>-1</sup> < Ra < 10<sup>9</sup>.
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

end vertical_plate_ASHRAE;
