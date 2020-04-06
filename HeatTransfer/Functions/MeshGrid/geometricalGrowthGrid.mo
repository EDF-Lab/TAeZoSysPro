within TAeZoSysPro.HeatTransfer.Functions.MeshGrid;

function geometricalGrowthGrid

  input Modelica.SIunits.Length L "Length of the domain to mesh" ;
  input Integer N "number of segments" ;
  input Real q "Growth rate" ;
  input Boolean symmetricalMesh = true "Axial symmetry mesh where the axis is the middle of the domain";
  output Modelica.SIunits.Position x[N+1] "Vector of vertice position" ;

protected
  Modelica.SIunits.Length dx "size of the first element" ;

algorithm

  if symmetricalMesh then
    if rem(N,2) == 0 then // even number of segment
      dx := (L/2) / ( (1-q^(N/2))/(1-q) ) ;
      x[1] := 0.0 ;
      for i in 1:integer(N/2) loop
        x[i+1] := x[i] + dx * q^(i-1) ;
      end for ;
      
      for i in integer(N/2)+1:N+1 loop
        x[i] := L - x[N+1-i+1] ;
      end for ;      
            
    else
      dx := L / ( 2 * (1-q^(floor(N/2)))/(1-q) + q^(floor(N/2))) ;
      x[1] := 0.0 ;
      for i in 1:integer( ceil(N/2) ) loop
        x[i+1] := x[i] + dx * q^(i-1) ;
      end for ;     
      for i in integer(ceil(N/2))+1:N+1 loop
        x[i] := L - x[N+1-i+1] ;
      end for ;
    
    end if;
  else
    dx := L / ( (1-q^(N))/(1-q) ) ;
    x[1] := 0.0 ;
    for i in 1:N loop
      x[i+1] := x[i] + dx * q^(i-1) ;
    end for ;
  end if ;

  annotation(Documentation(info = "
<html>
  <head>
    <title> geometricalGrowthGrid </title>
  </head>
  
  <body>
    <p>
      This functions gives the position of the vertices that form segments. 
      The position is computed to insure a geometrical increase of the distance between a vertex and its next.
    </p>
    <p>
      if <b>symmetricalMesh</b> is true, the mesh is symmetrical on both sides of the middle of the domain. In that case, one of the two different processes are run depending on whether the number of nodes (segments) N is even or not.
    </p> 
    <p>
      The distance between vertices derives for odd number of segments:
    </p>
    
    <img 
      src=\"modelica://TAeZoSysPro/Information/HeatTransfer/Functions/MeshGrid/EQ_geometricalGrowthGrid_odd.png\" 
    />
    
    </p>
      The distance between vertices derives for even number of segments:
    </p>
    
    <img 
      src=\"modelica://TAeZoSysPro/Information/HeatTransfer/Functions/MeshGrid/EQ_geometricalGrowthGrid_even.png\" 
    />

    <p>
      if <b>symmetricalMesh</b> is false, the mesh grows from the start to the end of the domain. </br>
      The distance between vertices derives:
    </p>

    <img 
      src=\"modelica://TAeZoSysPro/Information/HeatTransfer/Functions/MeshGrid/EQ_geometricalGrowthGrid_asymetric.png\" 
    />

    <p>
      Where :
      <ul>
        <li> <b>symmetricalMesh</b> is a boolean to select if the mesh is symetric to the middle of the domain </li> 
        <li> <b>x</b> is the vector of size N+1 of position of the vertex that form the segment of the mesh of the domain </li>
        <li> <b>dx</b> is length of the first segment </li>
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

end geometricalGrowthGrid;
