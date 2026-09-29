within TAeZoSysPro_testsuite.HeatTransfer.Functions.MeshGrid;

model test_uniformGrid

  parameter Modelica.SIunits.Length L = 1 "Length of the domain to mesh" ;
  parameter Integer N = 5 "number of segments" ;
  parameter Modelica.SIunits.Position x[:] = TAeZoSysPro.HeatTransfer.Functions.MeshGrid.uniformGrid(L = L, N = N);

equation

annotation(
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-6, Interval = 0.002));
end test_uniformGrid;