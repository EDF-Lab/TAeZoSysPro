within TAeZoSysPro.FluidDynamics.BasesClasses.Tests;

model test_MolecularDiffusion
  TAeZoSysPro.FluidDynamics.BasesClasses.MolecularDiffusion molecularDiffusion(A = 1, Th = 0.1)  annotation(
    Placement(visible = true, transformation(origin = {-3.55271e-15, 3.55271e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  TAeZoSysPro.FluidDynamics.Sources.Atmosphere atmosphere(RH = 0)  annotation(
    Placement(visible = true, transformation(origin = {-80, 3.55271e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  TAeZoSysPro.FluidDynamics.Sources.Atmosphere atmosphere1(RH = 1)  annotation(
    Placement(visible = true, transformation(origin = {80, 0}, extent = {{20, -20}, {-20, 20}}, rotation = 0)));
equation
  connect(atmosphere.Flowport, molecularDiffusion.flowPort_a) annotation(
    Line(points = {{-80, 0}, {-22, 0}, {-22, 0}, {-20, 0}}, color = {0, 85, 255}));
  connect(molecularDiffusion.flowPort_b, atmosphere1.Flowport) annotation(
    Line(points = {{20, 0}, {82, 0}, {82, 0}, {80, 0}}, color = {0, 85, 255}));
end test_MolecularDiffusion;
