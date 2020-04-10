within TAeZoSysPro.HeatTransfer.BasesClasses;

model CarrollRadiation 

  extends Modelica.Thermal.HeatTransfer.Interfaces.Element1D ;
   
  // User defined parameters
  parameter Real add_on = 1 "Custom add-on";
  parameter Modelica.SIunits.Area A = 0 "Wall Surface Area " annotation(
  Dialog(group="Geometrical properties"));
  parameter Modelica.SIunits.Emissivity eps = 1 "Grey wall surface emissivity" annotation(
  Dialog(group="Radiative properties"));
  // Constants
  constant Real sigma = Modelica.Constants.sigma "Stefan-Boltzmann constant";
  
  // Internal variables
  Modelica.SIunits.CoefficientOfHeatTransfer h_rad "Heat transfer coefficient";
  Modelica.SIunits.Energy E "Energy passed throught the component" ;
  
  // Imported components
  Modelica.Blocks.Interfaces.RealInput Fview annotation(
    Placement(visible = true, transformation(origin = {-93, 88}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-80, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

initial equation
  E = 0.0 ;

equation
// linearization of the radiative equation
  h_rad = TAeZoSysPro.HeatTransfer.Functions.Radiation.h_rad(T_A = port_a.T,
                                                             T_B = port_b.T,
                                                             R_th = ((1 - eps) / eps + Fview ^ (-1))) ;
  
// Heat flux calculation
  Q_flow = h_rad * A * dT ;  
  der(E) = Q_flow ;
   
  annotation(Documentation(info = "
<html>
  <head>
    <title>CarrollRadiation</title>	
  </head>
	
  <body lang=\"en-UK\">
	<p>
      This component links the heat flow with a temperature difference between a wall and the Carroll node, actually the Mean Radiant Temperature (MRT), thanks to the Stefan-Boltzmann law of radiation. </br> 
      It incoporates the resistance calculation between the surface net flux and radiatity and the resistance induced by the form factor.
      The detail of the model is available in the theoretical note. </br>
      The following assumptions are made:
      
      <ul>
        <li> Wall is opaque: Their transmittivty is zero </li>
        <li> Kirchhoff law is supposed practical: spectral absorptivity is equal to spectral emissivity </li>
        <li> The surface bodies are grey: They radiative properties are thus independant from the wavelength. It implies to remains within a small range a wavelength </li>
      </ul>
			
      The basic constitutive equation for CarrollRadiation derives :
			
    </p>
    
    <img
      src=\"modelica://TAeZoSysPro/Information/HeatTransfer/BasesClasses/EQ_CarrollRadiation1.PNG\"
    /> 

    <p>
      <b>Where :</b>
      <ul>
        <li> Q_flow: Heat flow rate from connector 'wall' (e.g., a plate) to connector 'MRT' (the Carrol's Node).
        <li> add_on is a user paramater to adjust if needed the Heat flow </li>
        <li> &sigma; is Stefan-Boltzmann's constant </li>
        <li> A is the radiative surface area of the wall </li>
        <li> &epsilon; is the emissivity </li>
        <li> Fview<sub>j->MRT</sub> is the form factor (or view factor) between the wall and the Carrol's Node </li>
      </ul>
    </p>	

    <p>
      However, the above equation is non-linear. 
      The idea is then to reduce this last equation to an equation of the Newton’s cooling law type.
      The heat transfer coefficient <b>h_rad</b> from the linearization of the above equation is calculated by a function.
    </p>

    <img
      src=\"modelica://TAeZoSysPro/Information/HeatTransfer/BasesClasses/EQ_CarrollRadiation3.PNG\"
    />

    <p>
      <b>Where :</b>
      <ul>
        <li> h_rad is the linearized heat transfer coefficient (Newton's coefficient) </li>
        <li> add_on is a user paramater to adjust if needed the Heat flow to the temperature difference dT </li>
        <li> dT is the Temperature difference between the wall (port_a.T) and port_b.T </li>
      </ul>
    </p>
          
    <p>       
      Using a function to calculate <b>h_rad</b> rather than putting directly the relation between the heat flux and the temperature difference without function seems to us to allow a gain of stability. 
      Indeed, the passage by a function seemed to us to make the calculation of the exchange coefficient explicit rather than implicit.
    </p>
    
    <p>
      In addition, the transition from biquadratique to a linear relationship between the heat flux and the temperature difference makes the calculation more stable numerically
    </p>

    <p>
      The difference between the heat flow lost or gained by the solid (the net flux) and the heat flow leaving the surface taking account of the reflectivity is seen as 'thermal resistance' <b>R_th</b>. 
      This thermal resistance is given as input to the function to compute <b>h_rad</b> (See <b>h_rad</b> function description).
    </p>
    
    <img
      src=\"modelica://TAeZoSysPro/Information/HeatTransfer/BasesClasses/EQ_CarrollRadiation2.PNG\"
    />       
		
  </body>
</html>"),
    Icon(graphics = {Rectangle(origin = {0, 70}, fillColor = {106, 105, 108}, fillPattern = FillPattern.Cross, extent = {{-40, 10}, {40, -10}}), Rectangle(origin = {-70, 0}, fillColor = {106, 105, 108}, fillPattern = FillPattern.Cross, extent = {{-10, 40}, {10, -40}}), Rectangle(origin = {0, -70}, fillColor = {106, 105, 108}, fillPattern = FillPattern.Cross, extent = {{-40, -10}, {40, 10}}), Rectangle(origin = {70, 0}, fillColor = {106, 105, 108}, fillPattern = FillPattern.Cross, extent = {{-10, 40}, {10, -40}}), Rectangle(origin = {-59, 0}, fillColor = {255, 0, 0}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{1, -40}, {-1, 40}}), Rectangle(origin = {59, 0}, fillColor = {255, 0, 0}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{1, -40}, {-1, 40}}), Rectangle(origin = {0, 59}, fillColor = {255, 0, 0}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-40, 1}, {40, -1}}), Rectangle(origin = {0, -59}, fillColor = {255, 0, 0}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-40, 1}, {40, -1}}), Ellipse(fillPattern = FillPattern.Solid, extent = {{-6, -6}, {6, 6}}, endAngle = 360), Line(origin = {0, -31}, points = {{0, 23}, {0, -27}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.Filled, Arrow.Filled}), Line(origin = {-31, 0}, points = {{23, 0}, {-27, 0}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.Filled, Arrow.Filled}), Line(origin = {33, 0}, points = {{27, 0}, {-25, 0}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.Filled, Arrow.Filled}), Text(origin = {95, 21}, extent = {{-9, -11}, {17, 9}}, textString = "MRT", fontSize = 8), Line(origin = {-30, 21}, points = {{-28, 19}, {24, -15}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.Filled, Arrow.Filled}), Line(origin = {-30, -20}, points = {{-28, -18}, {24, 14}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.Filled, Arrow.Filled}), Line(origin = {-21, 30}, points = {{-19, 28}, {15, -24}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.Filled, Arrow.Filled}), Line(origin = {23, 32}, points = {{19, 28}, {-17, -26}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.Filled, Arrow.Filled}), Line(origin = {31, 22}, points = {{27, 18}, {-25, -16}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.Filled, Arrow.Filled}), Line(origin = {0, 31}, points = {{0, 27}, {0, -23}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.Filled, Arrow.Filled}), Line(origin = {30, -21}, points = {{28, -19}, {-24, 15}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.Filled, Arrow.Filled}), Line(origin = {22, -31}, points = {{18, -27}, {-16, 25}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.Filled, Arrow.Filled}), Line(origin = {-23, -32}, points = {{-19, -28}, {17, 26}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.Filled, Arrow.Filled}), Text(origin = {-105, 21}, rotation = 180, extent = {{-19, -9}, {9, 11}}, textString = "Wall", fontSize = 8)}, coordinateSystem(initialScale = 0.1)));
    
end CarrollRadiation;
