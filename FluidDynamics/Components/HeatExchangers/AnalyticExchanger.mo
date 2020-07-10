within TAeZoSysPro.FluidDynamics.Components.HeatExchangers;

model AnalyticExchanger
  //
  extends TAeZoSysPro.HeatTransfer.BasesClasses.PartialHeatExchanger;
  import TAeZoSysPro.HeatTransfer.Functions.ExchangerEffectiveness ;
  import TAeZoSysPro.HeatTransfer.Functions.ExchangerHeatTransferCoeff ;  
  //
  import SI = Modelica.SIunits ;
  
  // Medium declaration
  replaceable package MediumA = Modelica.Media.Air.ReferenceAir.Air_pT ;
  replaceable package MediumB = Modelica.Media.Air.ReferenceAir.Air_pT ;
  
  //
  replaceable function effectiveness = ExchangerEffectiveness.counterCurrent ;
  replaceable function heatTransferCoeff = ExchangerHeatTransferCoeff.user_defined ;
  
  // User defined parameters
  parameter SI.Area CrossSectionA = 1 "Cross section of the pipe for the fluid A" annotation(Dialog(group="Geometrical parameters")) ; 
  parameter SI.Area CrossSectionB = 1 "Cross section of the pipe for the fluid B" annotation(Dialog(group="Geometrical parameters"));
  parameter Real ksi_fixedA = 1.0 annotation(Dialog(group="Flow parameters"));
  parameter Real ksi_fixedB = 1.0 annotation(Dialog(group="Flow parameters"));
  
  // Internal variables
  MediumA.ThermodynamicState stateA_in "State of fluid A a inlet"  ;
  MediumB.ThermodynamicState stateB_in "State of fluid B a inlet"  ;
  SI.SpecificHeatCapacity cp_A ;
  SI.SpecificHeatCapacity cp_B ;
  SI.MassFlowRate m_flowA "Mass flow rate of fluid A" ;
  SI.MassFlowRate m_flowB "Mass flow rate of fluid B" ;
  SI.PressureDifference dp_A "fluid A pressure drop";
  SI.PressureDifference dp_B "fluid B pressure drop";
  
  // Imported modules
  Modelica.Fluid.Interfaces.FluidPort_a port_A_in(replaceable package Medium = MediumA) annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_b port_A_out(replaceable package Medium = MediumA) annotation(
    Placement(visible = true, transformation(origin = {102, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_a port_B_in(replaceable package Medium = MediumB) annotation(
    Placement(visible = true, transformation(origin = {-68, 88}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {70, -84}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_b port_B_out(replaceable package Medium = MediumB) annotation(
    Placement(visible = true, transformation(origin = {66, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-70, 82}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    
equation 
//
  stateA_in = MediumA.setState_phX(port_A_in.p, inStream(port_A_in.h_outflow), inStream(port_A_in.Xi_outflow));
  stateB_in = MediumB.setState_phX(port_B_in.p, inStream(port_B_in.h_outflow), inStream(port_B_in.Xi_outflow));
  
  // compute thermodynamical properties
  cp_A = MediumA.specificHeatCapacityCp(stateA_in) ;
  cp_B = MediumB.specificHeatCapacityCp(stateB_in) ;
  
  //
  Qc_A = m_flowA * cp_A ;
  Qc_B = m_flowB * cp_B ;
  
  //
  T_A_in = MediumA.temperature(stateA_in) ;
  T_B_in = MediumB.temperature(stateB_in) ;
  
//momentum - steady state assumptions
  m_flowA = CrossSectionA * TAeZoSysPro.FluidDynamics.Utilities.regRoot2(
    x = port_A_in.p - port_A_out.p, 
    x_small = 10, 
    k1 = 2 * MediumA.density(stateA_in) / ksi_fixedA, 
    k2 = 2 * MediumA.density(stateA_in) / ksi_fixedA);
    dp_A = port_A_in.p - port_A_out.p;
    
  m_flowB = CrossSectionB * TAeZoSysPro.FluidDynamics.Utilities.regRoot2(
    x = port_B_in.p - port_B_out.p, 
    x_small = 10, 
    k1 = 2 * MediumB.density(stateB_in) / ksi_fixedB, 
    k2 = 2 * MediumB.density(stateB_in) / ksi_fixedB);
    dp_B = port_B_in.p - port_B_out.p;
    
// heat exchange properties
  h_global = heatTransferCoeff() ;
  Eff = effectiveness(NTU = NTU, Cr = Cr) ;
  
// ports handover
  port_A_in.m_flow = m_flowA;
  port_A_in.h_outflow = inStream(port_A_in.h_outflow);
// reverse flow not modelled
  port_A_in.Xi_outflow = inStream(port_A_in.Xi_outflow);
  port_A_out.m_flow + port_A_in.m_flow = 0.0;
  m_flowA * (inStream(port_A_in.h_outflow) - port_A_out.h_outflow) = Q_flow;
  port_A_out.Xi_outflow = inStream(port_A_out.Xi_outflow);
//
  port_B_in.m_flow = m_flowB;
  port_B_in.h_outflow = inStream(port_B_in.h_outflow);
// reverse flow not modelled
  port_B_in.Xi_outflow = inStream(port_B_in.Xi_outflow);
  port_B_out.m_flow + port_B_in.m_flow = 0.0;
  m_flowB * (inStream(port_B_in.h_outflow) - port_B_out.h_outflow) = -Q_flow;
  port_B_out.Xi_outflow = inStream(port_B_out.Xi_outflow);  

annotation(Documentation(info = "
<html>
	<head>
		<title>DryExchanger</title>
		
	</head>
	
	<body lang=\"en-UK\">
	
		<p>
			This component models a dry heat exchange. It is a duplication of the component <a href= \"modelica://TAeZoSysPro.HeatTransfer.Components.HeatExchanger\">HeatExchanger</a>
			from the HeatTransfer package adapted to use fluidports.  
		</p>
		
	</body>
</html>")) ;

end AnalyticExchanger;
