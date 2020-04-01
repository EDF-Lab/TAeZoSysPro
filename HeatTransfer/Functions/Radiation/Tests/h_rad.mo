within TAeZoSysPro.HeatTransfer.Functions.Radiation.Tests;

model h_rad

  parameter Modelica.SIunits.Temperature T_A = 303.15 ;
  parameter Modelica.SIunits.Temperature T_B = 283.15 ;
  constant Modelica.SIunits.Emissivity eps = 1 ;
  Modelica.SIunits.CoefficientOfHeatTransfer h_rad, h_rad_check ;

equation

  h_rad = Radiation.h_rad(T_A = T_A, T_B = T_B, R_th = 1/eps) ;
  h_rad_check = eps * Modelica.Constants.sigma * (T_A^4 - T_B^4) / (T_A - T_B)  ; 

annotation(
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-6, Interval = 0.002));

end h_rad;
