within TAeZoSysPro.HeatTransfer.BasesClasses;

model LumpVolume
  import TAeZoSysPro.HeatTransfer.Types.Dynamics ;

  // Medium is declared
  //replaceable package Medium = Modelica.Media.Air.ReferenceAir.Air_pT;
//  replaceable package Medium = TAeZoSysPro.Media.Air.SimpleAir ;
  
  replaceable package Medium = Modelica.Media.Air.SimpleAir ;
  Medium.BaseProperties medium(preferredMediumStates= true, p = p) ;     //preferredMediumStates = true for having a static state selection
  
  // User defined parameters
  parameter Modelica.SIunits.Volume V = 1 "Air node volume [m3]";
  parameter Dynamics energyDynamics = Dynamics.FixedInitial "Formulation of energy balance";
  parameter Modelica.SIunits.Temperature T_start = 293.15 "Start value for temperature, if not steady state";
  final parameter Modelica.SIunits.Pressure p = Medium.reference_p "Constant pressure";
  
  //Internal variables
  Modelica.SIunits.Energy E "Energy storage";
  Modelica.SIunits.Mass m "Mass of the volume";
  Medium.Temperature T "temperature of the fluid";

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, -4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

initial equation
  E = 0.0 ;
// Initialisation
  if energyDynamics == Dynamics.SteadyStateInitial then
    der(medium.T) = 0 "Zero time derivative at initilisation" ;
    
  elseif energyDynamics == Dynamics.FixedInitial then
    T = T_start "Initial temperature" ;
    
  end if;
  
equation

  T = medium.T;
  
// Mass balance
  m = medium.d * V;
  
// Energy balance
  if energyDynamics == Dynamics.SteadyState then
    port_a.Q_flow = 0;
  else
    m * der(medium.h) = port_a.Q_flow;
  end if;
  der(E) = port_a.Q_flow;
  
// Port handover
  port_a.T = T;
  annotation(
    Icon(graphics = {Ellipse(lineColor = {85, 85, 255}, fillColor = {85, 170, 255}, fillPattern = FillPattern.Solid, extent = {{100, 100}, {-100, -100}}, endAngle = 360), Text(origin = {24, -43}, extent = {{76, -17}, {-124, -57}}, textString = "V=%V")}, coordinateSystem(initialScale = 0.1)),
    Documentation(info="
    <html>
	<head>
		<title>LumpVolume</title>
	
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
        This component links the variation of the potential enthalpy (or temperature for an ideal gase) to heat flow balance in the opened lumped volume.
        It is the thermal inertia of a lumped volume
      </p>

      <p>
        A lump volume means that a fixed geometric volume is considered but the boundary of this volume are not hermetic thus the volume is not closed. <br/>
        The volume is at constant pressure since the focus is on the thermal aspect only and the thermal time is often much greater than the aeraulic time. <br/>
		For an open volume the balance is performed with the enthalpy to take account of the isobaric dilatation.
      </p>      

      <p>        
        The basic constitutive equation for convection derives from the first principe of thermodynamics :
      </p>
      		
      <img	
        src=\"modelica://TAeZoSysPro/Information/HeatTransfer/BasesClasses/EQ_LumpVolume.PNG\"
      />
      
      <p>
        <b>Where :</b>
        <ul>
          <li> port.Q_flow: The Heat flow balance at the heat port </li>
          <li> m: The Mass of the inertial component </li>
          <li> h: The specific enthalpy </li>
        </ul>
      </p>					
			
	</body>
</html>"),
    experiment(StartTime = 0, StopTime = 864000, Tolerance = 1e-06, Interval = 865.731));

end LumpVolume;
