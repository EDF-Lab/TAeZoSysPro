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
  parameter SI.Area Av(
    fixed= CvData == Modelica.Fluid.Types.CvTypes.Av,
    start=m_flow_nominal/(sqrt(rho_nominal*dp_nominal))*valveCharacteristic(opening_nominal)) "Av (metric) flow coefficient" annotation(
    Dialog(group = "Flow Coefficient", enable = (CvData==Modelica.Fluid.Types.CvTypes.Av)));
  parameter Real Kv = 0 "Kv (metric) flow coefficient [m3/h]" annotation(
  Dialog(group = "Flow Coefficient", enable = (CvData==Modelica.Fluid.Types.CvTypes.Kv)));
  parameter Real Cv = 0 "Cv (US) flow coefficient [USG/min]"annotation(
  Dialog(group = "Flow Coefficient", enable = (CvData==Modelica.Fluid.Types.CvTypes.Cv)));
  parameter SI.Pressure dp_nominal "Nominal pressure drop" annotation(
  Dialog(group="Nominal operating point"));
  parameter Medium.MassFlowRate m_flow_nominal "Nominal mass flowrate" annotation(
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
  constant SI.Area Kv2Av = 27.7e-6 "Conversion factor";
  constant SI.Area Cv2Av = 24.0e-6 "Conversion factor";
  
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
protected
  parameter SI.Pressure dp_small=1e-2 "Regularisation of zero flow" annotation(Dialog(tab="Advanced"));
initial equation
  if CvData == CvTypes.Kv then
    Av = Kv*Kv2Av "Unit conversion";
  elseif CvData == CvTypes.Cv then
    Av = Cv*Cv2Av "Unit conversion";
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
    Icon(coordinateSystem(initialScale = 0.1), graphics = {Rectangle(extent = {{-80, 80}, {80, -80}})}),
    Documentation(info="<html>
<p>This is the base model for the <code>ValveIncompressible</code>, <code>ValveVaporizing</code>, and <code>ValveCompressible</code> valve models. The model is based on the IEC 534 / ISA S.75 standards for valve sizing.</p>
<p>The model optionally supports reverse flow conditions (assuming symmetrical behaviour) or check valve operation, and has been suitably regularized, compared to the equations in the standard, in order to avoid numerical singularities around zero pressure drop operating conditions.</p>
<p>The model assumes adiabatic operation (no heat losses to the ambient); changes in kinetic energy
from inlet to outlet are neglected in the energy balance.</p>
<p><strong>Modelling options</strong></p>
<p>The following options are available to specify the valve flow coefficient in fully open conditions:</p>
<ul><li><code>CvData = Modelica.Fluid.Types.CvTypes.Av</code>: the flow coefficient is given by the metric <code>Av</code> coefficient (m^2).</li>
<li><code>CvData = Modelica.Fluid.Types.CvTypes.Kv</code>: the flow coefficient is given by the metric <code>Kv</code> coefficient (m^3/h).</li>
<li><code>CvData = Modelica.Fluid.Types.CvTypes.Cv</code>: the flow coefficient is given by the US <code>Cv</code> coefficient (USG/min).</li>
<li><code>CvData = Modelica.Fluid.Types.CvTypes.OpPoint</code>: the flow is computed from the nominal operating point specified by <code>p_nominal</code>, <code>dp_nominal</code>, <code>m_flow_nominal</code>, <code>rho_nominal</code>, <code>opening_nominal</code>.</li>
</ul>
<p>The nominal pressure drop <code>dp_nominal</code> must always be specified; to avoid numerical singularities, the flow characteristic is modified for pressure drops less than <code>b*dp_nominal</code> (the default value is 1% of the nominal pressure drop). Increase this parameter if numerical problems occur in valves with very low pressure drops.</p>
<p>If <code>checkValve</code> is true, then the flow is stopped when the outlet pressure is higher than the inlet pressure; otherwise, reverse flow takes place. Use this option only when needed, as it increases the numerical complexity of the problem.</p>
<p>The valve opening characteristic <code>valveCharacteristic</code>, linear by default, can be replaced by any user-defined function. Quadratic and equal percentage with customizable rangeability are already provided by the library. The characteristics for constant port_a.p and port_b.p pressures with continuously changing opening are shown in the next two figures:
</p>

<blockquote>
<img src=\"modelica://Modelica/Resources/Images/Fluid/Components/ValveCharacteristics1a.png\"
 alt=\"ValveCharacteristics1a.png\"><br>
<img src=\"modelica://Modelica/Resources/Images/Fluid/Components/ValveCharacteristics1b.png\"
 alt=\"Components/ValveCharacteristics1b.png\">
</blockquote>

<p>
The treatment of parameters <strong>Kv</strong> and <strong>Cv</strong> is
explained in detail in the
<a href=\"modelica://Modelica.Fluid.UsersGuide.ComponentDefinition.ValveCharacteristics\">User's Guide</a>.
</p>

<p>
With the optional parameter \"filteredOpening\", the opening can be filtered with a
<strong>second order, criticalDamping</strong> filter so that the
opening demand is delayed by parameter \"riseTime\". The filtered opening is then available
via the output signal \"opening_filtered\" and is used to control the valve equations.
This approach approximates the driving device of a valve. The \"riseTime\" parameter
is used to compute the cut-off frequency of the filter by the equation: f_cut = 5/(2*pi*riseTime).
It defines the time that is needed until opening_filtered reaches 99.6 % of
a step input of opening. The icon of a valve changes in the following way
(left image: filteredOpening=false, right image: filteredOpening=true):
</p>

<blockquote>
<img src=\"modelica://Modelica/Resources/Images/Fluid/Components/FilteredValveIcon.png\"
 alt=\"FilteredValveIcon.png\">
</blockquote>

<p>
If \"filteredOpening = <strong>true</strong>\", the input signal \"opening\" is limited
by parameter <strong>leakageOpening</strong>, i.e., if \"opening\" becomes smaller as
\"leakageOpening\", then \"leakageOpening\" is used instead of \"opening\" as input
for the filter. The reason is that \"opening=0\" might structurally change the equations of the
fluid network leading to a singularity. If a small leakage flow is introduced
(which is often anyway present in reality), the singularity might be avoided.
</p>

<p>
In the next figure, \"opening\" and \"filtered_opening\" are shown in the case that
filteredOpening = <strong>true</strong>, riseTime = 1 s, and leakageOpening = 0.02.
</p>

<blockquote>
<img src=\"modelica://Modelica/Resources/Images/Fluid/Components/ValveFilteredOpening.png\"
 alt=\"ValveFilteredOpening.png\">
</blockquote>

</html>", revisions="<html>
<ul>
<li><em>Sept. 5, 2010</em>
by <a href=\"mailto:martin.otter@dlr.de\">Martin Otter</a>:<br>
Optional filtering of opening introduced, based on a proposal
from Mike Barth (Universitaet der Bundeswehr Hamburg) +
Documentation improved.</li>
<li><em>2 Nov 2005</em>
by <a href=\"mailto:francesco.casella@polimi.it\">Francesco Casella</a>:<br>
   Adapted from the ThermoPower library.</li>
</ul>
</html>"));

end PartialDamper;
