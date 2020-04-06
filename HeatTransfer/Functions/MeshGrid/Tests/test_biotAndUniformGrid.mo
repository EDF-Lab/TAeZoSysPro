within TAeZoSysPro.HeatTransfer.Functions.MeshGrid.Tests;

model test_biotAndUniformGrid

  parameter Modelica.SIunits.Length L = 1 "Length of the domain to mesh" ;
  parameter Integer N = 5 "number of segments" ;
  parameter Modelica.SIunits.CoefficientOfHeatTransfer h = 10 ;
  parameter Modelica.SIunits.ThermalConductivity k = 1 ;  
  parameter Modelica.SIunits.Position x[:] =  TAeZoSysPro.HeatTransfer.Functions.MeshGrid.biotAndUniformGrid(L = L, 
                                                               N = N, 
                                                               h = h, 
                                                               k = k,
                                                               symmetricalMesh = false);
  parameter Modelica.SIunits.Position x2[:] =  TAeZoSysPro.HeatTransfer.Functions.MeshGrid.biotAndUniformGrid(L = L, 
                                                               N = N, 
                                                               h = h, 
                                                               k = k,
                                                               symmetricalMesh =  true);
  
equation

end test_biotAndUniformGrid;
