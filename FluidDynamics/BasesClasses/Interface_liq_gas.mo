within TAeZoSysPro.FluidDynamics.BasesClasses;

model Interface_liq_gas
  import SI = Modelica.SIunits;
//
  replaceable package Medium = TAeZoSysPro.Media.MyMedia;
  replaceable package MediumLiquid = Modelica.Media.Water.WaterIF97_ph;  
// User defined parameters
  parameter SI.Area A = 0 "Interface surface Area" annotation(
    Dialog(group = "Geometrical properties"));
  parameter SI.Length Lc = 4 * A ^ 0.5 "Perimeter of the surface Area" annotation(
    Dialog(group = "Geometrical properties"));
  parameter SI.Emissivity eps = 0.96 "Emissivity of liquid interface" annotation(
    Dialog(group = "Geometrical properties"));
  parameter Modelica.SIunits.NumberDensityOfMolecules n_bubbles = 150 * 1e6 "Number density of bubble in node" ;
  constant Modelica.SIunits.CoefficientOfFriction Cx = 0.47 "drag coefficient for a sphere" ;
    
// Internal variables
  //for convection
  Medium.Temperature T_mean "Mean temperature between fluid and wall";
  SI.TemperatureDifference dT "Temperature difference Interface - gas";
  SI.Pressure p "Pressure of the atmosphere";
  SI.CoefficientOfHeatTransfer h_cv "Heat transfert coefficient";
  SI.Density d "Density of fluid at T_mean";
  SI.SpecificHeatCapacity cp "Specific heat capacity of fluid at T_mean";
  SI.DynamicViscosity mu "Dynamic viscosity of fluid at T_mean";
  SI.ThermalConductivity k "Thermal Conductivity of fluid at T_mean";
  SI.PrandtlNumber Pr "Prandtl Number";
  SI.GrashofNumber Gr "Grashof Number";
  SI.RayleighNumber Ra "Rayleigh Number";
  SI.NusseltNumber Nu "Nusselt Number";
  Real betaV(unit = "kg/m2/s") "Mass transfer coefficient";
  SI.HeatFlowRate Q_flow_conv "Heat flow rate from convection";
  //for evapo-condensation
  SI.HeatFlowRate Q_flow_evap "Heat flow rate from evaporation";
  SI.EnthalpyFlowRate H_flow_evap ;
  SI.MassFlowRate m_flow_evap "Mass flow rate from evaporation";
  SI.Density d_sat "Saturation density of the condensable species";
  //for boiling
  SI.SpecificEnthalpy h_dew "Specific dew enthalpy of liquid medium";
  SI.SpecificEnthalpy h_bubble "Specific bubble enthalpy of liquid medium";
  SI.SpecificEnthalpy h "Specific enthalpy of liquid medium";
  SI.Density d_liq "Density in the liquid medium";  
  SI.Diameter d_bubble "Diameter of bubble in liquid medium";
  SI.Velocity Vel "Ascending velocity of bubble in the liquid medium";
  SI.MassFlowRate m_flow_bubble "Mass flow rate from boiling";
  Real Xg "Mass fraction of gas in the liquid medium";
  SI.ReynoldsNumber Re "Reynold number of a bubble";
  //
  SI.Energy E "Energy passed throught the component";
  
  // Imported modules
  TAeZoSysPro.HeatTransfer.Interfaces.HeatPort_a heatPort_a annotation(
    Placement(visible = true, transformation(origin = {-60, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-60, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature prescribedTemperature annotation(
    Placement(visible = true, transformation(origin = {-90, 18}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
  TAeZoSysPro.FluidDynamics.Interfaces.FlowPort_b flowPort_b(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {50, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {70, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  TAeZoSysPro.HeatTransfer.Interfaces.HeatPort_b port_rad annotation(
    Placement(visible = true, transformation(origin = {-90, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-70, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  TAeZoSysPro.HeatTransfer.BasesClasses.CarrollRadiation carrollRadiation(A = A, eps = 0.8)  annotation(
    Placement(visible = true, transformation(origin = {-60, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput F_view annotation(
    Placement(visible = true, transformation(origin = {-7, 85}, extent = {{-15, -15}, {15, 15}}, rotation = -90), iconTransformation(origin = {-10, 90}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealOutput A_wall annotation(
    Placement(visible = true, transformation(origin = {-36, 84}, extent = {{-10, -10}, {10, 10}}, rotation = 90), iconTransformation(origin = {-40, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Fluid.Interfaces.FluidPort_a fluidPort_a(redeclare package Medium = MediumLiquid) annotation(
    Placement(visible = true, transformation(origin = {54, -88}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {60, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
protected
  Medium.ThermodynamicState state;
  MediumLiquid.SaturationProperties sat "Saturation property record at the interface";

initial equation
  E = 0.0;
  
equation
  T_mean = (heatPort_a.T + flowPort_b.T) / 2 "port_a and port_b are defined in Element1D";
  dT = heatPort_a.T - flowPort_b.T;
  prescribedTemperature.T = heatPort_a.T;
  p = Medium.pressure(Medium.setState_dTX(d = sum(flowPort_b.d), T = flowPort_b.T, X=flowPort_b.d/sum(flowPort_b.d)));
  state = Medium.setState_dTX(d = sum(flowPort_b.d), T = T_mean, X=flowPort_b.d/sum(flowPort_b.d));
  sat = MediumLiquid.setSat_p(p = p) ;
  
// Thermodynamic properties calculation
  d = Medium.density(state);
  mu = Medium.dynamicViscosity(state);
  cp = Medium.specificHeatCapacityCp(state);
  k = Medium.thermalConductivity(state);
  
// Calculation of characteristic numbers for convection
  Pr = mu * cp / k;
  Gr = 9.81 * 1 / flowPort_b.T * d ^ 2 * abs(dT) * Lc ^ 3 / mu ^ 2;
  Ra = Gr * Pr;
  Nu = TAeZoSysPro.HeatTransfer.Functions.FreeConvection.ground_ASHRAE(dT = dT, Ra = Ra);
  
// Convective heat transfer calculation
  h_cv = Nu * k / Lc;
  
// Convective Heat flow rate calculation
  Q_flow_conv = h_cv * A * dT;
  
// Evapocondensation heat flow rate calculation
  //d_sat = Medium.saturationPressure(heatPort_a.T) / (heatPort_a.T * Modelica.Constants.R / Medium.MMX[Medium.Water]);
  d_sat = MediumLiquid.dewDensity(sat) ;
  betaV = h_cv / (sum(flowPort_b.d) * cp);
  m_flow_evap = betaV * (d_sat - flowPort_b.d[Medium.Water]) * A;
  Q_flow_evap = m_flow_evap * Medium.enthalpyOfVaporization(heatPort_a.T);
  H_flow_evap = m_flow_evap * h_dew ; 

// Boiling
  h_dew = MediumLiquid.dewEnthalpy(sat) ;
  h_bubble = MediumLiquid.bubbleEnthalpy(sat) ;
  h = inStream(fluidPort_a.h_outflow) ;
  h_dew * Xg + (1 - Xg) * h_bubble = h;
  d_liq = MediumLiquid.density_ph(p = fluidPort_a.p, h = inStream(fluidPort_a.h_outflow)) ;
  //
  Modelica.Constants.pi * (d_bubble^3)/6 = max(Xg, 0.0) * d_liq / d_sat / n_bubbles ; 
  // quasi static flow: friction force + bouyancy force = 0
  Vel = sqrt(4/3*Modelica.Constants.g_n * d_bubble / Cx) ;
  m_flow_bubble = Vel * A * (n_bubbles * Modelica.Constants.pi / 6 * d_bubble ^ 3) * d_sat;
  Re = MediumLiquid.bubbleDensity(sat) * Vel * d_bubble / MediumLiquid.dynamicViscosity(MediumLiquid.setBubbleState(sat)) ;
//
  der(E) = heatPort_a.Q_flow;
  A_wall = A ;
  
// Ports handovers
  heatPort_a.Q_flow = carrollRadiation.Q_flow + Q_flow_conv + Q_flow_evap + m_flow_bubble * (h_dew - h_bubble) ;
  flowPort_b.H_flow = -Q_flow_conv - H_flow_evap - m_flow_bubble * h_dew ;
  flowPort_b.m_flow[Medium.Water] = -m_flow_evap - m_flow_bubble ;
  flowPort_b.m_flow[Medium.Air] = 0.0;
  fluidPort_a.p = p;
  fluidPort_a.m_flow = m_flow_evap + m_flow_bubble  ;
  fluidPort_a.h_outflow = inStream(fluidPort_a.h_outflow);
  fluidPort_a.Xi_outflow = inStream(fluidPort_a.Xi_outflow);
  fluidPort_a.C_outflow = inStream(fluidPort_a.C_outflow);
  
  connect(port_rad, carrollRadiation.port_b) annotation(
    Line(points = {{-90, 90}, {-90, 75}, {-60, 75}, {-60, 60}}, color = {191, 0, 0}));
  connect(prescribedTemperature.port, carrollRadiation.port_a) annotation(
    Line(points = {{-90, 28}, {-90, 28}, {-90, 32}, {-60, 32}, {-60, 40}, {-60, 40}}, color = {191, 0, 0}));
  connect(F_view, carrollRadiation.Fview) annotation(
    Line(points = {{-6, 86}, {-8, 86}, {-8, 42}, {-52, 42}, {-52, 42}}, color = {0, 0, 127}));
  
  annotation(
    Documentation(info = "
<html>
  <head>
    <title>Interface_liq_gas</title>
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
      This components allows to model a flat interface between a liquid and surrounding gas where evapo-condensation, boiling, radiation and convection occur. This component is designed to work with moist air media.
    </p>

    <h4>Evapo-condensation</h4>
    
    <p>
      The mathematical model of evapo-condensation uses the same approach than in the <b>Condensation</b> module. It assumed that the limiting phenomenon for the transfer is the ability to bring the mass of moist air into contact to a wall.
    </p>

    <h4>Convection</h4>
    			
    <p>
      Regarding the convection, the approach is the same than for the <b>FreeConvection</b> module of the <b>HeatTransfer</b> package. The correlation used is ground_ASHRAE.
    </p>

    <h4>Radiation</h4>
    
    <p>
      The radiative heat transfer is computed using the <b>CarrollRadiation</b> module.
    </p>

    <h4>Boiling</h4>
    
    <p>
      The boiling is modelled by an homogeneneous formation of bubbles of equal diameter (no coalescence, no growth, no collapse) that would be formed in the liquid node and that escape by the interface. </br> 
      The bubble formation rate is deduced from the fraction of gas itself deduced from the liquid node specific enthalpy, the bubble and dew specific enthalpy:
    </p>

    <img	
      src=\"modelica://TAeZoSysPro/Information/FluidDynamics/BasesClasses/EQ_Interface_liq_gas1.PNG\"
    />

    <p>
      The diameter of bubble is computed from the amount of gas, from an arbitrary number density of bubble (number of bubble per cubic meter of liquid) and from the knowledge of the state of the liquid node connected to the interface. By default <code>n_bubbles = 150e6 m<sup><code>-3</code></sup></code>
    </p>
    
    <img	
      src=\"modelica://TAeZoSysPro/Information/FluidDynamics/BasesClasses/EQ_Interface_liq_gas2.PNG\"
    />
    
    <p>
      The velocity of bubbles is computed from the steady balance between the buoyancy force and the friction force. The weight of the bubble in neglected and the density term of liquid phase regarding the density of the gas phase in neglected in the buoyancy force claculation. The flow regime considered for the friction is laminar and the bubbles are assimilated to spheres. 
    </p>

    <img	
      src=\"modelica://TAeZoSysPro/Information/FluidDynamics/BasesClasses/EQ_Interface_liq_gas3.PNG\"
    />
    
    <p>
      The boiling mass flow rate derives from the surface aera of the interface corrected by the ratio between the volume of bubbles and the total volume of the liquid node connected to the interface module. 
    </p>

    <img	
      src=\"modelica://TAeZoSysPro/Information/FluidDynamics/BasesClasses/EQ_Interface_liq_gas4.PNG\"
    />

    <p>
      <b>Where:</b>
      <ul>
        <li> <code>Xg</code> is ratio between the mass of bubble (<code>m<sub><code>bubble</code></sub></code>) in the liquid node connected to the interface and the total mass (<code>m</code>) of the liquid node </li>
        <li> <code>h</code> is the specific enthalpy of the liquid node connected to the interface, <code>h_bubble</code> and <code>h_dew</code> being its respectively the saturated liquid and gas specific enthalpy </li>
        <li> <code>d_sat</code> is the density of bubble</li>
        <li> <code>V</code> is the volume of the liquid node connected to the interface</li>        
        <li> <code>n_bubbles</code> is the number density (number/m3) of bubbles in the liquid node </li>
        <li> <code>d_bubble</code> is the diameter of a bubble </li>
        <li> <code>d</code> is the total density of the liquid node connected to the interface </li> 
        <li> <code>Vel</code> is the ascending velocity of bubble </li> 
        <li> <code>μ</code> is dynamic viscosity of the liquid node connected to the interface </li>
        <li> <code>g</code> is gravitationnal acceleration </li>
        <li> <code>m_flow</code> is the mass flow rate of leaving bubble </li>
        <li> <code>A</code> is the surface area of the interface </li>      
      </ul>	
    </p>    
     
       
    <h4>Port heat and mass flows</h4>
    
    <p>
      The heat exchanged from radiation, convection, evapo-condensation and boiling is transfered via the <b>heatPort_a</b>. The <b>fluidPort</b>_a is just used to transfer mass from the liquid to the atmosphere for evaporation and the vice versa for condensation. It is not used to transport energy.
    </p>    	
  </body>
</html>"),
    Icon(graphics = {Polygon(origin = {0, -20}, fillColor = {0, 85, 255}, fillPattern = FillPattern.Solid, points = {{100, -20}, {-100, -20}, {-100, 20}, {-80, 16}, {-60, 20}, {-40, 16}, {-20, 20}, {0, 16}, {20, 20}, {40, 16}, {60, 20}, {80, 16}, {100, 20}, {100, -20}}), Polygon(origin = {-80, 2}, fillColor = {0, 85, 255}, fillPattern = FillPattern.Solid, points = {{0, -6}, {-4, -2}, {0, 12}, {4, -2}, {0, -6}}, smooth = Smooth.Bezier), Line(origin = {-60.96, 18.5556}, points = {{0.962089, -16}, {0.962089, -10}, {-3.03791, -10}, {4.96209, -6}, {-3.03791, -2}, {4.96209, 2}, {-3.03791, 6}, {4.96209, 10}, {0.96209, 10}, {0.96209, 16}}, color = {255, 0, 0}, thickness = 0.5, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 5), Line(origin = {-42.09, 17.5956}, points = {{0.0936599, -17.0363}, {-1.90634, -9.03629}, {2.09366, -3.03629}, {-1.90634, 2.96371}, {2.09366, 8.9637}, {0.0936601, 14.9637}}, color = {0, 85, 255}, thickness = 0.5, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 5, smooth = Smooth.Bezier), Line(origin = {-36.9446, 17.6656}, points = {{0.0936599, -17.0363}, {-1.90634, -9.03629}, {2.09366, -3.03629}, {-1.90634, 2.96371}, {2.09366, 8.9637}, {0.0936601, 14.9637}}, color = {0, 85, 255}, thickness = 0.5, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 5, smooth = Smooth.Bezier), Polygon(origin = {80, 2}, fillColor = {0, 85, 255}, fillPattern = FillPattern.Solid, points = {{0, -6}, {-4, -2}, {0, 12}, {4, -2}, {0, -6}}, smooth = Smooth.Bezier), Line(origin = {58.711, 18.1843}, points = {{0.962089, -16}, {0.962089, -10}, {-3.03791, -10}, {4.96209, -6}, {-3.03791, -2}, {4.96209, 2}, {-3.03791, 6}, {4.96209, 10}, {0.96209, 10}, {0.96209, 16}}, color = {255, 0, 0}, thickness = 0.5, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 5), Line(origin = {37.4338, 17.6656}, points = {{0.0936599, -17.0363}, {-1.90634, -9.03629}, {2.09366, -3.03629}, {-1.90634, 2.96371}, {2.09366, 8.9637}, {0.0936601, 14.9637}}, color = {0, 85, 255}, thickness = 0.5, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 5, smooth = Smooth.Bezier), Line(origin = {42.5791, 17.515}, points = {{0.0936599, -17.0363}, {-1.90634, -9.03629}, {2.09366, -3.03629}, {-1.90634, 2.96371}, {2.09366, 8.9637}, {0.0936601, 14.9637}}, color = {0, 85, 255}, thickness = 0.5, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 5, smooth = Smooth.Bezier), Line(origin = {-4, 16.5556}, points = {{0, -16}, {0, 16}}, color = {255, 0, 0}, thickness = 0.5, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 5), Line(origin = {5.5, 16.4445}, points = {{0, -16}, {0, 16}}, color = {255, 0, 0}, thickness = 0.5, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 5)}, coordinateSystem(initialScale = 0.1)),
    Diagram(graphics = {Polygon(origin = {0, -40}, fillColor = {0, 85, 255}, fillPattern = FillPattern.Solid, points = {{100, -20}, {-100, -20}, {-100, 20}, {-80, 16}, {-60, 20}, {-40, 16}, {-20, 20}, {0, 16}, {20, 20}, {40, 16}, {60, 20}, {80, 16}, {100, 20}, {100, -20}}), Polygon(origin = {-80, -18}, fillColor = {0, 85, 255}, fillPattern = FillPattern.Solid, points = {{0, -6}, {-4, -2}, {0, 12}, {4, -2}, {0, -6}}, smooth = Smooth.Bezier), Line(origin = {-61.3489, -2.44444}, points = {{0.962089, -16}, {0.962089, -10}, {-3.03791, -10}, {4.96209, -6}, {-3.03791, -2}, {4.96209, 2}, {-3.03791, 6}, {4.96209, 10}, {0.96209, 10}, {0.96209, 16}}, color = {255, 0, 0}, thickness = 0.5, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 5), Line(origin = {-42.4789, -3.40444}, points = {{0.0936599, -17.0363}, {-1.90634, -9.03629}, {2.09366, -3.03629}, {-1.90634, 2.96371}, {2.09366, 8.9637}, {0.0936601, 14.9637}}, color = {0, 85, 255}, thickness = 0.5, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 5, smooth = Smooth.Bezier), Line(origin = {-37.3335, -3.33444}, points = {{0.0936599, -17.0363}, {-1.90634, -9.03629}, {2.09366, -3.03629}, {-1.90634, 2.96371}, {2.09366, 8.9637}, {0.0936601, 14.9637}}, color = {0, 85, 255}, thickness = 0.5, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 5, smooth = Smooth.Bezier), Polygon(origin = {80, -18}, fillColor = {0, 85, 255}, fillPattern = FillPattern.Solid, points = {{0, -6}, {-4, -2}, {0, 12}, {4, -2}, {0, -6}}, smooth = Smooth.Bezier), Line(origin = {58.3221, -2.81574}, points = {{0.962089, -16}, {0.962089, -10}, {-3.03791, -10}, {4.96209, -6}, {-3.03791, -2}, {4.96209, 2}, {-3.03791, 6}, {4.96209, 10}, {0.96209, 10}, {0.96209, 16}}, color = {255, 0, 0}, thickness = 0.5, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 5), Line(origin = {37.0449, -3.33444}, points = {{0.0936599, -17.0363}, {-1.90634, -9.03629}, {2.09366, -3.03629}, {-1.90634, 2.96371}, {2.09366, 8.9637}, {0.0936601, 14.9637}}, color = {0, 85, 255}, thickness = 0.5, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 5, smooth = Smooth.Bezier), Line(origin = {42.1902, -3.48504}, points = {{0.0936599, -17.0363}, {-1.90634, -9.03629}, {2.09366, -3.03629}, {-1.90634, 2.96371}, {2.09366, 8.9637}, {0.0936601, 14.9637}}, color = {0, 85, 255}, thickness = 0.5, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 5, smooth = Smooth.Bezier), Line(origin = {-4.38889, -4.44444}, points = {{0, -16}, {0, 16}}, color = {255, 0, 0}, thickness = 0.5, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 5), Line(origin = {5.11111, -4.55554}, points = {{0, -16}, {0, 16}}, color = {255, 0, 0}, thickness = 0.5, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 5)}, coordinateSystem(initialScale = 0.1)));

end Interface_liq_gas;
