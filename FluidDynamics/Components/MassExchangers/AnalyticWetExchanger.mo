within TAeZoSysPro.FluidDynamics.Components.MassExchangers;

model AnalyticWetExchanger
  //extends TAeZoSysPro.HeatTransfer.BasesClasses.PartialHeatExchanger(final S = ExchangeSurface);
  //
  import SI = Modelica.SIunits;
  /*  in : refers to the inlet of the boundaries of the exchanger (carreful, counter flow considered)
      out : refers to the outlet of the boundaries of the exchanger (carreful, counter flow considered)
      mid : refers to the the conditions at the transition between the dry and wet part of the exchanger
      sat : refers to saturation conditions
      eq : refers to the fictive fluid to represent the liquid water 
      A : refers to the air fluid
      B : refers to the water fluid
    */
  // Medium declaration
  replaceable package MediumA = TAeZoSysPro.Media.MyMedia;
  replaceable package MediumB = Modelica.Media.Water.WaterIF97_ph;
  //replaceable package MediumB = Modelica.Media.Air.MoistAir ;
  // User defined parameters
  parameter SI.Area CrossSectionA = 4.26 "Cross section of the pipe for the fluid A" annotation(
    Dialog(group = "Geometrical parameters"));
  parameter SI.Area CrossSectionB = 4.26 "Cross section of the pipe for the fluid B" annotation(
    Dialog(group = "Geometrical parameters"));
  parameter SI.Area ExchangeSurface = 0.0 "Largest exchange surface area" annotation(
    Dialog(group = "Geometrical parameters"));
  parameter Real ksi_fixedA = 1.0 annotation(
    Dialog(group = "Flow parameters"));
  parameter Real ksi_fixedB = 1.0 annotation(
    Dialog(group = "Flow parameters"));
  parameter SI.CoefficientOfHeatTransfer K_global "Global heat transfer coeffcient" annotation(
    Dialog(group = "Exchange parameters"));
  parameter SI.CoefficientOfHeatTransfer hcv_A "Heat transfer coeffcient Wall<->Fluid A" annotation(
    Dialog(group = "Exchange parameters"));
  // define constants
  constant SI.SpecificEnergy Ll = 2501e3 "Latent heat of liquifaction at 0°C";
  final parameter SI.CoefficientOfHeatTransfer hcv_B = (1 / K_global - 1 / hcv_A) ^ (-1);
  // Internal variables
  // variables common to all configurations
  MediumA.ThermodynamicState stateA_in "State of fluid A a inlet";
  MediumB.ThermodynamicState stateB_in "State of fluid B a inlet";
  SI.SpecificHeatCapacity cpA;
  SI.SpecificHeatCapacity cpB;
  SI.MassFlowRate m_flowA "Mass flow rate of fluid A";
  SI.MassFlowRate m_flowB "Mass flow rate of fluid B";
  SI.ThermalConductance QcA(min = 0) "Thermal flow rate unit";
  SI.ThermalConductance QcB(min = 0) "Thermal flow rate unit";
  SI.Temperature TA_in, TA_out, TB_in, TB_out;
  SI.Power Pex "exchanged power";
  // variables for the "no condensation" model
  Real NTU_1 "Number of transfer unit";
  Real Cr_1 "Ration of thermal condutance";
  SI.Efficiency Eff_1 "Exchanger effectiveness";
  SI.Temperature TA_out_1, TB_out_1;
  SI.Power Pex_1;
  // variables for the "condensation" model
  SI.Temperature TA_mid_2, TA_mid_buffer, TB_mid_2, TB_out_2, TA_out_2, Tdew, Tsat_out;
  SI.Pressure p_water;
  Real NTU_2, NTU_wet "Number of transfer unit";
  Real Cr_wet;
  SI.Efficiency Eff_2, Eff_wet "Exchanger effectiveness";
  SI.Area S_sensible "Sensible surface to achieved saturation on moist air";
  SI.Area S_wet "Sensible surface to achieved saturation on moist air";
  SI.MassFraction wsat_eq_in, wA_in, wsat_out, wA_out_2, XA_out_2, wA_out "Moisture content peer kg of dry air";
  SI.SpecificEnthalpy hsat_eq_in, hA_mid_2, hA_out_2, hcond_out, hA_sat_in "Enthalpies peer kg of dry air";
  SI.SpecificHeatCapacity cp_eq "Specific heat capacity of the fictive fluid";
  SI.MassFlowRate m_flow_eq "Mass flow rate of the fictive fluid";
  SI.Power Q_flow_wet, Q_flow_dry, Q_flow_wet_2, Q_flow_dry_2;
  SI.Power P_sensible "Sensible exchanged power";
  SI.Power P_latent "Latent exchanged power";
  
  // Imported modules
  Modelica.Fluid.Interfaces.FluidPort_a port_in_A(redeclare package Medium = MediumA) annotation (
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {80, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_b port_out_A(redeclare package Medium = MediumA) annotation (
    Placement(visible = true, transformation(origin = {102, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-80, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_a port_in_B(redeclare package Medium = MediumB) annotation (
    Placement(visible = true, transformation(origin = {-68, 88}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_b port_out_B(redeclare package Medium = MediumB) annotation (
    Placement(visible = true, transformation(origin = {66, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
//initial algorithm
//TA_mid_2.start := TA_in ;
equation
//
  stateA_in = MediumA.setState_phX(port_in_A.p, inStream(port_in_A.h_outflow), inStream(port_in_A.Xi_outflow));
  stateB_in = MediumB.setState_phX(port_in_B.p, inStream(port_in_B.h_outflow), inStream(port_in_B.Xi_outflow));
// compute thermodynamical properties
  cpA = MediumA.specificHeatCapacityCp(stateA_in);
  cpB = MediumB.specificHeatCapacityCp(stateB_in);
//
  QcA = m_flowA * cpA;
  QcB = m_flowB * cpB;
//
  TA_in = MediumA.temperature(stateA_in);
  TB_in = MediumB.temperature(stateB_in);
//momentum - steady assumptions
  m_flowA = CrossSectionA * TAeZoSysPro.FluidDynamics.Utilities.regRoot2(x = port_in_A.p - port_out_A.p, x_small = 10, k1 = 2 * MediumA.density(stateA_in) / ksi_fixedA, k2 = 2 * MediumA.density(stateA_in) / ksi_fixedA);
  m_flowB = CrossSectionB * TAeZoSysPro.FluidDynamics.Utilities.regRoot2(x = port_in_B.p - port_out_B.p, x_small = 10, k1 = 2 * MediumB.density(stateB_in) / ksi_fixedB, k2 = 2 * MediumB.density(stateB_in) / ksi_fixedB);
  
/*---------- Calculation of a fully dry exchanger ----------*/
  Cr_1 = min(QcA, QcB) / max(max(QcA, QcB), 1e3 * Modelica.Constants.small);
  NTU_1 = K_global * ExchangeSurface / max(min(QcA, QcB), 1e3 * Modelica.Constants.small);
  Eff_1 = (1 - exp(-NTU_1 * (1.0 - Cr_1))) / (1.0 - Cr_1 * exp(-NTU_1 * (1.0 - Cr_1)));
  Pex_1 = Eff_1 * min(QcA, QcB) * (TA_in - TB_in);
  Pex_1 + QcA * (TA_out_1 - TA_in) = 0;
  QcA * (TA_out_1 - TA_in) + QcB * (TB_out_1 - TB_in) = 0;
  
/*---------- Calculation of the sensible part for condensation configuration ----------*/
// Compute the saturation temperature of the moist air
  p_water / port_in_A.p = stateA_in.X[MediumA.Water] * Modelica.Constants.R / MediumA.MMX[MediumA.Water] / MediumA.gasConstant(stateA_in);
  Tdew = TAeZoSysPro.FluidDynamics.Utilities.regStep(x = p_water - 625, x_small = 5.0, y1 = Modelica.Media.Water.StandardWater.saturationTemperature(max(620, p_water)), y2 = 273.15 + 0.1);
// Determination of the temperature of the gas which corresponds to the dew temperature of the external surface knowing the thermal resistance
  hcv_A * (TA_mid_buffer - Tdew) = K_global * (TA_mid_buffer - TB_mid_2);
//TA_mid_2 = min(TA_mid_buffer, TA_in) ;
  TA_mid_2 = TAeZoSysPro.FluidDynamics.Utilities.regStep(x = TA_in - TA_mid_buffer - 0.01, x_small = 0.01, y1 = TA_mid_buffer, y2 = TA_in);
  QcA * (TA_mid_2 - TA_in) + QcB * (TB_out_2 - TB_mid_2) = 0.0;
// Determination of the dry surface necessary for  the surface temperature to achieve the dew temperature
  NTU_2 = K_global * S_sensible / max(min(QcA, QcB), 1e3 * Modelica.Constants.small);
  Eff_2 = (1 - exp(-NTU_2 * (1.0 - Cr_1))) / (1.0 - Cr_1 * exp(-NTU_2 * (1.0 - Cr_1)));
  Eff_2 = QcA * (TA_in - TA_mid_2) / (max(min(QcA, QcB), 1e3 * Modelica.Constants.small) * (TA_in - TB_mid_2));
  Q_flow_dry_2 = QcA * (TA_in - TA_mid_2);
/*---------- Calculation of the latent part for condensation configuration ----------*/
/* As enthalpy is used rather than temperatures to compute the exchange, the air is considered to exchange with a fictive air at the same temperature than the water but gaving a moisture content always saturated. Therefore, the mass flow rate and the heat capacity of this fictive fluid are computed to well fit the real behavior that is having the water.*/
// Calculation of the saturated moisture content at the boundaries of the wet part of the exchanger
  wsat_eq_in = MediumA.xsaturation_pT(p = port_in_A.p, T = TB_in);
// Calculation of the moisture content at the boundaries of the wet part of the exchanger
  wA_in = stateA_in.X[MediumA.Water] / stateA_in.X[MediumA.Air];
// Calculation of the saturated enthalpies of the equivalent fictive fluid at the boundaries
  hsat_eq_in = cpA * (TB_in - 273.15) + wsat_eq_in * Ll;
// Caculation of enthalpy with respect to temperature and moisture content
  hA_mid_2 = cpA * (TA_mid_2 - 273.15) + wA_in * Ll;
/* hgas_out is computed from the wet part of the exchanger. TA_out is computed from the hypothesis that the moisture content at the outlet is equal
    to the moisture content of the saturated gas at the contact of the condensation film of the outlet */
  hA_out_2 = cpA * (TA_out_2 - 273.15) + wA_out_2 * Ll;
// Calculation of an heat capacity that would have the fictive fluid encompassing the latent exchange
  hA_sat_in = cpA * (Tdew - 273.15) + wA_in * Ll;
  cp_eq = (hA_sat_in - hsat_eq_in) / (Tdew - TB_in);
// calculation of an equivalent mass flow rate of this fictive gas
  m_flow_eq = m_flowB * cpB / cp_eq;
// Calculation of the ration of the thermal flow rate for wet part
  Cr_wet = min(m_flowA, m_flow_eq) / max(max(m_flowA, m_flow_eq), 1e3 * Modelica.Constants.small);
//
  NTU_wet = (cpA / hcv_B + cp_eq / hcv_A) ^ (-1) * S_wet / min(m_flowA, m_flow_eq);
//
  Eff_wet = TAeZoSysPro.FluidDynamics.Utilities.regStep(x = 0.98 - Cr_wet, x_small = 1.0e-2, y1 = (1.0 - exp(-NTU_wet * (1.0 - Cr_wet))) / (1.0 - Cr_wet * exp(-NTU_wet * (1.0 - Cr_wet))), y2 = NTU_wet / (NTU_wet + 1.0));
  Eff_wet = m_flowA / min(m_flowA, m_flow_eq) * (hA_mid_2 - hA_out_2) / (hA_mid_2 - hsat_eq_in);
//
  Q_flow_wet_2 = m_flowA * stateA_in.X[MediumA.Air] * (hA_out_2 - hA_mid_2);
  QcB * (TB_mid_2 - TB_in) + Q_flow_wet = 0.0;
//
  ExchangeSurface = S_sensible + S_wet;
// Determination of the outlet air temperature and humidity
  (hcond_out - hsat_eq_in) / (cp_eq / hcv_B) = (hA_out_2 - hsat_eq_in) / (cp_eq / hcv_B + cpA / hcv_A);
  hcond_out = cpA * (Tsat_out - 273.15) + wsat_out * Ll;
  wsat_out = MediumA.xsaturation_pT(p = port_out_A.p, T = Tsat_out);
//hcv_A * (TA_out_2 - Tsat_out) + hcv_A / cpA * (wA_out_2 - wsat_eq_in) * Ll = hcv_B * (Tsat_out - TB_in) ;
  XA_out_2 = MediumA.massFraction_pTphi(p = port_out_A.p, T = Tsat_out, phi = 0.8);
  wA_out_2 = XA_out_2 / (1-XA_out_2) "80% of the saturation moisture content at outlet";
//retained configuration
  TA_out = TAeZoSysPro.FluidDynamics.Utilities.regStep(x = S_wet - 1e-2, x_small = 1e-2, y1 = TA_out_2, y2 = TA_out_1);
  wA_out = TAeZoSysPro.FluidDynamics.Utilities.regStep(x = S_wet - 1e-2, x_small = 1e-2, y1 = wA_out_2, y2 = wA_in);
  Q_flow_dry = TAeZoSysPro.FluidDynamics.Utilities.regStep(x = S_wet - 1e-2, x_small = 1e-2, y1 = Q_flow_dry_2, y2 = Pex_1);
  Q_flow_wet = TAeZoSysPro.FluidDynamics.Utilities.regStep(x = S_wet - 1e-2, x_small = 1e-2, y1 = Q_flow_wet_2, y2 = 0.0);
  P_sensible = m_flowA * cpA * (TA_out - TA_in) ;
  P_latent = m_flowA  * stateA_in.X[MediumA.Air] * (wA_out_2-wA_in) * Ll ; 
  Pex = Q_flow_dry + Q_flow_wet;
  QcB * (TB_out - TB_in) + Pex = 0.0;
// ports handover
  port_in_A.m_flow = m_flowA;
  port_in_A.h_outflow = inStream(port_in_A.h_outflow);
// reverse flow not modelled
  port_in_A.Xi_outflow = inStream(port_in_A.Xi_outflow);
  port_out_A.m_flow + port_in_A.m_flow = 0.0;
  m_flowA * (inStream(port_in_A.h_outflow) - port_out_A.h_outflow) = Pex;
  port_out_A.Xi_outflow = inStream(port_out_A.Xi_outflow);
//
  port_in_B.m_flow = m_flowB;
  port_in_B.h_outflow = inStream(port_in_B.h_outflow);
// reverse flow not modelled
  port_in_B.Xi_outflow = inStream(port_in_B.Xi_outflow);
  port_out_B.m_flow + port_in_B.m_flow = 0.0;
  m_flowB * (inStream(port_in_B.h_outflow) - port_out_B.h_outflow) = -Pex;
  port_out_B.Xi_outflow = inStream(port_out_B.Xi_outflow);
  annotation(
    Documentation(info = "
<html>
  <head>
    <title>WetExchanger</title>
		
    <style type=\"text/css\">
      *       { font-size: 10pt; font-family: Arial,sans-serif; }
      code    { font-size:  9pt; font-family: Courier,monospace;}
      h6      { font-size: 10pt; font-weight: bold; color: green; }
      h5      { font-size: 11pt; font-weight: bold; color: green; }
      h4      { font-size: 13pt; font-weight: bold; color: green; }
      address {                  font-weight: normal}
      td      { solid #000; vertical-align:top; }
      th      { solid #000; vertical-align:top; font-weight: bold; }
      table   { solid #000; border-collapse: collapse;}
    </style>
  </head>
	
  <body lang=\"en-UK\">
	
    <p>
      This components allows to model heat and moisture laden transfers between a moist air media and a cooling fluid (commonly water). 
      The mathematical model under this component takes inspiration from the paper: 
        <a href=https://pastel.archives-ouvertes.fr/pastel-00566261/document>Methodologies d’identification d’économies d’energie : application aux systèmes de climatisation à eau glacee</a> where the theoretical approach under the wet exchanger modelling is summarized  <a href= \"modelica://TAeZoSysPro/Information/FluidDynamics/Components/MassExchangers/Module Batterie froide humide BEG_V2_0.pdf\">here</a>. 
      The module embedes a modelling of a fully dry exchanger (variable with suffix '_1' ex:TA_out_1) and a model of a partially or fully wet (variable with suffix '_2' ex:TA_out_2).
      Both the fully dry exchange and the wet exchange are running simultaneously during the simulation.
      The output values are taken from one of the two configurations based on the value of the wet surface. 
      A null or negative value means a fully dry exchange. 
      To avoid chattering between the configurations, the outputs are computed by a polynomial interpolation close to zero value for the wet surface. </br>
      For information regarding the dry exchange, please refer to the dry exchanger module. 
      The following description focuses only on the wet exchange.
    </p>
		
    <p>
      The physical model under this module uses the following assumptions:
      <ul>
        <li> The lewis number is constant and equal to one </li>
        <li> The sensible term for the water vapour within the expression of the mixing specific enthalpy is neglected </li>
        <li> The conduction resistance within the tube between the moist air and the cooling fluid is neglected regarding the great thermal conductivity of used material. The heat regime is considered as quasistatic </li>
        <li> The exchanger is adiabatic regarding the environment</li>
        <li> The convective heat exchange coefficients between the tube and the cooling fluid and the moist air and the condensation film are constant </li>
        <li> The exchanger is linkened to an counter flow exchanger </li>
      </ul>
    </p>
		
    <p>
      To sum up the approach of a wet echange modlling described by the paper and the article above, The link between the mass and heat transfer	is made via a Lewis number (Le) equal to one. 
      It is discussed in the paper the relevancy of the assumptions of a Le = 1.
    </p>

    <img	
      src=\"modelica://TAeZoSysPro/Information/FluidDynamics/Components/MassExchangers/EQ_AnalyticWetExchanger.PNG\"
      alt=\"image Lewis number\" 
    />

    <p>
      The founding principles of the representation method were established according to the work of [THRELKELD, 1970]. 
      This method aggregates the phenomena of heat and mass transfer in an enthalpy exchange between air and water represented by a fictitious enthalpy.
    </p>
		
    <h5> Exchange between the moist air and the condensation film </h5>
		
    <p>
      It is assumed that the air immediately against the surface of the condensing film is saturated at the surface temperature of the condensing film. 
      The water vapor and the condensation water being in equilibrium, the temperature of the condensation film is the temperature of the saturated air Tsat. 
      The exchange between the air and the condensing film is expressed as follows:
    </p>
		
    <img	
      src=\"modelica://TAeZoSysPro/Information/FluidDynamics/Components/MassExchangers/EQ_AnalyticWetExchanger2.PNG\"
    />
		
    <p>
      In the temperature range [15 - 30°C] on which we are working, the term [cp T] represents only about 1% of the total enthalpy and can therefore be neglected. 
      The enthalpy of humid air can then be written as follows:
    </p>
		
    <img	
      src=\"modelica://TAeZoSysPro/Information/FluidDynamics/Components/MassExchangers/EQ_AnalyticWetExchanger3.PNG\"
    />
		
    <p>
      By introducing the expression of the number of LEWIS, we obtain:
    </p>

    <img	
      src=\"modelica://TAeZoSysPro/Information/FluidDynamics/Components/MassExchangers/EQ_AnalyticWetExchanger4.PNG\"
    />

    <p>
      If we consider a number of LEWIS of 1 in the domain considered, the expression becomes:
    </p>
		
    <img	
      src=\"modelica://TAeZoSysPro/Information/FluidDynamics/Components/MassExchangers/EQ_AnalyticWetExchanger5.PNG\"
    />

    <p>
      It can be seen that, for the air / condensation film exchange, the two exchange potentials for temperature gradient and humidity gradient have been replaced by a single enthalpy potential.
    </p>

    <h5> Exchange between the condensation film and the cooling fluid </h5>
		
    <p>
      Regarding the exchange between the condensation film and the cooling fluid, the principle of representation is to be reduced to a homogeneous expression with that of the exchange between the air and the condensing film. 
      We then assume that in a small temperature scale, we can represent the enthalpy of saturated air as a linear function of temperature:
    </p>

    <img	
      src=\"modelica://TAeZoSysPro/Information/FluidDynamics/Components/MassExchangers/EQ_AnalyticWetExchanger6.PNG\"
    />
		
    <p>
      If the conduction in the tube and the condensing film is neglected due to the high conductivity of the materials used and of the water regarding the convective phenomena, the heat exchange between the condensing film and the water current expresses as follows:
    </p>
		
    <img	
      src=\"modelica://TAeZoSysPro/Information/FluidDynamics/Components/MassExchangers/EQ_AnalyticWetExchanger7.PNG\"
    />

    <p>
      Using the assumption that cpsat does not vary over the small temperature interval taken into account, water is then represented by a fictitious enthalpy corresponding to the enthalpy that saturated air would have at water temperature:
    </p>
		
    <img	
      src=\"modelica://TAeZoSysPro/Information/FluidDynamics/Components/MassExchangers/EQ_AnalyticWetExchanger8.PNG\"
    />

    <p>
      Considering the expression of the heat flow in the different exchanges, we then conceive of a direct exchange between air and temperature by introducing the expression of two resistors in series, one comprising the convective exchange between the air and the condensation film (Uext), the other comprising the conductive exchange (neglected) and the convective exchange between the tube and the water (Uint). </br>
      The global conductance is therefore written, associating transfer conductance and exchange surface:
    </p>
		
    <img	
      src=\"modelica://TAeZoSysPro/Information/FluidDynamics/Components/MassExchangers/EQ_AnalyticWetExchanger9.PNG\"
    />

    <p>
      The heat and mass exchange within the cold battery is then described by the following expression of the power:
    </p>
		
    <img	
      src=\"modelica://TAeZoSysPro/Information/FluidDynamics/Components/MassExchangers/EQ_AnalyticWetExchanger10.PNG\"
    />

    <p>
      The whole of this approach therefore amounts to substituting for the two thermodynamic forces generating the heat flow, a single force derived from the enthalpy of humid air. 
      It then becomes possible to apply the calculation techniques developed for heat exchangers using this unified expression of heat and mass transfer.
    </p>
		
    <h5> Methodology of the heat exchange coefficient calculation </h5>
		
    <p>
      As presented above, the value of the convective heat exchange coefficient hv_A and hv_B are required. 
      However, their value are often not available in the manufacturer's data sheets. 
      The only available data is sometimes the global heat exchange coefficient (K). 
      The choice has been to have as parameter K and hv_A to computed hcv_B from K and hcv_A as follows. If the configuration flow is not counter flow, the coefficient K here has to be the coefficient that would have a counter flow exchanger with the same output properties.
    </p>
		
    <img	
      src=\"modelica://TAeZoSysPro/Information/FluidDynamics/Components/MassExchangers/EQ_AnalyticWetExchanger11.PNG\"
    />
		
    <p>
      In exchanger dealing with air, it is common to used fins to increase the surface of exchange and thus the exchanged heat. 
      The surface of exchange between the cooling fluid and the tube (piping) and between the pipe and the air is not the same. 
      In that case, the supplier mainly refers the value of K to the largest surface (surface tube / air). </br>
      With the above formula, the convective exchange coefficient hcv_B is not related to the exchange surface between the cooling fluid and the tube but to the exchange surface between the tube and the air (the largest surface ). 
      In such way, the knowledge of the exchange surface between the cooling fluid and the tube is not required:	
    </p>
		
    <img	
      src=\"modelica://TAeZoSysPro/Information/FluidDynamics/Components/MassExchangers/EQ_AnalyticWetExchanger12.PNG\"
    />
		
	</body>
</html>"),
    Icon(coordinateSystem(initialScale = 0.1), graphics = {Polygon(origin = {18, 50}, rotation = 180, fillColor = {213, 0, 0}, fillPattern = FillPattern.Solid, lineThickness = 0.5, points = {{-72, 36}, {-72, 14}, {88, 14}, {88, -16}, {108, -16}, {108, 36}, {-72, 36}}), Polygon(origin = {-18, -50}, fillColor = {255, 0, 0}, fillPattern = FillPattern.Solid, lineThickness = 0.5, points = {{-72, 36}, {-72, 14}, {88, 14}, {88, -18}, {108, -18}, {108, 36}, {-72, 36}}), Rectangle(origin = {-2, 0}, lineColor = {0, 161, 241}, fillColor = {211, 211, 211}, pattern = LinePattern.None, fillPattern = FillPattern.HorizontalCylinder, lineThickness = 0.5, extent = {{-86, 14}, {90, -14}}), Text(origin = {-40, -6}, lineThickness = 0.5, extent = {{ 12, 16}, {72, -4}}, textString = "Fluid B"), Text(origin = {-2, 30}, lineThickness = 0.5, extent = {{-26, 6}, {34, -14}}, textString = "Fluid A"), Line(origin = {-48.1691, -0.0769465}, points = {{-12, 0}, {12, 0}}, color = {94, 94, 94}, thickness = 0.5, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 5), Line(origin = {45.8309, -0.336488}, points = {{-12, 0}, {12, 0}}, color = {94, 94, 94}, thickness = 0.5, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 5), Line(origin = {79.0506, -52.8561}, rotation = 90, points = {{-12, 0}, {12, 0}}, color = {207, 207, 207}, thickness = 0.5, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 5), Line(origin = {-79.2242, 50.9302}, rotation = 90, points = {{-12, 0}, {12, 0}}, color = {207, 207, 207}, thickness = 0.5, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 5), Line(origin = {-41.4227, 25.3271}, rotation = 180, points = {{-12, 0}, {12, 0}}, color = {207, 207, 207}, thickness = 0.5, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 5), Line(origin = {37.5697, -26.3828}, rotation = 180, points = {{-12, 0}, {12, 0}}, color = {207, 207, 207}, thickness = 0.5, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 5), Line(origin = {-35.3005, -26.0775}, rotation = 180, points = {{-12, 0}, {12, 0}}, color = {207, 207, 207}, thickness = 0.5, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 5), Line(origin = {43.5697, 25.5256}, rotation = 180, points = {{-12, 0}, {12, 0}}, color = {207, 207, 207}, thickness = 0.5, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 5)}));
end AnalyticWetExchanger;
