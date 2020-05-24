within TAeZoSysPro.HeatTransfer.BasesClasses;

model Convection
  // Components imported
  // Media
  replaceable package Medium = TAeZoSysPro.HeatTransfer.Media.MyMedia;
  // Customs parameters are declared
  parameter Modelica.SIunits.Pressure p = Medium.reference_p "fluid pressure";
  //
  parameter Boolean FreeConvection = true;
  //
  parameter Modelica.SIunits.Area A = 0 "Wall Area ";
  //
  parameter Modelica.SIunits.Height carac_length = 0 "characteritic length";
  //
  parameter Real add_on(unit = "R+") = 1 "Custom add-on";
  //
  parameter TAeZoSysPro.HeatTransfer.Types.FreeConvectionCorrelation correlation_free = TAeZoSysPro.HeatTransfer.Types.FreeConvectionCorrelation.ChurchillAndChu_vertical_plate "Free convection Correlation";
  //
  parameter TAeZoSysPro.HeatTransfer.Types.ForcedConvectionCorrelation correlation_forced = TAeZoSysPro.HeatTransfer.Types.ForcedConvectionCorrelation.ASHRAE_internal_cylinder "Forced convection Correlation";
  //
  parameter Modelica.SIunits.CoefficientOfHeatTransfer h = 0 "Constant heat transfer coefficient (optional)";
  //
  parameter Modelica.SIunits.Length perimeter = 0 "Perimeter is used for ground and ceiling (optional)";
  //
  parameter Modelica.SIunits.Velocity Vel = 0 "characteristic velocity ";
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a Heatport_a annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b Heatport_b annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  // Variables
  Modelica.SIunits.Temperature meanT(start = 320);
  // Mean temperature
  Modelica.SIunits.TemperatureDifference deltaT;
  // Delta temperature (wall-fluid)
  Modelica.SIunits.CoefficientOfHeatTransfer hcv;
  // Heat transfert coefficient W/(m^2*K)
  Modelica.SIunits.Power Q_flow;
  Modelica.SIunits.Energy E;
  // Energy
  Modelica.SIunits.Density d;
  Modelica.SIunits.SpecificHeatCapacity cp;
  Modelica.SIunits.DynamicViscosity mu;
  Modelica.SIunits.KinematicViscosity eta;
  Modelica.SIunits.ThermalConductivity k;
  Modelica.SIunits.PrandtlNumber pr;
protected
  Medium.ThermodynamicState state;
initial equation
// Energy at time 0 second is equal to 0J
  E = 0;
equation
// Temperature Calculation
  meanT = (Heatport_a.T + Heatport_b.T) / 2;
  deltaT = Heatport_a.T - Heatport_b.T;
// state vector
  state = Medium.setState_pTX(p = p, T = meanT);
// Thermodynamic perperties calculation
  d = state.d;
  mu = Medium.dynamicViscosity(state);
  cp = Medium.specificHeatCapacityCp(state);
  k = Medium.thermalConductivity(state);
  eta = mu / d;
  pr = mu * cp / k;
// Flow configuration
  if FreeConvection == true then
