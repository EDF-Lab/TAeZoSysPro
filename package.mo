package TAeZoSysPro

annotation(
    Documentation(info = "<html><head>
		<title>The TAeZoSysPro librairy</title>
	
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

		<h1>Version 3.1.0</h1><p>
		This package with all of its subpackages contains the elements of the “ TAeZoSysPro ” librairie version 3.1.0 
		</p>

		<p>
		<a href=\"#1. What is TAeZoSysPro ?-outline\">1. What is TAeZoSysPro ? </a><br>
		<a href=\"#2. Library structure-outline\">2. Library structure </a><br>
		<a href=\"#3. Main uses-outline\">3. Main uses </a><br>
		</p>

		<hr>

		<h4><a name=\"1. What is TAeZoSysPro ?-outline\"></a>1. What is TAeZoSysPro ?</h4>
		<p>
			The <b>TAeZoSysPro</b> library for Thermo-AEraulic ZOnal SYStem PROfessionnal is used to provide mathematical models of HVAC systems within buildings for both steady state and transient conditions within an industrial framework. 
			The Modules of the library are able to model multispecies, multiphase media.
			The description of the multi-phase model is available in the released notes. 
			Two approach are treated here: <br>
			</p><ul>
				<li>The simple thermal mode via the <b>HeatTransfer</b> subpackage </li>
				<li>The multi-zonal mode or sometimes called thermo-aeraulic mode via the <b>Aeraulic</b> subpackage </li>
			</ul>
		<p></p>

		<p>
			<b>Definition</b>
		</p>
		
		<ol type=\"a\">
			<li>“ The simple thermal mode ” makes the hypothesis that the pressure remains constant during all the process or the transformation. Then the two remaining state variables are
			the density and the temperature. The last are link to by a state law. Therefore it has been chosen to use the temperature as explicit variable. The equation solved with the simple 
			thermal mode is the first law of thermodynamic being energy conservation throught en enthalpic balance.</li> <br>

			<li>“ The multi-zonal mode ” do not make any other hypotheses and the solved the change of state variables such as the pressure, the density and temperature via the 
			conservation of mass, momentum and energy coupled with a state law.</li>
		</ol>
		
		<br>
		
		
		<h4><a name=\"2. Library structure-outline\"></a>2. Library structure</h4>
		
		<p>
		The libraries have been developed from basic components each of which model one precise phenomenon in such a way that more complex mathematical models can be created by joining / assembling
		these basic components. Most of the basic components are situated in the “ BasesClasses ” package. The complex “ complex ” components made of an assembling are 
		situated in the “ Components ” package. The components are designed in a way that each contains only the equations of conservation (said capacitive components) or flux calculations
		(resitive components). The equation are coded in a way so that they are suitable for modelling many medium (one or multi-species, condensable or not...)  and the medium modelled and its 
		properties are given by equations contained in the package named “Media”.
		</p>
		
		<br>

		
		<h4><a name=\"3. Main uses-outline\"></a>3. Main uses</h4>

		<p>
		
			</p><ul>
				<li> dynamic behavior of  a room bounded by walls where conduction takes place, containing dissipator echanging by radiation and convection and supplied and extracted by a 
				ventilation system makes the hypothesis that the pressure remains constant during all the process or the transformation. Then the two remaining state are the density and the 
				temperature. The last are link to by a state law. Therefore it has been chosen to use the temperature as explicit variable. The equation solved with the simple thermal mode is
				the first law of thermodynamic being energy conservation throught en enthalpic balance.</li> <br>

				<li> modeling of ventilation system containing piping, control valves, fan, I&amp;C, exchanger (wet of dry) ... where the thermal and flow aspect are coupled </li> <br>
				
				<li> modeling volume propagation where latent transfer (condensation an evaporation) occurs  </li> <br>				
				
			</ul>
			
		<p></p>		

	
	

    </body></html>"),
    uses(Modelica(version = "3.2.3")));

end TAeZoSysPro;