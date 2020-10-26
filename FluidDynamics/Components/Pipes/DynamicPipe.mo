within TAeZoSysPro.FluidDynamics.Components.Pipes;

model DynamicPipe
  // Imports
    import TAeZoSysPro.HeatTransfer.Types.Dynamics ;

  // Medium
  replaceable package Medium = TAeZoSysPro.Media.MyMedia ;
  
  // User defined parameters
  parameter Modelica.SIunits.Area A "Inner cross section area" annotation(
    Dialog(group = "Geometry"));
  parameter Modelica.SIunits.Length L "Pipe length" annotation(
    Dialog(group = "Geometry"));
  parameter Integer N = 3 "Number of discrete layers" ;  
  parameter Real ksi = 1 "dynamic pressure loss" annotation(
    Dialog(group = "Flow"));
  parameter Dynamics energyDynamics = Dynamics.SteadyStateInitial "Formulation of energy balance";
  parameter Modelica.SIunits.Temperature T_start = 293.15 "Start value for temperature, if energyDynamics = FixedInitial";
  parameter Dynamics massDynamics = Dynamics.SteadyStateInitial "Formulation of mass balance";
  
  // Internal variables
  Modelica.SIunits.Density d_a "Density if flow positive at port_a" ;
  Modelica.SIunits.Density d_b "Density if flow positive at port_b" ;
  Modelica.SIunits.PressureDifference dp;
  Modelica.SIunits.Velocity Vel;
  Modelica.SIunits.MassFlowRate m_flow "Aperture flow kg/s";
  
  // Imported Modules
  Modelica.Fluid.Interfaces.FluidPort_a port_a(replaceable package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-100, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(replaceable package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  TAeZoSysPro.PDE.Transport.UpwindFirstOrder transport[2](
    each N=N,
    each CoeffSpaceDer=Vel,
    each x = linspace(0.0, L, N+1),
    each SourceTerm = fill(0.0, N),
    N_quantity = {1,Medium.nXi}) annotation(
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

initial equation

  if energyDynamics == Dynamics.SteadyStateInitial then
    der(transport[1].u[2:N,1])= fill(0.0, N-1);
    
  elseif energyDynamics == Dynamics.FixedInitial then
    for i in 2:N loop
      transport[1].u[i,1]= Medium.specificEnthalpy_pTX(
        p = -dp / N * (i-1) + port_a.p,
        T = T_start,
        X = actualStream(port_a.Xi_outflow) );  
    end for;
    
  elseif energyDynamics == Dynamics.SteadyState then
    assert(false, "SteadyState pipe is not model, use rather static pipe module", level = AssertionLevel.error);
  
  end if ;
  
  if massDynamics == Dynamics.SteadyStateInitial then
    for index in 1:Medium.nX loop
      der(transport[2].u[2:N,index])= fill(0.0, N-1);
    end for;

  elseif massDynamics == Dynamics.FixedInitial then
    assert(false, "Fixed initial condition for mass is not modelled, use rather steady state initialisation", level = AssertionLevel.error);
    
  elseif massDynamics == Dynamics.SteadyState then
    assert(false, "SteadyState pipe is not modelled, use rather static pipe module", level = AssertionLevel.error);
  
  end if ;

equation

// mass balance
  d_a = Medium.density_phX(p = port_a.p, 
                           h = inStream(port_a.h_outflow), 
                           X = cat(1, inStream(port_a.Xi_outflow), {1 - sum(inStream(port_a.Xi_outflow))})) ;
  d_b = Medium.density_phX(p = port_b.p, 
                           h = inStream(port_b.h_outflow), 
                           X = cat(1, inStream(port_b.Xi_outflow), {1 - sum(inStream(port_b.Xi_outflow))})) ;

// momentum
  dp = port_a.p - port_b.p;
  Vel =Modelica.Fluid.Utilities.regRoot2(x = dp,
                                         x_small = 0.1,
                                         k1 = 2.0 / (ksi*d_a),
                                         k2 = 2.0 / (ksi*d_b)) ;
  Vel * d_a * A = m_flow ;
                                                     
// Transports of enthalpy
  // boundary equations
  if Vel>=0.0 then
    transport[1].u[1,1] = inStream(port_a.h_outflow);
    transport[1].u[N+1,1] = transport[1].u[N,1] ;  
  else
    transport[1].u[N+1,1] = inStream(port_b.h_outflow);    
    transport[1].u[1,1] = transport[1].u[2,1] ;
  end if;
  
// Transports of mass
  // boundary equations
  if Vel>=0.0 then
    transport[2].u[1,1:1] = inStream(port_a.Xi_outflow);
    transport[2].u[N+1,1:1] = transport[2].u[N,1:1] ;  
  else
    transport[2].u[N+1,1:1] = inStream(port_b.Xi_outflow);    
    transport[2].u[1,1:1] = transport[2].u[2,1:1] ;
  end if;

// Ports handover
  port_a.m_flow = m_flow;
  port_a.m_flow + port_b.m_flow = 0.0;
  port_a.h_outflow = transport[1].u[1,1];  
  port_b.h_outflow = transport[1].u[N+1,1];
  port_a.Xi_outflow = transport[2].u[1,1:1];
  port_b.Xi_outflow = transport[2].u[N+1,1:1];
  
  annotation (defaultComponentName="dynamicPipe",
Documentation(info ="
<html>
  <head>
    <title>StaticPipe</title>
  </head>
	
  <body lang=\"en-UK\">
    <p>
      This components allows to model the mass flow rate through a pipe from a pressure difference at boundaries and the pressure loss coefficient <b>ksi</b>.
      The flow regime is steady state. 
    </p>
    
    <p>
      ksi expresses how many dynamic pressure is lost. 
      It is assumed to be constant and therefore independent of the flow regime.
    </p>    
    			
    <img	
      src=\"modelica://TAeZoSysPro/Information/FluidDynamics/Components/Pipes/EQ_StaticPipe_ksi.PNG\"
    />

    <p>
      The mass flow rate relation derives:
    </p>

    <img	
      src=\"modelica://TAeZoSysPro/Information/FluidDynamics/Components/Pipes/EQ_StaticPipe_m_flow.PNG\"
    />
 		
    <p>	
      <b>Where</b>:
      <ul>
        <li> <code>dp</code> is the pressure difference between port_a.p and port_b.p </li>
        <li> <code>ksi</code> is the pressure loss coefficient </li>
        <li> <code>d</code> is the upstream density </li>
        <li> <code>Vel</code> is fluid velocity </li>              
        <li> <code>m_flow</code> is the mass flow rate through the pipe </li>
        <li> <code>A</code> is cross section of the pipe </li>
      </ul>				
    </p>

    <p>
      To avoid infinite derivative at dp=0, The square root is replaced by the function <b>regRoot2</b> of the MSL that replace the square root by a polynomial expression to insure a finite derivative. The threshold to switch between the polynom and the square root is <b> abs(dp≤0.1) Pa </b>
    </p>			
  </body>
</html>"),
Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}}), graphics={Rectangle(fillColor = {95, 95, 95}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-100, 40}, {100, -40}}), Rectangle(fillColor = {0, 127, 255}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-100, 44}, {100, -44}}), Line(origin = {-40, 12}, points = {{0, 30}, {0, -54}}, color = {150, 150, 150}, thickness = 2), Line(origin = {40, 12}, points = {{0, 30}, {0, -54}}, color = {150, 150, 150}, thickness = 2), Text(origin = {-70, 0}, lineColor = {255, 255, 255}, extent = {{-20, 40}, {20, -40}}, textString = "1"), Text(origin = {70, 0}, lineColor = {255, 255, 255}, extent = {{-20, 40}, {20, -40}}, textString = "N"), Text(lineColor = {255, 255, 255}, extent = {{-20, 40}, {20, -40}}, textString = "...")}));

end DynamicPipe;
