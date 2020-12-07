within TAeZoSysPro.FluidDynamics.Components.HeatExchangers;

model DiscreteExchanger
  //
  encapsulated type FlowConfiguration = enumeration(CoCurrent, CounterCurrent) ;
  //
  import TAeZoSysPro.HeatTransfer.Functions.ExchangerEffectiveness ;
  import TAeZoSysPro.HeatTransfer.Functions.ExchangerHeatTransferCoeff ;  
//
  import SI = Modelica.SIunits ;
  // Medium declaration
  replaceable package MediumA = TAeZoSysPro.Media.MyMedia ;
  replaceable package MediumB = TAeZoSysPro.Media.MyMedia ;
  //
  replaceable function effectiveness = ExchangerEffectiveness.counterCurrent ;
  replaceable function heatTransferCoeff = ExchangerHeatTransferCoeff.user_defined ;
  // User defined parameters
  parameter Modelica.SIunits.Area A = 1.0 "equivalent exchange surface area" annotation(Dialog(group="Geometrical parameters"));
  parameter Modelica.SIunits.Length L_A = 1.0 "Length of the side A of the exchanger" annotation(Dialog(group="Geometrical parameters"));
  parameter Modelica.SIunits.Length L_B = 1.0 "Length of the side B of the exchanger" annotation(Dialog(group="Geometrical parameters"));
  parameter SI.Area CrossSectionA = 1 "Cross section of the pipe for the fluid A" annotation(Dialog(group="Geometrical parameters")) ; 
  parameter SI.Area CrossSectionB = 1 "Cross section of the pipe for the fluid B" annotation(Dialog(group="Geometrical parameters"));
  parameter Real ksi_fixedA = 1.0 annotation(Dialog(group="Flow parameters"));
  parameter Real ksi_fixedB = 1.0 annotation(Dialog(group="Flow parameters"));
  parameter Integer N = 3 "Number of discrete layers" ;
  parameter FlowConfiguration flowConfiguration = FlowConfiguration.CounterCurrent ;
  // Internal variables
  Modelica.SIunits.ThermalConductance Qc_A(min=0) "Thermal flow rate unit of fluid A";
  Modelica.SIunits.ThermalConductance Qc_B(min=0) "Thermal flow rate unit of fluid B";
  Modelica.SIunits.Temperature T_A_in, T_A_out, T_B_in, T_B_out;
  Modelica.SIunits.CoefficientOfHeatTransfer h_global "Heat transfer coeffcient between fluid A and B" ;
  Modelica.SIunits.HeatFlowRate Q_flow "Heat flow exchanged";
  Modelica.SIunits.Energy E "Energy passed throught the component" ;
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
  TAeZoSysPro.PDE.Transport.UpwindFirstOrder transport_A(
    N = N, 
    x = linspace(0, L_A, N+1),
    CoeffTimeDer = MediumA.density(stateA_in) * CrossSectionA * cp_A) annotation(
    Placement(visible = true, transformation(origin = {4, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  TAeZoSysPro.PDE.Transport.UpwindFirstOrder transport_B(
    N = N, 
    x = linspace(0, L_B, N+1),
    CoeffTimeDer = MediumB.density(stateB_in) * CrossSectionB * cp_B) annotation(
    Placement(visible = true, transformation(origin = {-12, -32}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

initial  equation
  E = 0.0;
//  der(transport_A.u[2:end]) = fill(0.0, N) ;
//  der(transport_B.u[2:end]) = fill(0.0, N) ;
  transport_A.u[:,1] = fill(293.15, N) ;
  transport_B.u[:,1] = fill(293.15, N) ;
  
equation
//
  stateA_in = MediumA.setState_phX(
    port_A_in.p, 
    inStream(port_A_in.h_outflow), 
    inStream(port_A_in.Xi_outflow));
  stateB_in = MediumB.setState_phX(
    port_B_in.p, 
    inStream(port_B_in.h_outflow), 
    inStream(port_B_in.Xi_outflow));
    
// compute thermodynamical properties
  cp_A = MediumA.specificHeatCapacityCp(stateA_in);
  cp_B = MediumB.specificHeatCapacityCp(stateB_in) ;
  
//
  Qc_A = m_flowA * cp_A;
  Qc_B = m_flowB * cp_B ;
  
//
  T_A_in = MediumA.temperature(stateA_in);
  T_B_in = MediumB.temperature(stateB_in) ;
  
//momentum - steady state assumptions
  m_flowA = CrossSectionA * TAeZoSysPro.FluidDynamics.Utilities.regRoot2(x = port_A_in.p - port_A_out.p, x_small = 10, k1 = 2 * MediumA.density(stateA_in) / ksi_fixedA, k2 = 2 * MediumA.density(stateA_in) / ksi_fixedA);
    dp_A = port_A_in.p - port_A_out.p;
    
  m_flowB = CrossSectionB * TAeZoSysPro.FluidDynamics.Utilities.regRoot2(
    x = port_B_in.p - port_B_out.p, 
    x_small = 10, 
    k1 = 2 * MediumB.density(stateB_in) / ksi_fixedB, 
    k2 = 2 * MediumB.density(stateB_in) / ksi_fixedB);
    dp_B = port_B_in.p - port_B_out.p;
    
// transport 
  transport_A.CoeffSpaceDer = m_flowA * cp_A ;
  transport_B.CoeffSpaceDer = m_flowB * cp_B ;
  //
// boundary equations
// left
  transport_A.u_ghost_left[1] = T_A_in;
  transport_B.u_ghost_left[1] = T_B_in;
// left
  transport_A.u_ghost_right[1] = T_A_in;
  transport_B.u_ghost_right[1] = T_B_in;

  
  if flowConfiguration == FlowConfiguration.CounterCurrent then
    for i in 1:N loop
      transport_A.SourceTerm[i] = h_global * A/L_A * (transport_B.u[N+1-i,1]-transport_A.u[i,1]);
      transport_B.SourceTerm[i] = h_global * A/L_B * (transport_A.u[N+1-i,1]-transport_B.u[i,1]);
    end for;
      
  else
    for i in 1:N loop
      transport_A.SourceTerm[i] = h_global * A/L_A  * (transport_B.u[i,1]-transport_A.u[i,1]);
      transport_B.SourceTerm[i] = h_global * A/L_B  * (transport_A.u[i,1]-transport_B.u[i,1]);
    end for;

  end if ;

  T_A_out = transport_A.u[end,1] ;
  T_B_out = transport_B.u[end,1] ;
// heat exchange properties
  h_global = heatTransferCoeff();
  Q_flow = sum(transport_A.SourceTerm) * L_A/N ;
  der(E) = Q_flow ;
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
</html>"),
    Icon(coordinateSystem(initialScale = 0.1), graphics = {Rectangle(origin = {-2, 0}, lineColor = {0, 161, 241}, fillColor = {211, 211, 211}, pattern = LinePattern.None, fillPattern = FillPattern.HorizontalCylinder, lineThickness = 0.5, extent = {{-86, 14}, {90, -14}}), Line(origin = {-48.1691, -0.0769465}, points = {{-12, 0}, {12, 0}}, color = {94, 94, 94}, thickness = 0.5, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 5), Text(origin = {-48, -2}, lineThickness = 0.5, extent = {{-26, 12}, {122, -8}}, textString = "Fluid A", fontSize = 8), Line(origin = {45.8309, -0.336488}, points = {{-12, 0}, {12, 0}}, color = {94, 94, 94}, thickness = 0.5, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 5), Line(origin = {33.5697, -26.3828}, rotation = 180, points = {{-12, 0}, {12, 0}}, color = {207, 207, 207}, thickness = 0.5, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 5), Line(origin = {69.0506, -52.8561}, rotation = 90, points = {{-12, 0}, {12, 0}}, color = {207, 207, 207}, thickness = 0.5, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 5), Line(origin = {-35.3005, -26.0775}, rotation = 180, points = {{-12, 0}, {12, 0}}, color = {207, 207, 207}, thickness = 0.5, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 5), Polygon(origin = {-18, -50}, fillColor = {255, 0, 0}, fillPattern = FillPattern.Solid, lineThickness = 0.5, points = {{-62, 36}, {-62, 14}, {78, 14}, {78, -18}, {98, -18}, {98, 36}, {-62, 36}}), Polygon(origin = {18, 50}, rotation = 180, fillColor = {213, 0, 0}, fillPattern = FillPattern.Solid, lineThickness = 0.5, points = {{-62, 36}, {-62, 14}, {78, 14}, {78, -16}, {98, -16}, {98, 36}, {-62, 36}}), Line(origin = {-70.0865, 48.0933}, rotation = 90, points = {{-12, 0}, {12, 0}}, color = {207, 207, 207}, thickness = 0.5, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 5), Text(origin = {-48, 26}, lineThickness = 0.5, extent = {{-26, 6}, {122, -8}}, textString = "Fluid B", fontSize = 8), Line(origin = {-34.2845, 24.4902}, rotation = 180, points = {{-12, 0}, {12, 0}}, color = {207, 207, 207}, thickness = 0.5, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 5), Line(origin = {39.9145, 24.3595}, rotation = 180, points = {{-12, 0}, {12, 0}}, color = {207, 207, 207}, thickness = 0.5, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 5), Line(origin = {-34.1619, -25.5166}, rotation = 180, points = {{-12, 0}, {12, 0}}, color = {207, 207, 207}, thickness = 0.5, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 5), Line(origin = {70.1888, -52.2955}, rotation = 90, points = {{-12, 0}, {12, 0}}, color = {207, 207, 207}, thickness = 0.5, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 5), Line(origin = {34.7078, -25.8219}, rotation = 180, points = {{-12, 0}, {12, 0}}, color = {207, 207, 207}, thickness = 0.5, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 5)}));

end DiscreteExchanger;
