within TAeZoSysPro.FluidDynamics.Components.Valves;

model Damper_parallelBlades
  extends TAeZoSysPro.FluidDynamics.Components.Valves.BaseClasses.PartialDamper(
    redeclare function valveCharacteristic = TAeZoSysPro.FluidDynamics.Components.Valves.BaseClasses.ValveCharacteristics.polynomial(
      c = {0, 0.5082, -0.5258, 1.0667, -0.0491}) ) ;
  import Modelica.Fluid.Types.CvTypes;
    parameter Medium.AbsolutePressure p_nominal "Nominal inlet pressure" annotation(Dialog(group="Nominal operating point"));
  parameter Real Fxt=0.5 "F_gamma*xt critical ratio at full opening";
  
  Real x "Pressure drop ratio";
  Real xs "Saturated pressure drop ratio";
  Real Y "Compressibility factor";
  Medium.AbsolutePressure p "Inlet pressure";
  Real relativeFlowCoefficient, d_a ;  

protected
  parameter Real Fxt_nominal(fixed=false) "Nominal Fxt";
  parameter Real x_nominal(fixed=false) "Nominal pressure drop ratio";
  parameter Real xs_nominal(fixed=false)
    "Nominal saturated pressure drop ratio";
  parameter Real Y_nominal(fixed=false) "Nominal compressibility factor";
  
initial equation
  if CvData == CvTypes.OpPoint then
    // Determination of Av by the nominal operating point conditions
    Fxt_nominal = Fxt ;
    x_nominal = dp_nominal/p_nominal;
    xs_nominal = smooth(0, if x_nominal > Fxt_nominal then Fxt_nominal else x_nominal);
    Y_nominal = 1 - abs(xs_nominal)/(3*Fxt_nominal);
    m_flow_nominal = valveCharacteristic(opening_nominal)*Av*Y_nominal*sqrt(rho_nominal)*Modelica.Fluid.Utilities.regRoot(p_nominal*xs_nominal, dp_small);
  else
    // Dummy values
    Fxt_nominal = 0 ;
    x_nominal = 0;
    xs_nominal = 0;
    Y_nominal = 0;
  end if;
  
equation
  p = max(port_a.p, port_b.p);
  x = dp/p;
  xs = max(-Fxt, min(x, Fxt));
  Y = 1 - abs(xs)/(3*Fxt);
  
  if CvData == CvTypes.OpPoint then
    Kv = m_flow_nominal / (N6*Y_nominal*sqrt(xs*p_nominal*rho_nominal)) ;
  end if ;
  relativeFlowCoefficient = valveCharacteristic(opening) ;
  d_a = Medium.density(state_a) ;
  // m_flow = valveCharacteristic(opening)*Av*Y*sqrt(p*xs*d);
  if checkValve then
    m_flow = homotopy(
      valveCharacteristic(opening) * Av * Y * sqrt(Medium.density(state_a)) * (if xs>=0 then Modelica.Fluid.Utilities.regRoot(p*xs, dp_small) else 0),
      valveCharacteristic(opening) * m_flow_nominal * dp/dp_nominal);    
  
  elseif not allowFlowReversal then
    m_flow = homotopy(
      valveCharacteristic(opening) * Av * Y * sqrt(Medium.density(state_a)) * Modelica.Fluid.Utilities.regRoot(p*xs, dp_small),
      valveCharacteristic(opening)*m_flow_nominal*dp/dp_nominal);
        
  else
    m_flow = homotopy(
      valveCharacteristic(opening) * Av * Y * Modelica.Fluid.Utilities.regRoot2(p*xs, dp_small, Medium.density(state_a), Medium.density(state_b)),
      valveCharacteristic(opening)*m_flow_nominal*dp/dp_nominal);
  end if;

annotation(
  Documentation(info=
"<html>
  <p>
    This component models a blade damper where the blades move in parallel according to the IEC 534/ISA S.75 standards for valve sizing, compressible fluid, no phase change, also covering choked-flow conditions.
  </p>

  <p>
    The parameters of this model are explained in detail in <a href=\"modelica:// TAeZoSysPro.FluidDynamics.Components.Valves.BaseClasses.PartialDamper\">PartialDamper</a> (the base model for dampers).
  </p>

  <p>
    The product Fγ*xt is given by the parameter <code>Fxt</code>, and is assumed constant by default. 
  </p>
  
  <p>
    If <code>checkValve</code> is false, the valve supports reverse flow, with a symmetric flow characteristic curve. Otherwise, reverse flow is stopped (check valve behaviour).
  </p>

  <p>
    The treatment of parameters <b>Kv</b> and <b>Cv</b> differs from the explaination in the in the <a href=\"modelica://Modelica.Fluid.UsersGuide.ComponentDefinition.ValveCharacteristics\">User's Guide</a> but is more detailed in the <a href=\"modelica:// TAeZoSysPro.FluidDynamics.Components.Valves.BaseClasses.PartialDamper\">PartialDamper</a>.
  </p>
  
  <p>
    The damper curve is digitized from the CIBSE Guide H and fit with a fourth order polynom.
  </p>

</html>"),
    Icon(graphics = {Ellipse(origin = {4, 16}, fillPattern = FillPattern.Solid, extent = {{-8, 8}, {0, 0}}, endAngle = 360), Line(origin = {-1, 20}, points = {{-13, 14}, {15, -16}}), Line(origin = {0.31, -20}, rotation = -90, points = {{14, 14}, {-14, -14}}), Line(origin = {0.62712, -60}, points = {{-13, 14}, {15, -16}}), Line(origin = {0, 1}, points = {{0, 79}, {0, -81}}, pattern = LinePattern.Dot), Ellipse(origin = {4, 56}, fillPattern = FillPattern.Solid, extent = {{-8, 8}, {0, 0}}, endAngle = 360), Ellipse(origin = {4, -64}, fillPattern = FillPattern.Solid, extent = {{-8, 8}, {0, 0}}, endAngle = 360), Line(origin = {0, 60}, rotation = -90, points = {{14, 14}, {-14, -14}}), Ellipse(origin = {4, -24}, fillPattern = FillPattern.Solid, extent = {{-8, 8}, {0, 0}}, endAngle = 360)}, coordinateSystem(initialScale = 0.1)));

end Damper_parallelBlades;
