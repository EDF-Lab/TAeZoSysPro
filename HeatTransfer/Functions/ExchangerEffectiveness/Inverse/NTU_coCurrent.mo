within TAeZoSysPro.HeatTransfer.Functions.ExchangerEffectiveness.Inverse;

function NTU_coCurrent

  extends Modelica.Icons.Function;

  input Modelica.SIunits.Efficiency Eff "Exchanger effectiveness";
  input Real Cr "Ratio of thermal condutance";
  output Real NTU "Number of transfer unit";

algorithm

  NTU := -log(1.0-Eff*(1+Cr))/(1+Cr);

  annotation (
    inverse(Eff = TAeZoSysPro.HeatTransfer.Functions.ExchangerEffectiveness.counterCurrent(NTU = NTU, Cr = Cr)),
    Documentation(info = "
<html>
  <head>
    <title>NTU_coCurrent</title>
  </head>
        
  <body lang=\"en-UK\">
    <p>
      This functions computes the Number of Transfer Units (NTU) of an exchanger for co current flows.
      The function is mainly used to supply to the solver the inverse function of the effectiveness.
    </p>    
    <img
      src = \"modelica://TAeZoSysPro/Information/HeatTransfer/Functions/ExchangerEffectiveness/inverse/EQ_NTU_coCurrent.png\"
    />
                
  </body>
</html>"));
end NTU_coCurrent;
