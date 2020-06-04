within TAeZoSysPro.HeatTransfer.Functions.ExchangerHeatTransferCoeff;

function user_defined
  extends baseFun ;
  input Modelica.SIunits.CoefficientOfHeatTransfer h_in = 1 ;
  
algorithm

  h := h_in ;

end user_defined;
