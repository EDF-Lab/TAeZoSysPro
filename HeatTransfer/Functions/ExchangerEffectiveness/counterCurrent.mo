within TAeZoSysPro.HeatTransfer.Functions.ExchangerEffectiveness;
function counterCurrent

  extends baseFunc;

algorithm

  Eff := Modelica.Fluid.Utilities.regStep(
    x = 0.98 - Cr,
    x_small = 1.0e-2,
    y1 = (1.0 - exp(-NTU * (1.0 - Cr))) / (1.0 - Cr * exp(-NTU * (1.0 - Cr))),
    y2 = NTU / (NTU + 1.0));

  annotation (
    inverse(NTU = TAeZoSysPro.HeatTransfer.Functions.ExchangerEffectiveness.Inverse.NTU_counterCurrent(Eff = Eff, Cr = Cr)),
    Documentation(info = "
<html>
  <head>
    <title>counterCurrent</title>
  </head>
        
  <body lang=\"en-UK\">
    <p>
      This functions computes the exchanger effectiveness of for counter current flows.
    </p>
    
    <p>
      When both flows have the same thermal capacity ( <b>Cr = 1</b> ), a zero division occurs.
      However, an analytical relation is existing for this specific case. 
      To get around the problem, when the value of <b>Cr</b> comes closer to one, a polynomial interpolation between the normal relation and the relation for <b>Cr = 1</b> is performed.
    </p>    
    
    <img
      src = \"modelica://TAeZoSysPro/Information/HeatTransfer/Functions/ExchangerEffectiveness/EQ_counterCurrent.PNG\"
      width = \"500\"
    />
                
        </body>
</html>"));
end counterCurrent;
