within TAeZoSysPro.HeatTransfer.BasesClasses;

model CarrollRadiation "<html> KURY_SOFINEL_2016<p>
                                                  
                                                Radiative Heat Transfer to J MRT. <p> The block represents an energy transfer by radiation between two surfaces.<p> The transfer is governed by the Stefan-Boltzmann law and is directly proportional to the area,<p> the radiation coefficient, and the difference of the forth powers of body temperatures.<p> The radiation coefficient depends on the configuration properties and emissivity of
                                                interacting bodies.<p> The resistance is equal to (1 - emissivity) / (emissity * area)"
  extends Modelica.Thermal.HeatTransfer.Interfaces.Element1D;
  // Customs parameters are declared
  parameter Real add_on(unit = "R+") = 1 "Custom add-on";
  parameter Modelica.SIunits.Area A = 0 "Area ";
  parameter Modelica.SIunits.Emissivity emissivity = 1 "Total emissivity ";
  constant Real sigma = Modelica.Constants.sigma "Stefan-Boltzmann constant";
  // Variables are declared
  Modelica.SIunits.Energy E;
  // Energy
  Modelica.SIunits.CoefficientOfHeatTransfer hrad "radiation linearization coefficient";
  // Input are declared
  Modelica.Blocks.Interfaces.RealInput Fview annotation(
    Placement(visible = true, transformation(origin = {-93, 88}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-80, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
equation
//  hrad = if port_a.T <> port_b.T then ((port_a.T)^4- (port_b.T)^4)/((port_a.T)- (port_b.T))*sigma*((1- emissivity ) / (emissivity)  + (Fview)^(-1)) else 0;
//  hrad = 4*(273.15+20)^3*sigma*((1- emissivity ) / (emissivity)  + (Fview)^(-1)) ;
//  hrad = 4 * ((port_a.T + port_b.T) / 2) ^ 3 * sigma * ((1 - emissivity) / emissivity + Fview ^ (-1));
  hrad = TAeZoSysPro.HeatTransfer.Functions.hrad_Linearize(Tporta=port_a.T,Tportb=port_b.T,emissivity=emissivity,sigma=sigma,Fview=Fview);
//  Q_flow = add_on * sigma * (port_a.T ^ 4 - port_b.T ^ 4) / ((1 - emissivity) / (A * emissivity) + (A * Fview) ^ (-1));
  Q_flow = hrad*A*((port_a.T)- (port_b.T));
//Heat flow through ports are calculated
  der(E) = Q_flow;
// Energy is calculated
  annotation(
    uses(Modelica(version = "3.2.2")),
    Icon(graphics = {Text(origin = {68, -93}, extent = {{-28, 5}, {28, -5}}, textString = "KURY - EDVANCE"), Rectangle(origin = {0, 70}, fillColor = {106, 105, 108}, fillPattern = FillPattern.Cross, extent = {{-40, 10}, {40, -10}}), Rectangle(origin = {-70, 0}, fillColor = {106, 105, 108}, fillPattern = FillPattern.Cross, extent = {{-10, 40}, {10, -40}}), Rectangle(origin = {0, -70}, fillColor = {106, 105, 108}, fillPattern = FillPattern.Cross, extent = {{-40, -10}, {40, 10}}), Rectangle(origin = {70, 0}, fillColor = {106, 105, 108}, fillPattern = FillPattern.Cross, extent = {{-10, 40}, {10, -40}}), Rectangle(origin = {-59, 0}, fillColor = {255, 0, 0}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{1, -40}, {-1, 40}}), Rectangle(origin = {59, 0}, fillColor = {255, 0, 0}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{1, -40}, {-1, 40}}), Rectangle(origin = {0, 59}, fillColor = {255, 0, 0}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-40, 1}, {40, -1}}), Rectangle(origin = {0, -59}, fillColor = {255, 0, 0}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-40, 1}, {40, -1}}), Ellipse(fillPattern = FillPattern.Solid, extent = {{-6, -6}, {6, 6}}, endAngle = 360), Line(origin = {0, -31}, points = {{0, 23}, {0, -27}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.Filled, Arrow.Filled}), Line(origin = {-31, 0}, points = {{23, 0}, {-27, 0}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.Filled, Arrow.Filled}), Line(origin = {33, 0}, points = {{27, 0}, {-25, 0}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.Filled, Arrow.Filled}), Text(origin = {91, 35}, rotation = 90, extent = {{-9, -11}, {9, 11}}, textString = "JMRT"), Line(origin = {-30, 21}, points = {{-28, 19}, {24, -15}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.Filled, Arrow.Filled}), Line(origin = {-30, -20}, points = {{-28, -18}, {24, 14}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.Filled, Arrow.Filled}), Line(origin = {-21, 30}, points = {{-19, 28}, {15, -24}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.Filled, Arrow.Filled}), Line(origin = {23, 32}, points = {{19, 28}, {-17, -26}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.Filled, Arrow.Filled}), Line(origin = {31, 22}, points = {{27, 18}, {-25, -16}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.Filled, Arrow.Filled}), Line(origin = {0, 31}, points = {{0, 27}, {0, -23}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.Filled, Arrow.Filled}), Line(origin = {30, -21}, points = {{28, -19}, {-24, 15}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.Filled, Arrow.Filled}), Line(origin = {22, -31}, points = {{18, -27}, {-16, 25}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.Filled, Arrow.Filled}), Line(origin = {-23, -32}, points = {{-19, -28}, {17, 26}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.Filled, Arrow.Filled}), Text(origin = {-91, 29}, rotation = -90, extent = {{-9, -11}, {9, 11}}, textString = "Wall")}, coordinateSystem(initialScale = 0.1)));
end CarrollRadiation;
