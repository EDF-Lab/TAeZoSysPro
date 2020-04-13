within TAeZoSysPro;

package FluidDynamics

  extends Modelica.Icons.Package ;
  
annotation(
    Documentation(info = "
<html>
  <head>
    <title>FluidDynamics</title>
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
      <a href=\"#1. What is FluidDynamics ?-outline\">1. What is FluidDynamics ? </a><br>
      <a href=\"#2. Package structure-outline\">2. Package structure </a><br>
      <a href=\"#3. Use examples-outline\">3. Use examples </a><br>
    </p>

    <hr>
        
    <p>
		The scale type used for the modelling in the <b>FluidDynamics</b> package is of the multi zone type. 
		The multi-zone models are more complex than simple models that use a single ‘Node’ for each room, with only one node for fluid there is no modelling of fluid-movement within a volume. 
		Using multi-zones within a volume introduces multiple nodes with similar characteristics (pressure, temperature, flow velocity, etc.). 
		The notion of fluid-movement within the rooms (between the nodes) is then possible. 
		The tools used in the multi-zone model are based on the more general approach of fluid mechanics, the equations used are those governing the motion of fluids: the Navier Stokes equations.
    </p>

    <p>	
		With a simple thermal approach of the <b>HeatTransfer</b> package, the only state variable is temperature. 
		It is determined from the conservation of energy and an enthalpy balance in the control volume. 
		The enthalpy can be directly deduced from the temperature with the assumption of perfect gas. 
		</br>
		In the thermo-aeraulic model there are three variables of state: pressure, Temperature (or enthalpy if appropriate) and density. 
		These three variables are coupled together thanks to an equation of state (perfect gas law for instance). 
		Within a node, there are two conservation equations to solve two of the three state variables (say explicit variables) and the third is deduced from an equation of state. 	
    </p>

    <h4><a name=\"1. What is FluidDynamics ?-outline\"></a>1. What is FluidDynamics ?</h4>

      The goal of this package is to provide modules to carry out:
		<ul>
		  <li> mass and energy transfer induced by movement </li>
		  <li> mass and energy transfer induced by phase change </li>		  
		</ul>	

    <p>
      The <b>FluidDynamics</b> package is used to provide modules to model systems dominated by coupled heat and mass transfers. </br>
      Regarding the heat transfer only, the <b>FluidDynamics</b> uses the modules already developped in the <b>HeatTransfer</b>.
		Therefore, the <b>FluidDynamics</b> package contains modules to compute:
		<ul>
		  <li> mass and energy transfer from phase change </li>
		  <li> mass and energy transfer from total (in sens of not partial) pressure gradient </li>		  
		  <li> mass and energy transfer from diffusion </li>		
		</ul>		
    </p>
        
		
    <h4><a name=\"2. Package structure-outline\"></a>2. Package structure</h4>


    <h4><a name=\"3. Use examples-outline\"></a>3. Use examples</h4>	

  </body>
	
</html>
    "),
  Icon(coordinateSystem(extent = {{-100.0, -100.0}, {100.0, 100.0}}), graphics = {Line(origin = {-47.5, 11.6667}, points = {{-2.5, -91.6667}, {17.5, -71.6667}, {-22.5, -51.6667}, {17.5, -31.6667}, {-22.5, -11.667}, {17.5, 8.3333}, {-2.5, 28.3333}, {-2.5, 48.3333}}, smooth = Smooth.Bezier), Polygon(origin = {-50.0, 68.333}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{0.0, 21.667}, {-10.0, -8.333}, {10.0, -8.333}}), Line(origin = {2.5, 11.6667}, points = {{-2.5, -91.6667}, {17.5, -71.6667}, {-22.5, -51.6667}, {17.5, -31.6667}, {-22.5, -11.667}, {17.5, 8.3333}, {-2.5, 28.3333}, {-2.5, 48.3333}}, smooth = Smooth.Bezier), Polygon(origin = {0.0, 68.333}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{0.0, 21.667}, {-10.0, -8.333}, {10.0, -8.333}}), Line(origin = {52.5, 11.6667}, points = {{-2.5, -91.6667}, {17.5, -71.6667}, {-22.5, -51.6667}, {17.5, -31.6667}, {-22.5, -11.667}, {17.5, 8.3333}, {-2.5, 28.3333}, {-2.5, 48.3333}}, smooth = Smooth.Bezier), Polygon(origin = {50.0, 68.333}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{0.0, 21.667}, {-10.0, -8.333}, {10.0, -8.333}})}) );

end FluidDynamics;
