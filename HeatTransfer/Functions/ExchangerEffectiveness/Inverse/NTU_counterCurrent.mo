within TAeZoSysPro.HeatTransfer.Functions.ExchangerEffectiveness.Inverse;

function NTU_counterCurrent

  extends Modelica.Icons.Function ;
  
  input Modelica.SIunits.Efficiency Eff "Exchanger effectiveness" ;
  input Real Cr "Ratio of thermal condutance" ;
  output Real NTU "Number of transfer unit" ;

algorithm
  
  NTU := Modelica.Fluid.Utilities.regStep(
    x = 0.98 - Cr,
    x_small = 1.0e-2,
    y1 = (1.0 / (1.0 - Cr)) * log((1.0 - max(Eff, 0.999)*Cr) / (1.0 - Cr)),
    y2 = Eff / (1.0 - max(Eff, 0.999)) ) ;
    
  annotation(
    inverse(Eff = Inverse.counterCurrent(NTU = NTU, Cr = Cr)),
    Documentation(info = "
<html>
  <head>
    <title>NTU_counterCurrent</title>
  </head>
	
  <body lang=\"en-UK\">
    <p>
      This functions computes the Number of Transfer Units (NTU) of an exchanger for counter current flows.
      The function is mainly used to supplier to the solver the inverse function of the effectiveness.
    </p> 
    <p>
      When both flows have the same thermal capacity ( <b>Cr = 1</b> ), a zero division occurs.
      However, an analytical relation is existing for this specific case. 
      To get around the problem, when the value of <b>Cr</b> comes closer to one, a polynomial interpolation between the normal relation and the relation for <b>Cr = 1</b> is performed.
    </p>   
    <img
      src = \"modelica://TAeZoSysPro/Information/HeatTransfer/Functions/ExchangerEffectiveness/inverse/EQ_NTU_counterCurrent.png\"
      width = \"500\"
    />

    <p>
      A threshold is applied on the value of the effectiveness <b>Eff = 0.999</b> to avoid numerical troubles such as zero divisions or infinite values.
    </p>
		
	</body>
</html>")) ;

end NTU_counterCurrent;
