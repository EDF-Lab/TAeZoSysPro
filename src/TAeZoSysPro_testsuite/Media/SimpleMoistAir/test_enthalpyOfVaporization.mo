within TAeZoSysPro_testsuite.Media.SimpleMoistAir;

model test_enthalpyOfVaporization

  package Medium = Modelica.Media.Water.StandardWater;
  //
  Modelica.SIunits.Temperature T;
  Modelica.SIunits.SpecificEnergy h_lv;
  Modelica.SIunits.SpecificEnergy h_lv_check;
  Medium.SaturationProperties sat;
  Medium.ThermodynamicState dewState, bubbleState;

equation

  T = 273.16 + time;
  h_lv = TAeZoSysPro.Media.Air.MoistAir.enthalpyOfVaporization(T);
  sat = Medium.setSat_T(T);
  dewState = Medium.setDewState(sat);
  bubbleState = Medium.setBubbleState(sat);
  h_lv_check = dewState.h - bubbleState.h;

  annotation (
    Icon(coordinateSystem(preserveAspectRatio = false)),
    Diagram(
      coordinateSystem(preserveAspectRatio = false)),
    experiment(StartTime = 0, StopTime = 100, Tolerance = 1e-6, Interval = 0.2));

end test_enthalpyOfVaporization;
