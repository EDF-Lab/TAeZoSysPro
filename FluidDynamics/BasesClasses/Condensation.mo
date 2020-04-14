within TAeZoSysPro.FluidDynamics.BasesClasses;

model Condensation
  // medium declaration
  replaceable package Medium = Modelica.Media.Air.MoistAir;

  Medium.ThermodynamicState state "State of fluid at infinite conditions";
  
  // User defined parameters
  parameter Modelica.SIunits.Area A = 1 "Wall surface area";
  parameter Real add_on = 1 "add on mass transfer coefficient";
  
  // Internal variables
  Modelica.SIunits.MassFlowRate m_flow "Mass flow rate >0 if condensation";
  Modelica.SIunits.SpecificHeatCapacityAtConstantPressure cp "Specific Heat Capacity";
  Modelica.SIunits.Density d_sat "Saturation density of the condensable species" ;
  Real betaV(unit = "kg/m2/s") "mass transfer coefficient";
  
  // Imported Modules
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b heatPort annotation(
    Placement(visible = true, transformation(origin = {102, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput m_flow_cond(unit = "kg/s") annotation(
    Placement(visible = true, transformation(origin = {0, -50}, extent = {{10, -10}, {-10, 10}}, rotation = 90), iconTransformation(origin = {-30, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 270)));
  TAeZoSysPro.FluidDynamics.Interfaces.FlowPort_a flowPort(replaceable package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-100, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-92, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput h_cv(unit = "W/(m2.K)") "Convective heat exchange coefficient" annotation(
    Placement(visible = true, transformation(origin = {-80, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-80, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

equation

// Calculation of properties
  state = Medium.setState_dTX(d = sum(flowPort.d), T = flowPort.T, X = flowPort.d / sum(flowPort.d));
  cp = Medium.specificHeatCapacityCp(state);
  d_sat = Medium.saturationPressure(heatPort.T) / (heatPort.T*Modelica.Constants.R/Medium.MMX[Medium.Water]) ;

// Calculation of the condensation flow rate
  betaV = add_on * h_cv / (sum(flowPort.d) * cp);
  m_flow = betaV * max((flowPort.d[Medium.Water] - d_sat), 0.0) * A ;

// Ports handover
  flowPort.m_flow[Medium.Water] = m_flow;
  flowPort.m_flow[Medium.Air] = 0;
  flowPort.H_flow = m_flow * Medium.enthalpyOfVaporization(flowPort.T);
  flowPort.H_flow + heatPort.Q_flow = 0.0 ;

//Output condensation data
  m_flow_cond = m_flow ;
  
  annotation(
    Diagram,
    Icon(graphics = {Rectangle(origin = {-10, -1}, fillColor = {136, 136, 136}, fillPattern = FillPattern.Cross, extent = {{-10, 101}, {30, -99}}), Ellipse(origin = {-23, 46}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid, extent = {{-11, 34}, {3, 20}}, endAngle = 360), Line(origin = {44.67, 60}, points = {{-15, 0}, {15, 0}}, color = {255, 0, 0}, thickness = 1.25, arrow = {Arrow.Filled, Arrow.Filled}, arrowSize = 5), Line(origin = {44.67, -40}, points = {{-15, 0}, {15, 0}}, color = {255, 0, 0}, thickness = 1.25, arrow = {Arrow.Filled, Arrow.Filled}, arrowSize = 5), Line(origin = {44.67, 40}, points = {{-15, 0}, {15, 0}}, color = {255, 0, 0}, thickness = 1.25, arrow = {Arrow.Filled, Arrow.Filled}, arrowSize = 5), Line(origin = {44.28, -60}, points = {{-15, 0}, {15, 0}}, color = {255, 0, 0}, thickness = 1.25, arrow = {Arrow.Filled, Arrow.Filled}, arrowSize = 5), Ellipse(origin = {-23, 30}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid, extent = {{-11, 34}, {3, 20}}, endAngle = 360), Ellipse(origin = {-23, 14}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid, extent = {{-11, 34}, {3, 20}}, endAngle = 360), Ellipse(origin = {-23, -2}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid, extent = {{-11, 34}, {3, 20}}, endAngle = 360), Ellipse(origin = {-23, -18}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid, extent = {{-11, 34}, {3, 20}}, endAngle = 360), Ellipse(origin = {-23, -34}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid, extent = {{-11, 34}, {3, 20}}, endAngle = 360), Ellipse(origin = {-23, -50}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid, extent = {{-11, 34}, {3, 20}}, endAngle = 360), Ellipse(origin = {-23, -66}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid, extent = {{-11, 34}, {3, 20}}, endAngle = 360), Ellipse(origin = {-23, -82}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid, extent = {{-11, 34}, {3, 20}}, endAngle = 360), Ellipse(origin = {-23, -98}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid, extent = {{-11, 34}, {3, 20}}, endAngle = 360)}, coordinateSystem(initialScale = 0.1)),
    Documentation(info = "
<html>
  <head>
    <title>Condensation</title>
  </head>
	
  <body lang=\"en-UK\">
    <p>
      This components allows to model the mass flow rate and the energy transfer induced by the condensation of a condensable species over a colder surface.
    </p>
		
    <p>
      <b>Remark:</b> Condensation is scientifically defined as the transition from gaseous to solid state. 
      However, it is commonly used today for the passage from the gaseous to liquid state. 
      The term “condensation” is therefore used in this report for a transformation corresponding to liquefaction.
    </p>
		
    <p>
      The mathematical beyond this module uses a different approach than the filmwise or dropwise condensation where the main assumption remains that the limiting phenomena is the capability of the film to evacuate the heat from condensation. 
      Here the mains assumptions is that the model for condensation is limited by the capability of the flow of moisture laden vapour to be brought into contact with the cold surface.
    </p>
		
    <p>
      During condensation, the heat transfer and mass transfer mechanism can be decomposed by the following steps.
      <ol>
        <li>A mass of moist air from a control volume is brought into contact with the wall by the natural convection. </li> 
        <li>The gas exchanges heat with the wall until the temperature of the wall and the gas are equal (hypothesis required to computed the mass flow rate induced by natural convection: see FreeConvection module for details). 
            The Heat tranfer induced by this cooling phase is <b>not</b> counted in this module since it is the role of the convection modules. Here only the Heat from condensation is exchanged </li> 
        <li>The condensable liquid contained in this mass of gas is then totally drained until the density of the condensable species equates to that of saturation at the temperature of the wall.
            Since the characteristic time of condensation is much less than the convective time, it can be considered that the whole potentially condensable material quantity has condensed. 
      </ol> 
    </p>
    
    <p>           
      The element limiting the rate of condensation is <b>the ability to bring the mass of moist air into contact with a wall</b>. 
      This is represented by a coefficient βv determined by the following equation:
    </p>
		
    <img	
      src=\"modelica://TAeZoSysPro/Information/FluidDynamics/BasesClasses/EQ_Condensation.PNG\" 
      width = \"600\"
    />	
			
    <p>	
      <b>Where</b>:
      <ul>
        <li> <code>V_fow</code> is the volume flow rate induced by the convection phenomenon</li>
        <li> <code>&beta;</code> is the mass transfer coefficient</li>
        <li> <code>A</code> is exchange surface area between the fluid and the wall </li>
        <li> <code>m_fow</code> is the mass flow rate of condensation</li>             
        <li> <code>d</code> is the density of the condensable species  </li>
        <li> <code>d_sat</code> is the saturation density of the condensable species at the wall surface temperature <code>heatPort.T</code> </li>
      </ul>				
    </p>
		
    <p>		
      As explained at the begining of this description, the fluid of the control volume is first cooled before condensation occurs. 
      For the energy balance, this phase of sensible cooling is not counted as heat exchange by condensation because it has already been in the convective exchange model. 
      The additional energy transferred from the fluid into the wall is the latent heat from condensation.
    </p>
		
	</body>
</html>"));

end Condensation;
