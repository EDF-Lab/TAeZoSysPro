within TAeZoSysPro.Aeraulic.Media;

package SimpleAir
  ////////////////////////////////////////////////////////////////
  extends Modelica.Media.Interfaces.PartialCondensingGases(mediumName = "MoistAir", substanceNames = {"water", "Air"}, final fixedX = false, final reducedX = true, final singleState = false, reference_X = {0.01, 0.99});
  //--------------------------------------------------------------
  ////////////////////////////////////////////////////////////////
  // Provide constants here
  constant Real k_mair = steam.MM / dryair.MM "Ratio of molar weights";
  constant Integer Water = 1 "Index of water (in substanceNames, massFractions X, etc.)";
  constant Integer Air = 2 "Index of air (in substanceNames, massFractions X, etc.)";
  constant Modelica.SIunits.MolarMass[2] MMX = {steam.MM, dryair.MM};
  //--------------------------------------------------------------
  ////////////////////////////////////////////////////////////////

  redeclare record ThermodynamicState "Thermodynamic variables records"
    extends Modelica.Icons.Record;
    Modelica.SIunits.Pressure[nX] pi "Partial pressure of each species";
    Modelica.SIunits.Density[nX] di "Density of each species";
    Modelica.SIunits.Temperature T "Temperature";
    Modelica.SIunits.SpecificEnthalpy[nX] hi "SpecificEnthalpy of each species";
  end ThermodynamicState;

  //--------------------------------------------------------------
  ////////////////////////////////////////////////////////////////

  redeclare replaceable model extends BaseProperties(final standardOrderComponents = true) "Base properties of medium"
      // Pressure declaration
      Modelica.SIunits.Pressure[nX] pi "partial pressure peer species";
      Modelica.SIunits.AbsolutePressure p_steam_sat "partial pressure of steam at saturation";
      // Density declaration
      Modelica.SIunits.Density[nX] di(start = {0.03, 1.2}) "Density peer species (liquid mass included)";
      Modelica.SIunits.Density d_steam_sat "density of steam at saturation";
      // Enthalpy declaration
      Modelica.SIunits.SpecificEnthalpy[nX] hi "Specific enthalpy of a species";
      // Mass declaration
      Modelica.SIunits.MassFraction X_steam "Mass fraction of steam water / kg_moistair";
      Modelica.SIunits.MassFraction X_air "Mass fraction of air / kg_moistair ";
      //
      Real phi "Relative humidity";

    equation
//
      MM = 1 / (X[Water] / MMX[Water] + (1.0 - X[Water]) / MMX[Air]);
//Molar mass of the mixing (taking account of liquid water)
      R = Modelica.Constants.R / MMX[Air] * X_air + Modelica.Constants.R / MMX[Water] * X_steam;
//-----
//
      d_steam_sat = p_steam_sat / (Modelica.Constants.R / MMX[Water] * T);
      d = sum(di);
//
      p_steam_sat = saturationPressure(T);
      pi[Water] = X_steam * sum(di) * Modelica.Constants.R / MMX[Water] * T;
      pi[Air] = di[Air] * Modelica.Constants.R / MMX[Air] * T;
      p = sum(pi);
//
      hi[Water] = steam.cp * (T - 273.15) + liquidWater.LHea;
      hi[Air] = dryair.cp * (T - 273.15);
      h = X[Air] * hi[Air] + X[Water] * hi[Water];
//
      u = h - p / d;
//-----
//
      X[Water] = di[Water] / d;
      X_steam = di[Water] / sum(di);
      X_air = di[Air] / sum(di);
//-----
//
      state.pi = pi;
      state.T = T;
      state.di = di;
      state.hi = hi;
//-----
//
      phi = p / p_steam_sat * X[Water] / (X[Water] + k_mair * X[Air]);
