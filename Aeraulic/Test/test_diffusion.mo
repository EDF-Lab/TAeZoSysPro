within TAeZoSysPro.Aeraulic.Test;

model test_diffusion
  TAeZoSysPro.Aeraulic.Sources.Atmosphere atmosphere1(replaceable package Medium = Media.SimpleDryAirH2, VolH2 = 5) annotation(
    Placement(visible = true, transformation(origin = {-80, 56}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  TAeZoSysPro.Aeraulic.Sources.Atmosphere atmosphere2(replaceable package Medium = Media.SimpleDryAirH2) annotation(
    Placement(visible = true, transformation(origin = {60, 56}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  TAeZoSysPro.Aeraulic.BasesClasses.MolecularDiffusion molecularDiffusion1(A = 100)  annotation(
    Placement(visible = true, transformation(origin = {0, 56}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  TAeZoSysPro.Aeraulic.BasesClasses.GasNode gasNode1(replaceable package Medium = Media.SimpleDryAirH2, VolH2 = 5)  annotation(
    Placement(visible = true, transformation(origin = {-74, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  TAeZoSysPro.Aeraulic.BasesClasses.GasNode gasNode2 annotation(
    Placement(visible = true, transformation(origin = {60, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  TAeZoSysPro.Aeraulic.BasesClasses.MolecularDiffusion molecularDiffusion2(A = 100)  annotation(
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  TAeZoSysPro.Aeraulic.BasesClasses.GasNode gasNode3(VolH2 = 5) annotation(
    Placement(visible = true, transformation(origin = {-74, -42}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  TAeZoSysPro.Aeraulic.BasesClasses.MolecularDiffusion molecularDiffusion3(A = 100) annotation(
    Placement(visible = true, transformation(origin = {0, -42}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  TAeZoSysPro.Aeraulic.BasesClasses.GasNode gasNode4 annotation(
    Placement(visible = true, transformation(origin = {60, -42}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  TAeZoSysPro.Aeraulic.Components.PressureLosses.Orifices.SimpleOpening simpleOpening1(Ae = 100)  annotation(
    Placement(visible = true, transformation(origin = {0, -72}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));  equation
  connect(simpleOpening1.Flowport_b, gasNode4.Flowport) annotation(
    Line(points = {{5, -72}, {34, -72}, {34, -42}, {60, -42}}, color = {0, 85, 255}));
  connect(gasNode3.Flowport, simpleOpening1.Flowport_a) annotation(
    Line(points = {{-74, -42}, {-38, -42}, {-38, -72}, {-5, -72}}, color = {0, 85, 255}));
  connect(molecularDiffusion3.flowPort_b, gasNode4.Flowport) annotation(
    Line(points = {{10, -42}, {60, -42}, {60, -42}, {60, -42}}, color = {0, 85, 255}));
  connect(gasNode3.Flowport, molecularDiffusion3.flowPort_a) annotation(
    Line(points = {{-74, -42}, {-10, -42}, {-10, -42}, {-10, -42}}, color = {0, 85, 255}));
  connect(molecularDiffusion2.flowPort_b, gasNode2.Flowport) annotation(
    Line(points = {{10, 0}, {60, 0}, {60, 0}, {60, 0}}, color = {0, 85, 255}));
  connect(gasNode1.Flowport, molecularDiffusion2.flowPort_a) annotation(
    Line(points = {{-74, 0}, {-10, 0}}, color = {0, 85, 255}));
  connect(molecularDiffusion1.flowPort_b, atmosphere2.Flowport) annotation(
    Line(points = {{10, 56}, {60, 56}, {60, 56}, {60, 56}}, color = {0, 85, 255}));
  connect(atmosphere1.Flowport, molecularDiffusion1.flowPort_a) annotation(
    Line(points = {{-80, 56}, {-10, 56}, {-10, 56}, {-10, 56}}, color = {0, 85, 255}));  end test_diffusion;
