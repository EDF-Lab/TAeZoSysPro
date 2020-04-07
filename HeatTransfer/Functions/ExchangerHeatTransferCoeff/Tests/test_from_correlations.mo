within TAeZoSysPro.HeatTransfer.Functions.ExchangerHeatTransferCoeff.Tests;

model test_from_correlations

  parameter Modelica.SIunits.ReynoldsNumber Re_A = 1e5 "Reynolds number for flow A" ;
  parameter Modelica.SIunits.PrandtlNumber Pr_A = 7 "Prandtl number for fluid A" ;
  parameter Modelica.SIunits.Length Lc_A = 0.2 "Charactereistic length for flow A" ;
  parameter Modelica.SIunits.ThermalConductivity k_A = 0.06 "Thermal conductivity for fluid A" ;
  parameter Modelica.SIunits.ReynoldsNumber Re_B = 1e6 "Reynolds number for flow A" ;
  parameter Modelica.SIunits.PrandtlNumber Pr_B = 1 "Prandtl number for fluid A" ;
  parameter Modelica.SIunits.Length Lc_B = 1 "Charactereistic length for flow A" ;
  parameter Modelica.SIunits.ThermalConductivity k_B = 0.03 "Thermal conductivity for fluid A" ;
  Modelica.SIunits.CoefficientOfHeatTransfer h, h_A, h_B "Heat transfer Coefficient" ;

equation

  h = TAeZoSysPro.HeatTransfer.Functions.ExchangerHeatTransferCoeff.from_correlations(
    Re_A = Re_A,
    Pr_A = Pr_A,
    Lc_A = Lc_A,
    k_A = k_A,
    Re_B = Re_B,
    Pr_B = Pr_B,
    Lc_B = Lc_B,
    k_B = k_B);
    
  h_A = TAeZoSysPro.HeatTransfer.Functions.ForcedConvection.internal_pipe_ASHRAE(Re = Re_A, Pr = Pr_A, dT = 0.0) * k_A / Lc_A ;
  
  h_B = TAeZoSysPro.HeatTransfer.Functions.ForcedConvection.flat_plate_ASHRAE(Re = Re_B, Pr=Pr_B)* k_B / Lc_B  ;

end test_from_correlations;
