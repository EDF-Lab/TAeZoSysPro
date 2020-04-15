within TAeZoSysPro.FluidDynamics.BasesClasses;

model Interface_liq_gas
  import SI = Modelica.SIunits;
  //
  replaceable package Medium = Modelica.Media.Air.MoistAir;
  replaceable package MediumLiquid = Modelica.Media.Water.StandardWater;  
  // User defined parameters
  parameter SI.Area A = 0 "Interface surface Area" annotation(
    Dialog(group = "Geometrical properties"));
  parameter SI.Length Lc = 4 * A ^ 0.5 "Perimeter of the surface Area" annotation(
    Dialog(group = "Geometrical properties"));
  parameter SI.Emissivity eps = 0.96 "Emissivity of liquid interface" annotation(
    Dialog(group = "Geometrical properties"));
  
  // Internal variables
  Medium.Temperature T_mean "Mean temperature between fluid and wall";
  SI.TemperatureDifference dT "Temperature difference Interface - gas";
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
  SI.Density d_sat "Saturation density of the condensable species";
  SI.HeatFlowRate Q_flow_conv "Heat flow rate from convection";
  SI.HeatFlowRate Q_flow_evap "Heat flow rate from evaporation";
  SI.MassFlowRate m_flow "Mass flow rate from evaporation";
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

initial equation
  E = 0.0;
  
equation
  T_mean = (heatPort_a.T + flowPort_b.T) / 2 "port_a and port_b are defined in Element1D";
  dT = heatPort_a.T - flowPort_b.T;
  prescribedTemperature.T = heatPort_a.T;
  state = Medium.setState_pTX(p = Medium.reference_p, T = T_mean);
  
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
  d_sat = Medium.saturationPressure(heatPort_a.T) / (heatPort_a.T * Modelica.Constants.R / Medium.MMX[Medium.Water]);
  betaV = h_cv / (sum(flowPort_b.d) * cp);
  m_flow = betaV * (d_sat - flowPort_b.d[Medium.Water]) * A;
  Q_flow_evap = m_flow * Medium.enthalpyOfVaporization(heatPort_a.T);
  
//
  der(E) = heatPort_a.Q_flow;
  A_wall = A ;
  
// Ports handovers
  heatPort_a.Q_flow = carrollRadiation.Q_flow + Q_flow_conv + Q_flow_evap;
  flowPort_b.H_flow + heatPort_a.Q_flow = 0.0;
  flowPort_b.m_flow[Medium.Water] = -m_flow;
  flowPort_b.m_flow[Medium.Air] = 0.0;
  fluidPort_a.m_flow = m_flow ;
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
  </head>
	
  <body lang=\"en-UK\">
    <p>
      This components allows to model an interface between a liquid and surrounding where evapo-condensation, radiation and convection occur. This component is designed to work with moist air media.
    </p>
    
    <p>
      The mathematical model of evapo-condensation uses the same approach than in the <b>Condensation</b> module. It assumed that the limiting phenomenon for the transfer is the ability to bring the mass of moist air into contact to a wall.
    </p>
    			
    <p>
      Regarding the convection, the approach is the same than for the <b>FreeConvection</b> module of the <b>HeatTransfer</b> package. The correlation used is ground_ASHRAE.
    </p>
    
    <p>
      The radiative heat transfer is computed using the <b>CarrollRadiation</b> module.
    </p>

    <p>
      The heat exchanged from radiation, convection and evapo-condensation is transfered via the <b>heatPort_a</b>. The <b>fluidPort</b>_a is just used to transfer mass from the liquid to the atmosphere for evaporation and the vice versa for condensation. It does not transport energy.
    </p>    	
  </body>
