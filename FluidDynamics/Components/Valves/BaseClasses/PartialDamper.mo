within TAeZoSysPro.FluidDynamics.Components.Valves.BaseClasses;

model PartialDamper "Base model for dampers"
  // Import section
  import Modelica.Fluid.Types.CvTypes;
  import SI = Modelica.SIunits ;

  // Replaceable classes
  replaceable function valveCharacteristic = 
    Modelica.Fluid.Valves.BaseClasses.ValveCharacteristics.linear constrainedby Modelica.Fluid.Valves.BaseClasses.ValveCharacteristics.baseFun "Inherent flow characteristic" 
    annotation(choicesAllMatching=true);
  replaceable package Medium =
      Modelica.Media.Interfaces.PartialMedium "Medium in the component"
      annotation (choicesAllMatching = true);
  
  // User defined parameters
  // *** Asumptions ***
  parameter Boolean allowFlowReversal = true "= true to allow flow reversal, false restricts to design direction (port_a -> port_b)" annotation(
  Dialog(tab="Assumptions"), Evaluate=true);
  parameter Boolean checkValve=false "Reverse flow stopped" annotation(
  Dialog(tab="Assumptions"));  

  // *** Advanced ***
  // Note: value of dp_start shall be refined by derived model, basing on local dp_nominal
  parameter Medium.AbsolutePressure dp_start(min=-Modelica.Constants.inf) = dp_nominal
      "Guess value of dp = port_a.p - port_b.p"
    annotation(Dialog(tab = "Advanced"));
  parameter Medium.MassFlowRate m_flow_start = m_flow_nominal
      "Guess value of m_flow = port_a.m_flow"
    annotation(Dialog(tab = "Advanced"));
  parameter SI.Pressure dp_small=0.01*dp_nominal "Regularisation of zero flow" 
    annotation(Dialog(tab="Advanced"));
  // Note: value of m_flow_small shall be refined by derived model, basing on local m_flow_nominal
  parameter Medium.MassFlowRate m_flow_small = 0.0
      "Small mass flow rate for regularization of zero flow"
    annotation(Dialog(tab = "Advanced"));

  // *** Diagnostics ***
  parameter Boolean show_T = true
      "= true, if temperatures at port_a and port_b are computed"
    annotation(Dialog(tab="Advanced",group="Diagnostics"));
  parameter Boolean show_V_flow = true
      "= true, if volume flow rate at inflowing port is computed"
    annotation(Dialog(tab="Advanced",group="Diagnostics"));

