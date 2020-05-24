within TAeZoSysPro.Aeraulic.Test;

model test_DiffusionCoeff

Modelica.SIunits.Temperature T ;
Modelica.SIunits.Pressure p ;
Modelica.SIunits.DiffusionCoefficient[2,2] D;
equation

T = 273.15 + time ;
p = 101325 ;

D = Media.SimpleDryAirH2.MolecularDiffusionCoeff(T = T, p = p) ;

end test_DiffusionCoeff;
