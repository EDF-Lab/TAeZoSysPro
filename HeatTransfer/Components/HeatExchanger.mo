within TAeZoSysPro.HeatTransfer.Components;

model HeatExchanger
  extends BasesClasses.PartialHeatExchanger;
  //
  replaceable package MediumA = Modelica.Media.Air.ReferenceAir.Air_pT ;
  replaceable package MediumB = Modelica.Media.Air.ReferenceAir.Air_pT ;
  MediumA.ThermodynamicState stateA ;
  MediumB.ThermodynamicState stateB ;
  
  // User defined parameters
  Boolean UseNominalK = true "use the fixed nominal value or K" ;
  parameter Modelica.SIunits.CoefficientOfHeatTransfer K_nominal = 1 "Nominal value of the global exchange coefficient";
  
  // Imported Modules
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_A_in annotation(
    Placement(visible = true, transformation(origin = {-88, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port_A_out annotation(
    Placement(visible = true, transformation(origin = {96, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_B_in annotation(
    Placement(visible = true, transformation(origin = {82, -82}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {70, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port_B_out annotation(
    Placement(visible = true, transformation(origin = {-92, 94}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-70, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput m_flowA annotation(
    Placement(visible = true, transformation(origin = {-78, -50}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-100, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput m_flowB annotation(
    Placement(visible = true, transformation(origin = {34, -78}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {40, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
equation
  stateA = MediumA.setState_pTX(p=MediumA.reference_p, T = TA_in) ;
  stateB = MediumB.setState_pTX(p=MediumB.reference_p, T = TB_in) ;
  
  TA_in = port_A_in.T ;
  TB_in = port_B_in.T ;
  
  QcA = m_flowA * MediumA.specificHeatCapacityCp(stateA) ;
  QcB = m_flowB * MediumB.specificHeatCapacityCp(stateB) ;
  
  K_global = if UseNominalK then K_nominal else K_nominal ;
  
  Eff = Modelica.Fluid.Utilities.regStep(
                                           x = 0.98 - Cr,
                                           x_small = 1.0e-2,
                                           y1 = (1.0 - exp(-NTU * (1.0 - Cr))) / (1.0 - Cr * exp(-NTU * (1.0 - Cr))),
                                           y2 = NTU / (NTU + 1.0) ) ;
  
  
  // port handovers
  port_A_in.Q_flow = 0 ;
  port_B_in.Q_flow = 0 ;
  port_A_out.Q_flow = QcA * (port_A_out.T - TA_out) ;
  port_B_out.Q_flow = QcB * (port_B_out.T - TB_out) ;

annotation(Documentation(info = 
"<html>
	<head>
		<title>HeatExchanger</title>
		
	</head>
	
	<body lang=\"en-UK\">
	
		<p>
			This component models a dry heat exchange. It uses an inheritance of the component <b>PartialHeatExchanger</b>. From the <b>PartialHeatExchanger</b>,
			this component supplies the mass flow rates, the specific heat capacity and the relation to compute the efficiency of the exchanger. 
		</p>
		
		<p>
			To compute the exchange power, the following assumptions are made:
			<ul>
				<li> The heat induced by the work of friction forces throughout the exchanger are neglected </li>
				<li> The global heat transfer coefficient is constant. Its variation with respect to the flow or thermodynamical properties are neglected </li>	
				<li> The Flow configuration is supposed to be a counter flow </li>				
			</ul>
		</p>
		
		<p>
			The efficiency of the exchanger is computed using the following relations. The first one is for a ratio of the thermal flow capacity 
			<b>Cr</b>  &lt 0.98 whereas the second is for 0.98 &le; <b>Cr</b> &le; 1. The continuity between the two equations is insured by
			a polynomial interpolation.
		</p>
		
		<img	
			src=\"modelica://TAeZoSysPro/Information/HeatTransfer/Components/EQ_HeatExchanger.PNG\"
		/>
		
	</body>
</html>") ) ;

end HeatExchanger;
