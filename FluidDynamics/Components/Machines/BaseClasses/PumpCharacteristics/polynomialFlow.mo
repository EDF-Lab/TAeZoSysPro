within TAeZoSysPro.FluidDynamics.Components.Machines.BaseClasses.PumpCharacteristics;

function polynomialFlow
  import Modelica.Math.Vectors ;

  extends Modelica.Fluid.Machines.BaseClasses.PumpCharacteristics.baseFlow ;

  input Modelica.SIunits.VolumeFlowRate V_flow_nominal[:]
      "Volume flow rate for N operating points (single pump)" annotation(Dialog);
  input Modelica.SIunits.Position head_nominal[:] "Pump head for N operating points" annotation(Dialog);
  input Integer OrderPolyFitting = 3 "Order of the polynom that fits the fan curve";
  
  protected
  Integer N = size(V_flow_nominal,1) "Number of nominal operating points";
  Real[OrderPolyFitting + 1] coeff "[^0,^1,^2,...,^OrderPolyFitting]";
  Real[N, OrderPolyFitting + 1] A ;
  Modelica.SIunits.VolumeFlowRate V_flow_min = min(V_flow_nominal);
  Modelica.SIunits.VolumeFlowRate V_flow_max = max(V_flow_nominal);
  Modelica.SIunits.Position head_min "Head from the fitting at V_flow_min ";
  Modelica.SIunits.Position head_max "Head from the fitting at V_flow_max ";
  Real poly ; 

algorithm
// Initialisation
  poly := 0.0 ;

//
  for i in 1:OrderPolyFitting + 1 loop
    A[:, i] := V_flow_nominal .^ (i - 1);
  end for;

// Compute the coefficient to fit the curve
  
coeff := Modelica.Math.Matrices.leastSquares(A = A, b = head_nominal);

// Compte the minimal head with the fitting coefficients  
  poly := coeff[OrderPolyFitting+1] ;
  for i in 1:OrderPolyFitting loop
    poly := poly * V_flow_min + coeff[OrderPolyFitting+1-i] ;
  end for ; 
  head_min := poly ;

// Compte the maximal head with the fitting coefficients  
  poly := coeff[OrderPolyFitting+1] ;
  for i in 1:OrderPolyFitting loop
    poly := poly * V_flow_max + coeff[OrderPolyFitting+1-i] ;
  end for ; 
  head_max := poly ; 
  
  if V_flow >= V_flow_max then /* Linear extrapolation until zero head */
    // poly is the derivative of the curve at V_flow_max
    poly := coeff[OrderPolyFitting+1] * (OrderPolyFitting) ;
    for i in 1:OrderPolyFitting-1 loop
      poly := poly * V_flow_max + coeff[OrderPolyFitting+1-i] * (OrderPolyFitting-i) ;
    end for ;
    head := head_max + (V_flow - V_flow_max) * poly ;
    if head < 0.0 then // head is threshold at 0.0 ;
      head := 0.0 ;
    end if ;
    
  elseif V_flow <= V_flow_min and V_flow > 0.0 then /* Linear extrapolation */
    // poly is the derivative of the curve at V_flow_min
    poly := coeff[OrderPolyFitting+1] * (OrderPolyFitting) ;
    for i in 1:OrderPolyFitting-1 loop
      poly := poly * V_flow_min + coeff[OrderPolyFitting+1-i] * (OrderPolyFitting-i) ;
    end for ;
    head := head_min + (V_flow - V_flow_min) * poly ;  
  
  elseif V_flow <= 0.0 then
    if V_flow_min <= 0.0 then
      head := coeff[1] ;
  
    else
      // poly is the derivative of the curve at V_flow_min
      poly := coeff[OrderPolyFitting+1] * (OrderPolyFitting) ;
      for i in 1:OrderPolyFitting-1 loop
        poly := poly * V_flow_min + coeff[OrderPolyFitting+1-i] * (OrderPolyFitting-i) ;
      end for ;
      head := head_min + (0 - V_flow_min) * poly ;
    end if ;
    
  else
    poly := coeff[OrderPolyFitting+1] ;
    for i in 1:OrderPolyFitting loop
      poly := poly * V_flow + coeff[OrderPolyFitting+1-i] ;
    end for ; 
    head := poly ;
  
  end if ;  

end polynomialFlow;
