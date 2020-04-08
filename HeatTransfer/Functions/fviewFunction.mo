within TAeZoSysPro.HeatTransfer.Functions;

function fviewFunction

  input Real[:] Awall;
  output Real[:] Fview;

  protected
  Real tolerance=1e-5 "convergence criteria of residual that stops the iteration process";
  Real Fview_pre[:] "Fview at iteration N-1";
  Real AwallFviewSum "sum of the product Sk*Fk";
  Real residual "norm 2 of vector of the difference (Fview-Fview_pre)";
  Integer iter "number of iterations";

algorithm
  
  for i in 1:size(Awall,1) loop
    if Awall[i] > sum(Awall)*0.48 then
      assert(false,"The surface with the index "+String(i)+" is greater than 48 percent of total surface, Fview factor not calculated\n", AssertionLevel.error);
    end if ;
  end for ;
 
// initialisation
  iter := 0 ;
  Fview := ones(size(Awall,1)) ;
  residual := 10*tolerance ;
    
// loop
  while (residual > tolerance and iter <=1000) loop
    AwallFviewSum := 0.0 ;
    residual := 0.0 ;
    Fview_pre := Fview ;
    AwallFviewSum := Awall*Fview;
        
    for j in 1:size(Awall,1) loop
      Fview[j] := 1/(1-Fview[j]*Awall[j]/AwallFviewSum);
    end for;
        
    residual := Modelica.Math.Vectors.norm(v=(Fview-Fview_pre), p=2);
      
    iter := iter+1;
      
  end while;
      
  Modelica.Utilities.Streams.print("iteration to converge on Fview: "+String(iter)) ;
      
  assert(not(iter>=1000),"The convergence criteria on view factors is not achieved\n", AssertionLevel.warning);
      
annotation(Inline = true, Documentation(info = "
<html>
  <head>
    <title>FviewFunction</title>	
  </head>
	
  <body lang=\"en-UK\">
    <p>
      This functions computes the view factor (or called form factor) from the input Areas and with the Carrol's method. 
      To summarize, this method allows to calculate the value of the view factor without knowing the detailed geometry (civil work) but just with the knowing of the value of all the areas. 
      The Carroll's method requires the following hypotheses:
      
      <ul>
        <li> All surfaces are visible to each other (see theoretical note for details) </li>
        <li> A surface area does not have to theorically exceed 50% of the total area. In the module, the value of 48% is used rather than 50% as margin </li>
      </ul>
    </p>

    <p>			 
      The formula of the F_view factor derives to an heuristic relation: <br/>
    </p>
    			
    <img	
      src=\"modelica://TAeZoSysPro/Information/HeatTransfer/Components/EQ_FviewCalculator.PNG\"	
    />		
					
    <p>
      <b>Where :</b>
      <ul>
        <li> F_view<sub>i or k</sub> is a view factor
        <li> A_wall<sub>i or k</sub> is a surface area </li>
      </ul>
    </p>

    <p>
      This heuristic relation is solved iteratively.
      The convergence criteria (the value of <b>tolerance</b>) is performed on the residuals wich are defined as the norm between the difference vector Fview at iteration N and iteration N-1.
      The default value for the <b>tolerance</b> is 10<sup>-5</sup>.
    </p>		

    <p>
      The convergence is theorically guaranteed if the initial value for fview is 1.
    </p>
			
  </body>
</html>"));
  
end fviewFunction;
