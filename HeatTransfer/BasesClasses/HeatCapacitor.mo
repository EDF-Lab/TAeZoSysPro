within TAeZoSysPro.HeatTransfer.BasesClasses;

model HeatCapacitor
  import TAeZoSysPro.HeatTransfer.Types.Dynamics ;
 
// User defined parameters :
  parameter Modelica.SIunits.SpecificHeatCapacity cp = 0 "Specific heat capacity of element" annotation(
  Dialog(group="Thermal properties"));
  parameter Modelica.SIunits.Mass m = 0 "Mass of element";
  parameter Dynamics energyDynamics = Dynamics.SteadyStateInitial "Formulation of energy balance";
  parameter Modelica.SIunits.Temperature T_start = 293.15 "Start value for temperature, if not steady state";
  
  // Internal variables
  Modelica.SIunits.Temperature T "Temperature of element";
  Modelica.SIunits.Energy E "Energy storage";
  
  // Imported components
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port annotation(
    Placement(visible = true, transformation(origin = {0, -98}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, -98}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
                                                           
initial equation
  E = 0 " Energy at time 0s is equal to 0J" ;
  
  if energyDynamics == Dynamics.SteadyStateInitial then
    //der(T) = 0;
    port.Q_flow = 0.0 ;
    
  elseif energyDynamics == Dynamics.FixedInitial then
    T = T_start ;

  end if;

equation
  if energyDynamics == Dynamics.SteadyState then
    port.Q_flow = 0.0 ;
  else
  // enthalpy balance
    m * cp * der(T) = port.Q_flow;
    
  end if ;

  // energy storage calculation
    der(E) = port.Q_flow;
    
  // port handover
    port.T = T;
      
  annotation(
    Icon(coordinateSystem(initialScale = 0.1), graphics = {Text(origin = {0, -2},lineColor = {0, 0, 255}, extent = {{-150, 110}, {150, 70}}, textString = "%name"), Polygon(lineColor = {160, 160, 164}, fillColor = {192, 192, 192}, fillPattern = FillPattern.Solid, points = {{0, 67}, {-20, 63}, {-40, 57}, {-52, 43}, {-58, 35}, {-68, 25}, {-72, 13}, {-76, -1}, {-78, -15}, {-76, -31}, {-76, -43}, {-76, -53}, {-70, -65}, {-64, -73}, {-48, -77}, {-30, -83}, {-18, -83}, {-2, -85}, {8, -89}, {22, -89}, {32, -87}, {42, -81}, {54, -75}, {56, -73}, {66, -61}, {68, -53}, {70, -51}, {72, -35}, {76, -21}, {78, -13}, {78, 3}, {74, 15}, {66, 25}, {54, 33}, {44, 41}, {36, 57}, {26, 65}, {0, 67}}), Polygon(fillColor = {160, 160, 164}, fillPattern = FillPattern.Solid, points = {{-58, 35}, {-68, 25}, {-72, 13}, {-76, -1}, {-78, -15}, {-76, -31}, {-76, -43}, {-76, -53}, {-70, -65}, {-64, -73}, {-48, -77}, {-30, -83}, {-18, -83}, {-2, -85}, {8, -89}, {22, -89}, {32, -87}, {42, -81}, {54, -75}, {42, -77}, {40, -77}, {30, -79}, {20, -81}, {18, -81}, {10, -81}, {2, -77}, {-12, -73}, {-22, -73}, {-30, -71}, {-40, -65}, {-50, -55}, {-56, -43}, {-58, -35}, {-58, -25}, {-60, -13}, {-60, -5}, {-60, 7}, {-58, 17}, {-56, 19}, {-52, 27}, {-48, 35}, {-44, 45}, {-40, 57}, {-58, 35}}), Text(origin = {-30, 52},extent = {{-69, 7}, {129, -12}}, textString = "Mass = %Mass", fontSize = 8),  Text(origin = {-30, -8}, extent = {{-69, 7}, {129, -12}}, textString = "Cp = %Cp", fontSize = 8)}),
    Diagram(coordinateSystem(preserveAspectRatio = true, extent = {{-100, -100}, {100, 100}}), graphics = {Polygon(points = {{0, 67}, {-20, 63}, {-40, 57}, {-52, 43}, {-58, 35}, {-68, 25}, {-72, 13}, {-76, -1}, {-78, -15}, {-76, -31}, {-76, -43}, {-76, -53}, {-70, -65}, {-64, -73}, {-48, -77}, {-30, -83}, {-18, -83}, {-2, -85}, {8, -89}, {22, -89}, {32, -87}, {42, -81}, {54, -75}, {56, -73}, {66, -61}, {68, -53}, {70, -51}, {72, -35}, {76, -21}, {78, -13}, {78, 3}, {74, 15}, {66, 25}, {54, 33}, {44, 41}, {36, 57}, {26, 65}, {0, 67}}, lineColor = {160, 160, 164}, fillColor = {192, 192, 192}, fillPattern = FillPattern.Solid), Polygon(points = {{-58, 35}, {-68, 25}, {-72, 13}, {-76, -1}, {-78, -15}, {-76, -31}, {-76, -43}, {-76, -53}, {-70, -65}, {-64, -73}, {-48, -77}, {-30, -83}, {-18, -83}, {-2, -85}, {8, -89}, {22, -89}, {32, -87}, {42, -81}, {54, -75}, {42, -77}, {40, -77}, {30, -79}, {20, -81}, {18, -81}, {10, -81}, {2, -77}, {-12, -73}, {-22, -73}, {-30, -71}, {-40, -65}, {-50, -55}, {-56, -43}, {-58, -35}, {-58, -25}, {-60, -13}, {-60, -5}, {-60, 7}, {-58, 17}, {-56, 19}, {-52, 27}, {-48, 35}, {-44, 45}, {-40, 57}, {-58, 35}}, lineColor = {0, 0, 0}, fillColor = {160, 160, 164}, fillPattern = FillPattern.Solid), Ellipse(extent = {{-6, -1}, {6, -12}}, lineColor = {255, 0, 0}, fillColor = {191, 0, 0}, fillPattern = FillPattern.Solid), Text(extent = {{11, 13}, {50, -25}}, lineColor = {0, 0, 0}, textString = "T"), Line(points = {{0, -12}, {0, -96}}, color = {255, 0, 0})}),
    Documentation(info = "
<html>
	<head>
		<title>HeatCapacitor</title>
	</head>
	
	<body lang=\"en-UK\">
      <p>
        This components, refleting the first principe of thermodynamic (energy conservation), computes the variation of the temperature (the potential variable) from a heat flow balance and its thermal inertia.
      </p>
              
      <p>        
        The basic constitutive equation for convection is : 
      </p>
      			
      <img
        alt=\"First principe of thermodynamic\"	
        src=\"modelica://TAeZoSysPro/Information/HeatTransfer/BasesClasses/EQ_HeatCapacitor.png\"
      />
      
      <p>
        <b>Where :</b>
        <ul>
          <li> port.Q_flow: The Heat flow balance at the heat port </li>
          <li> m: The Mass of the inertial component </li>
          <li> cp: The specific heat capacity at constant pressure </li>
        </ul>
      </p>	

      <p>
        If <b>energyDynamics</b> parameter is <b>SteadyStateInitial</b>, the modelica solver will determine which value of the temperature ,<b>at the initilisation</b>, that satisfies a zero time derivative and will ignore the <b>Tstart</b> parameter.
      </p>
      <p>
        If <b>energyDynamics</b> parameter is <b>FixedInitial</b>, the initial temperature is equal to the value of the <b>T_start</b> parameter.
      </p>
      <p>
        If <b>energyDynamics</b> parameter is <b>SteadyState</b>, the heat capacitor becomes non inertial and behaves like a temperature sensor. 
        The heat flow through the port <b>port.Q_flow</b> is set to 0.
      </p>
		
	</body>
</html>"));

end HeatCapacitor;
