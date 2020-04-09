within TAeZoSysPro.HeatTransfer.BasesClasses;

model PartialWall
  // imports
    import TAeZoSysPro.HeatTransfer.Types.Dynamics ;
    import MeshFunction = TAeZoSysPro.HeatTransfer.Functions.MeshGrid ;
    import TAeZoSysPro.HeatTransfer.Types.MeshGrid ;    
  
  // User defined parameters
    parameter Integer N = integer(max(2, 5 * Th / 0.2 * 1e-6 / D_th) )  "Number of discrete layer from 2" annotation(
    Dialog(group = "Mesh properties"));
    parameter MeshGrid mesh = MeshGrid.uniform "Shape function selection for the mesh" annotation(
    Dialog(group = "Mesh properties"));    
    parameter Real q = 1.2  "Growth rate (if geometricalGrowth)" annotation(
    Dialog(group = "Mesh properties"));
    parameter Modelica.SIunits.CoefficientOfHeatTransfer h = 10 "Decoupled value of the heat transfer coefficient (if biot)" annotation(
    Dialog(group = "Mesh properties"));  
    final parameter Modelica.SIunits.Position x[:] = 
      if mesh == MeshGrid.uniform then
        MeshFunction.uniformGrid(L=Th, N=N)
      elseif mesh == MeshGrid.geometricalGrowth then
        MeshFunction.geometricalGrowthGrid(L=Th, N=N, q=q)  
      elseif mesh == MeshGrid.biotAndUniform then
        MeshFunction.biotAndUniformGrid(L=Th, N=N, h=h, k=k)
      elseif mesh == MeshGrid.biotAndGeometricalGrowth then
        MeshFunction.biotAndGeometricalGrowthGrid(L=Th, N=N, h=h, k=k, q=q)
      else
        MeshFunction.uniformGrid(Th, N) "position of the vertices of the mesh" ;
                
    parameter Real add_on(unit = "R+") = 1 "Custom add-on";
    parameter Dynamics energyDynamics = Dynamics.SteadyStateInitial "Formulation of energy balance";
    parameter Modelica.SIunits.Temperature T_start = 293.15 "Start value for temperature, if energyDynamics = FixedInitial";
  //
    parameter Modelica.SIunits.SpecificHeatCapacity cp = 0 "Wall specific heat capacity" annotation(
    Dialog(group = "Medium properties"));
    parameter Modelica.SIunits.Density d = 0 "Wall density" annotation(
    Dialog(group = "Medium properties"));
    parameter Modelica.SIunits.ThermalConductivity k = 0 "Wall conductivity" annotation(
    Dialog(group = "Medium properties"));
  //
    parameter Modelica.SIunits.Thickness Th = 0 "Material thickness" annotation(
    Dialog(group="Geometrical properties"));
    parameter Modelica.SIunits.Area A = 1 "Wall area" annotation(
    Dialog(group = "Geometrical properties"));

  // Internal variables
    Modelica.SIunits.Energy E "Energy stored in the wall";

  // Imported components
    Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a annotation(
    Placement(visible = true, transformation(origin = {-98, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-98, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port_b annotation(
    Placement(visible = true, transformation(origin = {98, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {98, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    PDE.ThermalDiffusion.CentralSecondOrder centralSecondOrder(
      N = N,  
      CoeffSpaceDer=-D_th, 
      SourceTerm = fill(0.0, N), 
      x=x) annotation(
    Placement(visible = true, transformation(origin = {-2, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));


final parameter Modelica.SIunits.ThermalDiffusionCoefficient D_th = k / (d * cp) "Thermal diffusivity";

initial equation
  // Energy at time 0 second is equal to 0J
  E = 0;
  
  if energyDynamics == Dynamics.SteadyStateInitial then
    centralSecondOrder.u[2:end - 1] = {port_a.T - (port_a.T - port_b.T) / Th * (x[i - 1] + (x[i] - x[i - 1]) / 2) for i in 2:N + 1};
    //der(centralSecondOrder.u[2:end-1]) = fill(0, n) ;
    
  elseif energyDynamics == Dynamics.FixedInitial then
    centralSecondOrder.u[2:end - 1] = fill(T_start, N) "Initial Condition";
    
  end if;
  
equation
  // Energy is calculated
    der(E) = port_a.Q_flow + port_b.Q_flow "Energy stored";
  //
    //D_th = k / (d * cp);

  //PDE
    // determination of ghost node value
    port_a.Q_flow + (centralSecondOrder.u[2] - centralSecondOrder.u[1]) / (x[2] - x[1]) * k * A = 0.0 "flux conservation";
    
    port_b.Q_flow - (centralSecondOrder.u[end] - centralSecondOrder.u[end-1])/(x[end]-x[end-1]) * k * A = 0.0 "flux conservation" ;

  if energyDynamics == Dynamics.SteadyState then
    centralSecondOrder.CoeffTimeDer = 0.0 ;
    
  else
    centralSecondOrder.CoeffTimeDer = 1.0 ;
        
  end if ;     
    
//  port_a.T = centralSecondOrder.u[1] ;
//  port_b.T = centralSecondOrder.u[end] ;
  // for increasing stability, the following boundary condition can be used
  port_a.T = centralSecondOrder.u[2];
  port_b.T = centralSecondOrder.u[end-1] ;
   
  
  annotation(
    Documentation(info = "
  <html>
	<head>
      <title>PartialWall</title>
	
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
        This components performed a one dimensionnal discretisation over a solid wall. 
        For the discrete scheme, it uses an inheritance of a model <b>CentralSecondOrder</b> of the <b>PDE.ThermalDiffusion</b> subpackage.
      </p>

      <h4> Meshing </h4>
      <p>
        The parameter <b>N</b> for number of discrete layers is by default calculated from the thermal diffusivity of the wall, its thickness and a reference wall having a sufficient number of nodes with regard to the desired precision. In that case, the minimal number of node is 2. 
        The user can, if desired, manually define the value of the parameter <b>N</b>.
      </p>
      <p>
        The reference wall is a concrete wall with:
        <ul>
          <li> a density of 2500 kg/m3 </li>
          <li> a specific heat capacity of 1000 J/kg/K </li>
          <li> a thermal conductivity of 2.3 W/m/K </li>
          <li> a thickness of 0.2 m </li>
          <li> 5 discrete node (<b>N</b> = 5) </li>
        </ul>                
      </p>

      <img
        src = \"modelica://TAeZoSysPro/Information/HeatTransfer/BasesClasses/EQ_PartialWall.png\"
      />      

      <p>
        Regarding the mesh shape, the position of vertices in the mesh are given via a function allowing to have uniform or non uniform grid, to have boundary layers shape from Biot number etc. 
        The list of mesh functions is available in the subpackage Functions.MeshGrid.
      </p>      

      <h4> Boundaries management </h4>
		
      <p>
        The ports temperature should be the boundary edges temperatures. 
        As the scheme is cell vertex, the boundary temperatures are computed from flow conservation. 
		Therefore, the boundary vertices are non inertial. 
		However it can induced numerical difficulties. 
		In that case, it is better to use the boundary node (cell centered) temperature as port temperature. 
		It however becomes impossible to fix the wall surface temperature. <br />
      </p>

<h4> Initialisation </h4>

      <p>
        If <b>energyDynamics</b> parameter is <b>FixedInitial</b>, the initial temperature is equal to the value of the <b>T_start</b> parameter.
      </p>
		
      <p>
        Regarding the steady state initialization (<b>energyDynamics = SteadyStateInitial</b>), it has been chosen to do not set the time derivative to zero which is the definition of the steady state but rather to force a straight slope profile within the wall. 
        The slope of the profil is based on the boundary temperature difference and the wall heat resistance. 
        Physically is it equivalent but it let a degree of freedom on the time derivative. 
      </p>
		
      <p>
        Regarding the steady state (<b>energyDynamics = SteadyState</b>), it has been chosen to do not change the diffusion equation but rather to set the coefficient of the time derivative <b>CoeffTimeDer</b> in the model <b>CentralSecondOrder</b> to 0.
        Multiple a time derivative per 0 rather than remove it can lead to numerical instabilities but it is simpler regarding the coding.
      </p>	
	
	</body>
</html>"),uses(Modelica(version = "3.2.3")),
    Icon(graphics = {Line(origin = {-90, 0}, points = {{-10, 0}, {20, 0}}, thickness = 1), Rectangle(origin = {-60, -1}, lineThickness = 1, extent = {{10, -3}, {-10, 5}}), Rectangle(origin = {-20, -1}, lineThickness = 1, extent = {{10, -3}, {-10, 5}}), Rectangle(origin = {20, -1}, lineThickness = 1, extent = {{10, -3}, {-10, 5}}), Rectangle(origin = {60, -1}, lineThickness = 1, extent = {{10, -3}, {-10, 5}}), Line(origin = {80, 0}, points = {{-10, 0}, {20, 0}}, thickness = 1), Line(origin = {-40, -10}, points = {{0, 10}, {0, -10}}, thickness = 1), Line(points = {{-10, 0}, {10, 0}}, thickness = 1), Line(origin = {40, 0}, points = {{-10, 0}, {10, 0}}, thickness = 1), Line(origin = {-40, 0}, points = {{-10, 0}, {10, 0}}, thickness = 1), Line(origin = {-40, -20}, points = {{-10, 0}, {10, 0}}, thickness = 1), Line(origin = {-40, -26}, points = {{-10, 0}, {10, 0}}, thickness = 1), Line(origin = {0, -20}, points = {{-10, 0}, {10, 0}}, thickness = 1), Line(origin = {0, -26}, points = {{-10, 0}, {10, 0}}, thickness = 1), Line(origin = {40, -20}, points = {{-10, 0}, {10, 0}}, thickness = 1), Line(origin = {40, -26}, points = {{-10, 0}, {10, 0}}, thickness = 1), Line(origin = {0, -10}, points = {{0, 10}, {0, -10}}, thickness = 1), Line(origin = {40, -10}, points = {{0, 10}, {0, -10}}, thickness = 1), Line(origin = {-40, -36}, points = {{0, 10}, {0, -4}}, thickness = 1), Line(origin = {0, -36}, points = {{0, 10}, {0, -4}}, thickness = 1), Line(origin = {40, -36}, points = {{0, 10}, {0, -4}}, thickness = 1), Line(origin = {-38, -40}, points = {{-10, 0}, {6, 0}}, thickness = 1), Line(origin = {-34, -44}, points = {{-10, 0}, {-2, 0}}, thickness = 1), Line(origin = {2, -40}, points = {{-10, 0}, {6, 0}}, thickness = 1), Line(origin = {42, -40}, points = {{-10, 0}, {6, 0}}, thickness = 1), Line(origin = {6, -44}, points = {{-10, 0}, {-2, 0}}, thickness = 1), Line(origin = {46, -44}, points = {{-10, 0}, {-2, 0}}, thickness = 1), Rectangle(fillColor = {229, 229, 229}, lineThickness = 1, extent = {{-80, 80}, {80, -80}})}, coordinateSystem(initialScale = 0.1)));

end PartialWall;
