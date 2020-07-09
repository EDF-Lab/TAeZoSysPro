within TAeZoSysPro.HeatTransfer.Functions.ExchangerEffectiveness;

function crossCurrent

  extends baseFunc;
  import TAeZoSysPro.HeatTransfer.Types.CrossFlow_arrangement ; 
  input CrossFlow_arrangement arrangement ;
  input Real Qc_A, Qc_B ;
  
protected
  Real gamma ;

algorithm
  if Cr<=1e-2 then
    gamma:= 0.0 ;
    Eff := 1-exp(-NTU) ;
  
  else
  
    if arrangement == CrossFlow_arrangement.both_unmixed then
      gamma := exp(-Cr*NTU^0.78)-1 ;
      Eff := TAeZoSysPro.FluidDynamics.Utilities.regStep(
        x = Cr-2e-2,
        x_small = 1.0e-2,
        y1 = 1.0 - exp(-NTU^(0.22*gamma/Cr)),
        y2 = 1-exp(-NTU));  
    
    elseif arrangement == CrossFlow_arrangement.fluidA_mixed_fluidB_unmixed then
      if Qc_A == max(Qc_A, Qc_B) then 
        gamma := 1-exp(-NTU) ;
        Eff := TAeZoSysPro.FluidDynamics.Utilities.regStep(
          x = Cr-2e-2,
          x_small = 1.0e-2,
          y1 = (1-exp(Cr*gamma))/Cr,
          y2 = 1-exp(-NTU));
    
      else
        gamma := 1-exp(-NTU*Cr) ;
        Eff := TAeZoSysPro.FluidDynamics.Utilities.regStep(
          x = Cr-2e-2,
          x_small = 1.0e-2,
          y1 = (1-exp(-gamma/Cr)),
          y2 = 1-exp(-NTU));    
      end if ;
       
    elseif arrangement == CrossFlow_arrangement.fluidB_mixed_fluidA_unmixed then
      if Qc_A == max(Qc_A, Qc_B) then 
        gamma := 1-exp(-NTU*Cr) ;
        Eff := TAeZoSysPro.FluidDynamics.Utilities.regStep(
          x = Cr-2e-2,
          x_small = 1.0e-2,
          y1 = (1-exp(-gamma/Cr)),
          y2 = 1-exp(-NTU));  
      
      else
        gamma := 1-exp(-NTU) ;
        Eff := TAeZoSysPro.FluidDynamics.Utilities.regStep(
          x = Cr-2e-2,
          x_small = 1.0e-2,
          y1 = (1-exp(Cr*gamma))/Cr,
          y2 = 1-exp(-NTU));
            
      end if ; 
    
    else
      gamma := 0.0 ;
      Eff := 0.0 ;
       
    end if ;

  end if ;

  annotation (
    inverse(NTU = TAeZoSysPro.HeatTransfer.Functions.ExchangerEffectiveness.Inverse.NTU_counterCurrent(Eff = Eff, Cr = Cr)),
    Documentation(info = "
<html>
  <head>
    <title>crossCurrent</title>
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
      src = \"modelica://TAeZoSysPro/Information/HeatTransfer/Functions/ExchangerEffectiveness/EQ_counterCurrent.png\"
      width = \"500\"
    />
                
  </body>
</html>"));

end crossCurrent;
