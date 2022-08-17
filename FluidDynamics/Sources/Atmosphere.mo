within TAeZoSysPro.FluidDynamics.Sources;

model Atmosphere
  // Medium declaration
  replaceable package Medium = TAeZoSysPro.Media.MyMedia ;
  /*Get TAeZoSysPro reference moist air Media*/
    package Medium_MoistAirTAezo=TAeZoSysPro.Media.Air.MoistAir;

// User defined parameters
  parameter Boolean use_p_in = false "Get the pressure from the input connector" annotation(
  Evaluate=true, HideResult=true, choices(checkBox=true));
  parameter Boolean use_T_in = false "Get the temperature from the input connector" annotation(
  Evaluate=true, HideResult=true, choices(checkBox=true)) ;
  parameter Boolean use_RH_in = false "Get the relative humidity from the input connector" annotation(
  Evaluate=true, HideResult=true, choices(checkBox=true)) ;
  
  parameter Modelica.SIunits.Temperature T = 293.15 "Atmosphere temperature" ;
  parameter Modelica.SIunits.Pressure p = 101325 "Atmosphere Pressure" ;
  parameter Real RH = 0.6 "Atmosphere relative humidity - Only accounted if medium == Moist air" ;
  parameter Modelica.SIunits.MassFraction X[Medium.nX] = Medium.X_default "usefull except for Moist Air";

  parameter Integer nPorts = 0 "Number of fluidport" annotation(Dialog(connectorSizing=true));
  // Internal variables
  Medium.ThermodynamicState state ;

  
// Imported module
  Modelica.Fluid.Interfaces.FluidPort_a[nPorts] Fluidport(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-30, 26}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  TAeZoSysPro.FluidDynamics.Interfaces.FlowPort_b Flowport(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-26, -46}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b Heatport annotation(
    Placement(visible = true, transformation(origin = {-44, -14}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput p_in annotation(
    Placement(visible = true, transformation(origin = {-72, 56}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-95, 59}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput T_in annotation(
    Placement(visible = true, transformation(origin = {-74, 14}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-95, -1}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput RH_in annotation(
    Placement(visible = true, transformation(origin = {-70, -30}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-95, -61}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));

protected
  /*Using TAeZoSysPro medium function ensure no fail with new OM frontend (function exist whatever medium used*/
  parameter Medium_MoistAirTAezo.MassFraction X_moist[Medium_MoistAirTAezo.nX]= cat(1, {Medium_MoistAirTAezo.massFraction_pTphi(p = p, T = T, phi = RH)}, {1-Medium_MoistAirTAezo.massFraction_pTphi(p = p, T = T, phi = RH)});
  
  /*depending on chosen medium, parameter X vector to be adjusted*/
  parameter Modelica.SIunits.MassFraction X_final[Medium.nX] = if Medium.mediumName=="Moist air" then 
                                                                X_moist 
                                                                else
                                                                X;
                                                                
  Modelica.Blocks.Interfaces.RealInput T_internal
    "Temperature at ports. Needed to connect to conditional connector";
  Modelica.Blocks.Interfaces.RealInput p_internal
    "Pressure at ports. Needed to connect to conditional connector";
  Modelica.Blocks.Interfaces.RealInput RH_internal
    "Relative humidity at ports. Needed to connect to conditional connector";

equation
  connect(T_internal, T_in) ;
  connect(p_internal, p_in) ;
  connect(RH_internal, RH_in) ;
  
  if not use_p_in then
    p_internal = p;
  end if;
  
  if not use_T_in then
    T_internal = T;
  end if;
  
  if not use_RH_in then
    RH_internal = RH;
  end if;

  state = Medium.setState_pTX(p = p_internal, 
                                T = T_internal,
                                X=X_final) ; 

// Ports handover
// Flowport
  Flowport.T = T_internal;
  Flowport.d = Medium.density(state) * X_final ;
// Heatport
  Heatport.T = T_internal;
// Fluidport
  for i in 1:nPorts loop
    Fluidport[i].p = p_internal;
    Fluidport[i].h_outflow = Medium.specificEnthalpy(state);
    Fluidport[i].Xi_outflow = X_final[1:Medium.nXi];
  end for;
  annotation(
    Icon(coordinateSystem(initialScale = 0.1), graphics = {Ellipse(origin = {-8, 23}, extent = {{-52, 37}, {68, -83}}, endAngle = 360), Text(origin = {-65, 87}, extent = {{-35, 13}, {165, -7}}, textString = "P=%p"), Text(origin = {-37, 33}, extent = {{-63, 47}, {137, 27}}, textString = "T=%T"), Text(origin = {-17, -97}, extent = {{-83, 17}, {117, -3}}, textString = "RH=%RH")}),
    Documentation(info = "
<html>
  <head>
    <title>Atmosphere</title>
  </head>
	
  <body lang=\"en-UK\">
    <p>
      This components supplies boundaries with prescribed temperature, pression and composition.
    </p>
	
    <p>
      If <code>use_p_in</code> is false (default option), the <code>p</code> parameter is used as boundary pressure, and the <code>p_in</code> input connector is disabled. </br> 
      if <code>use_p_in</code> is true, then the <code>p</code> parameter is ignored, and the value provided by the input connector is used instead.
    </p>
	
    <p>
      The same thing goes for the temperature and composition.
    </p>
		
    <p>
      Note, that boundary temperature and mass fractions have only an effect if the mass flow is from the boundary into the port. 
      If mass is flowing from the port into the boundary, the boundary definitions, with exception of boundary pressure, do not have an effect.
    </p>
		
    <p>
      This module has been developped to be used with an Air or Moist air Media. Indeed, specific function are required when modelling moist air. </br>
      When modelling Moist Air, the atmosphere component can supply an over saturated ambiance (meanning that the ambiance contains liquid water = foggy).
    </p>	
		
  </body>
</html>"));
end Atmosphere;
