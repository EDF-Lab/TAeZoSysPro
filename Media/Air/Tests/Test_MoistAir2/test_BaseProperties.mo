within TAeZoSysPro.Media.Air.Tests.Test_MoistAir2;
model test_BaseProperties

TAeZoSysPro.Media.Air.MoistAir2.BaseProperties medium;

equation

  medium.d = 1.2;
  medium.T = 293.15;
  medium.Xi = {0.01}
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));

end test_BaseProperties;
