within TAeZoSysPro.FluidDynamics.Components.Machines.Tests;

model test_polynomialFlow
  Modelica.SIunits.VolumeFlowRate V_flow_nominal[10] "Volume flow rate for N operating points (single pump)";
  Modelica.SIunits.Position head_nominal[10] "Pump head for N operating points";
  Modelica.SIunits.VolumeFlowRate V_flow;
  Modelica.SIunits.VolumeFlowRate V_flow2;  
  Modelica.SIunits.Position head ;
  Modelica.SIunits.Position head_analytic ;  
  Modelica.Blocks.Sources.Ramp ramp(duration = 10, height = 1.4, offset = -0.2) annotation(
    Placement(visible = true, transformation(origin = {1, -1}, extent = {{-21, -21}, {21, 21}}, rotation = 0)));
equation

  V_flow = ramp.y;
  V_flow2 = V_flow ; 
  V_flow_nominal = linspace(0.1, 0.9, 10);
  head_analytic = -20*V_flow^2 + 20 ;
  head_nominal = {-20*V_flow_nominal[i]^2 + 20 for i in 1:10} .* {1.1, 0.9, 1.1 , 0.9, 1.1, 0.9, 1.1, 0.9, 1.1, 0.9};
  head = TAeZoSysPro.FluidDynamics.Components.Machines.BaseClasses.PumpCharacteristics.polynomialFlow(
    V_flow = V_flow,
    V_flow_nominal = V_flow_nominal,
    head_nominal = head_nominal) ;

    
  annotation(
    experiment(StartTime = 0, StopTime = 10, Tolerance = 1e-06, Interval = 0.1));

end test_polynomialFlow;
