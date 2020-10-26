within TAeZoSysPro;

package PDE

extends Modelica.Icons.Package ;

  annotation(
    Documentation(info = "
<html>
	<head>
		<title>PDE package</title>
	
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
		<a href=\"#1. What is PDE ?-outline\">1. What is PDE ? </a><br>
		<a href=\"#2. Library structure-outline\">2. Package structure </a><br>
		<a href=\"#3. Use examples\">3. Use examples </a><br>
		</p>

		<hr>

		<h4><a name=\"1. What is PDE ?-outline\"></a>1. What is PDE ?</h4>

		<p>
			The <b>PDE</b> package for Partial Derivative Equation is used to provide numerical schemes for the resolution of partial derivative equations such as transport equation or diffusion equation. </br>
            The time resolution scheme and its implicit or explicit character is taken in charge by the open modelica solver selected by the user before simulating.
            The approach in this package is to proposed different numerical discrete schemes (central, upwind ... and first order, second order...) to model partial derivative other than temporal. </br>
            The PDE currently modelled are :
		</p>
        
		<ul>
			<li> Transport equation with the <b>Transport</b> subpackage </li>
            
			<li> Thermal Diffusion equation with the <b>ThermalDiffusion</b> subpackage </li>
		</ul>		
		
		<h4><a name=\"2. Package structure-outline\"></a>2. Package structure</h4>
		
		<p>
            The package is decomposed in subpackages for each kind of PDE. Each subpackage contains multiple models either having different spatial discrete scheme or simply that makes different assumptions. For example, the mathematical model for uncompressible or compressible transport is different. </br>
		</p>
        
        <ul>
			<li> Transport</li> 
            <ul>
                <li> UpwindFirstOrder</li> 
            </ul>
            </br>
			<li> ThermalDiffusion</li> 
            <ul>
                <li> CentralSecondOrder</li> 
            </ul>
		</ul>


		<h4><a name=\"3. Use examples-outline\"></a>3. Use examples</h4>

		<p>
			<ul>
				<li> Transport: advection of the enthalpy through a pipe with incompressible water</li>

				<li> ThermalDiffusion: Thermal diffusion through a wall </li>
			</ul>
			
		</p>		

	</body>
	
</html>"),
    Icon(coordinateSystem(initialScale = 0.1), graphics = {Bitmap(origin = {40.5, 22.5}, extent = {{-112.5, -112.5}, {67.5, 67.5}}, fileName = "modelica://TAeZoSysPro/Information/PDE/img_package.png")}));
end PDE;
