within TAeZoSysPro.FluidDynamics.Components.Valves;

model CommissioningDamper
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium "Medium in the component" annotation (choicesAllMatching = true);

  // User defined parameters
  parameter Medium.MassFlowRate m_flow_nominal "Nominal mass flow rate" annotation(Dialog(group="Nominal operating point")) ;
  parameter Modelica.SIunits.Pressure dp_nominal "Nominal pressure drop" annotation(Dialog(group="Nominal operating point")) ;    
  parameter Modelica.SIunits.Pressure dp_small = 0.01 * dp_nominal "Regularisation of zero flow" annotation(Dialog(tab="Advanced"));
  parameter Real Kv(fixed = false) "(Metric) flow coefficient";
  parameter Real Fxt=0.5 "F_gamma*xt critical ratio";
    
  // Internal variables
  Modelica.SIunits.Pressure dp(start=dp_nominal) "Pressure difference between port_a and port_b (= port_a.p - port_b.p)" ;
  Medium.MassFlowRate m_flow(start = m_flow_nominal) "Mass flow rate in design flow direction";
  
  // Imported modules
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(extent = {{110, -10}, {90, 10}}, rotation = 0), iconTransformation(extent = {{110, -10}, {90, 10}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(extent = {{-110, -10}, {-90, 10}}, rotation = 0), iconTransformation(extent = {{-110, -10}, {-90, 10}}, rotation = 0)));

protected
  Real xs "Saturated pressure drop ratio";
  Real Y "Compressibility factor";

initial equation

  Kv = if m_flow_nominal >= 0.0 then
        3600 * m_flow_nominal / (31.6 * Y * sqrt(dp*1e-5*Medium.density_phX(
          p = port_a.p, 
          h = inStream(port_a.h_outflow), 
          X = cat(1, inStream(port_a.Xi_outflow), {1 - sum(inStream(port_a.Xi_outflow))})))) 
       else
        3600 * m_flow_nominal / (31.6 * Y * sqrt(dp*1e-5*Medium.density_phX(
          p = port_b.p, 
          h = inStream(port_b.h_outflow), 
          X = cat(1, inStream(port_b.Xi_outflow), {1 - sum(inStream(port_b.Xi_outflow))})))) ; 

equation
  //
  dp = port_a.p - port_b.p ;
  xs = max(-Fxt, min(dp/max(port_a.p, port_b.p), Fxt));
  Y = 1 - abs(xs)/(3*Fxt);
  
  //
  m_flow = homotopy(Kv/3600 * 31.6 * Y * sqrt(1e-5) * Modelica.Fluid.Utilities.regRoot2(
    x = dp,
    x_small = dp_small,
    k1 = Medium.density_phX(
          p = port_a.p, 
          h = inStream(port_a.h_outflow), 
          X = cat(1, inStream(port_a.Xi_outflow), {1 - sum(inStream(port_a.Xi_outflow))})) ,
    k2 = Medium.density_phX(
          p = port_b.p, 
          h = inStream(port_b.h_outflow), 
          X = cat(1, inStream(port_b.Xi_outflow), {1 - sum(inStream(port_b.Xi_outflow))}))),
    
    m_flow_nominal*dp/dp_nominal );

  // Port handover
  port_a.m_flow = m_flow ;
  port_a.m_flow + port_b.m_flow = 0.0 ;

  port_a.h_outflow = inStream(port_b.h_outflow);
  port_b.h_outflow = inStream(port_a.h_outflow);    
  
  port_a.Xi_outflow = inStream(port_b.Xi_outflow);
  port_b.Xi_outflow = inStream(port_a.Xi_outflow);

  port_a.C_outflow = inStream(port_b.C_outflow);
  port_b.C_outflow = inStream(port_a.C_outflow);

annotation(
    Icon(graphics = {Rectangle(extent = {{-80, 80}, {80, -80}}), Bitmap(extent = {{-60, 60}, {60, -60}}, fileName = "modelica://TAeZoSysPro/FluidDynamics/Components/Valves/setting.png")}),
    Diagram);

end CommissioningDamper;
