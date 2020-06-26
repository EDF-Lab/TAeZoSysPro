within TAeZoSysPro.HeatTransfer.BasesClasses;
model ForcedConvection

  import Correlations = TAeZoSysPro.HeatTransfer.Types.ForcedConvectionCorrelation;
  import Functions = TAeZoSysPro.HeatTransfer.Functions.ForcedConvection;
  import SI = Modelica.SIunits;
  extends Modelica.Thermal.HeatTransfer.Interfaces.Element1D;
  //
  replaceable package Medium = Modelica.Media.Air.ReferenceAir.Air_pT;
  // User defined parameters
  parameter Real add_on = 1 "Custom add-on";
  parameter SI.Area A = 0 "Wall surface Area " annotation (
  Dialog(group="Geometrical properties"));
  parameter SI.Length Lc = 1 "characteritic dimension for correlation" annotation (
  Dialog(group="Geometrical properties"));
  parameter TAeZoSysPro.HeatTransfer.Types.ForcedConvectionCorrelation correlation = Correlations.flat_plate_ASHRAE "Forced convection Correlation" annotation (
  Dialog(group="Flow properties"));
  parameter SI.CoefficientOfHeatTransfer  h_cv_const = 0 "Constant heat transfer coefficient (optional: if correlation 'Constant' choosen)" annotation (
  Dialog(group="Flow properties"));

  // Internal variables
  Medium.Temperature T_mean "Mean temperature";
  SI.CoefficientOfHeatTransfer h_cv "Heat transfert coefficient";
  SI.Density d "Density of fluid at T_mean";
  SI.SpecificHeatCapacity cp "Specific heat capacity of fluid at T_mean";
  SI.DynamicViscosity mu "Dynamic viscosity of fluid at T_mean";
  SI.ThermalConductivity k "Thermal conductivity of fluid at T_mean";
  SI.PrandtlNumber Pr "Prandtl Number";
  SI.ReynoldsNumber Re "Reynolds Number";
  SI.NusseltNumber Nu "Nusselt Number";
  SI.Energy E "Energy passed throught the component";

  // Imported modules
  Modelica.Blocks.Interfaces.RealInput Vel "Velocity of fluid out of boundary layer" annotation (
    Placement(visible = true, transformation(origin = {56, 84}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {50, 80}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
protected
  Medium.ThermodynamicState state;

initial equation
  E = 0.0;

equation

  T_mean = (port_a.T + port_b.T) / 2 "port_a and port_b are defined in Element1D";
  state = Medium.setState_pTX(p = Medium.reference_p, T = T_mean);

// Thermodynamic perperties calculation
  d = state.d;
  mu = Medium.dynamicViscosity(state);
  cp = Medium.specificHeatCapacityCp(state);
  k = Medium.thermalConductivity(state);

// Calculation of characteristic numbers for convection
  Pr = mu * cp / k;
  Re = d * Vel * Lc / mu;

// Correlation selection
//Nu = hcv * carac_length / k ;
  if correlation == Correlations.internal_pipe_ASHRAE then
    Nu = Functions.internal_pipe_ASHRAE(Pr = Pr, Re = Re, dT = dT);

  elseif correlation == Correlations.crossFlow_cylinder_ASHRAE then
    Nu = Functions.crossFlow_cylinder_ASHRAE(Pr = Pr, Re = Re);

  elseif correlation == Correlations.flat_plate_ASHRAE then
    Nu = Functions.flat_plate_ASHRAE(Pr = Pr, Re = Re);

  elseif correlation == Correlations.Constant then
    Nu = h_cv_const * Lc / k;

  else
    Nu = 0;
    assert(false, "The correlation selected is not yet implemented of not applicable", AssertionLevel.error);

  end if;
//Convective heat transfer calculation
  h_cv = Nu * k / Lc;

// Heat flux calculation
  Q_flow = add_on * h_cv * A * dT;
  der(E) = Q_flow;

  annotation (
    Documentation(info=
    "<html>
        <head>
                <title>Convection</title>
        
                <style type=\"text/css\">
                *       { font-size: 10pt; font-family: Arial,sans-serif; }
                code    { font-size:  9pt; font-family: Courier,monospace;}
                h4      { font-size: 13pt; font-weight: bold; color: green; }
                </style>
                
        </head>
        
        <body lang=\"en-UK\">
        
      <p>
        This components links the heat flow to a temperature difference between a wall and a fluid thanks to the Newton's law of cooling. The basic constitutive equation for convection is : 
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
        The Heat Transfert coefficients is calculated from correlations. The correlation is set via the parameter <b> correlation </b>. Multiple correlations from multiple sources and for severals geometries are available. The details of correlations is in the released theoretical note.
      </p>
                
      <p>
                <h4>Available geometries: </h4>
                <ul>
          <li> Flow over a flat wall: the characteristic length (<b>Lc</b> parameter) is the height of the wall </li>
          <li> Cross flow around a cylinder: the characteristic length (<b>Lc</b> parameter) is external diameter of the cylinder </li>
          <li> Flow within a pipe: the characteristic length (<b>Lc</b> parameter) is the hydraulic diameter. </li>
                </ul>
      </p>        
        
</body>
</html>"),
  Icon(coordinateSystem(initialScale = 0.1), graphics={  Rectangle(origin = {-54, 0}, fillColor = {140, 138, 145},
            fillPattern =                                                                                                        FillPattern.Cross, extent = {{-26, 100}, {14, -100}}), Line(origin = {-10, 0}, points = {{0, 60}, {0, -80}}, color = {0, 85, 255}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {30, 0}, points = {{0, 60}, {0, -80}}, color = {0, 85, 255}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {70, 0}, points = {{0, 60}, {0, -80}}, color = {0, 85, 255}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Text(origin = {26, 4}, extent = {{-28, 24}, {28, -24}}, textString = "hcv"), Line(origin = {25, 0}, points = {{-27, -22}, {27, 22}}, thickness = 1.75, arrow = {Arrow.None, Arrow.Filled}), Text(origin = {-112, 21}, rotation = 180, extent = {{-28, 5}, {6, -5}}, textString = "Wall", fontSize = 8), Text(origin = {82, 19}, extent = {{2, 9}, {32, -5}}, textString = "Fluid", fontSize = 8), Ellipse(origin = {-2, 80}, extent = {{-20, 20}, {20, -20}}, endAngle = 360), Polygon(origin = {0, 89}, points = {{-2, -9}, {-2, 9}, {0, 9}, {2, 7}, {-2, -9}}), Polygon(origin = {8, 77}, rotation = -90, points = {{-2, -9}, {-2, 9}, {0, 9}, {2, 7}, {-2, -9}}), Polygon(origin = {-4, 71}, rotation = 180, points = {{-2, -9}, {-2, 9}, {0, 9}, {2, 7}, {-2, -9}}), Polygon(origin = {-12, 81}, rotation = 90, points = {{-2, -9}, {-2, 9}, {0, 9}, {2, 7}, {-2, -9}})}),
    Diagram(coordinateSystem(initialScale = 0.1, grid = {1, 1})),
  __OpenModelica_commandLineOptions = "");
end ForcedConvection;