// Correlation selection
    if correlation_free == TAeZoSysPro.HeatTransfer.Types.FreeConvectionCorrelation.ChurchillAndChu_vertical_plate then
      hcv = TAeZoSysPro.HeatTransfer.Functions.FreeConvection.ChurchillAndChu_Vert_Plate(Heatport_b.T, deltaT, carac_length, d, cp, eta, k, pr);
    elseif correlation_free == TAeZoSysPro.HeatTransfer.Types.FreeConvectionCorrelation.Recknagel_vertical_plate then
      hcv = TAeZoSysPro.HeatTransfer.Functions.FreeConvection.Recknagel_Vert_Plate(deltaT, meanT);
    elseif correlation_free == TAeZoSysPro.HeatTransfer.Types.FreeConvectionCorrelation.Cibse_vertical_plate then
      hcv = TAeZoSysPro.HeatTransfer.Functions.FreeConvection.Cibse_Vert_Plate(deltaT, Heatport_b.T, carac_length, d, cp, eta, k);
    elseif correlation_free == TAeZoSysPro.HeatTransfer.Types.FreeConvectionCorrelation.Ground then
      hcv = TAeZoSysPro.HeatTransfer.Functions.FreeConvection.Ground(Heatport_a.T, Heatport_b.T, deltaT, meanT, perimeter, d, cp, eta, k, A);
    elseif correlation_free == TAeZoSysPro.HeatTransfer.Types.FreeConvectionCorrelation.Ceiling then
      hcv = TAeZoSysPro.HeatTransfer.Functions.FreeConvection.Ceiling(Heatport_a.T, Heatport_b.T, deltaT, meanT, perimeter, d, cp, eta, k, A);
    elseif correlation_free == TAeZoSysPro.HeatTransfer.Types.FreeConvectionCorrelation.ChurchillAndChu_horizontal_cylinder then
      hcv = TAeZoSysPro.HeatTransfer.Functions.FreeConvection.ChurchillAndChu_Hor_Cyl(Heatport_b.T, deltaT, meanT, carac_length, d, cp, eta, k, pr);
    elseif correlation_free == TAeZoSysPro.HeatTransfer.Types.FreeConvectionCorrelation.Morgan_horizontal_cylinder then
      hcv = TAeZoSysPro.HeatTransfer.Functions.FreeConvection.Morgan_Hor_Cyl(Heatport_b.T, deltaT, meanT, carac_length, d, cp, eta, k, pr);
    elseif correlation_free == TAeZoSysPro.HeatTransfer.Types.FreeConvectionCorrelation.Constant then
      hcv = h;
    end if;
  else
    if correlation_forced == TAeZoSysPro.HeatTransfer.Types.ForcedConvectionCorrelation.ASHRAE_internal_cylinder then
      hcv = TAeZoSysPro.HeatTransfer.Functions.ForcedConvection.ASHRAE_Int_Cyl(deltaT, carac_length, Vel, eta, k, pr);
    elseif correlation_forced == TAeZoSysPro.HeatTransfer.Types.ForcedConvectionCorrelation.ASHRAE_external_cylinder then
      hcv = TAeZoSysPro.HeatTransfer.Functions.ForcedConvection.ASHRAE_Ext_Cyl(carac_length, Vel, eta, k, pr);
    elseif correlation_forced == TAeZoSysPro.HeatTransfer.Types.ForcedConvectionCorrelation.ASHRAE_flat_plate then
      hcv = TAeZoSysPro.HeatTransfer.Functions.ForcedConvection.ASHRAE_Flat_Plate(carac_length, Vel, eta, k, pr);
    elseif correlation_forced == TAeZoSysPro.HeatTransfer.Types.ForcedConvectionCorrelation.Constant then
      hcv = h;
    end if;
  end if;
// Heat flux calculation
  Q_flow = A * hcv * add_on * deltaT;
//Classical convection equation Q = h * A * (Ta - Tb)
  der(E) = Q_flow;
// E is equal to intregrate Q_flow;
// Heatport
  Heatport_a.Q_flow = Q_flow;
  Heatport_a.Q_flow + Heatport_b.Q_flow = 0;
  annotation(
    Icon(graphics = {Rectangle(origin = {-54, 0}, fillColor = {140, 138, 145}, fillPattern = FillPattern.Cross, extent = {{-26, 100}, {26, -100}}), Line(points = {{0, 80}, {0, -80}}, color = {0, 85, 255}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {40, 0}, points = {{0, 80}, {0, -80}}, color = {0, 85, 255}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {80, 0}, points = {{0, 80}, {0, -80}}, color = {0, 85, 255}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {35, 40}, points = {{-55, 0}, {55, 0}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {35, -40}, points = {{-55, 0}, {55, 0}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Text(origin = {36, 4}, extent = {{-28, 24}, {28, -24}}, textString = "hcv"), Line(origin = {35, 0}, points = {{-27, -22}, {27, 22}}, thickness = 1.75, arrow = {Arrow.None, Arrow.Filled}), Text(origin = {68, -93}, extent = {{-28, 5}, {28, -5}}, textString = "KURY- EDVANCE"), Text(origin = {-94, 29}, rotation = -90, extent = {{-28, 5}, {28, -5}}, textString = "Wall"), Text(origin = {92, 27}, rotation = 90, extent = {{-28, 5}, {28, -5}}, textString = "Air")}, coordinateSystem(initialScale = 0.1)),
    uses(Modelica(version = "3.2.2")),
    Diagram(graphics = {Rectangle(origin = {-56, -3}, fillColor = {172, 172, 172}, fillPattern = FillPattern.Cross, extent = {{-22, 85}, {22, -85}}), Line(origin = {-1, 42}, points = {{-23, 0}, {23, 0}}, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {-1, 0}, points = {{-23, 0}, {23, 0}}, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {1, -44}, points = {{-23, 0}, {23, 0}}, arrow = {Arrow.None, Arrow.Filled})}));
end Convection;