// *** General ***
  parameter Modelica.Fluid.Types.CvTypes CvData=Modelica.Fluid.Types.CvTypes.OpPoint "Selection of flow coefficient" annotation(
  Dialog(group = "Flow Coefficient"));
  parameter SI.Area A = 0 "Damper cross section surface area" annotation(
    Dialog(group = "Flow Coefficient", enable = (CvData==Modelica.Fluid.Types.CvTypes.Av)));
  parameter Real Kv = 0 "Kv (metric) flow coefficient [m3/h]" annotation(
  Dialog(group = "Flow Coefficient", enable = (CvData==Modelica.Fluid.Types.CvTypes.Kv)));
  parameter Real Cv = 0 "Cv (US) flow coefficient [USG/min]"annotation(
  Dialog(group = "Flow Coefficient", enable = (CvData==Modelica.Fluid.Types.CvTypes.Cv)));
  parameter SI.Pressure dp_nominal "Nominal pressure drop" annotation(
  Dialog(group="Nominal operating point"));
  parameter Medium.MassFlowRate m_flow_nominal "Nominal mass flow rate" annotation(
  Dialog(group="Nominal operating point"));
  parameter Medium.Density rho_nominal=Medium.density_pTX(Medium.p_default, Medium.T_default, Medium.X_default) "Nominal inlet density" annotation(
  Dialog(group="Nominal operating point", enable = (CvData==Modelica.Fluid.Types.CvTypes.OpPoint)));
  parameter Real opening_nominal(min=0,max=1)=1 "Nominal opening" annotation(
  Dialog(group="Nominal operating point", enable = (CvData==Modelica.Fluid.Types.CvTypes.OpPoint)));

  // Internal variables
  Medium.MassFlowRate m_flow(
     min=if allowFlowReversal then -Modelica.Constants.inf else 0,
     start = m_flow_start) "Mass flow rate in design flow direction";
     
  Modelica.SIunits.Pressure dp(start=dp_start)
      "Pressure difference between port_a and port_b (= port_a.p - port_b.p)";

  Modelica.SIunits.VolumeFlowRate V_flow=
      m_flow/Modelica.Fluid.Utilities.regStep(m_flow,
                  Medium.density(state_a),
                  Medium.density(state_b),
                  m_flow_small) if show_V_flow
      "Volume flow rate at inflowing port (positive when flow from port_a to port_b)";

  Medium.Temperature port_a_T=
      Modelica.Fluid.Utilities.regStep(port_a.m_flow,
                  Medium.temperature(state_a),
                  Medium.temperature(Medium.setState_phX(port_a.p, port_a.h_outflow, port_a.Xi_outflow)),
                  m_flow_small) if show_T
      "Temperature close to port_a, if show_T = true";
      
  Medium.Temperature port_b_T=
      Modelica.Fluid.Utilities.regStep(port_b.m_flow,
                  Medium.temperature(state_b),
                  Medium.temperature(Medium.setState_phX(port_b.p, port_b.h_outflow, port_b.Xi_outflow)),
                  m_flow_small) if show_T
      "Temperature close to port_b, if show_T = true";
  
  // Imported modules
  Modelica.Fluid.Interfaces.FluidPort_a port_a(
                                redeclare package Medium = Medium,
                     m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0))
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(
                                redeclare package Medium = Medium,
                     m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0))
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{110,-10},{90,10}}), iconTransformation(extent={{110,-10},{90,10}})));

  Modelica.Blocks.Interfaces.RealInput opening(min=0, max=1) "Valve position in the range 0..1" annotation (Placement(visible = true,transformation(
        origin={0,90},
        extent={{-20,-20},{20,20}},
        rotation=270), iconTransformation(origin = {8.88178e-16, 86}, extent = {{-14, -14}, {14, 14}}, rotation = 270)));
      
  protected
  Medium.ThermodynamicState state_a "state for medium inflowing through port_a";
  Medium.ThermodynamicState state_b "state for medium inflowing through port_b";
  constant Real N6 = 31.6 "N6 constant of the ISA-75.01.01-2007 standard";
  parameter SI.Area Av(fixed = false) ;

initial equation
  if CvData == CvTypes.Kv then
    Av = Kv * N6 / 3600 / sqrt(1e5) "Unit conversion";
  elseif CvData == CvTypes.Cv then
    Av = Cv * 0.865 * N6 "Unit conversion";
  elseif CvData == CvTypes.Av then
    Av = A * sqrt(2) "Root of 2 is added to compensate for its lack in head expression V_flow = f(head)";    
  end if;


