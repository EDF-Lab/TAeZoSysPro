within TAeZoSysPro.FluidDynamics.Utilities;

function regRoot2
  "Anti-symmetric approximation of square root with discontinuous factor so that the first derivative is finite and continuous"

  extends Modelica.Icons.Function;
  input Real x "Abscissa value";
  input Real x_small(min=0)=0.01 "Approximation of function for |x| <= x_small";
  input Real k1(min=0)=1 "y = if x>=0 then sqrt(k1*x) else -sqrt(k2*|x|)";
  input Real k2(min=0)=1 "y = if x>=0 then sqrt(k1*x) else -sqrt(k2*|x|)";
  input Boolean use_yd0 = false "= true, if yd0 shall be used";
  input Real yd0(min=0)=1 "Desired derivative at x=0: dy/dx = yd0";
  output Real y "Ordinate value";
protected
  Real sqrt_k1 = if k1 > 0 then sqrt(k1) else 0;
  Real sqrt_k2 = if k2 > 0 then sqrt(k2) else 0;
  encapsulated function regRoot2_utility
    "Interpolating with two 3-order polynomials with a prescribed derivative at x=0"
    import Modelica;
    extends Modelica.Icons.Function;
    import Modelica.Fluid.Utilities.evaluatePoly3_derivativeAtZero;
    input Real x;
    input Real x1 "Approximation of function abs(x) < x1";
    input Real k1 "y = if x>=0 then sqrt(k1*x) else -sqrt(k2*|x|); k1 >= k2";
    input Real k2 "y = if x>=0 then sqrt(k1*x) else -sqrt(k2*|x|))";
    input Boolean use_yd0 "= true, if yd0 shall be used";
    input Real yd0(min=0) "Desired derivative at x=0: dy/dx = yd0";
    output Real y;
  protected
     Real x2;
     Real xsqrt1;
     Real xsqrt2;
     Real y1;
     Real y2;
     Real y1d;
     Real y2d;
     Real w;
     Real y0d;
     Real w1;
     Real w2;
     Real sqrt_k1 = if k1 > 0 then sqrt(k1) else 0;
     Real sqrt_k2 = if k2 > 0 then sqrt(k2) else 0;
  algorithm
     if k2 > 0 then
        // Since k1 >= k2 required, k2 > 0 means that k1 > 0
        x2 :=-x1*(k2/k1);
     elseif k1 > 0 then
        x2 := -x1;
     else
        y := 0;
        return;
     end if;

     if x <= x2 then
        y := -sqrt_k2*sqrt(abs(x));
     else
        y1 :=sqrt_k1*sqrt(x1);
        y2 :=-sqrt_k2*sqrt(abs(x2));
        y1d :=sqrt_k1/sqrt(x1)/2;
        y2d :=sqrt_k2/sqrt(abs(x2))/2;

        if use_yd0 then
           y0d :=yd0;
        else
           /* Determine derivative, such that first and second derivative
            of left and right polynomial are identical at x=0:
         _
         Basic equations:
            y_right = a1*(x/x1) + a2*(x/x1)^2 + a3*(x/x1)^3
            y_left  = b1*(x/x2) + b2*(x/x2)^2 + b3*(x/x2)^3
            yd_right*x1 = a1 + 2*a2*(x/x1) + 3*a3*(x/x1)^2
            yd_left *x2 = b1 + 2*b2*(x/x2) + 3*b3*(x/x2)^2
            ydd_right*x1^2 = 2*a2 + 6*a3*(x/x1)
            ydd_left *x2^2 = 2*b2 + 6*b3*(x/x2)
         _
         Conditions (6 equations for 6 unknowns):
                   y1 = a1 + a2 + a3
                   y2 = b1 + b2 + b3
               y1d*x1 = a1 + 2*a2 + 3*a3
               y2d*x2 = b1 + 2*b2 + 3*b3
                  y0d = a1/x1 = b1/x2
                 y0dd = 2*a2/x1^2 = 2*b2/x2^2
         _
         Derived equations:
            b1 = a1*x2/x1
            b2 = a2*(x2/x1)^2
            b3 = y2 - b1 - b2
               = y2 - a1*(x2/x1) - a2*(x2/x1)^2
            a3 = y1 - a1 - a2
         _
         Remaining equations
            y1d*x1 = a1 + 2*a2 + 3*(y1 - a1 - a2)
                   = 3*y1 - 2*a1 - a2
            y2d*x2 = a1*(x2/x1) + 2*a2*(x2/x1)^2 +
                     3*(y2 - a1*(x2/x1) - a2*(x2/x1)^2)
                   = 3*y2 - 2*a1*(x2/x1) - a2*(x2/x1)^2
            y0d    = a1/x1
         _
         Solving these equations results in y0d below
         (note, the denominator "(1-w)" is always non-zero, because w is negative)
         */
           w :=x2/x1;
           y0d := ( (3*y2 - x2*y2d)/w - (3*y1 - x1*y1d)*w) /(2*x1*(1 - w));
        end if;

        /* Modify derivative y0d, such that the polynomial is
         monotonically increasing. A sufficient condition is
           0 <= y0d <= sqrt(8.75*k_i/|x_i|)
      */
        w1 :=sqrt_k1*sqrt(8.75/x1);
        w2 :=sqrt_k2*sqrt(8.75/abs(x2));
        y0d :=smooth(2, min(y0d, 0.9*min(w1, w2)));

        /* Perform interpolation in scaled polynomial:
         y_new = y/y1
         x_new = x/x1
      */
        y := y1*(if x >= 0 then evaluatePoly3_derivativeAtZero(x/x1,1,1,y1d*x1/y1,y0d*x1/y1) else
                                evaluatePoly3_derivativeAtZero(x/x1,x2/x1,y2/y1,y2d*x1/y1,y0d*x1/y1));
     end if;
     annotation(smoothOrder=2);
  end regRoot2_utility;
