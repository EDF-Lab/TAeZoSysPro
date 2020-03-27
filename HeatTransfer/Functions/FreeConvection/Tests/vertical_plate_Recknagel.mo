within TAeZoSysPro.HeatTransfer.Functions.FreeConvection.Tests;

model vertical_plate_Recknagel
  parameter Modelica.SIunits.Temperature T_ref = 283.15 "Reference temperature";
  Modelica.SIunits.Temperature T_mean "Mean temperature between plate and fluid";
  Modelica.SIunits.TemperatureDifference dT "Difference temperature between plate and fluid";
  Modelica.SIunits.CoefficientOfHeatTransfer h_cv "Convective heat transfer coefficient";
  
equation

  dT = time;
  T_mean = T_ref + dT / 2;
  h_cv = Functions.FreeConvection.vertical_plate_Recknagel(dT = dT, T_mean = T_mean);
  
  annotation(
    experiment(StartTime = 0, StopTime = 20, Tolerance = 1e-06, Interval = 0.2));

end vertical_plate_Recknagel;