//assert(0.0 <= phi and phi <= 1.0, "out of media boundaries: steam saturation point overtaken", level = AssertionLevel.error);
//-----
  end BaseProperties;

  //--------------------------------------------------------------
  ////////////////////////////////////////////////////////////////

  function setState_diT "Return thermodynamic state as function of p, h and composition X or Xi"
    extends Modelica.Icons.Function;
    input Modelica.SIunits.Density[nX] di "Density";
    input Modelica.SIunits.Temperature T "Temperature";
    output ThermodynamicState state "Thermodynamic state record";
  algorithm
    state.di[Air] := di[Air];
    state.di[Water] := di[Water];
    state.pi[Air] := pDryAir_dT(di[Air], T);
    state.pi[Water] := pWater_dT(di[Water], T);
    state.T := T;
    state.hi[Air] := enthalpyOfNonCondensingGas(T = T);
    state.hi[Air] := enthalpyOfCondensingGas(T = T);
  end setState_diT;

  //--------------------------------------------------------------
  ////////////////////////////////////////////////////////////////

  function massFraction_pTphi "Return steam mass fraction as a function of relative humidity phi and temperature T"
    extends Modelica.Icons.Function;
    input Modelica.SIunits.AbsolutePressure p "Pressure";
    input Modelica.SIunits.Temperature T "Temperature";
    input Real phi "Relative humidity (0 ... 1.0)";
    output Modelica.SIunits.MassFraction X_steam "Absolute humidity, steam mass fraction";
  protected
    //constant Real k=0.621964713077499 "Ratio of molar masses";
    Modelica.SIunits.AbsolutePressure psat = Modelica.Media.Water.IF97_Utilities.BaseIF97.Basic.psat(T) "Saturation pressure";
  algorithm
    X_steam := phi * k_mair / (k_mair * phi + p / psat - phi);
    annotation(
      smoothOrder = 2,
      Documentation(info = "<html>
Absolute humidity per unit mass of moist air is computed from temperature, pressure and relative humidity.
</html>"));
  end massFraction_pTphi;

  //--------------------------------------------------------------
  ////////////////////////////////////////////////////////////////

  function extends saturationPressure "Return saturation pressure of water as a function of the state"
      extends Modelica.Icons.Function;

    algorithm
      psat := Modelica.Media.Water.IF97_Utilities.BaseIF97.Basic.psat(Tsat);
    annotation(
      Documentation(info = "<html>
Saturation pressure of water in the liquid omputed using IF97 standard
</html>"));
  end saturationPressure;

  //--------------------------------------------------------------
  ////////////////////////////////////////////////////////////////

  function saturationTemperature "Return saturation Temperature of water as a function of the state"
    extends Modelica.Icons.Function;
    input Modelica.SIunits.Pressure p "pressure of water";
    output Modelica.SIunits.Temperature Tsat "saturation temperature";
  algorithm
    Tsat := Modelica.Media.Water.IF97_Utilities.BaseIF97.Basic.tsat(p);
    annotation(
      Documentation(info = "<html>
Saturation temperature of water in the liquid omputed using IF97 standard
</html>"));
  end saturationTemperature;

  //--------------------------------------------------------------
  ////////////////////////////////////////////////////////////////

  function saturationDensity "Return saturation density of condensing steam"
    extends Modelica.Icons.Function;
    input Modelica.SIunits.Temperature T "Thermodynamic state record";
    output Modelica.SIunits.Density dsat "Saturation pressure";
  algorithm
    dsat := Modelica.Media.Water.IF97_Utilities.BaseIF97.Regions.rhov_T(T);
  end saturationDensity;

  //--------------------------------------------------------------
  ////////////////////////////////////////////////////////////////

  function extends enthalpyOfCondensingGas "Return specific enthalpy of STEAM as a function of temperature and pressure in state"
    algorithm
//    h := Modelica.Media.Water.WaterIF97_base.specificEnthalpy_pT(p, T, region = 2);
      h := steam.cp * (T - 273.15) + liquidWater.LHea;
    annotation(
      Inline = false,
      smoothOrder = 5,
      Documentation(info = "<html>
Specific enthalpy of steam is computed from temperature.
</html>"));
  end enthalpyOfCondensingGas;

  //--------------------------------------------------------------
  ////////////////////////////////////////////////////////////////

  function extends enthalpyOfNonCondensingGas
      //    "Return specific enthalpy of dry air as a function of the state"

    algorithm
//  h:= Modelica.Media.Air.ReferenceAir.Air_Base.Air_Utilities.h_dT(d, T) ;
      h := dryair.cp * (T - 273.15);
    annotation(
      Inline = false,
      smoothOrder = 1,
      Documentation(info = "<html> Specific enthalpy of dry air is computed from temperature.
</html>"));
  end enthalpyOfNonCondensingGas;

  //--------------------------------------------------------------
  ////////////////////////////////////////////////////////////////

  function extends specificEnthalpy "Return specific enthalpy of moist air as a function of the thermodynamic state record"
    algorithm
      h := h_dT(di = state.di, T = State.T);
    annotation(
      smoothOrder = 2,
      Documentation(info = "<html>
Specific enthalpy of moist air is computed from the thermodynamic state record.
</html>"));
  end specificEnthalpy;

  //--------------------------------------------------------------
  ////////////////////////////////////////////////////////////////

  function h_dT
    extends Modelica.Icons.Function;
    input Modelica.SIunits.Density[nX] di;
    input Modelica.SIunits.Temperature T;
    output Modelica.SIunits.SpecificEnthalpy h;
  algorithm
    h := di[Air] / sum(di) * enthalpyOfNonCondensingGas(T = T) + di[Water] / sum(di) * enthalpyOfCondensingGas(T = T);
  end h_dT;

  //--------------------------------------------------------------
  ////////////////////////////////////////////////////////////////

  function extends specificHeatCapacityCp "Return specific heat capacity at constant pressure as a function of the thermodynamic state record"
    algorithm
// Based on IF97 standard
//    cp := state.X[Air] * Modelica.Media.Air.ReferenceAir.Air_Utilities.cp_dT(state.di[Air], state.T) +
//          state.X[Water] * Modelica.Media.Water.WaterIF97_base.IF97_Utilities.cp_dT(state.di[Water], state.T) ;
// Based on constant approach : the part of liquid water is neglected
      cp := 1 / sum(state.di) * (state.di[Air] * dryair.cp + state.di[Water] * steam.cp);
//
    annotation(
      Inline = false,
      smoothOrder = 2,
      Documentation(info = "<html>
The specific heat capacity at constant pressure <b>cp</b> is computed from the composition for a mixture of water (X[1]) and dry air.
</html>"));
  end specificHeatCapacityCp;

  //--------------------------------------------------------------
  ////////////////////////////////////////////////////////////////

  function Cp "Return specific heat capacity at constant pressure as a function of the thermodynamic state record"
    extends Modelica.Icons.Function;
    input Modelica.SIunits.Density[Medium.nX] di;
    output Modelica.SIunits.SpecificHeatCapacity cp;
  algorithm
// Based on IF97 standard
//    cp := state.X[Air] * Modelica.Media.Air.ReferenceAir.Air_Utilities.cp_dT(state.di[Air], state.T) +
//          state.X[Water] * Modelica.Media.Water.WaterIF97_base.IF97_Utilities.cp_dT(state.di[Water], state.T) ;
// Based on constant approach : the part of liquid water is neglected
    cp := 1 / sum(di) * (di[Air] * dryair.cp + di[Water] * steam.cp);
//
    annotation(
      Inline = false,
      smoothOrder = 2,
      Documentation(info = "<html>
The specific heat capacity at constant pressure <b>cp</b> is computed from the composition for a mixture of water (X[1]) and dry air.
</html>"));
  end Cp;

  //--------------------------------------------------------------
  ////////////////////////////////////////////////////////////////

  function extends specificHeatCapacityCv "Return specific heat capacity at constant volume"
    algorithm
// Based on IF97 standard
//    cp := state.X[Air] * Modelica.Media.Air.ReferenceAir.Air_Utilities.cp_dT(state.di[Air], state.T) +
//          state.X[Water] * Modelica.Media.Water.WaterIF97_base.IF97_Utilities.cp_dT(state.di[Water], state.T) ;
// Based on constant approach : the part of liquid water is neglected
      cv := 1 / sum(state.di) * (state.di[Air] * dryair.cv + state.di[Water] * steam.cv);
//
    annotation(
      Inline = false,
      smoothOrder = 2,
      Documentation(info = "<html>
The specific heat capacity at constant volume <b>cv</b> is computed from the composition
</html>"));
  end specificHeatCapacityCv;

  //--------------------------------------------------------------
  ////////////////////////////////////////////////////////////////

  function Cv "Return specific heat capacity at constant volume as a function of the thermodynamic state record"
    extends Modelica.Icons.Function;
    input Modelica.SIunits.Density[Medium.nX] di;
    output Modelica.SIunits.SpecificHeatCapacity cv;
  algorithm
// Based on constant approach : the part of liquid water is neglected
    cv := 1 / sum(di) * (di[Air] * dryair.cv + di[Water] * steam.cv);
//
    annotation(
      Inline = false,
      smoothOrder = 2,
      Documentation(info = "<html>
The specific heat capacity at constant volume <b>cp</b> is computed from the composition for a mixture of water (X[1]) and dry air.
</html>"));
  end Cv;

  //--------------------------------------------------------------
  ////////////////////////////////////////////////////////////////

  function extends dynamicViscosity
      extends Modelica.Icons.Function;
      input ThermodynamicState state "Thermodynamic state record";
      output DynamicViscosity mu "Dynamic viscosity";

    algorithm
      eta := dryair.mu;
    annotation(
      smoothOrder = 2,
      Documentation(info = "<html>
<p>Dynamic viscosity is fixed and computed from dry air. The influence of pressure and moisture is neglected. </p>
</html>"));
  end dynamicViscosity;

  //--------------------------------------------------------------
  ////////////////////////////////////////////////////////////////

  function extends thermalConductivity
    algorithm
      lambda := dryair.lambda;
    annotation(
      smoothOrder = 2,
      Documentation(info = "<html>
<p>Thermal conductivity is fixed computed from dry air. The influence of pressure and moisture is neglected. </p>
</html>"));
  end thermalConductivity;

  //--------------------------------------------------------------
  ////////////////////////////////////////////////////////////////

  function pDryAir_dT
    input Modelica.SIunits.Density d;
    input Modelica.SIunits.Temperature T;
    output Modelica.SIunits.Pressure p;
  algorithm
//  p := Modelica.Media.Water.WaterIF97_base.pressure_dT(d, T)
    p := d * Modelica.Constants.R / MMX[Air] * T;
  end pDryAir_dT;

  //--------------------------------------------------------------
  ////////////////////////////////////////////////////////////////

  function pWater_dT
    input Modelica.SIunits.Density d;
    input Modelica.SIunits.Temperature T;
    output Modelica.SIunits.Pressure p;
  algorithm
//  p := Modelica.Media.Air.ReferenceAir.Air_Base.pressure_dT(d, T)
    p := min(d, saturationDensity(T)) * Modelica.Constants.R / MMX[Water] * T;
  end pWater_dT;

  //--------------------------------------------------------------
  ////////////////////////////////////////////////////////////////

  record dryair "Record containing media properties"
    extends Modelica.Icons.Record;
    constant Modelica.SIunits.Density rho = 1.18 "Density";
    constant Modelica.SIunits.SpecificHeatCapacity cp = 1005 "Specific heat capacity at constant pressure";
    constant Modelica.SIunits.SpecificHeatCapacity cv = 720 "Specific heat capacity at constant volume";
    constant Modelica.SIunits.ThermalConductivity lambda = 2.62e-2 "Thermal conductivity";
    constant Modelica.SIunits.KinematicViscosity nue = 1.85e-5 "Kinematic viscosity";
    constant Modelica.SIunits.DynamicViscosity mu = 1.57e-5 "Dynamic viscosity";
    constant Modelica.SIunits.MolarMass MM = 0.029 "Medium Molar mass";
    annotation(
      Documentation(info = "<html>
Record containing (constant) air properties.
</html>"));
  end dryair;

  //--------------------------------------------------------------
  ////////////////////////////////////////////////////////////////

  record steam "Record containing media properties"
    extends Modelica.Icons.Record;
    constant Modelica.SIunits.Density rho = 0.6 "Density";
    constant Modelica.SIunits.SpecificHeatCapacity cp = 1860 "Specific heat capacity at constant pressure";
    constant Modelica.SIunits.SpecificHeatCapacity cv = 1410 "Specific heat capacity at constant volume";
    constant Modelica.SIunits.MolarMass MM = 0.018 "Medium Molar mass";
    annotation(
      Documentation(info = "<html>
Record containing (constant) air properties.
</html>"));
  end steam;

  //--------------------------------------------------------------
  ////////////////////////////////////////////////////////////////

  record liquidWater "Record containing media properties"
    extends Modelica.Icons.Record;
    constant Modelica.SIunits.Density rho = 1000 "Density";
    constant Modelica.SIunits.SpecificHeatCapacity c = 4185 "Specific heat capacity at constant pressure";
    constant Modelica.SIunits.ThermalConductivity lamda = 0.6 "Thermal conductivity";
    constant Modelica.SIunits.KinematicViscosity nue = 1.0e-3 "Kinematic viscosity";
    constant Modelica.SIunits.MolarMass MM = 0.018 "Medium Molar mass";
    constant Modelica.SIunits.SpecificEnergy LHea = 2500800 "Medium latent heat at 0°C";
    annotation(
      Documentation(info = "<html>
Record containing (constant) air properties.
</html>"));
  end liquidWater;

  //--------------------------------------------------------------
  ////////////////////////////////////////////////////////////////
  type MassFlowRate = Modelica.SIunits.MassFlowRate(quantity = "MassFlowRate." + mediumName, min = -1.0e7, max = 1.0e7) "Type for mass flow rate with medium specific attributes";
  //--------------------------------------------------------------
  //comments
  annotation(
    Documentation(info = "
<html>
<head>
<title>The Modelica License 2</title>
<style type=\"text/css\">
*       { font-size: 10pt; font-family: Arial,sans-serif; }
code    { font-size:  9pt; font-family: Courier,monospace;}
h1      { font-size: 20pt; font-weight: bold; color: rgb(32,32,32); }
h2      { font-size: 18pt; font-weight: bold; color: rgb(32,32,32); }
h3      { font-size: 16pt; font-weight: bold; color: rgb(32,32,32); }
h4      { font-size: 14pt; font-weight: bold; color: rgb(32,32,32); }
h5      { font-size: 12pt; font-weight: bold; color: rgb(32,32,32); }
h6      { font-size: 10pt; font-weight: bold; color: rgb(32,32,32); }
</style>

<meta http-equiv=\"Content-Type\" content=\"text/html;charset=utf-8\">
</head>

<!-- balise p pour paragraphe -->
<!-- balise br pour sauter une ligne -->
<!-- balise em pour italique ou plutot mettre en valeur -->

<body>

<h1> MoistAir Media  </h1>  

<p>	
The <em>MoistAir</em> packages provides most of useful equations, functions and physical quanties of a moist air. It is built following the idea of a decomposition in three
main parts. The first one is a <em>record</em> module where the principal physical quantities, being the total pressure, the temperature and the mass fraction of each species
are stored. This record, named <em>ThermodynamicState</em>, allows to simulate severals quantities variation avoiding to use severals base properties model for each variation
(cf example and <strong>base properties</strong> ). The second one is a model that contains the equation that link classical thermodynamical	properties
and others useful value (<strong>base properties</strong> chapter). The last one contains function to compute physical quanties depending on parameter values. The parameter can 
be some other quantities.
</p>


<p>
The thermodynamical properties (maily the specific heat capacity, the molar mass, the dynamic viscosity and the thermal conductivity) of the liquid water, the steam and the dry air are imported from an external record.
As a few quantifies are passed as vector, the first component always refers to the water even if the vector has only one component. For the most air, the max number of compoment is two (water and dry air). Therefore,
the integer variable Water = 1 and Air = 2.	
</p>

<h3> Base properties model  </h3> 

<p>
The model supplies equation to supply the following quantities :

<ul>
<li>The Molar Mass MM of the mixture. The liquid water (fog) is taken account here</li>
<li>The perfect gas constant R weighted by the mass fraction of steam and dry air. The liquid water (fog) is not taken account here </li>
<li>The mass fraction : </li>
<ul>
<li>X[medium.Water] = X[1] = mass of total water (steam + liquid ) per mass of moist air </li>			
<li>X[medium.Air] = X[2] = mass of dry air per mass of moist air </li>
<li>X_air = mass of dry air per mass of moist air </li>
<li>X_liquid = mass of liquid water (fog) per mass of moist air </li>
<li>X_steam = mass of steam per mass of moist air </li>	
<li>X_sat = mass of steam per mass of moist air at saturation condition. X_steam <&le> X_sat  </li>
<li>Xi[number of surbstance(=2) -1] = Xi[1] = independant mass fraction vector. Abitrary defined as mass of total water (steam + liquid ) per mass of moist air </li>
<li>x_water = mass of total water (steam + liquid ) per mass of dry air </li>				
<li>x_sat = mass of steam per mass of dry air at saturation condition </li>							
</ul>
<li>The relative humidity (phi or HR) </li>
<li>The absolute pressure (p) </li>
<li>The pressure of steam at saturation (p_steam_sat) </li>
<li>The temperature (T) </li>
<li>The specific internal energy (u) per unit  of moist air </li>			
<li>The specific internal energy (h) per unit  of moist air. The volume of water is neglected here </li>
<li>The density (d). The volume of water is neglected here </li>			
</ul>


The model requires the value of 3 three separated physical quantities for example the pressure, the temperature and the mass fraction to compute the remaining quantity. </br>
The equation system is the following :
</p>	

<h3> Functions  </h3>

<h5> Psat_T  </h5>	
<p>	
<em>Psat_T</em>	supplies the saturation pressure of steam for a given temperature. The temperature is in kelvin. The function is picked up from the modelica library with the following root : </br>
Psat_T(T) = Modelica.Media.Water.IF97_Utilities.BaseIF97.Basic.psat(T)
</p>	

<h5> X_sat </h5>		
<p>	
<em>X_sat</em> supplies the mass fraction of steam at saturation for a given temperature and pressure. The temperature is in kelvin and the pressure in pascal. </br>
X_sat = k_mair/(p/min(psat_T(T), 0.999*p)- 1 + k_mair)
</p>		

<h5> h_pTX </h5>		
<p>	
<em>h_pTX</em> supplies the specific enthalpy of the moist air for a given temperature, pressure and mass fraction. The temperature is in kelvin and the pressure in pascal.
The function computes the mass fraction of each components (liquid and steam water, dry air) to then computes the specific enthalpy.  </br>
h = X_air*air.cp*T + X_steam*(moisture.cp*T + moisture.LHea) + X_liquid*liquidWater.cp*T 
</p>		

<h5> massFraction_pTphi </h5>		
<p>	
<em>massFraction_pTphi</em> supplies the mass fraction of water for a given temperature, pressure and relative humidity (phi). If the user set a value up to 1 for phi, the mass fraction is the one of the steam and the one of the liquid water.
specific enthalpy of the moist air for a given temperature, pressure and mass fraction. The temperature is in kelvin and the pressure in pascal.
The function computes the mass fraction of each components (liquid and steam water, dry air) to then computes the specific enthalpy.  </br>
X_steam := phi*k_mair/(k_mair*phi + p/psat - phi) with psat =  psat_T(T)
</p>

</body>
</html>"));
end SimpleAir;
