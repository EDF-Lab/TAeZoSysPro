within TAeZoSysPro.HeatTransfer.Functions.ExchangerHeatTransferCoeff;

function from_correlations

  extends baseFun ;
  input Modelica.SIunits.ReynoldsNumber Re_A "Reynolds number for flow A" ;
  input Modelica.SIunits.PrandtlNumber Pr_A "Prandtl number for fluid A" ;
  input Modelica.SIunits.Length Lc_A "Charactereistic length for flow A" ;
  input Modelica.SIunits.ThermalConductivity k_A "Thermal conductivity for fluid A" ;
  input Modelica.SIunits.ReynoldsNumber Re_B "Reynolds number for flow A" ;
  input Modelica.SIunits.PrandtlNumber Pr_B "Prandtl number for fluid A" ;
  input Modelica.SIunits.Length Lc_B "Charactereistic length for flow A" ;
  input Modelica.SIunits.ThermalConductivity k_B "Thermal conductivity for fluid A" ;

protected 
  Modelica.SIunits.NusseltNumber Nu_A ;
  Modelica.SIunits.NusseltNumber Nu_B ;

algorithm

  Nu_A := TAeZoSysPro.HeatTransfer.Functions.ForcedConvection.internal_pipe_ASHRAE(Re = Re_A, Pr = Pr_A, dT = 0.0) ;
  Nu_B := TAeZoSysPro.HeatTransfer.Functions.ForcedConvection.flat_plate_ASHRAE(Re = Re_B, Pr=Pr_B) ;

  h := ( Lc_A/(Nu_A*k_A) + Lc_B/(Nu_B*k_B) )^(-1) ; 

end from_correlations;
