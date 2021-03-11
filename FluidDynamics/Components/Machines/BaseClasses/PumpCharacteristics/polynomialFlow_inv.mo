within TAeZoSysPro.FluidDynamics.Components.Machines.BaseClasses.PumpCharacteristics;

function polynomialFlow_inv
  import Modelica.Math.Vectors ;
  extends Modelica.Icons.Function ;

  input Modelica.SIunits.Position head "Pump head";
  input Modelica.SIunits.VolumeFlowRate V_flow_nominal[:]
      "Volume flow rate for N operating points (single pump)" annotation(Dialog);
  input Modelica.SIunits.Position head_nominal[:] "Pump head for N operating points" annotation(Dialog);
  input Integer OrderPolyFitting(min = 1) = 3 "Order of the polynom that fits the fan curve";
  output Modelica.SIunits.VolumeFlowRate V_flow "Volumetric flow rate";
    
  protected
  Integer N = size(V_flow_nominal,1) "Number of nominal operating points";
  Real[OrderPolyFitting + 1] coeff "[^0,^1,^2,...,^OrderPolyFitting]";
  Real[N, OrderPolyFitting + 1] A ;
  Real roots[3] "Roots of the polynomial relation between head and the volume flow rate" ;  
  
algorithm
//
  for j in 1:OrderPolyFitting + 1 loop
    for i in 1:N loop
      A[i, j] := V_flow_nominal[i] ^(j - 1);
    end for;
  end for;

// Compute the coefficient to fit the curve
  coeff := Modelica.Math.Matrices.leastSquares(A = A, b = head_nominal);

  roots := TAeZoSysPro.FluidDynamics.Functions.rootsPolyOrder3(
    a = if OrderPolyFitting == 3 then coeff[end] 
        else 0.0,
    b = if OrderPolyFitting == 3 then coeff[end-1] 
        elseif OrderPolyFitting == 2 then coeff[end]
        else 0.0,
    c = coeff[2],
    d = coeff[1]-head) ;

  V_flow := max(roots[1:OrderPolyFitting]) ;
  
annotation(
  Inline = true,
  inverse(head = polynomialFlow(V_flow_nominal=V_flow_nominal,
                                head_nominal = head_nominal,
                                V_flow = V_flow,
                                OrderPolyFitting = OrderPolyFitting)),
  Documentation(info = "
<html>
  <head>
    <title>polynomialFlow_inv</title>
	<style type=\"text/css\">
		h5      { font-size: 11pt; font-weight: bold; color: green; }
    </style>
  </head>
	
  <body lang=\"en-UK\">
    <p>
      This function computes the volume flow rate <b>V_flow</b> supplied by a pump at a given <b>head</b> from the roots of the polynom that fits the pump curve. </br>
      This function is mainly used as inverse of the polynomialFlow function when the head is known but not the volume flow rate.
    </p>
    
    <p>
      If the pump curve of the pressure as a function of the volume flow rate is not monotonically decreasing with increasing V_flow_nominal, severals solution for the flow rate are possible for a polynom higher than the first order. 
      However, a pumping system is designed to work only in the monotonically decreasing part of the pump curve. 
      Therefore, among the mulitiples roots, the most reasonable one is the higher value of roots.
    </p>      

    <p>
      The fitting is carried out from nominal inputs of the volume flow rate and the head (<b>V_flow_nominal</b> and <b>head_nominal</b>) via the least squares method.
      The order of the polynom that fits the curve is settable via the input <b>OrderPolyFitting</b> but cannot go over the third order.  
    </p>

  </body>
</html>") ) ;  
                                                                     
end polynomialFlow_inv;
