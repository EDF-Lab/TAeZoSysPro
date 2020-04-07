within TAeZoSysPro.HeatTransfer.Functions.ExchangerHeatTransferCoeff;

function user_defined
  input Modelica.SIunits.CoefficientOfHeatTransfer h_in = 1 ;
  output Modelica.SIunits.CoefficientOfHeatTransfer h_out ;
algorithm

  h_out := h_in ;

end user_defined;
