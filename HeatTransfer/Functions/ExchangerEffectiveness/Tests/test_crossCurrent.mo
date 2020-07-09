within TAeZoSysPro.HeatTransfer.Functions.ExchangerEffectiveness.Tests;

model test_crossCurrent

  parameter Real NTU = 10 "Number of transfer unit" ;
  Real Cr "Ratio of thermal condutance" ;
  Modelica.SIunits.Efficiency Eff_both_mixed, Eff_fluidA_mixed, Eff_fluidB_mixed  "Exchanger effectiveness" ;
  Modelica.Blocks.Sources.Ramp ramp1(duration = 1, height = 1)  annotation(
    Placement(visible = true, transformation(origin = {-10, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Real Qc_A, Qc_B ;

equation

  Cr = ramp1.y ;
  Qc_A = ramp1.y ;
  Qc_B = 0.5 ;
  Eff_both_mixed = TAeZoSysPro.HeatTransfer.Functions.ExchangerEffectiveness.crossCurrent(
    arrangement = TAeZoSysPro.HeatTransfer.Types.CrossFlow_arrangement.both_unmixed,
    NTU = NTU, 
    Cr = Cr,
    Qc_A = Qc_A,
    Qc_B = Qc_B) ;

  Eff_fluidA_mixed = TAeZoSysPro.HeatTransfer.Functions.ExchangerEffectiveness.crossCurrent(
    arrangement = TAeZoSysPro.HeatTransfer.Types.CrossFlow_arrangement.fluidA_mixed_fluidB_unmixed,
    NTU = NTU, 
    Cr = Cr,
    Qc_A = Qc_A,
    Qc_B = Qc_B) ;

  Eff_fluidB_mixed = TAeZoSysPro.HeatTransfer.Functions.ExchangerEffectiveness.crossCurrent(
    arrangement = TAeZoSysPro.HeatTransfer.Types.CrossFlow_arrangement.fluidB_mixed_fluidA_unmixed,
    NTU = NTU, 
    Cr = Cr,
    Qc_A = Qc_A,
    Qc_B = Qc_B) ;

annotation(
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-6, Interval = 0.01));

end test_crossCurrent;
