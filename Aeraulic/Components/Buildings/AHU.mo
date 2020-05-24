within TAeZoSysPro.Aeraulic.Components.Buildings;

model AHU
  package Medium = TAeZoSysPro.Aeraulic.Media.MyMedia;
  //
  parameter Modelica.SIunits.IsentropicExponent gamma = 1.4 "isentropic exponent" annotation(
    Dialog(group = "Fan"));
  parameter Modelica.SIunits.Efficiency n_is = 0.8 "isentropic efficiency" annotation(
    Dialog(group = "Fan"));
  parameter Real[:, :] Table "couple (Volume flow, pressure difference)" annotation(
    Dialog(group = "Fan"),
    HideResult = true);
  parameter Integer OrderPolyFitting = 3 "order of the polynome that fits the fan curve" annotation(
    Dialog(group = "Fan"));
  parameter Modelica.SIunits.Area crossArea "Inner cross section area" annotation(
    Dialog(group = "Geometry"));
  parameter Real K(unit = "Pa.s/m") = 0.0 "linear pressure loss coefficient for filter" annotation(
    Dialog(group = "Flow"));
  parameter Real ksi = 0.0 "quadratic pressure loss (filter not taken account)" annotation(
    Dialog(group = "Flow"));
  TAeZoSysPro.Aeraulic.Components.Machines.StaticFan staticFan1(OrderPolyFitting = OrderPolyFitting, Table = Table, n_is = n_is) annotation(
    Placement(visible = true, transformation(origin = {59, 1}, extent = {{-20.5, -20.5}, {20.5, 20.5}}, rotation = 0)));
  TAeZoSysPro.Aeraulic.Components.PressureLosses.Others.Filter filter1(K = K, crossArea = crossArea, filterBehavior = TAeZoSysPro.Aeraulic.Components.PressureLosses.Others.Filter.filterBehaviorModel.linear, ksi = 0.0) annotation(
    Placement(visible = true, transformation(origin = {-54, 1.88738e-15}, extent = {{-22, -22}, {22, 22}}, rotation = 0)));
  TAeZoSysPro.Aeraulic.Components.PressureLosses.Valves.Commissioningdamper commissioningdamper1(crossArea = crossArea, ksi = ksi, m_flow(fixed = false)) annotation(
    Placement(visible = true, transformation(origin = {6, 3.55271e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_a fluidport_in(replaceable package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-150, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_b fluidport_out(replaceable package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {148, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(fluidport_in, filter1.fluidport_a) annotation(
    Line(points = {{-100, 0}, {-78, 0}, {-78, 0}, {-76, 0}}));
  connect(staticFan1.fluidport_b, fluidport_out) annotation(
    Line(points = {{78, 16}, {100, 16}, {100, 0}, {100, 0}}, color = {0, 127, 255}));
  connect(commissioningdamper1.fluidport_b, staticFan1.fluidport_a) annotation(
    Line(points = {{26, 0}, {46, 0}, {46, 1}, {43, 1}}, color = {0, 127, 255}));
  connect(filter1.fluidport_b, commissioningdamper1.fluidport_a) annotation(
    Line(points = {{-32, 0}, {-12, 0}}, color = {0, 127, 255}));
  annotation(
    Icon(graphics = {Rectangle(origin = {-100, -4}, extent = {{-10, 70}, {10, -90}}), Line(origin = {-100.35, -14}, points = {{-9.64645, 80}, {10.3536, 60}, {-9.64645, 40}, {10.3536, 20}, {-9.64645, 0}, {10.3536, -20}, {-9.64645, -40}, {10.3536, -60}, {-9.64645, -80}}, thickness = 0.5), Rectangle(origin = {-24, -14}, extent = {{-30, 80}, {30, -80}}), Line(origin = {-28.6978, -27}, points = {{-29, 63}, {19, 63}, {27, 57}, {27, 49}, {19, 43}, {-9, 43}, {-17, 37}, {-17, 29}, {-9, 23}, {19, 23}, {27, 17}, {27, 9}, {19, 3}, {-9, 3}, {-17, -3}, {-17, -11}, {-9, -17}, {19, -17}, {27, -23}, {27, -31}, {19, -37}, {-29, -37}}, thickness = 0.5), Ellipse(origin = {60, -20}, extent = {{-30, 30}, {40, -40}}, endAngle = 360), Line(origin = {89, 1}, points = {{-23, 9}, {23, 9}, {23, -9}, {7, -9}}), Ellipse(lineThickness = 0.5, extent = {{34, 24}, {34, 24}}, endAngle = 360), Ellipse(lineThickness = 0.5, extent = {{36, 16}, {36, 16}}, endAngle = 360), Ellipse(lineThickness = 0.5, extent = {{40, 18}, {40, 18}}, endAngle = 360), Ellipse(lineThickness = 0.5, extent = {{16, 46}, {16, 46}}, endAngle = 360), Ellipse(lineThickness = 0.5, extent = {{18, 46}, {18, 46}}, endAngle = 360), Ellipse(lineThickness = 0.5, extent = {{32, -54}, {32, -54}}, endAngle = 360), Ellipse(origin = {80, -40}, extent = {{-30, 30}, {0, 0}}, endAngle = 360), Rectangle(lineThickness = 0.5, extent = {{-150, 100}, {150, -100}}), Polygon(origin = {81, 1}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-17, 9}, {15, 7}, {17, -9}, {7, -9}, {-17, 9}}), Line(origin = {103, 0}, points = {{-9, 0}, {27, 0}}, thickness = 0.5, arrow = {Arrow.None, Arrow.Open}, arrowSize = 7), Text(origin = {2, 85}, lineThickness = 0.5, extent = {{-52, 9}, {52, -9}}, textString = "AHU",  fontSize = 0 )}, coordinateSystem(extent = {{-150, -100}, {150, 100}})),
    __OpenModelica_commandLineOptions = "");
end AHU;
