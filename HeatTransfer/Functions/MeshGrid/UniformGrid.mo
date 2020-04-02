within TAeZoSysPro.HeatTransfer.Functions.MeshGrid;

function uniformGrid
  input Modelica.SIunits.Length L "Length of the domain to mesh" ;
  input Integer N "number of segments" ;
  output Modelica.SIunits.Position x[N+1] "Vector of vertice position" ;

algorithm

  x := linspace(0, L, N+1) ;

  annotation(Documentation(info = "
<html>
  <head>
    <title> uniformGrid </title>
  </head>
  
  <body>
    <p>
      This functions gives the position of the vertices that form segments. 
      The position is computes to insure an equal distance between all the vertices.
      The distance between vertices derives:
    </p>
    
    <img 
      src=\"modelica://TAeZoSysPro/Information/HeatTransfer/Functions/MeshGrid/EQ_uniformGrid.png\" 
    />
    
    <p>
      A mesh divided into N segments contains N+1 vertices. That is why the size of x is N+1.
    </p>    
        
  </body>  
</html>")) ;

end uniformGrid;
