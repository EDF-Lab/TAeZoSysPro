within TAeZoSysPro.HeatTransfer.BasesClasses;

partial model PartialHeatExchanger

  //User defined parameters
  parameter Modelica.SIunits.Area A = 1.0 "equivalent exchange surface area" annotation(
  Dialog(group="Geometrical properties"));
  
  // Internal variables
  Real NTU "Number of transfer unit";
  Real Cr "Ratio of thermal condutance";
  Modelica.SIunits.Efficiency Eff "Exchanger effectiveness";
  Modelica.SIunits.ThermalConductance Qc_A(min=0) "Thermal flow rate unit of fluid A";
  Modelica.SIunits.ThermalConductance Qc_B(min=0) "Thermal flow rate unit of fluid B";
  Modelica.SIunits.Temperature TA_in, TA_out, TB_in, TB_out;
  Modelica.SIunits.CoefficientOfHeatTransfer h_global "Heat transfer coeffcient between fluid A and B" ;
  Modelica.SIunits.HeatFlowRate Q_flow "Heat flow exchanged";
  Modelica.SIunits.Energy E "Energy passed throught the component" ;
  
  //Imported modules 

initial equation
  E = 0.0 ;

equation

  Cr = min(Qc_A, Qc_B) / max( max(Qc_A, Qc_B), 1e3*Modelica.Constants.small) ;
  NTU = h_global * A / max( min(Qc_A, Qc_B), 1e3*Modelica.Constants.small ) ;
  Q_flow = Eff * min(Qc_A, Qc_B) * (TA_in - TB_in) ;
  Q_flow + Qc_A * (TA_out - TA_in) = 0 ;
  Qc_A * (TA_out - TA_in) + Qc_B * (TB_out - TB_in) = 0 ;
  
  der(E) = Q_flow ;
  
annotation(
    Icon(coordinateSystem(initialScale = 0.1), graphics = {Polygon(origin = {18, 50}, rotation = 180, fillColor = {213, 0, 0}, fillPattern = FillPattern.Solid, lineThickness = 0.5, points = {{-62, 36}, {-62, 14}, {78, 14}, {78, -16}, {98, -16}, {98, 36}, {-62, 36}}), Polygon(origin = {-18, -50}, fillColor = {255, 0, 0}, fillPattern = FillPattern.Solid, lineThickness = 0.5, points = {{-62, 36}, {-62, 14}, {78, 14}, {78, -18}, {98, -18}, {98, 36}, {-62, 36}}), Rectangle(origin = {-2, 0}, lineColor = {0, 161, 241}, fillColor = {211, 211, 211}, pattern = LinePattern.None, fillPattern = FillPattern.HorizontalCylinder, lineThickness = 0.5, extent = {{-86, 14}, {90, -14}}), Text(origin = {-48, -2}, lineThickness = 0.5, extent = {{-26, 12}, {122, -8}}, textString = "Fluid A", fontSize = 8), Text(origin = {-48, 28}, lineThickness = 0.5, extent = {{-26, 6}, {122, -8}}, textString = "Fluid B", fontSize = 8), Line(origin = {-48.1691, -0.0769465}, points = {{-12, 0}, {12, 0}}, color = {94, 94, 94}, thickness = 0.5, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 5), Line(origin = {45.8309, -0.336488}, points = {{-12, 0}, {12, 0}}, color = {94, 94, 94}, thickness = 0.5, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 5), Line(origin = {69.0506, -52.8561}, rotation = 90, points = {{-12, 0}, {12, 0}}, color = {207, 207, 207}, thickness = 0.5, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 5), Line(origin = {-69.2242, 50.9302}, rotation = 90, points = {{-12, 0}, {12, 0}}, color = {207, 207, 207}, thickness = 0.5, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 5), Line(origin = {-35.4227, 27.3271}, rotation = 180, points = {{-12, 0}, {12, 0}}, color = {207, 207, 207}, thickness = 0.5, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 5), Line(origin = {33.5697, -26.3828}, rotation = 180, points = {{-12, 0}, {12, 0}}, color = {207, 207, 207}, thickness = 0.5, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 5), Line(origin = {-35.3005, -26.0775}, rotation = 180, points = {{-12, 0}, {12, 0}}, color = {207, 207, 207}, thickness = 0.5, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 5), Line(origin = {33.5697, 27.5256}, rotation = 180, points = {{-12, 0}, {12, 0}}, color = {207, 207, 207}, thickness = 0.5, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 5)}),
    Documentation(info = "
<html>
  <head>
    <title>PartialHeatExchanger</title>	
  </head>
	
  <body lang=\"en-UK\">	
    <p>
      This components contains partial equation describing a generic <b>adiabatic</b> heat exchanger using the effetiveness method. 
      The advantage of the effetiveness method regarding the mean logarithmic method is to avoid a non linear equation where oulet temperature are unknown(see explainations in the theoretical note). 
      The system of equations describing an heat exchanger derives:
    </p>
    			
	<img	
      src=\"modelica://TAeZoSysPro/Information/HeatTransfer/BasesClasses/EQ_PartialHeatExchanger.PNG\"
    />
    
    <p>			
      <b>Where:</b>
      <ul>
        <li> <b>Qc</b> is the thermal flow rate unit.<b>m_flow</b> and <b>cp</b> being the mass flow rate and the specific heat capacity 
        <li> <b>Cr</b> is the ration of the thermal flow rate units
        <li> <b>NTU</b> is the number of transfer unit
        <li> <b>h_global</b> is the global heat exchange coeffcient
        <li> <b>A</b> is generally the maximal exchange surface (if exchange surfaces for both fluid are different )
        <li> <b>Eff</b> is the effectiveness of the exchanger
        <li> <b>Q_flow</b> is the exchanged power. It is defined as positive when the fluid A is cooled
        <li> <b>Q_flow_max</b> is the maximal exchangeable power for an infinite exchanger
        <li> <b>T_A</b> is temperature of the fluid A (T_B for fluid B).
      </ul>			
    </p>
		
    <p>
      An heat exchanger is a complex object that can have various configurations such as:
      <ul>
        <li> counter, cross or parallel flow 
        <li> single or multi passes
		<li> etc
      </ul>
    </p>
    
    <p>			
      Therefore, it has been chosen to develop a partial heat exchanger containing the common equations to all kind of exchanger whatever its configuration. 
      For a specific exchanger the user just have to inherit this partial model and give the specific missing equations for:
      <ul>
        <li> The relation between the effectiveness and geometrical and flow configuration: Eff = f(Cr, NTU, ...) 
        <li> The thermal flow rate: Qc_A and Qc_B
        <li> The inlet temperature: T_A_in, T_B_in
        <li> The global heat exchange coefficient: K_global
      </ul>			
    </p>
	
  </body>
</html>"));

end PartialHeatExchanger;
