within TAeZoSysPro.FluidDynamics.Components.Buildings;

model Wall
  //
  import Correlations = TAeZoSysPro.HeatTransfer.Types.FreeConvectionCorrelation ;
  import TAeZoSysPro.HeatTransfer.Types.Dynamics ;
  import TAeZoSysPro.HeatTransfer.Types.MeshGrid ;
  import MeshFunction = TAeZoSysPro.HeatTransfer.Functions.MeshGrid ;
  

//Media
  replaceable package Medium = TAeZoSysPro.Media.MyMedia ;
  // User defined parameters
  parameter MeshGrid mesh = MeshGrid.biotAndGeometricalGrowth "Selection of meshing function" annotation(
  Dialog(group="Meshing properties"));
  parameter Real q = 1.2 "Growth rate (if geometricalGrowth chosen)" annotation(
  Dialog(group="Meshing properties"));
  parameter Modelica.SIunits.CoefficientOfHeatTransfer h = 10 "Decoupled value of the heat transfer (if biot segment chosen)" annotation(
  Dialog(group="Meshing properties"));  
  parameter Integer N(min=1) = integer(max(1, 5 * Th / 0.2 * 1e-6 * d * cp / k)) "Number of layers : 1 to 65535" annotation(
  Dialog(group="Meshing properties"));
  
  parameter Modelica.SIunits.Area A = 0 "Wall area " annotation(
  Dialog(group="Geometrical properties"));
  parameter Modelica.SIunits.Height Lc = 0 "Wall characteristic length" annotation(
  Dialog(group="Geometrical properties"));
  parameter Modelica.SIunits.Length Th = 0 "Wall thickness" annotation(
  Dialog(group="Geometrical properties"));
  
  parameter Dynamics energyDynamics = Dynamics.SteadyStateInitial "Formulation of energy balance" annotation(
  Dialog(group="Dynamic properties"));
  parameter Modelica.SIunits.Temperature T_start = 293.15 "Start value for temperature, if energyDynamics = FixedInitial" annotation(
  Dialog(group="Dynamic properties"));
  
  parameter Modelica.SIunits.SpecificHeatCapacity cp = 0 "Wall specific heat capacity" annotation(
  Dialog(group="Thermal properties"));
  parameter Modelica.SIunits.Density d(displayUnit="kg/m3") = 0 "Wall density" annotation(
  Dialog(group="Thermal properties"));
  parameter Modelica.SIunits.ThermalConductivity k = 0 "Wall conductivity" annotation(
  Dialog(group="Thermal properties"));
  
  parameter Real add_on_conv = 1 "Custom add-on for convection" annotation(
    Dialog(group = "Convection properties"));
  parameter Real add_on_cond = 1 "Custom add-on for condensation" annotation(
    Dialog(group = "Convection properties"));
  parameter TAeZoSysPro.HeatTransfer.Types.FreeConvectionCorrelation correlation_a = Correlations.vertical_plate_ASHRAE "free convection Correlation" annotation(
    Dialog(group = "Convection properties"));
  parameter TAeZoSysPro.HeatTransfer.Types.FreeConvectionCorrelation correlation_b = if correlation_a == Correlations.ceiling_ASHRAE then Correlations.ground_ASHRAE elseif correlation_a == Correlations.ground_ASHRAE then Correlations.ceiling_ASHRAE else correlation_a "free convection Correlation" annotation(
    Dialog(group = "Convection properties"));
  parameter Modelica.SIunits.CoefficientOfHeatTransfer h_cv_const_a = 0 "constant heat transfer coefficient (optional: if correlation 'Constant' choosen)" annotation(
    Dialog(group = "Convection properties"));
  
  parameter Modelica.SIunits.CoefficientOfHeatTransfer h_cv_const_b = 0 "constant heat transfer coefficient (optional: if correlation 'Constant' choosen)" annotation(
    Dialog(group = "Convection properties"));
  //
  parameter Modelica.SIunits.Emissivity eps_a = 0 "Wall emissivity " annotation(
    Dialog(group = "Radiative properties"));
  parameter Modelica.SIunits.Emissivity eps_b = 0 "Wall emissivity " annotation(
    Dialog(group = "Radiative properties"));
  parameter Real add_on_rad = 1 "Custom add-on" annotation(
    Dialog(group = "Radiative properties"));

