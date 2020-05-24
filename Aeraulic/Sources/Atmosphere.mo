within TAeZoSysPro.Aeraulic.Sources;

model Atmosphere
  // Medium declaration
  replaceable package Medium = Media.MyMedia;
  constant String MediumName = Medium.mediumName;
  //-----
  // Internal parameters
  // atmoshpere initial properties
  parameter Modelica.SIunits.Temperature T_out = 293.15 "Outside temperature" annotation(Dialog(tab = "Initialization"));
  parameter Modelica.SIunits.Pressure p_out = 101325 "Outside Pressure" annotation(Dialog(tab = "Initialization"));
  parameter Real HR_out = 0.6 "Relative humidity" annotation(Dialog(tab = "Initialization"));
  parameter Real VolH2 = 0.0 "Volume pourcentage of H2 [%]" annotation(Dialog(tab = "Initialization"));
  // atmosphere characteristics
  parameter Integer n_ports = 1 "Number of fluidport";
  // optional use of external values
  parameter Boolean Use_External_P = false "Use an input for p_out";
  parameter Boolean Use_External_T = false "Use an input for T_out";
  parameter Boolean Use_External_HR = false "Use an input for HR";
  //-----
  //Components involved
  Modelica.Fluid.Interfaces.FluidPort_a[n_ports] Fluidport(replaceable package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-30, 26}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  TAeZoSysPro.Aeraulic.Interfaces.FlowPort_b Flowport(replaceable package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-26, -46}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b Heatport annotation(
    Placement(visible = true, transformation(origin = {-44, -14}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput p_input if Use_External_P annotation(
    Placement(visible = true, transformation(origin = {-72, 56}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-95, 59}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput T_input if Use_External_T annotation(
    Placement(visible = true, transformation(origin = {-74, 14}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-95, -1}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput HR_input if Use_External_HR annotation(
    Placement(visible = true, transformation(origin = {-70, -30}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-95, -61}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  //-----
protected
  Modelica.SIunits.Pressure p_input_internal;
  Modelica.SIunits.Temperature T_input_internal;
  Real HR_input_internal;
  Modelica.SIunits.Pressure[3] pi "1 for water, 2 for dryair, 3 for H2";
  Modelica.SIunits.SpecificHeatCapacity[3] cpi = {0,0,0} "1 for water, 2 for dryair, 3 for H2";
equation
  pi[1] = min(HR_input_internal, 1) * Modelica.Media.Water.IF97_Utilities.BaseIF97.Basic.psat(T_input_internal);
  pi[2] = p_input_internal - pi[1] - pi[2] ;
  pi[3] = VolH2 / 100 * p_input_internal ;
//  for i in 1:Medium.nX loop
//    if Medium.substanceNames[i] == "water" then
//      Flowport.pi[i] = pi[1] ;
//    elseif Medium.substanceNames[i] == "air" then
//      Flowport.pi[i] = pi[2] ;
//    elseif Medium.substanceNames[i] == "H2" then
//      Flowport.pi[i] = pi[3] ;
//    end if ;
//    Flowport.di[i] = Flowport.pi[i] / (Modelica.Constants.R / Medium.MMX[i] * T_input_internal);
//  end for ;
// Detection of media used
  if MediumName == "MoistAir" then
//port handover
    Flowport.pi[Medium.Water] = min(HR_input_internal, 1) * Modelica.Media.Water.IF97_Utilities.BaseIF97.Basic.psat(T_input_internal);
    Flowport.pi[Medium.Air] = p_input_internal - Flowport.pi[Medium.Water];
    Flowport.di[Medium.Water] = Flowport.pi[Medium.Water] / (Modelica.Constants.R / Medium.MMX[Medium.Water] * T_input_internal);
    Flowport.di[Medium.Air] = Flowport.pi[Medium.Air] / (Modelica.Constants.R / Medium.MMX[Medium.Air] * T_input_internal);
    Flowport.hi[Medium.Water] = Medium.enthalpyOfCondensingGas(T = T_input_internal);
    Flowport.hi[Medium.Air] = Medium.enthalpyOfNonCondensingGas(T = T_input_internal);
    Flowport.h = Flowport.di[Medium.Air] / sum(Flowport.di) * Flowport.hi[Medium.Air] + Flowport.di[Medium.Water] / sum(Flowport.di) * Flowport.hi[Medium.Water];
  elseif MediumName == "DryAir" then
    Flowport.pi[Medium.Air] = p_input_internal;
    Flowport.di[Medium.Air] = Flowport.pi[Medium.Air] / (Modelica.Constants.R / Medium.MMX[Medium.Air] * T_input_internal);
    Flowport.hi[Medium.Air] = Medium.enthalpyOfNonCondensingGas(T = T_input_internal);
    Flowport.h = Flowport.hi[Medium.Air];
  elseif MediumName == "AirH2" then
    Flowport.pi[Medium.Air] = p_input_internal - pi[3];
    Flowport.di[Medium.Air] = Flowport.pi[Medium.Air] / (Modelica.Constants.R / Medium.MMX[Medium.Air] * T_input_internal);
    Flowport.hi[Medium.Air] = Medium.enthalpyOfNonCondensingGas(T = T_input_internal);
    Flowport.pi[Medium.H2] = pi[3];
    Flowport.di[Medium.H2] = Flowport.pi[Medium.H2] / (Modelica.Constants.R / Medium.MMX[Medium.H2] * T_input_internal);
    Flowport.hi[Medium.H2] = Medium.diHydrogen.cp * (T_input_internal - 273.15);
    Flowport.h = Flowport.di[Medium.Air] / sum(Flowport.di) * Flowport.hi[Medium.Air] + Flowport.di[Medium.H2] / sum(Flowport.di) * Flowport.hi[Medium.H2];
  else
    assert(1 > 0, "Current Medium is not praticable", AssertionLevel.error);
  end if;
// external of internal variable values
  if not Use_External_P then
    p_input_internal = p_out;
  else
    p_input_internal = p_input;
  end if;
  if not Use_External_T then
    T_input_internal = T_out;
  else
    T_input_internal = T_input;
  end if;
  if not Use_External_HR then
    HR_input_internal = HR_out;
  else
    HR_input_internal = HR_input;
  end if;
//-----
// Port handover
// Flowport
  Flowport.T = T_input_internal;
// Heatport
  Heatport.T = T_input_internal;
// Fluidport
  for i in 1:n_ports loop
    Fluidport[i].p = p_input_internal;
    Fluidport[i].h_outflow = Flowport.h;
    Fluidport[i].Xi_outflow[1:Medium.nXi] = 1 / sum(Flowport.di) * Flowport.di[1:Medium.nXi];
  end for;
//-----
  annotation(
    Icon(coordinateSystem(initialScale = 0.1), graphics = {Ellipse(origin = {-8, 23}, extent = {{-52, 37}, {68, -83}}, endAngle = 360), Text(origin = {-65, 87}, extent = {{-35, 13}, {165, -7}}, textString = "P=%p_out Pa"), Text(origin = {-37, 35}, extent = {{-63, 45}, {137, 25}}, textString = "T=%T_out K"), Text(origin = {-37, -77}, extent = {{-63, 17}, {137, -3}}, textString = "HR=%HR_out")}),
    experiment(StartTime = 0, StopTime = 100, Tolerance = 1e-06, Interval = 0.1));
end Atmosphere;