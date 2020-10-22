within TAeZoSysPro.HeatTransfer.Components;

model CabinetPower
  import Correlations = TAeZoSysPro.HeatTransfer.Types.FreeConvectionCorrelation ;
  import TAeZoSysPro.HeatTransfer.Types.Dynamics ;
    // Media
  replaceable package Medium = TAeZoSysPro.Media.MyMedia ;
  // User defined temperature
  parameter Dynamics energyDynamics = Dynamics.SteadyStateInitial "Formulation of energy balance" annotation(
  Dialog(group="Dynamic properties"));
  parameter Modelica.SIunits.Temperature T_start = 293.15 "Start value for temperature, if energyDynamics = FixedInitial" annotation(
  Dialog(group="Dynamic properties"));
  //
  parameter Modelica.SIunits.Area A_conv_emitter = 0 "Convection area emitter" annotation(
    Dialog(group = "Emitter"));
  parameter Modelica.SIunits.Area A_rad_emitter = 0 "Radiative area emitter" annotation(
    Dialog(group = "Emitter"));
  parameter Modelica.SIunits.Height Lc_emitter = 0 "Characteristic length emitter for convection correlation" annotation(
    Dialog(group = "Emitter"));
  parameter Modelica.SIunits.SpecificHeatCapacity cp_emitter = 0 "Specific heat capacity of emitter" annotation(
    Dialog(group = "Emitter"));
  parameter Modelica.SIunits.Mass m_emitter = 0 "Mass of emitter" annotation(
    Dialog(group = "Emitter"));
  parameter Modelica.SIunits.Emissivity eps_emitter = 1 "Emitter emissivity" annotation(
    Dialog(group = "Emitter"));
  //
  parameter Modelica.SIunits.Area A_in_casing = 0 "Inner area of casing" annotation(
    Dialog(group = "Assembly"));
  parameter Modelica.SIunits.Area A_conv_casing = 0 "Convection outer area of casing" annotation(
    Dialog(group = "Assembly"));
  parameter Modelica.SIunits.Area A_rad_casing = 0 "Radiative outer area of casing" annotation(
    Dialog(group = "Assembly"));
  parameter Modelica.SIunits.Height Lc_casing = 0 "Characteristic length of casing" annotation(
    Dialog(group = "Assembly"));
  parameter Modelica.SIunits.SpecificHeatCapacity cp_casing  = 0 "Specific heat capacity of assembly" annotation(
    Dialog(group = "Assembly"));
  parameter Modelica.SIunits.Mass m_casing  = 0 "Mass of Casing" annotation(
    Dialog(group = "Assembly"));
  parameter Modelica.SIunits.Emissivity eps_casing = 1 "Casing emissivity" annotation(
    Dialog(group = "Assembly"));
  // Internal variables
  Modelica.SIunits.Energy E_released "Energy released into the environement";
  // Imported modules
  Modelica.Thermal.HeatTransfer.Components.BodyRadiation radiation_emitter_casing(Gr = A_conv_emitter / (1 / eps_emitter + A_conv_emitter / A_in_casing * (1 / eps_casing - 1)))  annotation(
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  TAeZoSysPro.HeatTransfer.BasesClasses.CarrollRadiation radiation_outer_casing(A = A_rad_casing, eps = eps_casing)   annotation(
    Placement(visible = true, transformation(origin = {60, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port_conv "To air thermal mass" annotation(
    Placement(visible = true, transformation(origin = {102, 28}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {102, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port_rad "To J MRT" annotation(
    Placement(visible = true, transformation(origin = {102, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-102, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port_hood annotation(
    Placement(visible = true, transformation(origin = {48, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {1, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput F_view annotation(
    Placement(visible = true, transformation(origin = {107, -34}, extent = {{-20, -20}, {20, 20}}, rotation = 180), iconTransformation(origin = {-99, 79}, extent = {{-11, -11}, {11, 11}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput A_wall annotation(
    Placement(visible = true, transformation(origin = {109, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-102, 34}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  TAeZoSysPro.HeatTransfer.BasesClasses.HeatCapacitor mass_emitter(T_start = T_start, cp = cp_emitter,energyDynamics = energyDynamics, m = m_emitter)   annotation(
    Placement(visible = true, transformation(origin = {-57, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput Heatload_Variable annotation(
    Placement(visible = true, transformation(origin = {-115, 16}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-1.9984e-15, -100}, extent = {{-20, -20}, {20, 20}}, rotation = 90)));
  TAeZoSysPro.HeatTransfer.BasesClasses.HeatCapacitor mass_casing(T_start = T_start, cp = cp_casing, energyDynamics = energyDynamics, m = m_casing)   annotation(
    Placement(visible = true, transformation(origin = {31, -28}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor Inlet_Air_Temperature annotation(
    Placement(visible = true, transformation(origin = {59.5, 49.5}, extent = {{-5.5, -5.5}, {5.5, 5.5}}, rotation = 180)));
  TAeZoSysPro.HeatTransfer.BasesClasses.FreeConvection_dT_decoupled convection_emitter(replaceable package Medium = Medium, A = A_conv_emitter, Lc = Lc_emitter, correlation = TAeZoSysPro.HeatTransfer.Types.FreeConvectionCorrelation.vertical_plate_ASHRAE) annotation(
    Placement(visible = true, transformation(origin = {-57, 64}, extent = {{-10, 10}, {10, -10}}, rotation = 90)));
  TAeZoSysPro.HeatTransfer.BasesClasses.FreeConvection_dT_decoupled convection_inner_casing(replaceable package Medium = Medium, A = A_in_casing, Lc = Lc_casing, correlation = TAeZoSysPro.HeatTransfer.Types.FreeConvectionCorrelation.vertical_plate_ASHRAE) annotation(
    Placement(visible = true, transformation(origin = {31, 64}, extent = {{-10, 10}, {10, -10}}, rotation = 90)));
  TAeZoSysPro.HeatTransfer.BasesClasses.FreeConvection convection_outer_casing(replaceable package Medium = Medium, A = A_conv_casing, Lc = Lc_casing, correlation = TAeZoSysPro.HeatTransfer.Types.FreeConvectionCorrelation.vertical_plate_ASHRAE) annotation(
    Placement(visible = true, transformation(origin = {60, 28}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow annotation(
    Placement(visible = true, transformation(origin = {-74, 16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

initial equation
  E_released = 0.0 ; 

equation
  connect(F_view, radiation_outer_casing.Fview) annotation(
    Line(points = {{107, -34}, {52, -34}, {52, -8}, {52, -8}}, color = {0, 0, 127}));
  connect(prescribedHeatFlow.port, mass_emitter.port) annotation(
    Line(points = {{-64, 16}, {-57, 16}, {-57, -20}, {-57, -20}}, color = {191, 0, 0}));
  connect(radiation_emitter_casing.port_a, mass_emitter.port) annotation(
    Line(points = {{-10, 0}, {-57, 0}, {-57, -20}, {-57, -20}}, color = {191, 0, 0}));
  connect(mass_casing.port, convection_inner_casing.port_a) annotation(
    Line(points = {{31, -18.2}, {31, -18.2}, {31, 53.8}, {31, 53.8}}, color = {191, 0, 0}));
  connect(convection_outer_casing.port_a, mass_casing.port) annotation(
    Line(points = {{50, 28}, {31, 28}, {31, -18}, {31, -18}}, color = {191, 0, 0}));
  connect(convection_outer_casing.port_b, port_conv) annotation(
    Line(points = {{70, 28}, {100, 28}, {100, 28}, {102, 28}}, color = {191, 0, 0}));
  connect(Inlet_Air_Temperature.port, port_conv) annotation(
    Line(points = {{65, 49.5}, {83, 49.5}, {83, 27.5}, {102, 27.5}, {102, 27.5}}, color = {191, 0, 0}));
  connect(radiation_outer_casing.port_b, port_rad) annotation(
    Line(points = {{70, 0}, {104, 0}, {104, 0}, {102, 0}}, color = {191, 0, 0}));
  connect(convection_emitter.port_b, port_hood) annotation(
    Line(points = {{-57, 74}, {-57, 74}, {-57, 92}, {48, 92}, {48, 90}}, color = {191, 0, 0}));
  connect(convection_inner_casing.port_b, port_hood) annotation(
    Line(points = {{31, 74}, {31, 92}, {48, 92}, {48, 90}}, color = {191, 0, 0}));
  connect(Heatload_Variable, prescribedHeatFlow.Q_flow) annotation(
    Line(points = {{-115, 16}, {-86, 16}, {-86, 16}, {-84, 16}}, color = {0, 0, 127}));
  connect(Inlet_Air_Temperature.T, convection_emitter.T_fluid) annotation(
    Line(points = {{54, 49.5}, {-32, 49.5}, {-32, 65.5}, {-49, 65.5}, {-49, 65.5}}, color = {0, 0, 127}));
  connect(Inlet_Air_Temperature.T, convection_inner_casing.T_fluid) annotation(
    Line(points = {{54, 49.5}, {46, 49.5}, {46, 65.5}, {39, 65.5}}, color = {0, 0, 127}));
  connect(prescribedHeatFlow.port, convection_emitter.port_a) annotation(
    Line(points = {{-64, 16}, {-57, 16}, {-57, 54}, {-57, 54}}, color = {191, 0, 0}));
// Energy released is calculated
  der(E_released) = port_hood.Q_flow + port_conv.Q_flow + port_rad.Q_flow;
// Ports handover
  A_wall = A_rad_casing;
  connect(radiation_outer_casing.port_a, mass_casing.port) annotation(
    Line(points = {{50, 0}, {30, 0}, {30, -18}, {32, -18}}, color = {191, 0, 0}));
  connect(radiation_emitter_casing.port_b, mass_casing.port) annotation(
    Line(points = {{10, 0}, {30, 0}, {30, -18}, {32, -18}}, color = {191, 0, 0}));
  annotation(
    uses(Modelica(version = "3.2.3")),
    Dialog(group = "Component two"),
    Diagram(graphics = {Rectangle(origin = {-54.5, -3}, fillColor = {222, 222, 222}, fillPattern = FillPattern.Solid, lineThickness = 1, extent = {{-39.5, 93}, {39.5, -93}}), Rectangle(origin = {51.5, -3}, fillColor = {222, 222, 222}, fillPattern = FillPattern.Solid, lineThickness = 1, extent = {{-39.5, 93}, {39.5, -93}}), Text(origin = {-66, -89}, lineThickness = 1, extent = {{-29, -7}, {51, 9}}, textString = "Emitter"), Text(origin = {54.5, -88}, lineThickness = 1, extent = {{-42.5, -8}, {36.5, 8}}, textString = "Casing"), Text(origin = {75.5, 80}, lineThickness = 1, extent = {{-42.5, -8}, {13.5, 2}}, textString = "Hood node")}, coordinateSystem(initialScale = 0.1)),
    Icon(graphics = {Text(origin = {66, -104}, extent = {{2, -8}, {-46, 14}}, textString = "Heat Load"), Text(origin = {-114, -14}, rotation = 180, extent = {{6, -2}, {-34, 18}}, textString = "J_MRT"), Rectangle(fillColor = {184, 51, 11}, fillPattern = FillPattern.Cross, lineThickness = 1, extent = {{-20, 20}, {20, -20}}), Line(origin = {0, -50.55}, rotation = 180, points = {{0, -26}, {0, 18}}, color = {255, 0, 0}, thickness = 0.75, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {-50, -0.55}, rotation = 90, points = {{0, -26}, {0, -8}}, color = {255, 0, 0}, thickness = 0.75, arrow = {Arrow.None, Arrow.Filled}), Text(origin = {-40, 82}, extent = {{-22, -6}, {-46, 14}}, textString = "F_view"), Text(origin = {-60, 46}, extent = {{-6, -6}, {-46, 14}}, textString = "A_rad_casing"), Text(origin = {18, 112}, extent = {{32, -12}, {2, 8}}, textString = "Hood"), Text(origin = {78, 22}, extent = {{40, -10}, {4, 6}}, textString = "Fluid"), Line(origin = {-40, 20}, points = {{-20, -80}, {-20, 60}, {20, 60}}, thickness = 2), Line(origin = {40, 20}, points = {{20, -80}, {20, 60}, {-20, 60}}, thickness = 2), Line(origin = {0, -80}, points = {{-60, 0}, {60, 0}}, thickness = 2), Ellipse(origin = {-3, 91}, lineThickness = 2, extent = {{-17, -1}, {23, -21}}, endAngle = 360), Line(origin = {-50.5454, -69.0254}, points = {{-10, -11}, {-10, 9}}, pattern = LinePattern.Dot, thickness = 1), Line(origin = {70.3659, -68.8599}, points = {{-10, -11}, {-10, 9}}, pattern = LinePattern.Dot, thickness = 1), Line(origin = {-41, 15}, points = {{-39, -85}, {-19, -85}, {-11, -83}, {-9, -75}, {-9, 45}, {-3, 51}, {5, 55}, {21, 55}, {29, 57}, {33, 65}, {33, 85}}, color = {0, 85, 255}, thickness = 1, arrow = {Arrow.Filled, Arrow.Filled}, arrowSize = 5), Line(origin = {44, 15}, points = {{36, -85}, {16, -85}, {8, -83}, {6, -75}, {6, 45}, {4, 53}, {-4, 55}, {-24, 55}, {-32, 57}, {-34, 65}, {-34, 85}}, color = {0, 85, 255}, thickness = 1, arrow = {Arrow.Filled, Arrow.Filled}, arrowSize = 5), Line(origin = {50.07, -0.38}, rotation = -90, points = {{0, -26}, {0, -8}}, color = {255, 0, 0}, thickness = 0.75, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {15.64, -3}, points = {{-17.6391, 53}, {-17.6391, 43}, {-13.6391, 35}, {-5.63908, 33}, {2.3609, 33}, {8.3609, 29}, {12.3609, 23}, {12.3609, -17}, {10.3609, -25}, {2.36092, -29}, {0.36092, -29}, {-5.63908, -31}, {-7.6391, -37}, {-7.6391, -47}}, color = {0, 85, 255}, thickness = 0.75, arrow = {Arrow.Filled, Arrow.Filled}, arrowSize = 4), Line(origin = {-18, -0.36}, points = {{8, -51.6391}, {8, -41.6391}, {6, -33.6391}, {-2, -31.6391}, {-4, -31.6391}, {-10, -27.6391}, {-12, -21.6391}, {-12, 18.3609}, {-8, 24.3609}, {-2, 28.3609}, {4, 28.3609}, {14, 30.3609}, {18, 38.3609}}, color = {0, 85, 255}, thickness = 0.75, arrow = {Arrow.Filled, Arrow.None}, arrowSize = 4), Line(origin = {-28.7119, 40.0462}, rotation = -90, points = {{0, -26}, {0, -8}}, color = {255, 0, 0}, thickness = 0.75, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {-29.0928, -39.557}, rotation = -90, points = {{0, -26}, {0, -8}}, color = {255, 0, 0}, thickness = 0.75, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {30.4806, 39.4998}, rotation = 90, points = {{0, -26}, {0, -8}}, color = {255, 0, 0}, thickness = 0.75, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {30.0997, -40.1034}, rotation = 90, points = {{0, -26}, {0, -8}}, color = {255, 0, 0}, thickness = 0.75, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {-73, 0}, points = {{11, 0}, {7, 0}, {5, -6}, {1, 6}, {-3, -6}, {-7, 6}, {-9, 0}, {-17, 0}}, color = {255, 0, 0}, thickness = 0.75, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 5)}, coordinateSystem(initialScale = 0.1)),
    Documentation(info = "
<html>
  <head>
    <title>CabinetPower</title>		
  </head>
	
  <body lang=\"en-UK\">
    <p>
      This module allows to model a electrical cabinet, an I&amp;C cabinet or any cabinet that is composed of a thermal dissipator surrounded by a casing. 
    </p>
    
    <p>			
      The shape and the internal arrangement of a cabinet is clearly dependent from the manufacturer as it is visible on the first figure.
    </p>
		
    <img 
      src=\"modelica://TAeZoSysPro/Information/HeatTransfer/Components/FIG_CabinetPower.PNG\"	
      width = \"600\"
    />
		
    <p>
      Consequently a reduction model is performed to model generical cabinet as much as possible. 
      The cabinet is represented by a box (called emitter) into a box (called the casing). 
      The following assumptions are made:
      <ul>
        <li> The conductive exchanges due to possible media between the emitter and the casing are neglected </li>
        <li> The space between the emitter and the casing is large enough to consider that the outside boundary layer temperature is the room temperature for both the convection with the emitter or the inner of the casing </li>
        <li> The space for the radiation between the emitter and the casing is of kind 'convex to concave'. There is no self radiation for the emitter. The view (or form) factor between the emitter and the casing is equal to one </li>
      </ul>
    </p>
    
    <p>      
      The heatload are dissipated within the emitter. 
      The emitter exchanges by convection with the fluid between the emitter and the casing. 
      Regarding the convection, the emitter is supposed flat and horizontal or vertical depending on the value of <b>correlation_internal</b>. 
      The convective surface of the emitter (<b>A_conv_emitter</b>) has thus to be an equivalent surface is both vertical and horizontal surfaces are present. 
      For the casing for the inner and outer convection, the correlation is always a correlation for a vertical plate.
      All the convective surfaces are equivalent surface, there must not necessarily be any size hierachies between the surfaces. 
      For example, in the equivalent thermal model, the equivalent surface <b>A_in_casing</b> for the internal convection with the casing looks smaller than the external surface whereas in pratical it is often greater. <br/>	
      Regarding the emitter radiation, the real shape is often so much complex that self radiation almost always occurs. 
      The equivalent surface is thus often smaller than the real surface. 
      Regarding the radiation over the inner of the casing, as the view factor is attached to the emitter, the convective <b>A_in_casing</b> and radiative surface area are the same. <br/>
      The real outer surface area of the casing is represented by two variables <b>A_conv_casing</b> and <b>A_rad_casing</b> for respectively the convective and radiant exchange. 
      It is usefull when multiple cabinets are modelled by one equivalent cabinet (model reduction).
      If each cabinets are close enough to each other, a part of the external surface of each cabinet shines over its neighboors. 
      With the assumptions that the surface temperature of each cabinet is close, the balance of radiation is null. 
      It can be represented by a reduction of outer radiant surface area.  
    </p>
		
    <p>
      This module has been designed to be calibrated on data assimilation.
    </p>
		
    <img 
      src=\"modelica://TAeZoSysPro/Information/HeatTransfer/Components/FIG_CabinetPower2.PNG\"	
      width = \"600\"
    />
		
  </body>
</html>"));

end CabinetPower;
