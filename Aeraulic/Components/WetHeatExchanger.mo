within TAeZoSysPro.Aeraulic.Components;

model WetHeatExchanger
  package MediumGas = TAeZoSysPro.Aeraulic.Media.MyMedia;
  package MediumLiq = TAeZoSysPro.Aeraulic.Media.SimpleWater;
  //
  parameter TAeZoSysPro.HeatTransfer.Types.ExchangerType exchangerType = TAeZoSysPro.HeatTransfer.Types.ExchangerType.CounterFlow;
  //
  parameter Real ksi_gasFixed = 1.0 "fixed pressure loss coefficient for gas pipe" annotation(
    Dialog(group = "Flow"));
  parameter Real ksi_liqFixed = 1.0 "fixed pressure loss coefficient water pipe" annotation(
    Dialog(group = "Flow"));
  parameter Modelica.SIunits.CoefficientOfHeatTransfer hGas = 10 "Constant heat transfer coefficient for gas side" annotation(
    Dialog(group = "Flow"));
  parameter Modelica.SIunits.CoefficientOfHeatTransfer hLiquid = 100 "Constant heat transfer coefficient for gas side" annotation(
    Dialog(group = "Flow"));
  //
  parameter Modelica.SIunits.Area GasCrossArea = 1.0 "Gas cross section area" annotation(
    Dialog(group = "Geometry"));
  parameter Modelica.SIunits.Area LiqCrossArea = 1.0 "liquid cross section area" annotation(
    Dialog(group = "Geometry"));
  parameter Modelica.SIunits.Area ExchangeArea = 1.0 "Mean exchange area" annotation(
    Dialog(group = "Geometry"));
  // Internal variable
  Modelica.SIunits.MassFlowRate m_flow_cond ;
  Modelica.SIunits.MassFlowRate m_flow_Gas ;
  Modelica.SIunits.MassFlowRate m_flow_Liq ;
  //
  Modelica.SIunits.Velocity VelGas ;
  Modelica.SIunits.Velocity VelLiq ;
  //
  Modelica.SIunits.Density d_Gas_in "Gas density at inlet" ;
  Modelica.SIunits.Density d_Lid_in "Liq density at inlet" ;
  //
  Modelica.SIunits.SpecificEnthalpy hGas_in, hGas_out, hLiq_in_sat, hLiq_out_sat ;
  //
  Modelica.SIunits.Power P_sens "Sensible power" ;
  Modelica.SIunits.Power P_lat "Latent power" ;
  Modelica.SIunits.Power P_exc "Exchanged power" ;   
