within TAeZoSysPro.HeatTransfer.Components;

model HalfWall
  //
  import Correlations = TAeZoSysPro.HeatTransfer.Types.FreeConvectionCorrelation ;
  import TAeZoSysPro.HeatTransfer.Types.Dynamics ;
  import TAeZoSysPro.HeatTransfer.Types.MeshGrid ;
  import MeshFunction = TAeZoSysPro.HeatTransfer.Functions.MeshGrid ;
  
  outer TAeZoSysPro.HeatTransfer.Components.FviewCalculator fviewCalculator if UseImplicitConnection ;

//Media
  replaceable package Medium = Modelica.Media.Air.ReferenceAir.Air_pT ;
  // User defined parameters
  parameter MeshGrid mesh = MeshGrid.biotAndGeometricalGrowth "Selection of meshing function" annotation(
  Dialog(group="Meshing properties"));
  parameter Real q = 1.2 "Growth rate (if geometricalGrowth chosen)" annotation(
  Dialog(group="Meshing properties"));
  parameter Modelica.SIunits.CoefficientOfHeatTransfer h = 10 "Decoupled value of the heat transfer (if biot segment chosen)" annotation(
  Dialog(group="Meshing properties"));  
  parameter Integer N(min=2) = integer(max(2, 5 * Th / 0.2 * 1e-6 * d * cp / k)) "Number of layers : 2 to 65535" annotation(
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
  parameter Modelica.SIunits.Density d = 0 "Wall density" annotation(
  Dialog(group="Thermal properties"));
  parameter Modelica.SIunits.ThermalConductivity k = 0 "Wall conductivity" annotation(
  Dialog(group="Thermal properties"));
  
  parameter Real add_on_conv(unit = "R+") = 1 "Custom add-on" annotation(
    Dialog(group = "Convection properties"));
  parameter TAeZoSysPro.HeatTransfer.Types.FreeConvectionCorrelation correlation = Correlations.vertical_plate_ASHRAE "free convection Correlation" annotation(
    Dialog(group = "Convection properties"));
  parameter Modelica.SIunits.CoefficientOfHeatTransfer h_cv_const = 0 "constant heat transfer coefficient (optional: if correlation 'Constant' choosen)" annotation(
    Dialog(group = "Convection properties"));
  //
  parameter Boolean UseImplicitConnection = true "Implicit connection with the FviewCalculator" annotation(
    Dialog(group = "Radiative properties"));
  parameter Integer RadiativeIndex = 1 "Index number in the FviewCalculator module" annotation(
    Dialog(group = "Radiative properties"));
  parameter Modelica.SIunits.Emissivity eps = 0 "Wall emissivity " annotation(
    Dialog(group = "Radiative properties"));
  parameter Real add_on_rad(unit = "R+") = 1 "Custom add-on" annotation(
    Dialog(group = "Radiative properties"));

// Internal variables
  Modelica.SIunits.BiotNumber Bi ;

// Components inside wall are defined
  TAeZoSysPro.HeatTransfer.BasesClasses.PartialWall partialWall(A = A, N = N, T_start = T_start, Th = Th, cp = cp, d = d, energyDynamics = energyDynamics, h = h, k = k, mesh = mesh, q = q)  annotation(
    Placement(visible = true, transformation(origin = {6.5, 0.5}, extent = {{-29.5, -29.5}, {29.5, 29.5}}, rotation = 0)));
  TAeZoSysPro.HeatTransfer.BasesClasses.FreeConvection convection(replaceable package Medium = Medium, A = A, Lc = Lc, add_on = add_on_conv, correlation = correlation, h_cv_const = h_cv_const) annotation(
    Placement(visible = true, transformation(origin = {-47, 70}, extent = {{-18, -18}, {18, 18}}, rotation = 180)));
  TAeZoSysPro.HeatTransfer.BasesClasses.CarrollRadiation carrollRadiation(A = A, add_on = add_on_rad, eps = eps)  annotation(
    Placement(visible = true, transformation(origin = {-56.5, -70.5}, extent = {{-22.5, -22.5}, {22.5, 22.5}}, rotation = 180)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a_conv annotation(
    Placement(visible = true, transformation(origin = {-101, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-90, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a_rad annotation(
    Placement(visible = true, transformation(origin = {-101, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-90, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput A_wall annotation(
    Placement(visible = true, transformation(origin = {-92, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 180), iconTransformation(origin = {-93, -53}, extent = {{-7, -7}, {7, 7}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput F_view annotation(
    Placement(visible = true, transformation(origin = {-90, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-93, -27}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port_b annotation(
    Placement(visible = true, transformation(origin = {99, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  TAeZoSysPro.HeatTransfer.Interfaces.HeatPort_a port_surface annotation(
    Placement(visible = true, transformation(origin = {-100, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-40, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(port_surface, partialWall.port_a) annotation(
    Line(points = {{-100, 30}, {-22, 30}, {-22, 0}, {-22, 0}}, color = {191, 0, 0}));
  connect(port_a_conv, convection.port_b) annotation(
    Line(points = {{-101, 70}, {-65, 70}}, color = {191, 0, 0}));
  connect(convection.port_a, partialWall.port_a) annotation(
    Line(points = {{-29, 70}, {-22, 70}, {-22, 0}}, color = {191, 0, 0}));
  connect(F_view, carrollRadiation.Fview) annotation(
    Line(points = {{-90, -30}, {-38.5, -30}, {-38.5, -52.5}}, color = {0, 0, 127}));
  connect(port_a_rad, carrollRadiation.port_b) annotation(
    Line(points = {{-101, -70}, {-88, -70}, {-88, -70.5}, {-79, -70.5}}, color = {191, 0, 0}));
  connect(carrollRadiation.port_a, partialWall.port_a) annotation(
    Line(points = {{-34, -70.5}, {-22, -70.5}, {-22, 0}}, color = {191, 0, 0}));
  connect(partialWall.port_b, port_b) annotation(
    Line(points = {{36, 0}, {98, 0}, {98, 0}, {100, 0}}, color = {191, 0, 0}));

  Bi = convection.h_cv*(partialWall.x[2]-partialWall.x[1]) / k ;
  
  if UseImplicitConnection then
    F_view = fviewCalculator.F_view[RadiativeIndex] ;
    fviewCalculator.A_wall[RadiativeIndex] = A ;
  end if ;

A_wall = A;    //output y is set to Awall and it can be connected to FviewCalculator

  annotation(
    Diagram(graphics = {Rectangle(origin = {3.5, -1}, fillColor = {218, 218, 218}, fillPattern = FillPattern.Solid, lineThickness = 1, extent = {{-42.5, 101}, {36.5, -99}})}),
    Icon(graphics = {Rectangle(origin = {11, 9}, fillColor = {191, 191, 191}, fillPattern = FillPattern.Cross, lineThickness = 1, extent = {{-51, 91}, {29, -109}}), Line(origin = {-70, 70.1389}, points = {{0, 30}, {0, -30}}, color = {0, 0, 255}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {-52, 70.1389}, points = {{0, 30}, {0, -30}}, color = {0, 0, 255}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {-61, 88.1389}, points = {{17, 0}, {-17, 0}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {-61, 54.1389}, points = {{17, 0}, {-17, 0}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Text(origin = {-95, 95}, lineThickness = 1, extent = {{-7, 7}, {15, -9}}, textString = "Fluid", fontSize = 8), Text(origin = {-93, -67}, lineThickness = 1, extent = {{-7, 7}, {13, -13}}, textString = "J_MRT", fontSize = 8), Text(origin = {-73, -25}, lineThickness = 1, extent = {{-7, 7}, {13, -13}}, textString = "F_view"), Text(origin = {-73, -49}, lineThickness = 1, extent = {{-7, 7}, {13, -13}}, textString = "A_wall"), Line(origin = {-52.1559, -79.8606}, rotation = 180, points = {{-9, 0}, {-7, 0}, {-7, 4}, {-3, -4}, {1, 4}, {5, -4}, {9, 4}, {13, -4}, {13, 0}, {21, 0}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {-52.5726, -99.7217}, rotation = 180, points = {{-9, 0}, {-7, 0}, {-7, 4}, {-3, -4}, {1, 4}, {5, -4}, {9, 4}, {13, -4}, {13, 0}, {21, 0}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.None, Arrow.Filled})}, coordinateSystem(initialScale = 0.1)),
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
      This component models the thermal response of half wall in interface with a rest ambiance where the thermal exchanges are mainly driven by natural convection and radiation.
    </p>
    
    <p>		
      This component is an assembly of the <b>PartialWall</b> module, the <b>FreeConvection</b> module and a <b>CarrollRadiation</b> module.
    </p> 

    <p>		
      To remain a generic as possible, a heatport directly connected to the first discrete layer of the wall has been added. For specific applications, The ForcedConvection module or another module for modeliing radiation can be latter connected to this empty heat port when implementing the HalfWall 
    </p>

    <p>			
      For the <b>CarrollRadiation</b> module, the HalfWall module proposes two approaches for passing information about the form factor.
	
      <h4> Explicit connection: <b>UseImplicitConnection = false</b> </h4>
    
      The HalfWall supplies as output the surface area of the wall, via its ports, to the FviewCalculator module and get from this last the Fview as input. 
      The connection is performed explicitely via the graphic connector. 
      The <b>RadiativeIndex</b> parameter is not evaluated. 
      The explicit method is longer and is source of mistakes when manually selecting the index of the connection. 
			
      <h4> Implicit connection: <b>UseImplicitConnection = true</b> </h4>
    
      The implicit connection use the <b>inner</b> and <b>outer</b> key word to perform the passage of information. 
      The ports <b>Awall</b> and <b>Fview</b> have to remains without connection. 
      The <b>FviewCalculator</b> is declared as outer within the HalfWall module. 
      The equations corresponding to the 'connect' with graphic connection are done explicitely in the equation section.
      To connect severals walls to the FviewCalculator, a <b>RadiativeIndex</b> is added. 
      The value of raditave index corresponds to the index of the current wall in the FviewCalculator. 
      Therefore, each wall needs to have a different RadiativeIndex.
    </p>				
  </body>
</html>"),
    experiment(StartTime = 0, StopTime = 3600, Tolerance = 1e-06, Interval = 36));

end HalfWall;
