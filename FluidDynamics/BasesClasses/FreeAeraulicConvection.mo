within TAeZoSysPro.FluidDynamics.BasesClasses;

model FreeAeraulicConvection

  import TAeZoSysPro.HeatTransfer.Types.FreeConvectionCorrelation ;
  import TAeZoSysPro.HeatTransfer.Functions.FreeConvection ;
  import SI = Modelica.SIunits ;
  //
  replaceable package Medium = TAeZoSysPro.Media.MyMedia ;
  // User defined parameters
  parameter Real add_on = 1 "Custom add-on";
  parameter SI.Area A = 0 "Wall Area " annotation(
  Dialog(group="Geometrical properties"));
  parameter SI.Length Lc = 0 "characteritic dimension for correlation" annotation(
  Dialog(group="Geometrical properties"));
  parameter FreeConvectionCorrelation correlation = FreeConvectionCorrelation.vertical_plate_ASHRAE "Free convection Correlation" annotation(
  Dialog(group="Flow properties"));
  parameter SI.CoefficientOfHeatTransfer  h_cv_const = 0 "heat transfer coefficient (optional: if correlation 'Constant' choosen)" annotation(
  Dialog(group="Flow properties"));

// Internal variables
  Medium.Temperature T_mean "Mean temperature between fluid and wall";
  SI.TemperatureDifference dT "Wall Temperature - fluid Temperature ";
  SI.CoefficientOfHeatTransfer h_cv "Heat transfert coefficient";
  SI.Density d "Density of fluid at T_mean";
  SI.Pressure p "pressure at flowport_Inlet" ;
  SI.SpecificEnthalpy h "pressure at flowport_Inlet" ;
  SI.SpecificHeatCapacity cp "Specific heat capacity of fluid at T_mean";
  SI.DynamicViscosity mu "Dynamic viscosity of fluid at T_mean";
  SI.ThermalConductivity k "Thermal Conductivity of fluid at T_mean";
  SI.PrandtlNumber Pr "Prandtl Number";
  SI.GrashofNumber Gr "Grashof Number";
  SI.RayleighNumber Ra "Rayleigh Number";
  SI.NusseltNumber Nu "Nusselt Number";
  SI.Energy E "Energy passed throught the component" ;
  SI.MassFraction[Medium.nX] X_Inlet "Mass fraction at inlet";
  SI.HeatFlowRate Q_flow ;
  SI.MassFlowRate m_flow "Mass flow rate induced by convection";
  // Imported Modules
  TAeZoSysPro.FluidDynamics.Interfaces.FlowPort_b flowPort_up(replaceable package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {0, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-10, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  TAeZoSysPro.FluidDynamics.Interfaces.FlowPort_b flowPort_down(replaceable package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {0, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-10, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  TAeZoSysPro.FluidDynamics.Interfaces.FlowPort_a flowPort_inlet(replaceable package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort_a annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
protected
  Medium.ThermodynamicState state;

initial equation
  E = 0.0 ;

equation
// Temporary equation
  p = Medium.reference_p;
// State Calculation
  T_mean = (heatPort_a.T + flowPort_inlet.T) / 2;
//
  dT = heatPort_a.T - flowPort_inlet.T;
  X_Inlet = 1 / sum(flowPort_inlet.d) * flowPort_inlet.d;
  state = Medium.setState_dTX(d = sum(flowPort_inlet.d), T = T_mean);
// Thermodynamic properties calculation
  d = Medium.density(state);
  h = Medium.specificEnthalpy(state) ;
  mu = Medium.dynamicViscosity(state);
  cp = Medium.specificHeatCapacityCp(state);
  k = Medium.thermalConductivity(state);
// Calculation of characteristic numbers for convection
  Pr = mu * cp / k;
  Gr = 9.81 * 1 / flowPort_inlet.T * d ^ 2 * abs(dT) * Lc ^ 3 / mu ^ 2;
  Ra = Gr * Pr ;
// Selection of the correlation
  if correlation == FreeConvectionCorrelation.vertical_plate_ASHRAE then
    Nu = FreeConvection.vertical_plate_ASHRAE(Pr = Pr, Ra = Ra);
  elseif correlation == FreeConvectionCorrelation.vertical_plate_Recknagel then
    h_cv = FreeConvection.vertical_plate_Recknagel(dT = dT, T_mean = T_mean);
  elseif correlation == FreeConvectionCorrelation.ground_ASHRAE then
    Nu = FreeConvection.ground_ASHRAE(dT = dT, Ra = Ra);
  elseif correlation == FreeConvectionCorrelation.ceiling_ASHRAE then
    Nu = FreeConvection.ceiling_ASHRAE(dT = dT, Ra = Ra);
  elseif correlation == FreeConvectionCorrelation.horizontal_cylinder_ASHRAE then
    Nu = FreeConvection.horizontal_cylinder_ASHRAE(Pr = Pr, Ra = Ra);
  elseif correlation == FreeConvectionCorrelation.Constant then
    h_cv = h_cv_const;
  else
    Nu = 0;
    assert(false, "The correlation selected is not yet implemented of not applicable", AssertionLevel.error);
  end if;
//Convective heat transfer calculation
  h_cv = Nu * k / Lc;
// Heat flux calculation
  Q_flow = add_on * A * h_cv * dT;
  der(E) = Q_flow ;
// Mass flow rate induced by buoyancy
  m_flow = h_cv * A / cp;
// port handover
// Mass balance
  flowPort_inlet.m_flow = m_flow * X_Inlet;
  flowPort_up.m_flow = -max(sign(dT) * m_flow, 0.0) * X_Inlet;
  flowPort_inlet.m_flow + flowPort_up.m_flow + flowPort_down.m_flow = fill(0.0, Medium.nX);
// Energy balance
  heatPort_a.Q_flow = Q_flow;
  flowPort_inlet.H_flow = m_flow * h;
  flowPort_up.H_flow = -max(m_flow * h * sign(dT), 0.0) - max(Q_flow, 0.0) ;
  flowPort_inlet.H_flow + flowPort_up.H_flow + flowPort_down.H_flow + Q_flow = 0;
  
  annotation(
    Documentation(info ="
<html>
  <head>
    <title>FreeConvection</title>
  </head>
	
  <body lang=\"en-UK\">
    <p>
      This components allows to model the air movement induced by natural convection over a vertical wall. 
      It assumes that the prerequisites	presented in the information tab of the <b>FreeConvection</b> of the <b>HeatTransfer</b> component are known.
    </p>
    
    <p>
      To quantify the convective flow of gas an analogy between heat and mass transfer is made. 
      The natural convection heat transfer coefficient encompasses the balance between the buoyancy force and the viscous force. 
      This is a globalisation of the local resolution of momentum and energy conservation. 
      Therefore, it is supposed that all the heat dissipated by the wall creates the work to make the gas move. 
      To computed the mass flow rate inducted bu natural convection, it is necessary to make closure hypotheses. Indeed, the mathematical model under the analogy presented above gives:
    </p>
    			
    <img	
      src=\"modelica://TAeZoSysPro/Information/FluidDynamics/BasesClasses/EQ_FreeConvection.PNG\"
    />
 		
    <p>	
      <b>Where</b>:
      <ul>
        <li> <code>m_flow</code> is the mass flow rate induced by convection </li>
        <li> <code>cp</code> is the specific heat capacity at constant pressure of the mixture </li>
        <li> <code>T_outlet</code> is the mean outlet Temperature of the boundary layer  </li>
        <li> <code>T_inlet</code> is the mean inlet Temperature of the boundary layer  </li>
        <li> <code>h_cv</code> is the convective heat transfer coefficient </li>
        <li> <code>S</code> is exchange surface area </li>
        <li> <code>T_wall</code> is the wall Temperature </li>
        <li> <code> T_&infin; </code> is fluid Temperature outside the boundary layer</li>
      </ul>				
    </p>

    <p>
      The unknown variables are <code>m_flow</code>, <code>T_outlet</code> and <code>T_inlet</code>.
      With this tree unknowns and one equation, two closure equations are required. </br> 
    </p>
    
    <p>
      The obvious comes with the inlet temperature which is equal to the <code> T_&infin; </code> because there is there is not yet a boundary layer. </br> 
      The second is to assume that <code>T_outlet</code> = <code>T_wall</code>. In pratical is never true. A Computationnal Fluid Dynamic (CFD) study performed on a flat plate in a rest atmosphere gives roughly a flow rate twice that calculated from the method above.
    </p>
    
    <p>
      The final expression for the mass flow rate derives:    
    </p>    

    <img	
      src=\"modelica://TAeZoSysPro/Information/FluidDynamics/BasesClasses/EQ_FreeConvection2.PNG\"
    />
		
    <p>
      All the flowports have to be connected to components of type control volume (lump volume, boundaries...).
    </p>		
			
  </body>
</html>"),
  Icon(coordinateSystem(initialScale = 0.1), graphics = {Rectangle(origin = {-54, 0}, fillColor = {140, 138, 145}, fillPattern = FillPattern.Cross, extent = {{-26, 100}, {14, -100}}), Line(origin = {35, 40}, points = {{-67, 0}, {55, 0}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {35, -40}, points = {{-65, 0}, {55, 0}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Text(origin = {-92, 35}, rotation = 180, extent = {{-12, 15}, {28, -5}}, textString = "Wall"), Text(origin = {108, 35}, extent = {{-28, 5}, {12, -15}}, textString = "Fluid"), Line(origin = {-10, 39}, points = {{0, -39}, {0, 39}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 5), Line(origin = {-9.97, -40.69}, rotation = 180, points = {{0, -39}, {0, 39}}, color = {0, 0, 255}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 5), Line(origin = {30.471, -40.6561}, rotation = 180, points = {{0, -39}, {0, 39}}, color = {0, 0, 255}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 5), Line(origin = {30.441, 39.0339}, points = {{0, -39}, {0, 39}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 5), Line(origin = {70.441, 39.0339}, points = {{0, -39}, {0, 39}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 5), Line(origin = {70.471, -40.6561}, rotation = 180, points = {{0, -39}, {0, 39}}, color = {0, 0, 255}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 5), Text(origin = {26, 4}, extent = {{-28, 24}, {28, -24}}, textString = "hcv"), Line(origin = {25, 0}, points = {{-27, -22}, {27, 22}}, thickness = 1.75, arrow = {Arrow.None, Arrow.Filled})}),
    Diagram(graphics = {Rectangle(origin = {-56, -3}, fillColor = {172, 172, 172}, fillPattern = FillPattern.Cross, extent = {{-22, 85}, {22, -85}}), Line(origin = {-1, 42}, points = {{-23, 0}, {23, 0}}, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {-1, 0}, points = {{-23, 0}, {23, 0}}, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {1, -44}, points = {{-23, 0}, {23, 0}}, arrow = {Arrow.None, Arrow.Filled})}, coordinateSystem(initialScale = 0.1)),
  __OpenModelica_commandLineOptions = "");

end FreeAeraulicConvection;