// Internal components
  Modelica.Fluid.Interfaces.FluidPort_a portGas_in(replaceable package Medium = MediumGas) annotation(
    Placement(visible = true, transformation(origin = {-100, 52}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 52}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_b portGas_out(replaceable package Medium = MediumGas) annotation(
    Placement(visible = true, transformation(origin = {100, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_a portLiq_in(replaceable package Medium = MediumLiq) annotation(
    Placement(visible = true, transformation(origin = {100, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_b portLiq_out(replaceable package Medium = MediumLiq) annotation(
    Placement(visible = true, transformation(origin = {-100, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
   
equation
// Temporary equation
cpGas = 1005 ;
cpLiq = 4180 ;

//
m_flow_cond = 0.0 ;
P_sens = 0.0 ;
P_lat= 0.0 ;
P_exc = P_sens + P_lat ;

// Fuild dynamics calculation
  //Aeraulic part
  d_Gas_in = 1.2 ;
  portGas_in.p - portGas_out.p = ksi_gasFixed * 1/2 * d_Gas_in * VelGas^2 ;
  m_flow_Gas = d_Gas_in * VelGas * GasCrossArea ;
  
  //hydrolic part
  d_Liq_in = 1000 ;
  portLiq_in.p - portLiq_out.p = ksi_liqFixed * 1/2 * d_Liq_in * VelLiq^2 ;
  m_flow_Liq = d_Liq_in * VelLiq * LiqCrossArea ; 
  
// heat exchange part 
  hGas_in = inStream(portGas_in) ;
  hLiq_in_sat = inStream(portLiq_in) * cpGas ;
  QcGas = m_flow_Gas * cpGas ;
  QcLiq = m_flow_Liq * cpLiq / cpGas ;
  QcMin = min(QcGas, QcLiq) ;
  Cr = QcMin / max(QcGas, QcLiq) ;
  // NTU method
  NTU = K_average * ExchangeArea / QcMin ;
  Eff = ( 1 - exp( -(1-Cr)*NTU ) ) / ( 1 - Cr*exp( -(1-Cr)*NTU ) ) ;
  Eff = ( QcGas * ( hGas_in - hGas_out ) ) / ( QcMin * ( hGas_in - hLiq_in_sat) ) ;
  





annotation(
    Diagram(graphics = {Rectangle(lineThickness = 0.5, extent = {{-100, 100}, {100, -100}}), Rectangle(lineColor = {152, 152, 152}, fillColor = {238, 238, 238}, pattern = LinePattern.Dash, fillPattern = FillPattern.HorizontalCylinder, lineThickness = 0.5, extent = {{-100, 6}, {100, -6}}), Line(origin = {-22, 28}, points = {{0, 16}, {0, -16}}, color = {255, 0, 0}, pattern = LinePattern.Dash, thickness = 0.5, arrow = {Arrow.None, Arrow.Open}), Line(origin = {-8, 38}, points = {{-20, 0}, {12, 0}}, color = {0, 85, 255}, pattern = LinePattern.Dash, thickness = 0.5, arrow = {Arrow.None, Arrow.Open}), Line(origin = {-8, 28}, points = {{-20, 0}, {12, 0}}, color = {0, 85, 255}, pattern = LinePattern.Dash, thickness = 0.5, arrow = {Arrow.None, Arrow.Open}), Line(origin = {-4, 28}, points = {{0, 16}, {0, -16}}, color = {255, 0, 0}, pattern = LinePattern.Dash, thickness = 0.5, arrow = {Arrow.None, Arrow.Open}), Line(origin = {-8, 18}, points = {{-20, 0}, {12, 0}}, color = {0, 85, 255}, pattern = LinePattern.Dash, thickness = 0.5, arrow = {Arrow.None, Arrow.Open}), Polygon(origin = {21, 35}, lineColor = {0, 85, 255}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.CrossDiag, lineThickness = 0.5, points = {{-5, -19}, {7, -19}, {1, -1}, {-5, -19}}), Ellipse(origin = {21, 17}, lineColor = {0, 85, 255}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.CrossDiag, lineThickness = 0.5, extent = {{-5, 5}, {7, -7}}, endAngle = 360), Line(origin = {8, -44}, points = {{0, 16}, {0, -16}}, color = {255, 0, 0}, pattern = LinePattern.Dash, thickness = 0.5, arrow = {Arrow.None, Arrow.Open}), Line(origin = {-4, -54}, rotation = 180, points = {{-20, 0}, {12, 0}}, color = {0, 85, 255}, pattern = LinePattern.Dash, thickness = 0.5, arrow = {Arrow.None, Arrow.Open}), Line(origin = {-4, -44}, rotation = 180, points = {{-20, 0}, {12, 0}}, color = {0, 85, 255}, pattern = LinePattern.Dash, thickness = 0.5, arrow = {Arrow.None, Arrow.Open}), Line(origin = {-10, -44}, points = {{0, 16}, {0, -16}}, color = {255, 0, 0}, pattern = LinePattern.Dash, thickness = 0.5, arrow = {Arrow.None, Arrow.Open}), Line(origin = {-4, -34}, rotation = 180, points = {{-20, 0}, {12, 0}}, color = {0, 85, 255}, pattern = LinePattern.Dash, thickness = 0.5, arrow = {Arrow.None, Arrow.Open})}, coordinateSystem(initialScale = 0.1)),
    Icon(coordinateSystem(initialScale = 0.1), graphics = {Rectangle(lineThickness = 0.5, extent = {{-100, 100}, {100, -100}}), Rectangle(lineColor = {152, 152, 152}, fillColor = {238, 238, 238}, pattern = LinePattern.Dash, fillPattern = FillPattern.HorizontalCylinder, lineThickness = 0.5, extent = {{-100, 6}, {100, -6}}), Line(origin = {-36, 28}, points = {{-20, 0}, {32, 0}}, color = {0, 85, 255}, pattern = LinePattern.Dash, thickness = 0.5, arrow = {Arrow.None, Arrow.Open}), Line(origin = {-36, 18}, points = {{-20, 0}, {32, 0}}, color = {0, 85, 255}, pattern = LinePattern.Dash, thickness = 0.5, arrow = {Arrow.None, Arrow.Open}), Line(origin = {-36, 38}, points = {{-20, 0}, {32, 0}}, color = {0, 85, 255}, pattern = LinePattern.Dash, thickness = 0.5, arrow = {Arrow.None, Arrow.Open}), Line(origin = {-50, 28}, points = {{0, 16}, {0, -16}}, color = {255, 0, 0}, pattern = LinePattern.Dash, thickness = 0.5, arrow = {Arrow.None, Arrow.Open}), Line(origin = {-14, 28}, points = {{0, 16}, {0, -16}}, color = {255, 0, 0}, pattern = LinePattern.Dash, thickness = 0.5, arrow = {Arrow.None, Arrow.Open}), Polygon(origin = {49, 35}, lineColor = {0, 85, 255}, fillColor = {0, 170, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, lineThickness = 0.5, points = {{-5, -19}, {7, -19}, {1, -1}, {-5, -19}}), Ellipse(origin = {49, 17}, lineColor = {0, 85, 255}, fillColor = {0, 170, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, lineThickness = 0.5, extent = {{-5, 5}, {7, -7}}, endAngle = 360), Line(origin = {-17.3206, 74.6136}, points = {{-37, -0.293029}, {-25, -0.293029}, {-17, 15.707}, {-3, -14.293}, {11, 15.707}, {25, -14.293}, {37, 15.707}, {51, -14.293}, {57, -0.293029}, {69, -0.293029}}, thickness = 0.5), Line(origin = {-30.9618, 28.0611}, points = {{0, 16}, {0, -16}}, color = {255, 0, 0}, pattern = LinePattern.Dash, thickness = 0.5, arrow = {Arrow.None, Arrow.Open}), Line(origin = {-17.2595, -73.9666}, points = {{-37, -0.293029}, {-25, -0.293029}, {-17, 15.707}, {-3, -14.293}, {11, 15.707}, {25, -14.293}, {37, 15.707}, {51, -14.293}, {57, -0.293029}, {69, -0.293029}}, thickness = 0.5), Line(origin = {-16.5191, -29.9695}, rotation = 180, points = {{0, 16}, {0, -16}}, color = {255, 0, 0}, pattern = LinePattern.Dash, thickness = 0.5, arrow = {Arrow.None, Arrow.Open}), Line(origin = {5.48092, -19.9695}, rotation = 180, points = {{-20, 0}, {32, 0}}, color = {0, 85, 255}, pattern = LinePattern.Dash, thickness = 0.5, arrow = {Arrow.None, Arrow.Open}), Line(origin = {0.51912, -29.9084}, rotation = 180, points = {{0, 16}, {0, -16}}, color = {255, 0, 0}, pattern = LinePattern.Dash, thickness = 0.5, arrow = {Arrow.None, Arrow.Open}), Line(origin = {5.48092, -29.9695}, rotation = 180, points = {{-20, 0}, {32, 0}}, color = {0, 85, 255}, pattern = LinePattern.Dash, thickness = 0.5, arrow = {Arrow.None, Arrow.Open}), Line(origin = {17.4809, -29.9695}, rotation = 180, points = {{0, 16}, {0, -16}}, color = {255, 0, 0}, pattern = LinePattern.Dash, thickness = 0.5, arrow = {Arrow.None, Arrow.Open}), Line(origin = {5.48092, -39.9695}, rotation = 180, points = {{-20, 0}, {32, 0}}, color = {0, 85, 255}, pattern = LinePattern.Dash, thickness = 0.5, arrow = {Arrow.None, Arrow.Open})}),
    __OpenModelica_commandLineOptions = "");
       
end WetHeatExchanger;
