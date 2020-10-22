within TAeZoSysPro.HeatTransfer.BasesClasses;

model FreeConvection

  import Correlations = TAeZoSysPro.HeatTransfer.Types.FreeConvectionCorrelation ;
  import Functions = TAeZoSysPro.HeatTransfer.Functions.FreeConvection ;
  import SI = Modelica.SIunits ;
  extends Modelica.Thermal.HeatTransfer.Interfaces.Element1D;
  //
  replaceable package Medium = Modelica.Media.Air.ReferenceAir.Air_pT;
  // User defined parameters
  parameter Real add_on = 1 "Custom add-on";
  parameter SI.Area A = 0 "Wall surface Area" annotation(
  Dialog(group="Geometrical properties"));
  parameter SI.Length Lc = 1 "characteritic dimension for correlation" annotation(
  Dialog(group="Geometrical properties"));
  parameter TAeZoSysPro.HeatTransfer.Types.FreeConvectionCorrelation correlation = Correlations.vertical_plate_ASHRAE "Free convection Correlation" annotation(
  Dialog(group="Flow properties"));
  parameter SI.CoefficientOfHeatTransfer  h_cv_const = 0 "constant heat transfer coefficient (optional: if correlation 'Constant' choosen)" annotation(
  Dialog(group="Flow properties"));

// Internal variables
  Medium.Temperature T_mean "Mean temperature between fluid and wall";
  SI.CoefficientOfHeatTransfer h_cv "Heat transfert coefficient";
  SI.Density d "Density of fluid at T_mean";
  SI.SpecificHeatCapacity cp "Specific heat capacity of fluid at T_mean";
  SI.DynamicViscosity mu "Dynamic viscosity of fluid at T_mean";
  SI.ThermalConductivity k "Thermal Conductivity of fluid at T_mean";
  SI.PrandtlNumber Pr "Prandtl Number";
  SI.GrashofNumber Gr "Grashof Number";
  SI.RayleighNumber Ra "Rayleigh Number";
  SI.NusseltNumber Nu "Nusselt Number";
  SI.Energy E "Energy passed throught the component" ;
  
  protected
  Medium.ThermodynamicState state;
  
initial equation
  E = 0.0 ;
  
equation

  T_mean = (port_a.T + port_b.T) / 2 "port_a and port_b are defined in Element1D";
  state = Medium.setState_pTX(p = Medium.reference_p, T = T_mean, X=Medium.reference_X);
// Thermodynamic properties calculation
  d = Medium.density(state);
  mu = Medium.dynamicViscosity(state);
  cp = Medium.specificHeatCapacityCp(state);
  k = Medium.thermalConductivity(state);
// Calculation of characteristic numbers for convection
  Pr = mu * cp / k;
  Gr = 9.81 * 1/port_b.T * d^2 * abs(dT) * Lc^3 / mu^2 ;
  Ra = Gr * Pr ;
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
  der(E) = Q_flow ;
  
  annotation(
    Documentation(info =
    "<html>
	<head>
		<title>FreeConvection</title>
	
		<style type=\"text/css\">
		*       { font-size: 10pt; font-family: Arial,sans-serif; }
		code    { font-size:  9pt; font-family: Courier,monospace;}
		h4      { font-size: 13pt; font-weight: bold; color: green; }
		</style>
		
	</head>
	
	<body lang=\"en-UK\">
	
      <p>
        This component links the heat flow to a temperature difference between a wall and a fluid thanks to the Newton's law of cooling. The basic constitutive equation for convection is :
      </p>
      
      <img src=\"modelica://TAeZoSysPro/Information/HeatTransfer/BasesClasses/EQ_FreeConvection.png\" /> 

      <p>
        <b>Where :</b>
        <ul>
          <li> Q_flow: Heat flow rate from connector 'wall' (e.g., a plate) to connector 'fluid' (e.g., the surrounding air).
          <li> add_on is a user paramater to adjust if needed the Heat flow to the temperature difference dT </li>
          <li> h_cv is the convective Heat transfer coefficient (Newton's coefficient) </li>
          <li> A is the contact surface area between the wall and the fluid </li>
          <li> dT is the Temperature difference between the wall (port_a.T) and the fluid (port_b.T) </li>
        </ul>
      </p>	

      <p>
        The Heat Transfert coefficient is calculated from correlations. The correlation is set via the parameter <b> correlation </b>. Multiple correlations from multiple sources and for severals geometries are available. The details of correlations is in the released theoretical note.
      </p>
		
      <p>
		<h4>Available geometries: </h4>
		<ul>
          <li> Flow over a flat vertical wall: the characteristic length (<b>Lc</b> parameter) is the height of the wall </li>
          <li> Cross flow over a horizontal cylinder: the characteristic length (<b>Lc</b> parameter) is external diameter of the cylinder </li>
          <li> Flow over a horizontal flat wall: the characteristic length (<b>Lc</b> parameter) is the perimeter of the flat wall. A particular attention is required when dealing with horizontal surfaces. The correlation has to be <b>ground_ASHRAE</b> if the fluid is above the wall and <b>ceiling_ASHRAE</b> otherwise. The exchange coefficient is calculated differently depending on whether the wall is warmer or not. </li>
		</ul>
      </p>	
	
</body>
</html>"),
  Icon(coordinateSystem(initialScale = 0.1), graphics = {Rectangle(origin = {-54, 0}, fillColor = {140, 138, 145}, fillPattern = FillPattern.Cross, extent = {{-26, 100}, {14, -100}}), Line(origin = {-10, 0}, points = {{0, 80}, {0, -80}}, color = {0, 85, 255}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {30, 0}, points = {{0, 80}, {0, -80}}, color = {0, 85, 255}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {70, 0}, points = {{0, 80}, {0, -80}}, color = {0, 85, 255}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {25, 40}, points = {{-55, 0}, {55, 0}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {25, -40}, points = {{-55, 0}, {55, 0}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Text(origin = {26, 4}, extent = {{-28, 24}, {28, -24}}, textString = "hcv"), Line(origin = {25, 0}, points = {{-27, -22}, {27, 22}}, thickness = 1.75, arrow = {Arrow.None, Arrow.Filled}), Text(origin = {-88, 23}, rotation = 180, extent = {{-4, 11}, {28, -5}}, textString = "Wall", fontSize = 8), Text(origin = {114, 23}, extent = {{-28, 5}, {0, -9}}, textString = "Fluid", fontSize = 8)}),
    Diagram(graphics = {Rectangle(origin = {-56, -3}, fillColor = {172, 172, 172}, fillPattern = FillPattern.Cross, extent = {{-22, 85}, {22, -85}}), Line(origin = {-1, 42}, points = {{-23, 0}, {23, 0}}, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {-1, 0}, points = {{-23, 0}, {23, 0}}, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {1, -44}, points = {{-23, 0}, {23, 0}}, arrow = {Arrow.None, Arrow.Filled})}, coordinateSystem(initialScale = 0.1)),
  __OpenModelica_commandLineOptions = "");

end FreeConvection;
