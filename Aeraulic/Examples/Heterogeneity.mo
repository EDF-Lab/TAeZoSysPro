within TAeZoSysPro.Aeraulic.Examples;

model Heterogeneity
  parameter Modelica.SIunits.Length L = 4201 ^ (1 / 3);
  parameter Modelica.SIunits.CrossSection crossSection = L ^ 2;
  parameter Modelica.SIunits.Volume roomVolume = L ^ 3;
  //
  TAeZoSysPro.Aeraulic.BasesClasses.GasNode RoomTopLeft(V = roomVolume, n_ports = 2, pstart(displayUnit = "Pa")) annotation(
    Placement(visible = true, transformation(origin = {-57, 47}, extent = {{25, -25}, {-25, 25}}, rotation = 0)));
  BasesClasses.GasNode RoomTopRight(V = roomVolume, n_ports = 1, pstart(displayUnit = "Pa")) annotation(
    Placement(visible = true, transformation(origin = {55, 45}, extent = {{-25, -25}, {25, 25}}, rotation = 0)));
  BasesClasses.GasNode RoomBottomRight(Tstart = 294.15, V = roomVolume, n_ports = 2) annotation(
    Placement(visible = true, transformation(origin = {55, -55}, extent = {{-25, -25}, {25, 25}}, rotation = 0)));
  Components.PressureLosses.Orifices.VerticalOpening VerticalOpening_Top(Ae = crossSection, H = L) annotation(
    Placement(visible = true, transformation(origin = {-3.55271e-15, 62}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Components.PressureLosses.Orifices.VerticalOpening VerticalOpeningBottom(Ae = crossSection, H = L) annotation(
    Placement(visible = true, transformation(origin = {-3.55271e-15, -34}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  TAeZoSysPro.Aeraulic.Sources.Atmosphere AtmosphereExhaust(HR_out = 0.8, p_out = 101300) annotation(
    Placement(visible = true, transformation(origin = {-150, -54}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  TAeZoSysPro.Aeraulic.Components.PressureLosses.Orifices.VerticalOpening VerticalOpeningExhaust(Ae = crossSection, Cd = 1, H = 0.5) annotation(
    Placement(visible = true, transformation(origin = {-110, -54}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  BasesClasses.GasNode RoomBottomLeft(Tstart = 295.15, V = roomVolume, n_ports = 1) annotation(
    Placement(visible = true, transformation(origin = {-55, -55}, extent = {{25, -25}, {-25, 25}}, rotation = 0)));
  TAeZoSysPro.Aeraulic.Sources.Atmosphere atmosphere1(T_out = 313.15)  annotation(
    Placement(visible = true, transformation(origin = {-120, 122}, extent = {{20, -20}, {-20, 20}}, rotation = 0)));
  TAeZoSysPro.Aeraulic.Components.PressureLosses.Orifices.HorizontalOpening ApertureLeft(Ae = L ^ 2) annotation(
    Placement(visible = true, transformation(origin = {-60, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  TAeZoSysPro.Aeraulic.Components.PressureLosses.Orifices.HorizontalOpening ApertureRight(Ae = 1) annotation(
    Placement(visible = true, transformation(origin = {60, 3.55271e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  TAeZoSysPro.Aeraulic.Components.Machines.BasicVolumetricFanAeraulic Fan(Use_inlet_flowrate = true)  annotation(
    Placement(visible = true, transformation(origin = {-121.75, 61}, extent = {{-16.25, -13}, {16.25, 13}}, rotation = -90)));
  Modelica.Blocks.Sources.Constant VolumeFlowRate(k = 1)  annotation(
    Placement(visible = true, transformation(origin = {-70, 90}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
equation
  connect(ApertureLeft.Flowport_a, RoomTopLeft.Flowport) annotation(
    Line(points = {{-60, 12}, {-20, 12}, {-20, 47}, {-57, 47}}, color = {0, 85, 255}));
  connect(VerticalOpening_Top.Flowport_a, RoomTopLeft.Flowport) annotation(
    Line(points = {{-8, 62}, {-20, 62}, {-20, 47}, {-57, 47}}, color = {0, 85, 255}));
  connect(Fan.Flowport_b, RoomTopLeft.Flowport) annotation(
    Line(points = {{-122, 48}, {-122, 44}, {-57, 44}, {-57, 47}}, color = {0, 85, 255}));
  connect(atmosphere1.Flowport, Fan.Flowport_a) annotation(
    Line(points = {{-120, 122}, {-150, 122}, {-150, 74}, {-122, 74}, {-122, 74}}, color = {0, 85, 255}));
  connect(VolumeFlowRate.y, Fan.u) annotation(
    Line(points = {{-82, 90}, {-112, 90}, {-112, 74}, {-112, 74}}, color = {0, 0, 127}));
  connect(VerticalOpeningExhaust.Flowport_b, RoomBottomLeft.Flowport) annotation(
    Line(points = {{-104, -54}, {-54, -54}, {-54, -54}, {-54, -54}}, color = {0, 85, 255}));
  connect(AtmosphereExhaust.Flowport, VerticalOpeningExhaust.Flowport_a) annotation(
    Line(points = {{-150, -54}, {-118, -54}, {-118, -54}, {-118, -54}}, color = {0, 85, 255}));
  connect(ApertureRight.Flowport_b, RoomBottomRight.Flowport) annotation(
    Line(points = {{60, -12}, {20, -12}, {20, -54}, {56, -54}, {56, -54}}, color = {0, 85, 255}));
  connect(ApertureRight.Flowport_a, RoomTopRight.Flowport) annotation(
    Line(points = {{60, 12}, {20, 12}, {20, 46}, {56, 46}, {56, 46}}, color = {0, 85, 255}));
  connect(VerticalOpening_Top.Flowport_b, RoomTopRight.Flowport) annotation(
    Line(points = {{6, 62}, {20, 62}, {20, 46}, {56, 46}, {56, 46}}, color = {0, 85, 255}));
  connect(ApertureLeft.Flowport_b, RoomBottomLeft.Flowport) annotation(
    Line(points = {{-60, -12}, {-20, -12}, {-20, -54}, {-54, -54}, {-54, -54}}, color = {0, 85, 255}));
  connect(VerticalOpeningBottom.Flowport_b, RoomBottomRight.Flowport) annotation(
    Line(points = {{6, -34}, {20, -34}, {20, -54}, {56, -54}, {56, -54}}, color = {0, 85, 255}));
  connect(RoomBottomLeft.Flowport, VerticalOpeningBottom.Flowport_a) annotation(
    Line(points = {{-54, -54}, {-20, -54}, {-20, -34}, {-8, -34}, {-8, -34}}, color = {0, 85, 255}));
  annotation(
    experiment(StartTime = 0, StopTime = 4000, Tolerance = 1e-06, Interval = 4),
    Diagram(coordinateSystem(extent = {{-150, -150}, {150, 150}})),
    Icon(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -100}, {100, 100}}), graphics = {Ellipse(lineColor = {75, 138, 73}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, -100}, {100, 100}}), Polygon(lineColor = {0, 0, 255}, fillColor = {75, 138, 73}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-36, 60}, {64, 0}, {-36, -60}, {-36, 60}})}),
    __OpenModelica_commandLineOptions = "");
end Heterogeneity;
