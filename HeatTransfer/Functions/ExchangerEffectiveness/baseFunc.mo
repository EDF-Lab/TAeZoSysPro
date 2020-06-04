within TAeZoSysPro.HeatTransfer.Functions.ExchangerEffectiveness;

function baseFunc

  extends Modelica.Icons.Function ;
  //
  input Real NTU "Number of transfer unit" ;
  input Real Cr "Ratio of thermal condutance" ;
  output Modelica.SIunits.Efficiency Eff "Exchanger effectiveness" ;

end baseFunc;
