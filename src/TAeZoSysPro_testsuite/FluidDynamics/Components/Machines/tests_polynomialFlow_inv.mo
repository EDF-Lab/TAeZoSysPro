within TAeZoSysPro_testsuite.FluidDynamics.Components.Machines;

model tests_polynomialFlow_inv
  Modelica.SIunits.VolumeFlowRate V_flow_nominal[10] "Volume flow rate for N operating points (single pump)";
  Modelica.SIunits.Position head_nominal[10] "Pump head for N operating points";
  Modelica.SIunits.VolumeFlowRate V_flow ;
  Modelica.SIunits.VolumeFlowRate V_flow_2nd_order ;   
  Modelica.SIunits.Position head ; 

equation

  V_flow_nominal = linspace(0.1, 0.9, 10);
  head_nominal = {-20*V_flow_nominal[i]^2 + 20 for i in 1:10} .* {1.05, 0.95, 1.05 , 0.95, 1.05, 0.95, 1.05, 0.95, 1.05, 0.95};
  head = 13.368 ;
  V_flow = TAeZoSysPro.FluidDynamics.Components.Machines.BaseClasses.PumpCharacteristics.polynomialFlow_inv(
    head = head,
    V_flow_nominal = V_flow_nominal,
    head_nominal = head_nominal) ;

  V_flow_2nd_order = TAeZoSysPro.FluidDynamics.Components.Machines.BaseClasses.PumpCharacteristics.polynomialFlow_inv(
    OrderPolyFitting = 2,
    head = head,
    V_flow_nominal = V_flow_nominal,
    head_nominal = head_nominal) ;

    
  annotation(
    experiment(StartTime = 0, StopTime = 10, Tolerance = 1e-06, Interval = 0.1));

end tests_polynomialFlow_inv;
