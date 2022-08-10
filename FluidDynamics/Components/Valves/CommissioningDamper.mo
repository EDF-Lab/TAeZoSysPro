within TAeZoSysPro.FluidDynamics.Components.Valves;

model CommissioningDamper
  replaceable package Medium = TAeZoSysPro.Media.MyMedia "Medium in the component";

  // User defined parameters

  parameter Medium.MassFlowRate m_flow_nominal "Nominal mass flow rate targeted" annotation(Dialog(group="Nominal operating point")) ;
  parameter Modelica.SIunits.Pressure dp_ref=1e5 "Reference pressure drop (Standard states 1e5 Pa )" annotation(Dialog(group="Nominal operating point")) ; 
  parameter Modelica.SIunits.Temperature T_ref=293.15 "reference temperature used for computed Kv"annotation(Dialog(group="Nominal operating point"));
  parameter Modelica.SIunits.Density rho_ref=Medium.density_pTX(Medium.p_default, T_ref, Medium.X_default) annotation(Dialog(group="Nominal operating point"));   
  parameter Modelica.SIunits.Pressure dp_small = 1 "Regularisation of zero flow" annotation(Dialog(tab="Advanced"));
  parameter Real Kv(fixed = false) "(Metric) flow coefficient";
  parameter Real Fxt=0.5 "F_gamma*xt critical ratio";
    
  // Internal variables
  Modelica.SIunits.Pressure dp(start=100) "Pressure difference between port_a and port_b (= port_a.p - port_b.p)" ;
  Medium.MassFlowRate m_flow(start = m_flow_nominal) "Mass flow rate in design flow direction";
  
  // Imported modules
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(extent = {{110, -10}, {90, 10}}, rotation = 0), iconTransformation(extent = {{110, -10}, {90, 10}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(extent = {{-110, -10}, {-90, 10}}, rotation = 0), iconTransformation(extent = {{-110, -10}, {-90, 10}}, rotation = 0)));

protected
  Real xs "Saturated pressure drop ratio";
  Real Y "Compressibility factor";

/* initial equation block comment :
  + was initially intented to help homotopy function inversion 
  + lead to error since version 1.18 of OpenModelica
  
*/
//initial equation

//  Kv = if m_flow_nominal >= 0.0 then
//        3600 * m_flow_nominal / (31.6 * Y * sqrt(dp*1e-5*Medium.density_phX(
//          p = port_a.p, 
//          h = inStream(port_a.h_outflow), 
//          X = cat(1, inStream(port_a.Xi_outflow), {1 - sum(inStream(port_a.Xi_outflow))})))) 
//       else
//        3600 * m_flow_nominal / (31.6 * Y * sqrt(dp*1e-5*Medium.density_phX(
//          p = port_b.p, 
//          h = inStream(port_b.h_outflow), 
//          X = cat(1, inStream(port_b.Xi_outflow), {1 - sum(inStream(port_b.Xi_outflow))})))) ; 

equation
  //
  dp = port_a.p - port_b.p ;
  xs = max(-Fxt, min(dp/max(port_a.p, port_b.p), Fxt));
  Y = 1 - abs(xs)/(3*Fxt);
  
  // multiply volumetric flow by rho and integrate it in ssqrt to avoid two call to Medium.Density
  m_flow = homotopy(Kv/3600.0 * sqrt(rho_ref) * Y * sqrt(1.0/dp_ref) * Modelica.Fluid.Utilities.regRoot2(
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
    
    Kv/3600*dp/dp_ref );

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
    Documentation(info=
"<html><head>
    <title>CommissioningDamper</title>
  </head>
  
  <body>
    <p>
      This components computes the (Metric) flow coefficient <b>Kv</b> that insures the mass flow rate <b> m_flow_nominal </b> through the damper at the initialisation if m_flow(fixed=true) enabled.</p>
    
    <p>
      The flow coefficient Kv derives from the ISA-75.01.01-2007 standard for a compressible valve sizing (see <a href=\"modelica://TAeZoSysPro.FluidDynamics.Components.Valves.BaseClasses.PartialDamper\">PartialDamper</a>). 
    </p><p>dp_ref is used to compute Kv. To be consistent with standard, it should be kept to 1e5 Pa but could be modified by user to have more meaningfull Kv for HVAC application (order of magnitude of pressure drop across damper is 100 Pa)&nbsp;</p><p>Reference temperature is used to compute reference density (for water 1000 kg/m3 reference density is used). atmospheric pressure is used to compute reference density (medium default pressure)</p>   
    
    <p>Pressure drop across the damper is generally computed at initialization and derived from boundary condition;&nbsp;</p>
    
    <ul>
      <li> To avoid numerical singularities, the flow characteristic is modified for pressure drops less than <code>dp_small</code>. 
           The default value is 1 Pa but should be adjusted if required</li></ul>
    <p></p>  
  
</body></html>"),
    Icon(graphics = {Rectangle(extent = {{-80, 80}, {80, -80}}), Bitmap(extent = {{-60, 60}, {60, -60}}, fileName = "modelica://TAeZoSysPro/FluidDynamics/Components/Valves/setting.png")}),
    Diagram);

end CommissioningDamper;