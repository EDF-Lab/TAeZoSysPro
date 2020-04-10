within TAeZoSysPro.HeatTransfer.BasesClasses;

model FreeConvection_dT_decoupled
  import Correlations = TAeZoSysPro.HeatTransfer.Types.FreeConvectionCorrelation;
  import Functions = TAeZoSysPro.HeatTransfer.Functions.FreeConvection;
  import SI = Modelica.SIunits;
  //
  replaceable package Medium = Modelica.Media.Air.ReferenceAir.Air_pT;
  // User defined parameters
  parameter Real add_on = 1 "Custom add-on";
  parameter SI.Area A = 0 "Wall surface Area" annotation(
    Dialog(group = "Geometrical properties"));
  parameter SI.Length Lc = 1 "characteritic dimension for correlation" annotation(
    Dialog(group = "Geometrical properties"));
  parameter TAeZoSysPro.HeatTransfer.Types.FreeConvectionCorrelation correlation = Correlations.vertical_plate_ASHRAE "Free convection Correlation" annotation(
    Dialog(group = "Flow properties"));
  parameter SI.CoefficientOfHeatTransfer h_cv_const = 0 "constant heat transfer coefficient (optional: if correlation 'Constant' choosen)" annotation(
    Dialog(group = "Flow properties"));
  // Internal variables
  Medium.Temperature T_mean "Mean temperature between fluid and wall";
  Modelica.SIunits.TemperatureDifference dT "port_a.T - T_fluid";
  SI.CoefficientOfHeatTransfer h_cv "Heat transfert coefficient";
  SI.Density d "Density of fluid at T_mean";
  SI.SpecificHeatCapacity cp "Specific heat capacity of fluid at T_mean";
  SI.DynamicViscosity mu "Dynamic viscosity of fluid at T_mean";
  SI.ThermalConductivity k "Thermal Conductivity of fluid at T_mean";
  SI.PrandtlNumber Pr "Prandtl Number";
  SI.GrashofNumber Gr "Grashof Number";
  SI.RayleighNumber Ra "Rayleigh Number";
  SI.NusseltNumber Nu "Nusselt Number";
  Modelica.SIunits.HeatFlowRate Q_flow "Heat flow rate from port_a -> port_b";
  SI.Energy E "Energy passed throught the component";
  // Imported modules
  Modelica.Blocks.Interfaces.RealInput T_fluid annotation(
    Placement(visible = true, transformation(origin = {0, 80}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {20, 86}, extent = {{-14, -14}, {14, 14}}, rotation = -90)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port_b annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

protected
  Medium.ThermodynamicState state;
  // Imported modules
initial equation
  E = 0.0;
  
equation

  dT = port_a.T - T_fluid;
  port_a.Q_flow = Q_flow;
  port_b.Q_flow = -Q_flow;
  
  T_mean = (port_a.T + T_fluid) / 2 "port_a and port_b are defined in Element1D";
  state = Medium.setState_pTX(p = Medium.reference_p, T = T_mean);
// Thermodynamic properties calculation
  d = state.d;
  mu = Medium.dynamicViscosity(state);
  cp = Medium.specificHeatCapacityCp(state);
  k = Medium.thermalConductivity(state);
// Calculation of characteristic numbers for convection
  Pr = mu * cp / k;
  Gr = 9.81 * 1 / port_b.T * d ^ 2 * abs(dT) * Lc ^ 3 / mu ^ 2;
  Ra = Gr * Pr;
// Selection of the correlation
  if correlation == Correlations.vertical_plate_ASHRAE then
    Nu = Functions.vertical_plate_ASHRAE(Pr = Pr, Ra = Ra);
  elseif correlation == Correlations.vertical_plate_Recknagel then
    h_cv = Functions.vertical_plate_Recknagel(dT = dT, T_mean = T_mean);
  elseif correlation == Correlations.ground_ASHRAE then
    Nu = Functions.ground_ASHRAE(dT = dT, Ra = Ra);
  elseif correlation == Correlations.ceiling_ASHRAE then
    Nu = Functions.ceiling_ASHRAE(dT = dT, Ra = Ra);
  elseif correlation == Correlations.horizontal_cylinder_ASHRAE then
    Nu = Functions.horizontal_cylinder_ASHRAE(Pr = Pr, Ra = Ra);
  elseif correlation == Correlations.Constant then
    h_cv = h_cv_const;
  else
    Nu = 0;
    assert(false, "The correlation selected is not yet implemented of not applicable", AssertionLevel.error);
  end if;
//Convective heat transfer calculation
  h_cv = Nu * k / Lc;
// Heat flux calculation
  Q_flow = add_on * h_cv * A * dT;
  der(E) = Q_flow;
  
  annotation(
    Documentation(info = "
<html>
  <head>
    <title>FreeConvection_dT_decoupled</title>	
  </head>
	
  <body lang=\"en-UK\">
    <p>
      This components is almost like the FreeConvection module. 
      The difference appears for the calculation of the temperature difference between the wall and the fluid. 
      For the FreeConvection module, the temperature difference is calculated from the ports temperature. 
      It was supposed that the fluid that is caught by viscous effect within the boundary layer has the same temperature than the temperature of the port_b. 
      Moreover, it was supposed that the heat flux by convection was released or picked to the object (module) connected to the port_b. 
      The moduled 'FreeConvection_dT_decoupled' has been developped to overturn the problem where the temperature of the fluid catch by convection and the temperature of the infinite ambiance is different. 
      The fluid temperature is given the inlet port 'T_fluid'. 
      The temperature difference becomes T_wall(port_a.T) - T_fluid.
    </p>
    
    <p>
      An illustration of a difference between the fluid Temperature in contact to the boundary layer and the fluid temperature of the infinite ambiance is given on the following figure that represent an electrical ducted cabinet. 
      The air is sucked by the natural draft effect at room temperature and is released to the outside.
    </p>
    			
    <img	
      src= \"modelica://TAeZoSysPro/Information/HeatTransfer/BasesClasses/FIG_FreeConvection_dT_decoupled.png\" 
      width = \"500\"		
    />
	
	<p>
      The user defined parameters remains the same than for the FreeConvection module.
    </p>	
  </body>
</html>"),
    Icon(coordinateSystem(initialScale = 0.1), graphics = {Rectangle(origin = {-54, 0}, fillColor = {140, 138, 145}, fillPattern = FillPattern.Cross, extent = {{-26, 100}, {26, -100}}), Line(points = {{0, 80}, {0, -80}}, color = {0, 85, 255}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {40, 0}, points = {{0, 80}, {0, -80}}, color = {0, 85, 255}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {80, 0}, points = {{0, 80}, {0, -80}}, color = {0, 85, 255}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {35, 40}, points = {{-55, 0}, {55, 0}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {35, -40}, points = {{-55, 0}, {55, 0}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Text(origin = {36, 4}, extent = {{-16, 16}, {26, -24}}, textString = "hcv"), Line(origin = {35, 0}, points = {{-15, -20}, {25, 20}}, thickness = 1.75, arrow = {Arrow.None, Arrow.Filled}), Text(origin = {-112, 21}, rotation = 180, extent = {{-28, 5}, {4, -5}}, textString = "Wall", fontSize = 8), Text(origin = {88, 17}, extent = {{-4, 11}, {28, -5}}, textString = "Fluid", fontSize = 8)}),
    Diagram(graphics = {Rectangle(origin = {-56, -3}, fillColor = {172, 172, 172}, fillPattern = FillPattern.Cross, extent = {{-22, 85}, {22, -85}}), Line(origin = {-1, 42}, points = {{-23, 0}, {23, 0}}, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {-1, 0}, points = {{-23, 0}, {23, 0}}, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {1, -44}, points = {{-23, 0}, {23, 0}}, arrow = {Arrow.None, Arrow.Filled})}, coordinateSystem(initialScale = 0.1)),
    __OpenModelica_commandLineOptions = "");

end FreeConvection_dT_decoupled;
