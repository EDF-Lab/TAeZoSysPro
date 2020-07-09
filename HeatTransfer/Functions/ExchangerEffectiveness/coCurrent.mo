within TAeZoSysPro.HeatTransfer.Functions.ExchangerEffectiveness;

function coCurrent

  extends baseFunc;

algorithm

  Eff := (1.0 - exp(-NTU * (1.0 + Cr))) / (1.0 + Cr );

  annotation (
    inverse(NTU = TAeZoSysPro.HeatTransfer.Functions.ExchangerEffectiveness.Inverse.NTU_coCurrent(Eff = Eff, Cr = Cr)),
    Documentation(info = 
"<html>
  <head>
    <title>coCurrent</title>
  </head>
        
  <body lang=\"en-UK\">
    <p>
      This functions computes the exchanger effectiveness of for co current flows.
    </p>   
    
    <img
      src = \"modelica://TAeZoSysPro/Information/HeatTransfer/Functions/ExchangerEffectiveness/EQ_coCurrent.png\"
    />
                
  </body>
</html>"));

end coCurrent;
