within TAeZoSysPro.FluidDynamics.Components.Valves;

model Damper_parallelBlades
  extends TAeZoSysPro.FluidDynamics.Components.Valves.BaseClasses.PartialDamper(
  redeclare function valveCharacteristic = TAeZoSysPro.FluidDynamics.Components.Valves.BaseClasses.ValveCharacteristics.polynomial(
    c = {0, 0.5082, -0.5258, 1.0667, -0.0491}) ) ;
  import Modelica.Fluid.Types.CvTypes;
  
protected
  Real relativeFlowCoefficient;
  
initial equation
  if CvData == CvTypes.OpPoint then
      m_flow_nominal = valveCharacteristic(opening_nominal)*Av*sqrt(rho_nominal)*Modelica.Fluid.Utilities.regRoot(dp_nominal, dp_small)
    "Determination of Av by the operating point";
  end if;

equation
  // m_flow = valveCharacteristic(opening)*Av*sqrt(d)*sqrt(dp);

  relativeFlowCoefficient = valveCharacteristic(opening);
  if checkValve then
    m_flow = homotopy(relativeFlowCoefficient*Av*sqrt(Medium.density(state_a))*
                           TAeZoSysPro.FluidDynamics.Utilities.regRoot2(dp,dp_small,1.0,0.0,use_yd0=true,yd0=0.0),
                      relativeFlowCoefficient*m_flow_nominal*dp/dp_nominal);

  elseif not allowFlowReversal then
    m_flow = homotopy(relativeFlowCoefficient*Av*sqrt(Medium.density(state_a))*
                           Modelica.Fluid.Utilities.regRoot(dp, dp_small),
                      relativeFlowCoefficient*m_flow_nominal*dp/dp_nominal);
  else
    m_flow = homotopy(relativeFlowCoefficient*Av*
                           TAeZoSysPro.FluidDynamics.Utilities.regRoot2(dp,dp_small,Medium.density(state_a),Medium.density(state_b)),
                      relativeFlowCoefficient*m_flow_nominal*dp/dp_nominal);

  end if;

annotation(
    Icon(graphics = {Ellipse(origin = {4, 16}, fillPattern = FillPattern.Solid, extent = {{-8, 8}, {0, 0}}, endAngle = 360), Line(origin = {-1, 20}, points = {{-13, 14}, {15, -16}}), Line(origin = {0.31, -20}, points = {{14, 14}, {-14, -14}}), Line(origin = {0.62712, -60}, points = {{-13, 14}, {15, -16}}), Line(origin = {0, 1}, points = {{0, 79}, {0, -81}}, pattern = LinePattern.Dot), Ellipse(origin = {4, 56}, fillPattern = FillPattern.Solid, extent = {{-8, 8}, {0, 0}}, endAngle = 360), Ellipse(origin = {4, -64}, fillPattern = FillPattern.Solid, extent = {{-8, 8}, {0, 0}}, endAngle = 360), Line(origin = {0, 60}, rotation = -90, points = {{14, 14}, {-14, -14}}), Ellipse(origin = {4, -24}, fillPattern = FillPattern.Solid, extent = {{-8, 8}, {0, 0}}, endAngle = 360)}, coordinateSystem(initialScale = 0.1)));
end Damper_parallelBlades;