// Internal variables
  Modelica.SIunits.BiotNumber Bi_a, Bi_b ;

// Components inside wall are defined
  TAeZoSysPro.HeatTransfer.BasesClasses.PartialWall partialWall(A = A, N = N, T_start = T_start, Th = Th, cp = cp, d = d, energyDynamics = energyDynamics, h = h, k = k, mesh = mesh, q = q, symmetricalMesh = true) if N > 1  annotation(
    Placement(visible = true, transformation(origin = {0.5, 10.5}, extent = {{-29.5, -29.5}, {29.5, 29.5}}, rotation = 0)));
  TAeZoSysPro.FluidDynamics.BasesClasses.FreeConvection freeConvection_a(redeclare package Medium = Medium, A = A, Lc = Lc, add_on = add_on_conv, correlation = correlation_a, h_cv_const = h_cv_const_a) annotation(
    Placement(visible = true, transformation(origin = {-55, 70}, extent = {{-18, -18}, {18, 18}}, rotation = 180)));
  TAeZoSysPro.HeatTransfer.BasesClasses.CarrollRadiation carrollRadiation_a(A = A, add_on = add_on_rad, eps = eps_a)  annotation(
    Placement(visible = true, transformation(origin = {-59.5, -79.5}, extent = {{-19.5, -19.5}, {19.5, 19.5}}, rotation = 180)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a_rad annotation(
    Placement(visible = true, transformation(origin = {-101, -78}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-90, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput A_wall_a annotation(
    Placement(visible = true, transformation(origin = {-90, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 180), iconTransformation(origin = {-93, -53}, extent = {{-7, -7}, {7, 7}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput F_view_a annotation(
    Placement(visible = true, transformation(origin = {-90, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-93, -27}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  TAeZoSysPro.HeatTransfer.Interfaces.HeatPort_a port_surface_a annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-40, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  TAeZoSysPro.FluidDynamics.BasesClasses.FreeConvection freeConvection_b(redeclare package Medium = Medium, A = A, Lc = Lc, add_on = add_on_conv, correlation = correlation_b, h_cv_const = h_cv_const_b) annotation(
    Placement(visible = true, transformation(origin = {57, 70}, extent = {{18, -18}, {-18, 18}}, rotation = 180)));
  TAeZoSysPro.HeatTransfer.BasesClasses.CarrollRadiation carrollRadiation_b(A = A, add_on = add_on_rad, eps = eps_b) annotation(
    Placement(visible = true, transformation(origin = {59.5, -80.5}, extent = {{20.5, -20.5}, {-20.5, 20.5}}, rotation = 180)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port_b_rad annotation(
    Placement(visible = true, transformation(origin = {101, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {90, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput A_wall_b annotation(
    Placement(visible = true, transformation(origin = {90, -20}, extent = {{10, -10}, {-10, 10}}, rotation = 180), iconTransformation(origin = {93, -53}, extent = {{7, -7}, {-7, 7}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput F_view_b annotation(
    Placement(visible = true, transformation(origin = {90, -50}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {93, -27}, extent = {{7, -7}, {-7, 7}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port_surface_b annotation(
    Placement(visible = true, transformation(origin = {101, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {40, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
 TAeZoSysPro.FluidDynamics.Interfaces.FlowPort_a port_a(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-100, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-102, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
 TAeZoSysPro.FluidDynamics.Interfaces.FlowPort_b port_b(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {100, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {90, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
 TAeZoSysPro.FluidDynamics.BasesClasses.Condensation condensation_a(redeclare package Medium = Medium, A = A, add_on = add_on_cond, h_cv = freeConvection_a.h_cv)  annotation(
    Placement(visible = true, transformation(origin = {-55, 21}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
 TAeZoSysPro.FluidDynamics.BasesClasses.Condensation condensation_b(redeclare package Medium = Medium, A = A, add_on = add_on_cond, h_cv = freeConvection_b.h_cv)  annotation(
    Placement(visible = true, transformation(origin = {55, 21}, extent = {{15, -15}, {-15, 15}}, rotation = 0)));
  TAeZoSysPro.HeatTransfer.BasesClasses.HeatCapacitor heatCapacitor(T_start = T_start,cp = cp, energyDynamics = energyDynamics, m = Th * A * d) if N==1  annotation(
    Placement(visible = true, transformation(origin = {0, -70}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));

equation
 connect(port_a_rad, carrollRadiation_a.port_b) annotation(
    Line(points = {{-101, -78}, {-88, -78}, {-88, -79.5}, {-79, -79.5}}, color = {191, 0, 0}));

  if N > 1 then
    Bi_a = freeConvection_a.h_cv * (partialWall.x[2] - partialWall.x[1]) / k;
    Bi_b = freeConvection_b.h_cv * (partialWall.x[end] - partialWall.x[end-1]) / k;
  else
    Bi_a = 0.0;
    Bi_b = 0.0;    
  end if;

A_wall_a = A;
A_wall_b = A;
//output y is set to Awall and it can be connected to FviewCalculator
  connect(freeConvection_a.port_a, partialWall.port_a) annotation(
    Line(points = {{-36, 70}, {-28, 70}, {-28, 10.5}}, color = {191, 0, 0}));
 connect(carrollRadiation_a.port_a, partialWall.port_a) annotation(
    Line(points = {{-40, -79.5}, {-28, -79.5}, {-28, 10.5}}, color = {191, 0, 0}));
 connect(freeConvection_b.port_a, partialWall.port_b) annotation(
    Line(points = {{39, 70}, {28, 70}, {28, 10.5}, {29, 10.5}}, color = {191, 0, 0}));
 connect(carrollRadiation_b.port_a, partialWall.port_b) annotation(
    Line(points = {{39, -80.5}, {28, -80.5}, {28, 10.5}, {29, 10.5}}, color = {191, 0, 0}));
 connect(carrollRadiation_b.port_b, port_b_rad) annotation(
    Line(points = {{80, -80.5}, {92, -80.5}, {92, -80}, {101, -80}}, color = {191, 0, 0}));
 connect(port_surface_a, partialWall.port_a) annotation(
    Line(points = {{-100, 0}, {-28, 0}, {-28, 10.5}}, color = {191, 0, 0}));
 connect(port_surface_b, partialWall.port_b) annotation(
    Line(points = {{101, 0}, {27.5, 0}, {27.5, 10.5}, {29, 10.5}}, color = {191, 0, 0}));
 connect(F_view_a, carrollRadiation_a.Fview) annotation(
    Line(points = {{-90, -50}, {-44, -50}, {-44, -64}}, color = {0, 0, 127}));
 connect(F_view_b, carrollRadiation_b.Fview) annotation(
    Line(points = {{90, -50}, {44, -50}, {44, -64}, {43, -64}}, color = {0, 0, 127}));
 connect(condensation_a.heatPort, partialWall.port_a) annotation(
    Line(points = {{-41.5, 21}, {-28, 21}, {-28, 10.5}}, color = {191, 0, 0}));
 connect(port_a, freeConvection_a.port_b) annotation(
    Line(points = {{-100, 70}, {-74, 70}, {-74, 70}, {-72, 70}}, color = {0, 85, 255}));
 connect(port_a, condensation_a.flowPort) annotation(
    Line(points = {{-100, 70}, {-86, 70}, {-86, 21}, {-69, 21}}, color = {0, 85, 255}));
 connect(condensation_b.heatPort, partialWall.port_b) annotation(
    Line(points = {{41.5, 21}, {28, 21}, {28, 10.5}, {29, 10.5}}, color = {191, 0, 0}));
 connect(freeConvection_b.port_b, port_b) annotation(
    Line(points = {{74, 70}, {100, 70}, {100, 70}, {100, 70}}, color = {0, 85, 255}));
 connect(condensation_b.flowPort, port_b) annotation(
    Line(points = {{69, 21}, {88, 21}, {88, 70}, {100, 70}}, color = {0, 85, 255}));
  connect(freeConvection_a.port_a, heatCapacitor.port) annotation(
    Line(points = {{-36, 70}, {-28, 70}, {-28, -60}, {0, -60}}, color = {191, 0, 0}));
 connect(heatCapacitor.port, condensation_a.heatPort) annotation(
    Line(points = {{0, -60}, {-28, -60}, {-28, 21}, {-41.5, 21}}, color = {191, 0, 0}));
 connect(port_surface_a, heatCapacitor.port) annotation(
    Line(points = {{-100, 0}, {-28, 0}, {-28, -60}, {0, -60}}, color = {191, 0, 0}));
 connect(carrollRadiation_a.port_a, heatCapacitor.port) annotation(
    Line(points = {{-40, -79.5}, {-28, -79.5}, {-28, -60}, {0, -60}}, color = {191, 0, 0}));
 connect(freeConvection_b.port_a, heatCapacitor.port) annotation(
    Line(points = {{40, 70}, {28, 70}, {28, -60}, {0, -60}}, color = {191, 0, 0}));
 connect(condensation_b.heatPort, heatCapacitor.port) annotation(
    Line(points = {{41.5, 21}, {28, 21}, {28, -60}, {0, -60}}, color = {191, 0, 0}));
 connect(port_surface_b, heatCapacitor.port) annotation(
    Line(points = {{101, 0}, {28, 0}, {28, -60}, {0, -60}}, color = {191, 0, 0}));
 connect(carrollRadiation_b.port_a, heatCapacitor.port) annotation(
    Line(points = {{39, -80.5}, {28, -80.5}, {28, -60}, {0, -60}}, color = {191, 0, 0}));
  annotation(
    Diagram(graphics = {Rectangle(origin = {3.5, -1}, fillColor = {218, 218, 218}, fillPattern = FillPattern.Solid, lineThickness = 1, extent = {{-42.5, 101}, {36.5, -99}}), Text(origin = {2, 46}, extent = {{-20, 10}, {20, -10}}, textString = "If N > 1"), Text(origin = {2, -46}, extent = {{-20, 10}, {20, -10}}, textString = "If N = 1")}, coordinateSystem(initialScale = 0.1)),
    Icon(graphics = {Rectangle(origin = {11, 9}, fillColor = {191, 191, 191}, fillPattern = FillPattern.Cross, lineThickness = 1, extent = {{-51, 91}, {29, -109}}), Line(origin = {-70, 70.1389}, points = {{0, 30}, {0, -30}}, color = {0, 0, 255}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {-58, 70.1389}, points = {{0, 30}, {0, -30}}, color = {0, 0, 255}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {-61, 88.1389}, points = {{7, 0}, {-17, 0}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {-61, 54.14}, points = {{7, 0}, {-17, 0}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Text(origin = {-106, 93}, lineThickness = 1, extent = {{-14, 7}, {26, -13}}, textString = "Fluid"), Text(origin = {-93, -67}, lineThickness = 1, extent = {{-7, 7}, {13, -13}}, textString = "J_MRT"), Text(origin = {-73, -27}, lineThickness = 1, extent = {{-7, 7}, {13, -13}}, textString = "F_view_a"), Text(origin = {-73, -49}, lineThickness = 1, extent = {{-7, 7}, {13, -13}}, textString = "A_wall_a"), Line(origin = {-52.1559, -79.8606}, rotation = 180, points = {{-9, 0}, {-7, 0}, {-7, 4}, {-3, -4}, {1, 4}, {5, -4}, {9, 4}, {13, -4}, {13, 0}, {21, 0}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {-52.5726, -99.7217}, rotation = 180, points = {{-9, 0}, {-7, 0}, {-7, 4}, {-3, -4}, {1, 4}, {5, -4}, {9, 4}, {13, -4}, {13, 0}, {21, 0}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Text(origin = {67, -47}, lineThickness = 1, extent = {{-7, 7}, {13, -13}}, textString = "A_wall_b"), Text(origin = {67, -27}, lineThickness = 1, extent = {{-7, 7}, {13, -13}}, textString = "F_view_b"), Line(origin = {52.8486, -80.2659}, points = {{-9, 0}, {-7, 0}, {-7, 4}, {-3, -4}, {1, 4}, {5, -4}, {9, 4}, {13, -4}, {13, 0}, {21, 0}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {52.4319, -100.127}, points = {{-9, 0}, {-7, 0}, {-7, 4}, {-3, -4}, {1, 4}, {5, -4}, {9, 4}, {13, -4}, {13, 0}, {21, 0}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {68.8387, 69.7336}, points = {{0, 30}, {0, -30}}, color = {0, 0, 255}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {59.8387, 53.7336}, rotation = 180, points = {{7, 0}, {-17, 0}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {59.8387, 87.7336}, rotation = 180, points = {{7, 0}, {-17, 0}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {56.8387, 69.7336}, points = {{0, 30}, {0, -30}}, color = {0, 0, 255}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Text(origin = {94, 93}, lineThickness = 1, extent = {{-14, 7}, {26, -13}}, textString = "Fluid"), Text(origin = {87, -67}, lineThickness = 1, extent = {{-7, 7}, {13, -13}}, textString = "J_MRT"), Ellipse(origin = {-46, 88}, fillColor = {0, 85, 255}, fillPattern = FillPattern.Solid, extent = {{-4, 4}, {4, -4}}), Ellipse(origin = {-46, 70}, fillColor = {0, 85, 255}, fillPattern = FillPattern.Solid, extent = {{-4, 4}, {4, -4}}), Ellipse(origin = {-46, 52}, fillColor = {0, 85, 255}, fillPattern = FillPattern.Solid, extent = {{-4, 4}, {4, -4}}), Ellipse(origin = {46, 88}, fillColor = {0, 85, 255}, fillPattern = FillPattern.Solid, extent = {{-4, 4}, {4, -4}}), Ellipse(origin = {46, 70}, fillColor = {0, 85, 255}, fillPattern = FillPattern.Solid, extent = {{-4, 4}, {4, -4}}), Ellipse(origin = {46, 52}, fillColor = {0, 85, 255}, fillPattern = FillPattern.Solid, extent = {{-4, 4}, {4, -4}})}, coordinateSystem(initialScale = 0.1)),
    Documentation(info = "
<html>
  <head>
    <title>HalfWall</title>
	
    <style type=\"text/css\">
      *       { font-size: 10pt; font-family: Arial,sans-serif; }
      code    { font-size:  9pt; font-family: Courier,monospace;}
      h6      { font-size: 10pt; font-weight: bold; color: green; }
      h5      { font-size: 11pt; font-weight: bold; color: green; }
      h4      { font-size: 13pt; font-weight: bold; color: green; }
      address {                  font-weight: normal}
      td      { solid #000; vertical-align:top; }
      th      { solid #000; vertical-align:top; font-weight: bold; }
      table   { solid #000; border-collapse: collapse;}
    </style>	
  </head>
	
  <body lang=\"en-UK\">
  
    <p>
      This component models the thermal response of wall in interface with a rest ambiances where the thermal exchanges are mainly driven by natural convection, radiation and condensation.
    </p>
    
    <p>
      The suffix '..._a' refers to side where the ports 'port_a' are.
    </p>
        
        <p>		
      This component is an assembly of the <b>PartialWall</b> module, the <b>FreeConvection</b> modules, the <b>CarrollRadiation</b> modules and the <b>Condensation</b> modules. The solid wall is dicretises in <b>N</b> along its depth to model the heat propagation. By defaut the value of <b>N</b> is computed from the depth and the thermal diffusivty of the wall. </br>
      When the number of layers <b>N</b> is equal to one, the <b>PartialWall</b> is replaced by a <b>HeatCapacitor</b>.
    </p> 

    <p>		
      Ports name <b>port_surface</b> are connected to boundary ports of the <b>PartialWall</b>.
      It can be usefull for specific applications when another modules is required et can be latter connected to this empty heat port.
    </p>

    <p>			
      The Wall supplies as output the surface area of the wall, via its <b>A_wall</b> ports, to the FviewCalculator module and get from this last the form (or view) factor as input via the <b>F_view</b> ports. The connection is performed explicitely via the graphic connectors. 
    </p>					
  </body>
</html>"),
    experiment(StartTime = 0, StopTime = 3600, Tolerance = 1e-06, Interval = 36));

end Wall;