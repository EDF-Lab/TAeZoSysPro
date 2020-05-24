within TAeZoSysPro.HeatTransfer.Functions;

function hrad_Linearize
  extends Modelica.Icons.Function;
  
  input Real Tporta;
  //temperature port a --> temperature from the wall;
  input Real Tportb;
  //temperature port b --> temperature from the air;
  input Real sigma;
  //stephan boltzmann constant
  input Real Fview;
  //Carroll  node view factor
  input Real emissivity;
  //surface emissivity
  output Real hrad;
  //linearize coefficient
  
algorithm

  hrad := abs(4 * ((Tporta + Tportb) / 2) ^ 3 * sigma * ((1 - emissivity) / emissivity + Fview ^ (-1)));


end hrad_Linearize;