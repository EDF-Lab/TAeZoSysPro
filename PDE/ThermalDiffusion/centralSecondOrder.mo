within TAeZoSysPro.PDE.ThermalDiffusion;

model CentralSecondOrder
  // user defined parameters
  parameter Integer N = 3 "Number of discrete layers";
  parameter Modelica.SIunits.Position x[N+1] "Position array" ;
    
  // inputs
  input Real CoeffTimeDer "Coefficient for time derivative" ;
  input Real CoeffSpaceDer "Coefficient for space derivative" ;
  input Real SourceTerm[N] "Source term in the right hand side" ;
  input Boolean SteadyState = false "Steady state mode" ;

  
  // internal variable
  Real[N+2] u "transported variables. size = N + 2 for ghost nodes" annotation(HideResult = false ) ;
    
equation

  if SteadyState == false then
  
    for i in 2:size(u,1)-1 loop
      if i == 2 then //first layer: take account that the ghost node is vertex centered => not centered but forward derivative
        CoeffTimeDer * der(u[i]) +
        CoeffSpaceDer * ( 1/(x[i] - x[i-1]) * ( 2*(u[i+1] - u[i])/(x[i+1] - x[i-1]) - 2*(u[i] - u[i-1])/(x[i] - x[i-1]) ) ) = SourceTerm[i-1] "PDE domain";
      
      elseif i == size(u,1)-1 then //last layer: take account that the ghost node is vertex centered => not centered but backward derivative
        CoeffTimeDer * der(u[i]) +
        CoeffSpaceDer * ( 1/(x[i] - x[i-1]) * ( 2*(u[i+1] - u[i])/(x[i] - x[i-1]) - 2*(u[i] - u[i-1])/(x[i] - x[i-2]) ) ) = SourceTerm[i-1] "PDE domain";
        
      else    
        CoeffTimeDer * der(u[i]) +
        CoeffSpaceDer * ( 1/(x[i] - x[i-1]) * ( 2*(u[i+1] - u[i])/(x[i+1] - x[i-1]) - 2*(u[i] - u[i-1])/(x[i] - x[i-2]) ) ) = SourceTerm[i-1] "PDE domain";
      end if;    
    end for ;
  
  else /*SteadyState mode*/

    for i in 2:size(u,1)-1 loop
      if i == 2 then //first layer: take account that the ghost node is vertex centered => not centered but forward derivative
        CoeffSpaceDer * ( 1/(x[i] - x[i-1]) * ( 2*(u[i+1] - u[i])/(x[i+1] - x[i-1]) - 2*(u[i] - u[i-1])/(x[i] - x[i-1]) ) ) = SourceTerm[i-1] "PDE domain";
      
      elseif i == size(u,1)-1 then //last layer: take account that the ghost node is vertex centered => not centered but backward derivative
        CoeffSpaceDer * ( 1/(x[i] - x[i-1]) * ( 2*(u[i+1] - u[i])/(x[i] - x[i-1]) - 2*(u[i] - u[i-1])/(x[i] - x[i-2]) ) ) = SourceTerm[i-1] "PDE domain";
        
      else    
        CoeffSpaceDer * ( 1/(x[i] - x[i-1]) * ( 2*(u[i+1] - u[i])/(x[i+1] - x[i-1]) - 2*(u[i] - u[i-1])/(x[i] - x[i-2]) ) ) = SourceTerm[i-1] "PDE domain";
      end if;    
    end for ;  
  
  end if ;
  
 annotation(
    Documentation(info = "
<html>
	<head>
		<title>CentralSecondOrder</title>	
	</head>
	
	<body lang=\"en-UK\">
      <p>
        This model expresses the second space derivative by finite differences being second order accurate.
        The mesh grid can be non uniform. 
        The scheme used is central. 
        The control volume is cell centered. 
        As scheme is cell centered, the flux at boundaries are reconstruced.
        The diffused variable is <b>u</b>.	
      </p>

      <img 
        src=\"modelica://TAeZoSysPro/Information/PDE/ThermalDiffusion/Discrete_scheme.png\" width = \"600\" 
      />
		
      <p>
        for an central scheme, the reconstruction of the first space derivative of <b>u</b> at the borders of the control volume derives:
      </p>        

      <img 
        src=\"modelica://TAeZoSysPro/Information/PDE/ThermalDiffusion/Eq_spaceDerivative.png\" 
      />
			
      <p>
        For a non uniform grid cell centered, the location x for the flux reconstruction at borders of the control volume matches the edge of the mesh. 
        However for boundary nodes, called ghost nodes, the value is vertex center because it would go over the domain otherwise. 
        The scheme for expressing the first space derivative is respectively forward for the left side of the volume and backward for the right side. 
      </p>
      
      <img 
        src=\"modelica://TAeZoSysPro/Information/PDE/ThermalDiffusion/Eq_central.png\" 
      />
      
      <p>
        As the time derivative and numerical solving are taken in charge by the modelica's solver, the numerical stability is not be guarranteed because Fourrier (Fo) number is not monitored and it is unknows where the solving uses implicit, explicit or hybrid method. <br/>
		This model do not establish any equations for the boundary point (the red ones on the scheme above). 
		It is the responsability of the user to supply these equations when model is inherited.
      </p>
		
      <p>
        The model requires as input:
        <ul>
          <li> The <b>N</b> parameter: it the number of discrete layers. its value <b>have to be &ge; 2 </b> </li>
          <li> The <b>CoeffTimeDer</b> value: it is the coefficient for the time derivative (usually the density time the specific heat capacity for heat diffusion). </li>
          <li> The <b>CoeffSpaceDer</b> value: it is the coefficient for the space derivative (usually the conductivity for heat diffusion). </li>
          <li> The <b>sourceTerm</b> value: it is an array of the source therm with the same size of the number of nodes being 'N' . </li>
          <li> The <b>x</b> value: it is an array with the size of the number of nodes being 'N+1'. 
          If N is the number of segments, N+1 is the total number of edges. 
        </ul>
      </p>

	</body>
	
</html>"),
  __OpenModelica_commandLineOptions = "");
   
end CentralSecondOrder;