equation
  // medium states
  state_a = Medium.setState_phX(port_a.p, inStream(port_a.h_outflow), inStream(port_a.Xi_outflow));
  state_b = Medium.setState_phX(port_b.p, inStream(port_b.h_outflow), inStream(port_b.Xi_outflow));

  // Pressure drop in design flow direction
  dp = port_a.p - port_b.p;

  // Design direction of mass flow rate
  m_flow = port_a.m_flow;
  assert(m_flow > -m_flow_small or allowFlowReversal, "Reversing flow occurs even though allowFlowReversal is false");

  // Mass balance (no storage)
  port_a.m_flow + port_b.m_flow = 0;

  // Transport of substances
  port_a.Xi_outflow = inStream(port_b.Xi_outflow);
  port_b.Xi_outflow = inStream(port_a.Xi_outflow);

  port_a.C_outflow = inStream(port_b.C_outflow);
  port_b.C_outflow = inStream(port_a.C_outflow);
  
  // Isenthalpic state transformation (no storage and no loss of energy)
  port_a.h_outflow = inStream(port_b.h_outflow);
  port_b.h_outflow = inStream(port_a.h_outflow);
 
  annotation (
    Icon(graphics = {Rectangle(extent = {{-80, 80}, {80, -80}})}),
    Documentation(info="<html>
  <p>
    This is the base model for <code>Damper_parallelBlades</code> and <code>Damper_opposedBlades</code> strongly inspired from the PartialValve of Modelica Standard Library (MSL). 
    The model is based on the IEC 534 / ISA-75.01.01-2007 standard for valve sizing.
  </p>

  <p>
    The model optionally supports reverse flow conditions (assuming symmetrical behaviour) or check valve operation, and has been suitably regularized, compared to the equations in the standard, in order to avoid numerical singularities around zero pressure drop operating conditions.
  </p>
  
  <p>
    The model assumes adiabatic operation (no heat losses to the ambient); changes in kinetic energy
from inlet to outlet are neglected in the energy balance.
  </p>
  
  <p>
    <strong>Modelling options</strong>
  </p>
  
  <p>
    The following options are available to specify the valve flow coefficient in fully open conditions:
  </p>
  
  <ul>
    <li><code>CvData = Modelica.Fluid.Types.CvTypes.Av</code>: The cross section surface area is given by the metric <code>A</code> coefficient (m^2).</li>
    <li><code>CvData = Modelica.Fluid.Types.CvTypes.Kv</code>: the flow coefficient is given by the metric <code>Kv</code> coefficient (m^3/h).</li>
    <li><code>CvData = Modelica.Fluid.Types.CvTypes.Cv</code>: the flow coefficient is given by the US <code>Cv</code> coefficient (USG/min).</li>
    <li><code>CvData = Modelica.Fluid.Types.CvTypes.OpPoint</code>: the flow is computed from the nominal operating point specified by <code>p_nominal</code>, <code>dp_nominal</code>, <code>m_flow_nominal</code>, <code>rho_nominal</code>, <code>opening_nominal</code>.</li>
  </ul>
  
  <p>
    The nominal conditions (mainly pressure drop <code>dp_nominal</code> and mass flow rate <code>m_flow_nominal</code>) must always be specified;
  </p>
  
  <ul>
    <li> To avoid numerical singularities, the flow characteristic is modified for pressure drops less than <code>dp_small</code>. 
         The default value for <code>dp_small</code> is 1% of the nominal pressure drop <code>dp_nominal</code>.  
         Increase <code>dp_small</code> if numerical problems occur in dampers with very low pressure drops</li></li>
    <li> To be used a guess values. Moreover the homotopy operator used <code>dp_nominal</code> and <code>m_flow_nominal</code> to compute the flow with the 'simplified' solution.
  </ul>      
    
  <p>
    If <code>checkValve</code> is true, then the flow is stopped when the outlet pressure is higher than the inlet pressure; otherwise, reverse flow takes place. 
    Use this option only when needed, as it increases the numerical complexity of the problem.
  </p>
  
  <p>
    The valve opening characteristic <code>valveCharacteristic</code>, linear by default, can be replaced by any user-defined function available in the <code>ValveCharacteristics</code> package. 
    Functions provides by the Modelica Standard Library (MSL) are compatible.
    The characteristics for constant port_a.p and port_b.p pressures with continuously changing opening are shown in the next two figures:
  </p>

  <img 
    src=\"modelica://TAeZoSysPro/Information/FluidDynamics/Components/Valves/BaseClasses/FIG_PartialDamper.png\"
    alt=\"ValveCharacteristics.png\"><br>

  <p>
    The treatment of parameters <b>Kv</b> and <b>Cv</b> slightly differs from the explaination detailled in the <a href=\"modelica://Modelica.Fluid.UsersGuide.ComponentDefinition.ValveCharacteristics\">User's Guide</a> and derives more from the standard.
  </p>

  <img 
    src=\"modelica://TAeZoSysPro/Information/FluidDynamics/Components/Valves/BaseClasses/EQ_PartialDamper1.png\" ><br>

  <p>
    In the above equation, <code>m_flow</code> and <code>p</code> unit are respectively in m3/h and bar. 
  </p>
   
  <img 
    src=\"modelica://TAeZoSysPro/Information/FluidDynamics/Components/Valves/BaseClasses/EQ_PartialDamper2.png\" ><br>
    
  <img 
    src=\"modelica://TAeZoSysPro/Information/FluidDynamics/Components/Valves/BaseClasses/EQ_PartialDamper3.png\" ><br>
    
  <img 
    src=\"modelica://TAeZoSysPro/Information/FluidDynamics/Components/Valves/BaseClasses/EQ_PartialDamper4.png\" ><br>

  <p>	
    <b>Where</b>:
    <ul>
      <li> m_flow is the mass flow rate in m3/h </li>
      <li> <code>Y</code> is the expansion factor as defined in the standard </li> 
      <li> <code>x</code> is the ratio of pressure differential to upstream absolute pressure (dp /p) </li> 
      <li> <code>Fγ</code> is the Specific heat ratio factor (γ/1.4) </li>        
      <li> <code>d</code> is the upstream density </li>
      <li> <code>N6</code> is a constant depending of the chosen coefficient Kv or Cv </li>              
    </ul>				
  </p>

</html>"));

end PartialDamper;
