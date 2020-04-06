within TAeZoSysPro.HeatTransfer.Functions.MeshGrid.Tests;

model test_geometricalGrowthGrid

  parameter Modelica.SIunits.Length L = 1 "Length of the domain to mesh" ;
  parameter Integer N_odd = 5 "Odd number of segments" ;
  parameter Integer N_even = 6 "Even number of segments" ;
  parameter Modelica.SIunits.Position x[:] = TAeZoSysPro.HeatTransfer.Functions.MeshGrid.geometricalGrowthGrid(L = L, 
                                                                  N = N_odd, 
                                                                  q = 1.2,
                                                                  symmetricalMesh = false);
  parameter Modelica.SIunits.Position x_sym_odd[:] = TAeZoSysPro.HeatTransfer.Functions.MeshGrid.geometricalGrowthGrid(L = L, 
                                                                  N = N_odd, 
                                                                  q = 1.2,
                                                                  symmetricalMesh = true);

  parameter Modelica.SIunits.Position x_sym_even[:] = TAeZoSysPro.HeatTransfer.Functions.MeshGrid.geometricalGrowthGrid(L = L, 
                                                                  N = N_even, 
                                                                  q = 1.2,
                                                                  symmetricalMesh = true);
                                                                  
equation


end test_geometricalGrowthGrid ;
