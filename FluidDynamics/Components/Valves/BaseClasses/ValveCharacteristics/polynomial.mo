within TAeZoSysPro.FluidDynamics.Components.Valves.BaseClasses.ValveCharacteristics;

function polynomial  "Polynomial characteristic: rc = c[1] + c[2]*pos + c[3]*pos^2 + ...."
  extends baseFunc ;
  input Real  c[:] "Polynomial coefficients";
    
algorithm
  pos := min(pos, 1.0) ;
  pos := max(pos, 0.0) ;

  rc := c[size(c, 1)];
  for i in size(c, 1)-1:-1:1 loop
     rc := c[i] + pos*rc;
  end for;
  
 annotation (Documentation(info="<html>
<p>
Evaluate a polynomial using Horner's scheme.
</p>
</html>")) ;

end polynomial;
