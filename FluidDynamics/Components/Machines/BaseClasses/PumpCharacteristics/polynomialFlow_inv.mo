within TAeZoSysPro.FluidDynamics.Components.Machines.BaseClasses.PumpCharacteristics;

function polynomialFlow_inv
  import Modelica.Math.Vectors ;

  input Modelica.SIunits.Position head "Pump head";
  input Modelica.SIunits.VolumeFlowRate V_flow_nominal[:]
      "Volume flow rate for N operating points (single pump)" annotation(Dialog);
  input Modelica.SIunits.Position head_nominal[:] "Pump head for N operating points" annotation(Dialog);
  input Integer OrderPolyFitting = 3 "Order of the polynom that fits the fan curve";
  output Modelica.SIunits.VolumeFlowRate V_flow "Volumetric flow rate";
    
  protected
  Integer N = size(V_flow_nominal,1) "Number of nominal operating points";
  Real[OrderPolyFitting + 1] coeff "[^0,^1,^2,...,^OrderPolyFitting]";
  Real[N, OrderPolyFitting + 1] A ;
  Real roots[OrderPolyFitting] "Roots of the polynomial relation between head and the volume flow rate" ;  
  
algorithm
//
  for i in 1:OrderPolyFitting + 1 loop
    A[:, i] := V_flow_nominal .^ (i - 1);
  end for;

// Compute the coefficient to fit the curve
  coeff := Modelica.Math.Matrices.leastSquares(A = A, b = head_nominal);
  
  Modelica.Utilities.Streams.print("a = "+String(coeff[4])+", b = "+String(coeff[3])+", c = "+String(coeff[2])+", d = "+String(coeff[1])) ;

  roots := TAeZoSysPro.FluidDynamics.Functions.rootsPolyOrder3bis(
    a = coeff[4],
    b = coeff[3],
    c = coeff[2],
    d = coeff[1]-head) ;

  V_flow := max(roots) ;
                                                                     
end polynomialFlow_inv;
