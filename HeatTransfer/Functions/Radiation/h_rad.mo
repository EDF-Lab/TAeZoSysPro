within TAeZoSysPro.HeatTransfer.Functions.Radiation;

function h_rad

  input Modelica.SIunits.Temperature T_A ;
  input Modelica.SIunits.Temperature T_B ;
  input Modelica.SIunits.ThermalResistance R_th "Thermal resistance between solid A and B (emissivity and view factor)" ;
  output Modelica.SIunits.CoefficientOfHeatTransfer h_rad ;
  
algorithm
  
  // with the expression bellow rise a zero division when T_A = T_B
  //h_rad := 1 / R_th * Modelica.Constants.sigma * (T_A^4 - T_B^4) / (T_A - T_B)  ;
  
  // the expression bellow is non recursive
  //h_rad := 1 / R_th * Modelica.Constants.sigma * (T_A^3 + T_A * T_B^2 + T_B * T_A^2 + T_B^3) ;
  
  h_rad := Modelica.Constants.sigma * (T_A + T_B) * (T_A^2 + T_B^2) / R_th ;
  
  annotation(Documentation( info = "
<html>
	<head>
		<title>HeatTransfer package</title>		
	</head>
	
	<body lang=\"en-UK\">
	
      <p>
        This function is used to determine the coefficient of radiative exchange when the relation which links the radiative heat flux to the difference in potential temperature is assimilated to the Newton's law of cooling as below.
      </p> 
      <p>
        Using a function to calculate h_rad rather than putting directly the relation between the heat flux and the temperature difference without function seems to us to allow a gain of stability. </br>
        Indeed, the passage by a function seemed to us to make the calculation of the exchange coefficient explicit rather than implicit.
      </p>
      <p>
        In addition, the transition from biquadratique to a linear relationship between the heat flux and the temperature difference makes the calculation more stable numerically. 
      </p>
      
      <img
        src = \"modelica://TAeZoSysPro/Information/HeatTransfer/Functions/Radiation/EQ_h_rad.png\"
      />		

      <p>
        The original relation that links the radiative  heat flux to the difference in potential temperature is: 
      </p>

      <img
        src = \"modelica://TAeZoSysPro/Information/HeatTransfer/Functions/Radiation/EQ_h_rad2.png\"
      />

	  <p>
		Where :
		<ul>
		  <li> &epsilon; emissivity of the wall A </li>
		  <li> &sigma; is Stefan-Boltzmann's constant </li>
		  <li> A is the surface area of the wall A </li>
		  <li> T_A is the wall surface Temperature of the wall A </li>
		  <li> T_B is the wall surface Temperature of the wall B </li>
		</ul>
	  </p>

	</body>
	
</html> 
  ") ) ;

end h_rad;
