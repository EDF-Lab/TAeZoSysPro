within TAeZoSysPro.Aeraulic.BasesClasses;

model GasNode
  // Medium declaration
  replaceable package Medium = Media.MyMedia;
  constant String MediumName = Medium.mediumName;
  //medium properties
  Medium.BaseProperties medium;
  //-----
  // Internal parameters
  // gas node initial properties
  parameter Boolean SteadyState = false "Steady state initialization" annotation(Dialog(tab = "Initialization"));
  parameter Modelica.SIunits.AbsolutePressure pstart = 101325 "Initial absolute static pressure" annotation(Dialog(tab = "Initialization"));
  parameter Modelica.SIunits.Temperature Tstart = 293.15 "Initial temperature" annotation(Dialog(tab = "Initialization"));
  parameter Real phi_start = 0.6 "Initial relative humidity (pmoisture/psat) <= 1" annotation(Dialog(tab = "Initialization"));
  parameter Real VolH2 = 0.0 "Volume pourcentage of H2 [%]" annotation(Dialog(tab = "Initialization"));
  // gas node geometric characteristics
  parameter Integer n_ports = 2 "Number of fluidport";
  parameter Modelica.SIunits.Volume V = 50 "Room volume";
  parameter Modelica.SIunits.Area A = V ^ (2 / 3) "Room section";
  // condensated droplets properties
  parameter Integer n_drop = 150 "number of droplet per cm3";
  parameter Real C_drag = 0.47 "Drag coefficient of a sphere at 10^4 < RE < 5*10^5";
  //-----
  // Variables declarations
  // Temperatures
  Modelica.SIunits.Temperature T "Medium temperature ";
  // Pressures
  Modelica.SIunits.Pressure p(start = pstart) "Medium absolute pressure";
  // Densities
  Modelica.SIunits.Density[Medium.nX] di;
  // Masses
  Modelica.SIunits.Mass m "Medium mass";
  Modelica.SIunits.Mass[Medium.nX] mi "Medium mass";
  Modelica.SIunits.MassFraction[n_ports, Medium.nX] X_fluidport;
  // Mass flow rates
  //      Modelica.SIunits.MassFlowRate miComponent[n_ports, Medium.nXi] "mass flow rate of species at ports";
  Modelica.SIunits.MassFlowRate m_flow_fog "Mass flow rate of condensated steam to fog droplets";
  Modelica.SIunits.MassFlowRate m_flow_rain(each start = 0) "Mass flow rate of rain";
  // Enthalpy flow rates
  Modelica.SIunits.EnthalpyFlowRate Hi_flow[n_ports] "water mass flow rate in port i";
  //
  Modelica.SIunits.Velocity V_rain(start = 0) "Velocity of a fog's droplet";
  //
  Modelica.SIunits.Diameter d_drop(start = 0) "Droplet mean diameter in fog";
  //-----
  //Components inported
  Modelica.Fluid.Interfaces.FluidPort_a[n_ports] Fluidport(replaceable package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-40, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {0, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  TAeZoSysPro.Aeraulic.Interfaces.FlowPort_a Flowport(replaceable package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {20, 20}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {0, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a Heatport annotation(
    Placement(visible = true, transformation(origin = {-40, -20}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {0, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  //-----
protected
  parameter Modelica.SIunits.AbsolutePressure p_water_start = phi_start * Modelica.Media.Water.IF97_Utilities.BaseIF97.Basic.psat(Tstart);
  parameter Modelica.SIunits.AbsolutePressure p_da_start = pstart - p_water_start;
  Modelica.SIunits.Density d_liqWater;
initial equation
  if SteadyState then
    if MediumName == "MoistAir" then
      m_flow_fog + m_flow_rain = 0.0;
      m_flow_rain + sum(Fluidport.m_flow) + sum(Flowport.m_flow) = 0.0;
      Heatport.Q_flow + sum(Hi_flow) + Flowport.H_flow + m_flow_rain * 80000 = 0.0;
    else
      der(medium.T) = 0;
      der(medium.di) = fill(0.0, medium.nX);
    end if;
  else
    if MediumName == "MoistAir" or MediumName == "SimpleAir" then
      medium.di[Medium.Water] = p_water_start / (Modelica.Constants.R / Medium.MMX[Medium.Water] * Tstart);
      medium.di[Medium.Air] = p_da_start / (Modelica.Constants.R / Medium.MMX[Medium.Air] * Tstart);
    elseif MediumName == "DryAir" then
      medium.di[1] = pstart / (Modelica.Constants.R / Medium.MMX[1] * Tstart);
      
    elseif MediumName == "AirH2" then
      medium.di[Medium.Air] = pstart * (1.0 - VolH2/100) / (Modelica.Constants.R / Medium.MMX[Medium.Air] * Tstart);
      medium.di[Medium.H2] = pstart * VolH2/100 / (Modelica.Constants.R / Medium.MMX[Medium.H2] * Tstart);    
    else 
      assert(1 > 0, "Current Medium is not praticable", AssertionLevel.error);
      
    end if;
    medium.T = Tstart;
  end if;
equation
// X vector construction from fluidports
  for i in 1:n_ports loop
    X_fluidport[i, :] = cat(1, actualStream(Fluidport[i].Xi_outflow), {1 - sum(actualStream(Fluidport[i].Xi_outflow))});
  end for;
// Shorter variable
  p = medium.p;
  T = medium.T;
  di = medium.di;
//-----
// Detection of media used
  if MediumName == "MoistAir" then
// Mass balance
    der(mi[Medium.Water]) = Fluidport.m_flow * X_fluidport[:, Medium.Water] + Flowport.m_flow[Medium.Water] + m_flow_rain;
    der(mi[Medium.Air]) = Fluidport.m_flow * X_fluidport[:, Medium.Air] + Flowport.m_flow[Medium.Air];
    m = sum(mi);
// Condensation mass balance
    der(m * medium.X_liquid) = m_flow_fog + m_flow_rain;
// Loop to compute densities peer species
    for i in 1:Medium.nX loop
      di[i] = mi[i] / V;
    end for;
//-----
    d_liqWater = Modelica.Media.Water.WaterIF97_base.density_pT(p = p, T = T, region = 1);
// Rain calculation
    m * medium.X_liquid = d_liqWater * n_drop * 1e6 * V * 4 / 3 * Modelica.Constants.pi * (d_drop / 2) ^ 3;
// momentum conservation => weight = friction
    V_rain ^ 2 = d_liqWater / medium.d * 4 / 3 * d_drop * Modelica.Constants.g_n;
    m_flow_rain = -V_rain * A * (n_drop * 1e6 * Modelica.Constants.pi / 6 * d_drop ^ 3) * d_liqWater;
//-----
// Energy balance
// loop to compute the coming or leaving power through openings peer species
    for j in 1:n_ports loop
      Hi_flow[j] = Fluidport[j].m_flow * actualStream(Fluidport[j].h_outflow);
    end for;
// Global energy balance
    der(m * medium.u) = Heatport.Q_flow + sum(Hi_flow) + Flowport.H_flow + m_flow_rain * Medium.enthalpyOfLiquid(p = p, T = T);
  else
    d_drop = 0.0;
    V_rain = 0.0;
    d_liqWater = 0.0;
    m_flow_rain = 0.0;
    m_flow_fog = 0.0;
// Mass balance
    for k in 1:Medium.nX loop
      der(mi[k]) = Fluidport.m_flow * X_fluidport[:, k] + Flowport.m_flow[k];
      di[k] = mi[k] / V;
    end for;
    m = sum(mi);
//-----
// Energy balance
// loop to compute the coming or leaving power through openings peer species
    for j in 1:n_ports loop
      Hi_flow[j] = Fluidport[j].m_flow * actualStream(Fluidport[j].h_outflow);
    end for;
// Global energy balance
    der(m * medium.u) = Heatport.Q_flow + sum(Hi_flow) + Flowport.H_flow;
  end if;
//-----
// Port handover
// Heatport
  Heatport.T = T;
// Fluidport
  for i in 1:n_ports loop
    Fluidport[i].p = p;
    Fluidport[i].Xi_outflow[:] = medium.X[1:Medium.nXi];
    Fluidport[i].h_outflow = medium.h;
  end for;
// Flowport
  Flowport.T = T;
  Flowport.pi = medium.pi;
  Flowport.di = di;
  Flowport.hi = medium.hi;
  Flowport.h = medium.h;
//-----
  annotation(
    Diagram,
    Icon(graphics = {Text(origin = {-1, -94}, extent = {{-99, 14}, {101, -6}}, textString = "Volume = %V m3"), Text(origin = {-9, 86}, extent = {{-91, 14}, {109, -6}}, textString = "Initial pressure = %pstart Pa"), Text(origin = {-5, 66}, extent = {{-95, 14}, {105, -6}}, textString = "Initial temperture = %Tstart K"), Text(origin = {-3, -74}, extent = {{-97, 14}, {103, -6}}, textString = "Initial relative humidity = %phi"), Ellipse(origin = {-45, 42}, lineColor = {0, 0, 127}, fillColor = {154, 231, 231}, fillPattern = FillPattern.Sphere, extent = {{105, -102}, {-15, 18}}, endAngle = 360)}, coordinateSystem(initialScale = 0.1)),
    __OpenModelica_commandLineOptions = "",
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-06, Interval = 0.001));
end GasNode;