algorithm
  y := smooth(2, if x >= x_small then sqrt_k1*sqrt(x) else
                 if x <= -x_small then -sqrt_k2*sqrt(abs(x)) else
                 if k1 >= k2 then regRoot2_utility(x,x_small,k1,k2,use_yd0,yd0) else
                                 -regRoot2_utility(-x,x_small,k2,k1,use_yd0,yd0));
  annotation(smoothOrder=2, Documentation(info="<html>

<p>
 This function is a copy pasting of the same function from the MSL library with Modelica 3.2.3 . The function is copied rather than inherited to avoid regression issues due to an update of the function in further version of the MSL.
</p>
<p>
Approximates the function
</p>
<pre>
 y = <strong>if</strong> x &ge; 0 <strong>then</strong> <strong>sqrt</strong>(k1*x) <strong>else</strong> -<strong>sqrt</strong>(k2*<strong>abs</strong>(x)), with k1, k2 &ge; 0
</pre>
<p>
in such a way that within the region -x_small &le; x &le; x_small,
the function is described by two polynomials of third order
(one in the region -x_small .. 0 and one within the region 0 .. x_small)
such that
</p>
<ul>
<li> The derivative at x=0 is finite.</li>
<li> The overall function is continuous with a
   continuous first derivative everywhere.</li>
<li> If parameter use_yd0 = <strong>false</strong>, the two polynomials
   are constructed such that the second derivatives at x=0
   are identical. If use_yd0 = <strong>true</strong>, the derivative
   at x=0 is explicitly provided via the additional argument
   yd0. If necessary, the derivative yd0 is automatically
   reduced in order that the polynomials are strict monotonically
   increasing <em>[Fritsch and Carlson, 1980]</em>.</li>
</ul>
<p>
Typical screenshots for two different configurations
are shown below. The first one with k1=k2=1:
</p>
<p>
<img src=\"modelica://Modelica/Resources/Images/Fluid/Components/regRoot2_a.png\"
   alt=\"regRoot2_a.png\">
</p>
<p>
and the second one with k1=1 and k2=3:
</p>
<p>
<img src=\"modelica://Modelica/Resources/Images/Fluid/Components/regRoot2_b.png\"
    alt=\"regRoot2_b.png\">
</p>

<p>
The (smooth) derivative of the function with
k1=1, k2=3 is shown in the next figure:</p>
<p>
<img src=\"modelica://Modelica/Resources/Images/Fluid/Components/regRoot2_c.png\"
   alt=\"regRoot2_c.png\">
</p>

<p>
<strong>Literature</strong>
</p>

<dl>
<dt> Fritsch F.N. and Carlson R.E. (1980):</dt>
<dd> <strong>Monotone piecewise cubic interpolation</strong>.
   SIAM J. Numerc. Anal., Vol. 17, No. 2, April 1980, pp. 238-246</dd>
</dl>
</html>", revisions="<html>
<ul>
<li><em>Sept., 2010</em>
  by <a href=\"mailto:Martin.Otter@DLR.de\">Martin Otter</a>:<br>
  Improved so that k1=0 and/or k2=0 is also possible.</li>
<li><em>Nov., 2005</em>
  by <a href=\"mailto:Martin.Otter@DLR.de\">Martin Otter</a>:<br>
  Designed and implemented.</li>
</ul>
</html>"));
end regRoot2;
