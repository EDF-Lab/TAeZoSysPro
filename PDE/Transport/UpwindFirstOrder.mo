within TAeZoSysPro.PDE.Transport;

model UpwindFirstOrder
  // user defined parameters
  parameter Integer N = 3 "Number of discrete layers";
  
  // inputs
  input Real CoeffTimeDer "Coefficient for time derivative" ;
  input Real CoeffSpaceDer "Coefficient for space derivative" ;
  input Real SourceTerm[N+1] "Source term in the right hand side" ;
  input Modelica.SIunits.Position x[N+1] "Position array" ;
//  input Boolean SteadyState = false "Steady state mode" ;
  
  // internal variable
  Real[N+1] u "transported variables" annotation(HideResult = true ) ;
  
equation

  for i in 2:size(u,1)-1 loop
    
    CoeffTimeDer * der(u[i]) + (CoeffSpaceDer+abs(CoeffSpaceDer))/2 * (u[i] - u[i-1]) / (x[i] - x[i-1]) + (CoeffSpaceDer-abs(CoeffSpaceDer))/2 * (u[i+1] - u[i]) / (x[i+1] - x[i]) = SourceTerm[i] "PDE domain";    
  
  end for ;
  
 annotation(
    Documentation(info = 
"<html>
  <head>
    <title>upwindFirstOrder</title>
	
    <style type=\"text/css\">
      *       { font-size: 10pt; font-family: Arial,sans-serif; }
      code    { font-size:  9pt; font-family: Courier,monospace;}
      h6      { font-size: 10pt; font-weight: bold; color: green; }
      h5      { font-size: 11pt; font-weight: bold; color: green; }
      h4      { font-size: 13pt; font-weight: bold; color: green; }
      address {                  font-weight: normal}
      td      { solid #000; vertical-align:top; }
      th      { solid #000; vertical-align:top; font-weight: bold; }
      table   { solid #000; border-collapse: collapse;}
    </style>
		
  </head>
	
  <body lang=\"en-UK\">

    <p>
      This model expresses the first derivative by finite differences being a first order accuracy.
      The scheme used is uwpind. 
      It means that the knowledge of the sign of the velocity is required. 
      Therefore, the equations can not be written using conservative forms. 
      The boundaries of the control volume do not match the face of the mesh and boundaries flux are reconstruced
    </p>

    <img 
      src=\"modelica://TAeZoSysPro/Information/PDE/Transport/FIG_UpwindFirstOrder.png\"
      width = \"600\" 
    />
		
    <p>
      For an upwind scheme, the reconstruction of u at the borders of the control volume derives:
      <ul>
        <li> u<sub>i+1/2</sub> = u<sub>i</sub> for velocity &ge; 0 and u<sub>i+1</sub> otherwise  </li>
        <li> u<sub>i-1/2</sub> = u<sub>i-1</sub> for velocity &ge; 0 and u<sub>i</sub> otherwise  </li>
      </ul>
			
      For a non uniform grid, the location of the reconstruction u derives:

      <ul>
        <li> x<sub>i+1/2</sub> = 1/2 * ( x<sub>i+1</sub> + x<sub>i</sub> ) </li>
        <li> x<sub>i-1/2</sub> = 1/2 * ( x<sub>i</sub> + x<sub>i-1</sub> ) </li>
      </ul>
			
      <br/>
			
      Whatever the direction of the flow, the space derivative of u at node 'i' derives:
    </p>
		
    <img 
      src=\"modelica://TAeZoSysPro/Information/PDE/Transport/EQ_UpwindFirstOrder1.png\" 
    />

    <p>
      To get the equation bellow, the following hypotheses derives:
      <ul>
        <li> The velocity is independant from the space. it is supposed an uncompressible and unexpandable flow (zero divergence of velocity). </li>
      </ul>
    </p>
		
    <p>
      To deals with reversal transport, the scheme has to change with the sign of the velocity. 
      Use a conditionnal form could lead to chattering for an oscillating velocity and a suppressions of events using 'noEvent' could lead to numerical discrepansies in case of overtaking of the conditionnal expression. 
      Therefore it has been prefered to use the following continous expression. 
    </p>
		
    <img 
      src=\"modelica://TAeZoSysPro/Information/PDE/Transport/EQ_UpwindFirstOrder2.png\" 
      width = \"600\"
    />
		
    <p>
      As the time derivative and numerical solving are taken in charge by the modelica's solver, the numerical stability is not be guarranteed because Courant-Friedrich-Lewy (CFL) number is not monitored and it is unknows where the solving uses implicit, explicit or hybrid method. <br/>
      This model do not establish any equations for the boundary point (the red ones on the scheme above). 
      It is the responsability of the user to sypply these equations when model is inherited.
    </p>
		
    <p>
      The model requires as input:
      <ul>
        <li> The <b>N</b> parameter: it the number of discrete layers. its value <b>have to be &ge; 2 </b> </li>
        <li> The <b>CoeffTimeDer</b> value: it is the coefficient for the time derivative (usually one for a transport). </li>
        <li> The <b>CoeffSpaceDer</b> value: it is the coefficient for the space derivative (usually the velocity for the transport). </li>
        <li> The <b>sourceTerm</b> value: it is an array of the source therm with the same size of the number of nodes being 'N+1' (usually zero for transport). </li>
        <li> The <b>x</b> value: it is an array with the same size of the number of nodes being 'N+1' (usually zero for transport). </li>
      </ul>
			
    </p>
  </body>
</html>"),
  __OpenModelica_commandLineOptions = "");
   
end UpwindFirstOrder;