</html>"),
    Icon(graphics = {Polygon(origin = {0, -20}, fillColor = {0, 85, 255}, fillPattern = FillPattern.Solid, points = {{100, -20}, {-100, -20}, {-100, 20}, {-80, 16}, {-60, 20}, {-40, 16}, {-20, 20}, {0, 16}, {20, 20}, {40, 16}, {60, 20}, {80, 16}, {100, 20}, {100, -20}}), Polygon(origin = {-80, 2}, fillColor = {0, 85, 255}, fillPattern = FillPattern.Solid, points = {{0, -6}, {-4, -2}, {0, 12}, {4, -2}, {0, -6}}, smooth = Smooth.Bezier), Line(origin = {-60.96, 18.5556}, points = {{0.962089, -16}, {0.962089, -10}, {-3.03791, -10}, {4.96209, -6}, {-3.03791, -2}, {4.96209, 2}, {-3.03791, 6}, {4.96209, 10}, {0.96209, 10}, {0.96209, 16}}, color = {255, 0, 0}, thickness = 0.5, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 5), Line(origin = {-42.09, 17.5956}, points = {{0.0936599, -17.0363}, {-1.90634, -9.03629}, {2.09366, -3.03629}, {-1.90634, 2.96371}, {2.09366, 8.9637}, {0.0936601, 14.9637}}, color = {0, 85, 255}, thickness = 0.5, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 5, smooth = Smooth.Bezier), Line(origin = {-36.9446, 17.6656}, points = {{0.0936599, -17.0363}, {-1.90634, -9.03629}, {2.09366, -3.03629}, {-1.90634, 2.96371}, {2.09366, 8.9637}, {0.0936601, 14.9637}}, color = {0, 85, 255}, thickness = 0.5, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 5, smooth = Smooth.Bezier), Polygon(origin = {80, 2}, fillColor = {0, 85, 255}, fillPattern = FillPattern.Solid, points = {{0, -6}, {-4, -2}, {0, 12}, {4, -2}, {0, -6}}, smooth = Smooth.Bezier), Line(origin = {58.711, 18.1843}, points = {{0.962089, -16}, {0.962089, -10}, {-3.03791, -10}, {4.96209, -6}, {-3.03791, -2}, {4.96209, 2}, {-3.03791, 6}, {4.96209, 10}, {0.96209, 10}, {0.96209, 16}}, color = {255, 0, 0}, thickness = 0.5, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 5), Line(origin = {37.4338, 17.6656}, points = {{0.0936599, -17.0363}, {-1.90634, -9.03629}, {2.09366, -3.03629}, {-1.90634, 2.96371}, {2.09366, 8.9637}, {0.0936601, 14.9637}}, color = {0, 85, 255}, thickness = 0.5, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 5, smooth = Smooth.Bezier), Line(origin = {42.5791, 17.515}, points = {{0.0936599, -17.0363}, {-1.90634, -9.03629}, {2.09366, -3.03629}, {-1.90634, 2.96371}, {2.09366, 8.9637}, {0.0936601, 14.9637}}, color = {0, 85, 255}, thickness = 0.5, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 5, smooth = Smooth.Bezier), Line(origin = {-4, 16.5556}, points = {{0, -16}, {0, 16}}, color = {255, 0, 0}, thickness = 0.5, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 5), Line(origin = {5.5, 16.4445}, points = {{0, -16}, {0, 16}}, color = {255, 0, 0}, thickness = 0.5, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 5)}, coordinateSystem(initialScale = 0.1)),
    Diagram(graphics = {Polygon(origin = {0, -40}, fillColor = {0, 85, 255}, fillPattern = FillPattern.Solid, points = {{100, -20}, {-100, -20}, {-100, 20}, {-80, 16}, {-60, 20}, {-40, 16}, {-20, 20}, {0, 16}, {20, 20}, {40, 16}, {60, 20}, {80, 16}, {100, 20}, {100, -20}}), Polygon(origin = {-80, -18}, fillColor = {0, 85, 255}, fillPattern = FillPattern.Solid, points = {{0, -6}, {-4, -2}, {0, 12}, {4, -2}, {0, -6}}, smooth = Smooth.Bezier), Line(origin = {-61.3489, -2.44444}, points = {{0.962089, -16}, {0.962089, -10}, {-3.03791, -10}, {4.96209, -6}, {-3.03791, -2}, {4.96209, 2}, {-3.03791, 6}, {4.96209, 10}, {0.96209, 10}, {0.96209, 16}}, color = {255, 0, 0}, thickness = 0.5, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 5), Line(origin = {-42.4789, -3.40444}, points = {{0.0936599, -17.0363}, {-1.90634, -9.03629}, {2.09366, -3.03629}, {-1.90634, 2.96371}, {2.09366, 8.9637}, {0.0936601, 14.9637}}, color = {0, 85, 255}, thickness = 0.5, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 5, smooth = Smooth.Bezier), Line(origin = {-37.3335, -3.33444}, points = {{0.0936599, -17.0363}, {-1.90634, -9.03629}, {2.09366, -3.03629}, {-1.90634, 2.96371}, {2.09366, 8.9637}, {0.0936601, 14.9637}}, color = {0, 85, 255}, thickness = 0.5, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 5, smooth = Smooth.Bezier), Polygon(origin = {80, -18}, fillColor = {0, 85, 255}, fillPattern = FillPattern.Solid, points = {{0, -6}, {-4, -2}, {0, 12}, {4, -2}, {0, -6}}, smooth = Smooth.Bezier), Line(origin = {58.3221, -2.81574}, points = {{0.962089, -16}, {0.962089, -10}, {-3.03791, -10}, {4.96209, -6}, {-3.03791, -2}, {4.96209, 2}, {-3.03791, 6}, {4.96209, 10}, {0.96209, 10}, {0.96209, 16}}, color = {255, 0, 0}, thickness = 0.5, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 5), Line(origin = {37.0449, -3.33444}, points = {{0.0936599, -17.0363}, {-1.90634, -9.03629}, {2.09366, -3.03629}, {-1.90634, 2.96371}, {2.09366, 8.9637}, {0.0936601, 14.9637}}, color = {0, 85, 255}, thickness = 0.5, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 5, smooth = Smooth.Bezier), Line(origin = {42.1902, -3.48504}, points = {{0.0936599, -17.0363}, {-1.90634, -9.03629}, {2.09366, -3.03629}, {-1.90634, 2.96371}, {2.09366, 8.9637}, {0.0936601, 14.9637}}, color = {0, 85, 255}, thickness = 0.5, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 5, smooth = Smooth.Bezier), Line(origin = {-4.38889, -4.44444}, points = {{0, -16}, {0, 16}}, color = {255, 0, 0}, thickness = 0.5, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 5), Line(origin = {5.11111, -4.55554}, points = {{0, -16}, {0, 16}}, color = {255, 0, 0}, thickness = 0.5, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 5)}, coordinateSystem(initialScale = 0.1)));

end Interface_liq_gas;
