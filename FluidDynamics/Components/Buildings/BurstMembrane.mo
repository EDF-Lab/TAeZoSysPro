within TAeZoSysPro.FluidDynamics.Components.Buildings;

model BurstMembrane
   replaceable package Medium = TAeZoSysPro.Media.MyMedia "Medium in the component" annotation (choicesAllMatching = true);

   // User defined parameters
   parameter Modelica.SIunits.PressureDifference dp_burst = 7000 "Pressure difference to which the disk burst";

   // Internal variables
   Boolean bursted "Bursted membrane" ;
   Modelica.SIunits.PressureDifference dp ;
   Medium.MassFlowRate m_flow ;

   // Imported modules
   Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium = Medium) annotation(
     Placement(visible = true, transformation(extent = {{-110, -10}, {-90, 10}}, rotation = 0), iconTransformation(extent = {{-110, -10}, {-90, 10}}, rotation = 0)));
   Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium = Medium) annotation(
     Placement(visible = true, transformation(extent = {{110, -10}, {90, 10}}, rotation = 0), iconTransformation(extent = {{110, -10}, {90, 10}}, rotation = 0)));

initial equation
   bursted = false ;

equation

   dp = port_a.p - port_b.p ;

   if pre(bursted) then
     dp = 0.0;
   else
     m_flow = 0.0 ;
   end if ;

   when dp >= dp_burst then
     bursted = true ;
   end when ;

// Port handover
   // Mass balance (no storage)
   port_a.m_flow = m_flow ;
   port_a.m_flow + port_b.m_flow = 0;

   // Transport of substances
   port_a.Xi_outflow = inStream(port_b.Xi_outflow);
   port_b.Xi_outflow = inStream(port_a.Xi_outflow);

   port_a.C_outflow = inStream(port_b.C_outflow);
   port_b.C_outflow = inStream(port_a.C_outflow);

   // Isenthalpic state transformation (no storage and no loss of energy)
   port_a.h_outflow = inStream(port_b.h_outflow);
   port_b.h_outflow = inStream(port_a.h_outflow);

   annotation(
     Icon(graphics = {Rectangle(extent = {{-80, 80}, {80, -80}}), Line(origin = {9.84, 0}, points = {{-9.84189, 60}, {10.1581, 0}, {-9.84189, -60}}, thickness = 0.5, smooth = Smooth.Bezier), Line(origin = {0, 70}, points = {{0, 10}, {0, -10}}, thickness = 1), Line(origin = {0.0458716, -69.9541}, points = {{0, 10}, {0, -10}}, thickness = 1), Line(origin = {30, 50}, points = {{-30, 10}, {30, -10}}, pattern = LinePattern.Dot), Line(origin = {30, -40}, points = {{-30, -20}, {30, 0}}, pattern = LinePattern.Dot)}, coordinateSystem(initialScale = 0.1)),
     Description(info=
"<html>
  <head>
    <title>BurstMembrane</title>	
  </head>
	
  <body lang=\"en-UK\">
    <p>
      The module model a perfect one dimentional burst membrane. 
      Perfect means no pressure loss when opened and no flow when close. One dimensional since the membrane can bursted only when the boundary pressure difference <b>dp</b> &ge; <b>dp_burst</b>. 
      A negative pressure difference having an absolute value above the threshold <b>dp_burst</b> would not make the menbrane bursted.  
    </p>
    
    <p>
      The membrane is assumed non bursted at the initialisation. When it becomes burst, it is non reversible. 
    </p>
    
    <p>
      In this model of leaks, there is only one equation to model the behavior of the flow resistance. It is rather quadratic to the velocity for an equipment hole and linear to the velocity for the porosities.
    </p>
    
    <p>
      Therefore, in the module, the relation of the of the pressure loss is function of the kinetic energy exponent <b>leakExponent</b>.
    </p>
    
    <img	
      src=\"modelica://TAeZoSysPro/Information/FluidDynamics/Components/Buildings/EQ_WallLeak.PNG\"
    />

    <p>      
      The leak surface area is defined as a fraction of the wall surface equal to <b>leakSurfaceRatio</b>.   
    </p>
    
    <img	
      src=\"modelica://TAeZoSysPro/Information/FluidDynamics/Components/Buildings/EQ_WallLeak2.PNG\"
    />
    				
  </body>
</html>"));

end BurstMembrane;
