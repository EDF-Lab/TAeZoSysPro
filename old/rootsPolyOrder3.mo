within TAeZoSysPro.FluidDynamics.Functions;

function rootsPolyOrder3 "Find the roots of a 3 order polynome of kind ax3 + bx2 + cx + d = 0"

  input Real a "Polynom coefficients";
  input Real b "Polynom coefficients";
  input Real c "Polynom coefficients";
  input Real d "Polynom coefficients";
  output Real roots[3] ;   

protected
  Real p, q ;
  Real discriminant ;
  Real x1 "First root of the polynom";
  Real x2 "Second roots of the polynom";
  Real x3 "Third roots of the polynom";
    
algorithm
// default value
  x1 := 0.0 ;
  x2 := 0.0 ;
  x3 := 0.0 ;
  p := 0.0 ;
  q := 0.0 ;
  discriminant := 0.0 ;  

// check that is high enough to consider the polynom as a third order
  if abs(a) <= 1e-10 then /* 2nd order polynom */
    if abs(b) <= 1e-10 then /* 1st order polynom */
      x1 := -d / c ;
    else /* 2nd order polynom */
      discriminant := c^2 - 4*b*d ;
      if discriminant < 0.0 then
        assert(discriminant >= 0.0, message = "Negative discriminant, no real roots", level = AssertionLevel.error) ;
      elseif discriminant == 0.0 then
        x1 := -c / (2*b) ;
        
      else /*discriminant > 0.0 */
        x1 := (- c - sqrt(discriminant) ) / (2*b) ;
        x2 := (- c + sqrt(discriminant) ) / (2*b) ;

      end if ;    
    end if ;
  else /* 3rd order polynom */
// first a change of variable is performed to derives to the following equation solvable via the Cardan method: X^3 + pX + q = 0
    p := (3*a*c - b^2) / (3*a^2) ;
    q := (2*b^3 - 9*a*b*c + 27*a^2*d) / (27*a^3) ;
    discriminant := -(27*q^2 + 4*p^3) ;
    x1 := ((-q - sqrt(discriminant)) / 2)^(1/3) +   ((-q + sqrt(discriminant)) / 2)^(1/3) - b/(3*a) ;
/* knowing the first racine, the polynom becomes: ax^2 + (b+ax1)x + (c+(b+ax1)x1) = 0.
   The discriminant of this new equation derives: */
    discriminant := (b+a*x1)^2 - 4*a*(c+(b+a*x1)*x1) ;
    if discriminant < 0.0 then
      assert(discriminant >= 0.0, message = "Negative discriminant, no real roots", level = AssertionLevel.error) ;
    elseif discriminant == 0.0 then
        x2 := -(c+(b+a*x1)*x1) / (2*(b+a*x1)) ;
        
    else /*discriminant > 0.0 */
      x2 := (- (b+a*x1) - sqrt(discriminant) ) / (2*a) ;
      x3 := (- (b+a*x1) + sqrt(discriminant) ) / (2*a) ;

    end if ;    
  end if ;
  
  roots := {x1, x2, x3} ;

annotation(
  Documentation(info = "
<html>
  <head>
    <title>rootsPolyOrder3</title>
	<style type=\"text/css\">
		h5      { font-size: 11pt; font-weight: bold; color: green; }
    </style>
  </head>
	
  <body lang=\"en-UK\">
    <p>
      This function computes the vector of roots, <b>roots=(x1, x2, x3}</b>, of third order polynom P(x): 
    </p>      

    <img	
      src=\"modelica://TAeZoSysPro/Information/FluidDynamics/Functions/EQ_rootsPolyOrder3_1.PNG\" 
    />

    <p>
      The process to get the roots derives from CARDAN's method available at the following <a href=\"https://fr.wikiversity.org/wiki/%C3%89quation_du_troisi%C3%A8me_degr%C3%A9/M%C3%A9thode_de_Cardan\">link</a>. </br>
      To sum up: 
    </p>
    
    <ul>
      <li>if the determinant Δ of the 3rd order polynom is strictly positif, the roots derives:</li>
      <li>if Δ = 0, the roots derives:</li>       
      <li>if Δ > 0, the roots derives:</li>
    </ul>
    
<h5> If 'a' is bellow 1e-10, the polynom is assumed to be 2nd order </h5>

    <p>
      The discriminant of the second order polynom derives:
    </p>

    <img	
      src=\"modelica://TAeZoSysPro/Information/FluidDynamics/Functions/EQ_rootsPolyOrder3_4.PNG\" 
    />

    <ul>
      <li> If Δ < 0, there are no real root and an error message is raised. </li>
      <li> If Δ = 0, there is one double solution: </li> 
    </ul>

    <img	
      src=\"modelica://TAeZoSysPro/Information/FluidDynamics/Functions/EQ_rootsPolyOrder3_5.PNG\" 
    />

    <ul>
      <li> If Δ > 0, the two real roots derives. </li>
    </ul>
    
    <img	
      src=\"modelica://TAeZoSysPro/Information/FluidDynamics/Functions/EQ_rootsPolyOrder3_6.PNG\" 
    />	

    <h5> If 'a' and 'b' are bellow 1e-10, the polynom is assumed to be 1st order </h5>

    <p>
      The first root derives:
    </p>

    <img	
      src=\"modelica://TAeZoSysPro/Information/FluidDynamics/Functions/EQ_rootsPolyOrder3_7.PNG\" 
    />
    
    <p>
      <b>In case where a roots has no assigned value, its default value is 0.</b>
    </p>

  </body>
</html>")) ;

end rootsPolyOrder3;
