within TAeZoSysPro.HeatTransfer.Functions.MeshGrid;

function biotAndGeometricalGrowthGrid

  input Modelica.SIunits.Length L "Length of the domain to mesh" ;
  input Integer N "number of segments" ;
  input Real q "Growth rate" ;
  input Modelica.SIunits.CoefficientOfHeatTransfer h "Decoupled value of the heat transfer coefficient" ;
  input Modelica.SIunits.ThermalConductivity k "Decoupled value of thermal conductivity" ;
  input Boolean symmetricalMesh = true "Axial symmetry mesh where the axis is the middle of the domain";
  output Modelica.SIunits.Position x[N+1] "Vector of vertice position" ;

protected
  constant Modelica.SIunits.BiotNumber Bi = 0.1 ; 
  Modelica.SIunits.Distance dx_biot "length of the first segment according to the biot number" ;
  Modelica.SIunits.Distance dx "size of the first element" ;
  Integer N_2 "number of segments - 2 for biot segment" ;

algorithm
  N_2 := N - 2 ;
  dx_biot := Bi * k / h ;
  
  if N > 2 then  
    x[1] := 0.0 ;
    x[2] := dx_biot ;  
    
    if symmetricalMesh then
      if rem(N,2) == 0 then // even number of segment
        dx := (L-2*dx_biot)/2 / ( (1-q^(N_2/2))/(1-q) ) ;
        
        for i in 2:integer(N/2) loop
          x[i+1] := x[i] + dx * q^(i-2) ;
        end for ;
        
        for i in integer(N/2)+2:N+1 loop
          x[i] := L - x[N+1-i+1] ;
        end for ;      
              
      else
        dx := (L-2*dx_biot) / ( 2 * (1-q^(floor(N_2/2)))/(1-q) + q^(floor(N_2/2))) ;
        
        for i in 2:integer( ceil(N/2) ) loop
          x[i+1] := x[i] + dx * q^(i-2) ;
        end for ;     
        
        for i in integer(ceil(N/2))+1:N+1 loop
          x[i] := L - x[N+1-i+1] ;
        end for ;
      
      end if;
      
    else
      dx := (L-dx_biot) / ( (1-q^(N-1))/(1-q) ) ;
      
      for i in 2:N loop
        x[i+1] := x[i] + dx * q^(i-2) ;
      end for ;
      
    end if ;

  else
    x[1] := 0.0 ;
    x[2] := L/2 ;
    x[3] := L ;  
  end if;

  annotation(Documentation(info = "
<html>
  <head>
    <title> uniformGrid </title>
  </head>
  
  <body>
    <p>
      This functions gives the position of the vertices that form segments. 
      The position is computed to insure a geometrical increase of the distance between a vertex and its next expected for one of the boundary segment (x[2] - x[1]) if <b>symmetricalMesh</b> is false and both otherwise, where the size of the segment is computed for having a Biot number equal to 0.1.
    </p>

    <p>
      For the special case where the number of segments <b>N</b> equal <b>2</b>, the length of the segment is half of the length of the domain and biot layers are ignored.
    </p>
    
    <p>
      In order to compute the size of the 'Biot' layer, the user has to supply as input of the function a decouple value for the heat transfer coefficient at the boundary(ies) and the thermal conductivity of the material.
    </p>
    
    <p>
      if <b>symmetricalMesh</b> is true, the mesh is symmetrical on both sides of the middle of the domain. In that case, one of the two different processes are run depending on whether the number of nodes (segments) N is even or not.
    </p>
    
    <p>
      The common equations derives:
    </p>
    
    <img 
      src=\"modelica://TAeZoSysPro/Information/HeatTransfer/Functions/MeshGrid/EQ_biotAndGeometricalGrowthGrid.png\" 
    /> 
        
    <p>
      The distance between vertices derives for odd number of segments:
    </p>
    
    <img 
      src=\"modelica://TAeZoSysPro/Information/HeatTransfer/Functions/MeshGrid/EQ_biotAndGeometricalGrowthGrid_odd.png\" 
    />
    
    </p>
      The distance between vertices derives for even number of segments:
    </p>
    
    <img 
      src=\"modelica://TAeZoSysPro/Information/HeatTransfer/Functions/MeshGrid/EQ_biotAndGeometricalGrowthGrid_even.png\" 
    />

    <p>
      if <b>symmetricalMesh</b> is false, the mesh grows from the start to the end of the domain. </br>
      The distance between vertices derives:
    </p>

    <img 
      src=\"modelica://TAeZoSysPro/Information/HeatTransfer/Functions/MeshGrid/EQ_biotAndGeometricalGrowthGrid_asymmetric.png\" 
    />

    <p>
      Where :
      <ul>
        <li> <b>symmetricalMesh</b> is a boolean to select if the mesh is symetric to the middle of the domain </li> 
        <li> <b>x</b> is the vector of size N+1 of position of the vertex that form the segment of the mesh of the domain </li>
        <li> <b>dx_biot</b> is length of the biot layer segment </li>
        <li> <b>Biot</b> is the Biot number </li>
        <li> <b>λ</b> is the thermal conductivity os the material </li>
        <li> <b>h</b> is the heat exchange coefficient at the boundary(ies) </li>
        <li> <b>dx</b> is length of the first segment after the Biot layer </li>
        <li> <b>q</b> is the geometric progression of the length of the segment. q ≠ 1 </li>
        <li> <b>N</b> is the number of segments </li>
        <li> <b>n</b> is the integer part of the division of segments by 2 </li>        
        <li> <b>L</b> is the length of the domain to mesh </li>
      </ul>
	</p>
    
    <p>
      A mesh divided into N segments contains N+1 vertices. That is why the size of x is N+1.
    </p>    
        
  </body>  
</html>")) ;

end biotAndGeometricalGrowthGrid;
