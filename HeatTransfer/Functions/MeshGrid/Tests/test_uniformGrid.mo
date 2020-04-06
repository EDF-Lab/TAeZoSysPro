within TAeZoSysPro.HeatTransfer.Functions.MeshGrid.Tests;

model test_uniformGrid

  parameter Modelica.SIunits.Length L = 1 "Length of the domain to mesh" ;
  parameter Integer N = 5 "number of segments" ;
  parameter Modelica.SIunits.Position x[:] = TAeZoSysPro.HeatTransfer.Functions.MeshGrid.uniformGrid(L = L, N = N);

equation

end test_uniformGrid;
