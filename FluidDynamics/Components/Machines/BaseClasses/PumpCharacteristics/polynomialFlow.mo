within TAeZoSysPro.FluidDynamics.Components.Machines.BaseClasses.PumpCharacteristics;

function polynomialFlow
  import Modelica.Math.Vectors ;

  extends Modelica.Fluid.Machines.BaseClasses.PumpCharacteristics.baseFlow ;

  input Modelica.SIunits.VolumeFlowRate V_flow_nominal[:]
      "Volume flow rate for N operating points (single pump)" annotation(Dialog);
  input Modelica.SIunits.Position head_nominal[:] "Pump head for N operating points" annotation(Dialog);
  input Integer OrderPolyFitting(max = 3) = 3 "Order of the polynom that fits the fan curve";
  
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
    if head < 0.0 then // head is threshold at 0.0 ;
      head := 0.0 ;
    end if ;
     

  
  end if ;
  
annotation(
  Inline = true,
  inverse(V_flow = polynomialFlow_inv(V_flow_nominal=V_flow_nominal,
                                      head_nominal = head_nominal,
                                      head = head) ),
  Documentation(info = "
<html>
  <head>
    <title>polynomialFlow</title>
	<style type=\"text/css\">
		h5      { font-size: 11pt; font-weight: bold; color: green; }
    </style>
  </head>
	
  <body lang=\"en-UK\">
    <p>
      This function computes the <b>head</b> in meter supplied by a pump at a given volume flow rate <b>V_flow</b> from a polynomial fitting of the pump curve.  
    </p>      

    <p>
      The fitting is carried out from nominal inputs of the volume flow rate and the head (<b>V_flow_nominal</b> and <b>head_nominal</b>) via the least squares method.
      The order of the polynom that fits the curve is settable via the input <b>OrderPolyFitting</b> but cannot go over the third order.  
    </p>
    
    <p>
      <li>If the input <b>V_flow</b> is out of the range of the input nominal data <b>V_flow_nominal</b>, a linear extrapolation is performed. 
    </p>
    
    <p>
      <li>If <b>V_flow <= 0</b> the <b>head</b> remains at <b>head = f(V_flow = 0)</b>. This condition is prior to the bullet point above.
    </p>
    
    <p>
      <li>If the <b>head</b> computed by the polynom or by the extrapolation combined with the polynom goes bellow 0, the heat is threshold at 0 (<b> head ⩾ 0</b>).
    </p>

  </body>
</html>") ) ;  

end polynomialFlow;
