within TAeZoSysPro.HeatTransfer.Functions.ExchangerEffectiveness.Tests;

model test_coCurrent

  parameter Real NTU = 10 "Number of transfer unit" ;
  Real Cr "Ratio of thermal condutance" ;
  Modelica.SIunits.Efficiency Eff "Exchanger effectiveness" ;
  Modelica.Blocks.Sources.Ramp ramp1(duration = 1, height = 1)  annotation(
    Placement(visible = true, transformation(origin = {-10, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  Cr = ramp1.y ;
  Eff = TAeZoSysPro.HeatTransfer.Functions.ExchangerEffectiveness.coCurrent(NTU = NTU, Cr = Cr) ;

annotation(
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-6, Interval = 0.01));

end test_coCurrent;
