within TAeZoSysPro;

package HeatTransfer

annotation(
    Documentation(info = "
<html>
	<head>
		<title>HeatTransfer package</title>
	
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
		<a href=\"#1. What is HeatTransfer ?-outline\">1. What is HeatTransfer ? </a><br>
		<a href=\"#2. Package structure-outline\">2. Package structure </a><br>
		<a href=\"#3. Use examples-outline\">3. Use examples </a><br>
		</p>

		<hr>
        
        <p>
            All the modules in the HeatTransfer package use the simple thermal mode. As a reminder, it considers the state pressure variable as constant during the transformation.
            The two other state variables that are the density and the Temperature are firstly linked by the state law and solved via the energy conservation equation and an enthalpy balance.
            The explicit variable chosen is the temperature. </br>
            The goal of this package is to provide modules to carry out enthalpy balance and thus determine temperature of variable over the time of systems.
        </p>

		<h4><a name=\"1. What is HeatTransfer ?-outline\"></a>1. What is HeatTransfer ?</h4>

		<p>
			The <b>HeatTransfer</b> package is used to provide modules to model systems dominated by heat transfer where the interest state variable is the Temperature. </br>
            In that case, Heat transfer can only be done in three different ways, The conduction, the convection and the radiation. 
            The enthalpy transfer by displacement of material at the boundaries of the system for an open system is considered in this package as a particular heat transfer. </br>
            Therefore any system is seen as an assembly of heat capacities, convections, conductions and raditions modules. 
            As an example, a buidling wall, modelled by one node, is an assembly of a heat capacity and both radition and convection to exchange heat with its environment. 
            A wall modelled by two layers would have link the heat capacities by a conduction module.
		</p>
        
		
		<h4><a name=\"2. Package structure-outline\"></a>2. Package structure</h4>
		
		<p>
            The main idea in this package is to have the elementary modules in the package called <b>BasesClasses</b>. 
            The elementary module are what the other modules assemble to build more complex modules. 
            This is the lowest level of module. 
            For example a wall is not an elementary module because it assemble module such convection and radition whereas the convection module is an elementary module.
		</p>

		<p>
            The <b>Components</b> package contains the modules of high level (made from elementary modules) and the module which are either non elementary or non made of elementar modules
        </p>

		<p>
            The <b>Types</b> contains the defintion of new types of variables for:
            <ul>
                <li> Variables which are non existing in the package <code>Modelica.SIunits</code> </li>
                <li> Enumeration variables </li>
                <li> Redefine value of attributes such <code>start, min, max or nominal</code> of variables existing in the package <code>Modelica.SIunits</code> </li>                
            </ul>            
        </p>

		<p>
            The <b>Functions</b> package contains the defintion of functions. 
            Some function are sometimes copy pasting of the Modelica Standard Libray (MSL) in order to insure working in case of MSL changes regarding the functions in question.           
        </p>

		<p>
            The <b>Interfaces</b> package contains the HeatPorts that are copy pasting of the Modelica Standard Libray (MSL) in order to insure working in case of MSL changes regarding the Heatports.           
        </p>        


		<h4><a name=\"3. Use examples-outline\"></a>3. Use examples</h4>

		<p>
		</p>		

	</body>
	
</html>
    "),
    Icon(coordinateSystem(initialScale = 0.1), graphics = {Rectangle(lineColor = {200, 200, 200}, fillColor = {248, 248, 248}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-100, 100}, {100, -100}}, radius = 25), Polygon(origin = {13.758, 27.517}, lineColor = {128, 128, 128}, fillColor = {192, 192, 192}, fillPattern = FillPattern.Solid, points = {{-54, -6}, {-61, -7}, {-75, -15}, {-79, -24}, {-80, -34}, {-78, -42}, {-73, -49}, {-64, -51}, {-57, -51}, {-47, -50}, {-41, -43}, {-38, -35}, {-40, -27}, {-40, -20}, {-42, -13}, {-47, -7}, {-54, -5}, {-54, -6}}), Polygon(origin = {13.758, 27.517}, fillColor = {160, 160, 164}, fillPattern = FillPattern.Solid, points = {{-75, -15}, {-79, -25}, {-80, -34}, {-78, -42}, {-72, -49}, {-64, -51}, {-57, -51}, {-47, -50}, {-57, -47}, {-65, -45}, {-71, -40}, {-74, -33}, {-76, -23}, {-75, -15}, {-75, -15}}), Polygon(origin = {13.758, 27.517}, lineColor = {160, 160, 164}, fillColor = {192, 192, 192}, fillPattern = FillPattern.Solid, points = {{39, -6}, {32, -7}, {18, -15}, {14, -24}, {13, -34}, {15, -42}, {20, -49}, {29, -51}, {36, -51}, {46, -50}, {52, -43}, {55, -35}, {53, -27}, {53, -20}, {51, -13}, {46, -7}, {39, -5}, {39, -6}}), Polygon(origin = {13.758, 27.517}, fillColor = {160, 160, 164}, fillPattern = FillPattern.Solid, points = {{18, -15}, {14, -25}, {13, -34}, {15, -42}, {21, -49}, {29, -51}, {36, -51}, {46, -50}, {36, -47}, {28, -45}, {22, -40}, {19, -33}, {17, -23}, {18, -15}, {18, -15}}), Polygon(origin = {13.758, 27.517}, lineColor = {191, 0, 0}, fillColor = {191, 0, 0}, fillPattern = FillPattern.Solid, points = {{-9, -23}, {-9, -10}, {18, -17}, {-9, -23}}), Line(origin = {13.758, 27.517}, points = {{-41, -17}, {-9, -17}}, color = {191, 0, 0}, thickness = 0.5), Line(origin = {13.758, 27.517}, points = {{-17, -40}, {15, -40}}, color = {191, 0, 0}, thickness = 0.5), Polygon(origin = {13.758, 27.517}, lineColor = {191, 0, 0}, fillColor = {191, 0, 0}, fillPattern = FillPattern.Solid, points = {{-17, -46}, {-17, -34}, {-40, -40}, {-17, -46}})}),
    uses(Modelica(version = "3.2.3")));

end HeatTransfer;
