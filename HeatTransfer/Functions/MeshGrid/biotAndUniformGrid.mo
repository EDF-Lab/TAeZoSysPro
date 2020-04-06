within TAeZoSysPro.HeatTransfer.Functions.MeshGrid;

function biotAndUniformGrid

  input Modelica.SIunits.Length L "Length of the domain to mesh" ;
  input Integer N "number of segments" ;
  input Modelica.SIunits.CoefficientOfHeatTransfer h "Decoupled value of the heat transfer coefficient" ;
  input Modelica.SIunits.ThermalConductivity k "Decoupled value of thermal conductivity" ;
  input Boolean symmetricalMesh = true "Axial symmetry mesh where the axis is the middle of the domain";
  output Modelica.SIunits.Position x[N+1] "Vector of vertice position" ;

protected
  constant Modelica.SIunits.BiotNumber Bi = 0.1 ; 
  Modelica.SIunits.Distance dx "length of the first segment according to the biot number" ;
  
algorithm
  dx := Bi * k / h ;
  x[1] := 0 ;
  
  if symmetricalMesh then
    x[2:end-1] := linspace(dx, L-dx, N-1) ;  
    x[end] := x[end-1] + dx ;
    
  else
    x[2:end] := linspace(dx, L, N) ;   
  end if ;

  annotation(Documentation(info = "
<html>
  <head>
    <title> biotAndUniformGrid </title>
  </head>
  
  <body>
    <p>
      This functions gives the position of the vertices that form segments. 
      The position is computed to insure an equal distance between all the vertices, expected for one of the boundary segment (x[2] - x[1]) if <b>symmetricalMesh</b> is false and both otherwise, where the size of the segment is computed for having a Biot number equal to 0.1 
    </p>
    
    <p>
      In order to compute the size of the 'Biot' layer, the user has to supply as input of the function a decouple value for the heat transfer coefficient at the boundary(ies) and the thermal conductivity of the material.
    </p>
    
    <p>
      The distance between vertices derives:
    </p>
    
    <img 
      src=\"modelica://TAeZoSysPro/Information/HeatTransfer/Functions/MeshGrid/EQ_BiotAndUniformGrid.png\" 
    />
 
    <p>
      Where :
      <ul>
        <li> <b>x</b> is the vector of size N+1 of position of the vertex that form the segment of the mesh of the domain </li>
        <li> <b>N</b> is the number of segments </li>
        <li> <b>L</b> is the length of the domain to mesh </li>
        <li> <b>dx</b> is the thickness of the 'Biot layer' </li>
        <li> <b>Biot</b> is the Biot number </li>
        <li> <b>λ</b> is the thermal conductivity of the material </li>
        <li> <b>h</b> is the heat exchange coefficient at the boundary(ies) </li>
      </ul>
	</p>
    
    <p>
      A mesh divided into N segments contains N+1 vertices. That is why the size of x is N+1.
    </p>    
        
  </body>  
</html>")) ;

end biotAndUniformGrid;
