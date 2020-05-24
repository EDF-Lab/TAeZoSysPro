within TAeZoSysPro.Aeraulic;

package Media
  extends Modelica.Icons.Package;

  package MyMedia
  //    extends Media.MoistAir;
  //    extends Media.SimpleAir ;
      extends Media.SimpleDryAir;
  //    extends Media.SimpleDryAirH2;
  //    extends Media.SimpleWater;
  //    extends Modelica.Media.Air.MoistAir ;
    
  end MyMedia;





















  package MoistAir
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
        Modelica.SIunits.MassFraction X_liquid "Mass fraction of liquid / kg_moistair ";
        Modelica.SIunits.MassFraction X_steam "Mass fraction of steam water / kg_moistair";
        Modelica.SIunits.MassFraction X_air "Mass fraction of air / kg_moistair ";
        //
        Real phi "Relative humidity";

      equation
//
        MM = 1 / (X[Water] / MMX[Water] + (1.0 - X[Water]) / MMX[Air]);
//Molar mass of the mixing (taking account of liquid water)
        R = Modelica.Constants.R / MMX[Air] * (X_air / (1 - X_liquid)) + Modelica.Constants.R / MMX[Water] * (X_steam / (1 - X_liquid));
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
        hi[Water] = Functions.regStep(x = di[Water] - 2 * 1e3 * Modelica.Constants.small, y1 = min(di[Water], d_steam_sat) / di[Water] * (1860 * (T - 273.15) + liquidWater.LHea) + max(di[Water] - d_steam_sat, 0) / di[Water] * (liquidWater.c * (T - 273.15)), y2 = 1860 * (T - 273.15) + liquidWater.LHea, x_small = 1e3 * Modelica.Constants.small);
        hi[Air] = dryair.cp * (T - 273.15);
        h = X[Air] * hi[Air] + X[Water] * hi[Water];
//
        u = h - p / d;
//-----
//
        X[Water] = di[Water] / d;
        X_liquid = max(di[Water] - d_steam_sat, 0) / sum(di);
        X_steam = min(di[Water], d_steam_sat) / sum(di);
        X_air = di[Air] / sum(di);
//-----
//
        state.pi = pi;
        state.T = T;
        state.di = di;
//      state.X = X ;
        state.hi = hi;
//-----
//
        phi = p / p_steam_sat * X[Water] / (X[Water] + k_mair * X[Air]);
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
      state.pi[Air] := pDryAir_dT(di[Air], T);
      state.X[Air] := di[Air] / sum(di);
      state.di[Water] := di[Water];
      state.pi[Water] := pWater_dT(di[Water], T);
      state.X[Water] := di[Water] / sum(di);
      state.p := state.pi[Air] + state.pi[Water];
      state.T := T;
      state.h := state.X[Air] * enthalpyOfNonCondensingGas(d = di[Air], T = T) + state.X[Water] * enthalpyOfWater(d = di[Water], T = T);
      state.d := sum(di);
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

    function enthalpyOfVaporization "Return enthalpy of vaporization of water as a function of the state"
      input Modelica.SIunits.Pressure p "pressure of water";
      output Modelica.SIunits.SpecificEnthalpy r0 "Vaporization enthalpy";
    protected
      Modelica.SIunits.SpecificEnthalpy h_dew "Specific enthalpy of vapor at saturation";
      Modelica.SIunits.SpecificEnthalpy h_bubble "Specific enthalpy of liquid at saturation";
    algorithm
      h_dew := Modelica.Media.Water.WaterIF97_base.IF97_Utilities.BaseIF97.Regions.hv_p(p);
      h_bubble := Modelica.Media.Water.WaterIF97_base.IF97_Utilities.BaseIF97.Regions.hl_p(p);
      r0 := h_dew - h_bubble;
      annotation(
        smoothOrder = 2,
        Documentation);
    end enthalpyOfVaporization;

    //--------------------------------------------------------------
    ////////////////////////////////////////////////////////////////

    function extends enthalpyOfCondensingGas "Return specific enthalpy of STEAM as a function of temperature and pressure in state"
        input Modelica.SIunits.Pressure p = 101325 "pressure of water";

      algorithm
//    h := Modelica.Media.Water.WaterIF97_base.specificEnthalpy_pT(p, T, region = 2);
        h := 1860 * (T - 273.15) + liquidWater.LHea;
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
        input Modelica.SIunits.Density d = 1.2 "density of dry air";

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

    function extends enthalpyOfLiquid "Return enthalpy of liquid water as a function of state"
        input Modelica.SIunits.Pressure p "Total pressure of mixture";

      algorithm
        h := Modelica.Media.Water.IF97_Utilities.h_pT(p = p, T = T, region = 1);
      annotation(
        Inline = false,
        smoothOrder = 5,
        Documentation(info = "<html>
Specific enthalpy of liquid water is computed from temperature using a polynomial approach. Kept for compatibility reasons, better use <a href=\"modelica://Modelica.Media.Air.MoistAir.enthalpyOfWater\">enthalpyOfWater</a> instead.
</html>"));
    end enthalpyOfLiquid;

    //--------------------------------------------------------------
    ////////////////////////////////////////////////////////////////

    function enthalpyOfWater "Return enthalpy of water (vapor and liquid) as function of the density and temperature"
      input Modelica.SIunits.Density d "density of water";
      input Modelica.SIunits.Temperature T "density of water";
      output Modelica.SIunits.SpecificEnthalpy h "Specific enthalpy of water";
    algorithm
//    h := Modelica.Media.Water.IF97_Utilities.h_dT(d = d, T = T) ;
      h := min(d, saturationDensity(T)) / d * (1860 * (T - 273.15) + liquidWater.LHea) + max(d - saturationDensity(T), 0) / d * (liquidWater.c * (T - 273.15));
      annotation(
        Inline = false,
        smoothOrder = 5,
        Documentation(info = "<html>
Specific enthalpy of liquid water is computed from temperature using a polynomial approach. Kept for compatibility reasons, better use <a href=\"modelica://Modelica.Media.Air.MoistAir.enthalpyOfWater\">enthalpyOfWater</a> instead.
</html>"));
    end enthalpyOfWater;

    //--------------------------------------------------------------
    ////////////////////////////////////////////////////////////////

    function extends specificEnthalpy "Return specific enthalpy of moist air as a function of the thermodynamic state record"
      algorithm
        h := h_dT(di = state.di, T = state.T);
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
      h := di[Air] / sum(di) * enthalpyOfNonCondensingGas(d = di[Air], T = T) + di[Water] / sum(di) * enthalpyOfWater(d = di[Water], T = T);
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
        cp := 1 / sum(state.di) * (state.di[Air] * dryair.cv + state.di[Water] * steam.cv);
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

    function extends dynamicViscosity "Return dynamic viscosity as a function of the thermodynamic state record, valid from 123.15 K to 1273.15 K"
        import Modelica.Media.Incompressible.TableBased.Polynomials_Temp;
        import Cv = Modelica.SIunits.Conversions;

      algorithm
        eta := 1e-6 * Polynomials_Temp.evaluateWithRange({9.7391102886305869E-15, -3.1353724870333906E-11, 4.3004876595642225E-08, -3.8228016291758240E-05, 5.0427874367180762E-02, 1.7239260139242528E+01}, Cv.to_degC(123.15), Cv.to_degC(1273.15), Cv.to_degC(state.T));
      annotation(
        smoothOrder = 2,
        Documentation(info = "<html>
<p>Dynamic viscosity is computed from temperature using a simple polynomial for dry air. Range of validity is from 123.15 K to 1273.15 K. The influence of pressure and moisture is neglected. </p>
<p>Source: VDI Waermeatlas, 8th edition. </p>
</html>"));
    end dynamicViscosity;

    //--------------------------------------------------------------
    ////////////////////////////////////////////////////////////////

    function extends thermalConductivity "Return thermal conductivity as a function of the thermodynamic state record, valid from 123.15 K to 1273.15 K"
        import Modelica.Media.Incompressible.TableBased.Polynomials_Temp;
        import Cv = Modelica.SIunits.Conversions;

      algorithm
        lambda := 1e-3 * Polynomials_Temp.evaluateWithRange({6.5691470817717812E-15, -3.4025961923050509E-11, 5.3279284846303157E-08, -4.5340839289219472E-05, 7.6129675309037664E-02, 2.4169481088097051E+01}, Cv.to_degC(123.15), Cv.to_degC(1273.15), Cv.to_degC(state.T));
      annotation(
        smoothOrder = 2,
        Documentation(info = "<html>
<p>Thermal conductivity is computed from temperature using a simple polynomial for dry air. Range of validity is from 123.15 K to 1273.15 K. The influence of pressure and moisture is neglected. </p>
<p>Source: VDI Waermeatlas, 8th edition. </p>
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
      constant Modelica.SIunits.ThermalConductivity lamda = 2.62e-2 "Thermal conductivity";
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
  end MoistAir;





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

  package SimpleDryAir
    ////////////////////////////////////////////////////////////////
    extends Modelica.Media.Interfaces.PartialCondensingGases(mediumName = "DryAir", substanceNames = {"Air"}, final fixedX = false, final reducedX = true, final singleState = false, reference_X = {1.0});
    //--------------------------------------------------------------
    ////////////////////////////////////////////////////////////////
    // Provide constants here
    constant Integer Air = 1 "Index of air (in substanceNames, massFractions X, etc.)";
    constant Modelica.SIunits.MolarMass[1] MMX = {dryair.MM};
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
        // Density declaration
        Modelica.SIunits.Density[nX] di "Density peer species";
        // Enthalpy declaration
        Modelica.SIunits.SpecificEnthalpy[nX] hi "Specific enthalpy of a species";

      equation
//
        MM = MMX[Air];
//Molar mass of the mixing (taking account of liquid water)
        R = Modelica.Constants.R / MMX[Air];
//-----
//
        d = sum(di);
//
        pi[Air] = di[Air] * Modelica.Constants.R / MMX[Air] * T;
        p = sum(pi);
//
        hi[Air] = dryair.cp * (T - 273.15);
        h = hi[Air];
//
        u = h - p / d;
//-----
//
        state.pi = pi;
        state.T = T;
        state.di = di;
        state.hi = hi;
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
      state.pi[Air] := di[Air] * Modelica.Constants.R / MMX[Air] * T;
      state.T := T;
      state.hi[Air] := enthalpyOfNonCondensingGas(T = T);
    end setState_diT;

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
      h := enthalpyOfNonCondensingGas(T = T);
    end h_dT;

    //--------------------------------------------------------------
    ////////////////////////////////////////////////////////////////

    function extends specificHeatCapacityCp "Return specific heat capacity at constant pressure as a function of the thermodynamic state record"
      algorithm
// Based on IF97 standard
//    cp := Modelica.Media.Air.ReferenceAir.Air_Utilities.cp_dT(state.di[Air], state.T) ;
// Based on constant approach : the part of liquid water is neglected
        cp := dryair.cp;
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
//    cp := Modelica.Media.Air.ReferenceAir.Air_Utilities.cp_dT(state.di[Air], state.T) ;
// Based on constant approach : the part of liquid water is neglected
      cp := dryair.cp;
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
//    cp := Modelica.Media.Air.ReferenceAir.Air_Utilities.cv_dT(state.di[Air], state.T) ;
// Based on constant approach : the part of liquid water is neglected
        cv := water.cv;
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
      cv := water.cv;
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
  end SimpleDryAir;

  package MoistAir_package "Air: Moist air model (190 ... 647 K)"
    extends Interfaces.PartialCondensingGases(mediumName = "Moist air", substanceNames = {"water", "air"}, final reducedX = true, final singleState = false, reference_X = {0.01, 0.99}, fluidConstants = {IdealGases.Common.FluidData.H2O, IdealGases.Common.FluidData.N2}, Temperature(min = 190, max = 647));
    import Modelica.Media.IdealGases.Common.Functions;
    constant Integer Water = 1 "Index of water (in substanceNames, massFractions X, etc.)";
    constant Integer Air = 2 "Index of air (in substanceNames, massFractions X, etc.)";
    //     constant SI.Pressure psat_low=saturationPressureWithoutLimits(200.0);
    //     constant SI.Pressure psat_high=saturationPressureWithoutLimits(422.16);
    constant Real k_mair = steam.MM / dryair.MM "Ratio of molar weights";
    constant IdealGases.Common.DataRecord dryair = IdealGases.Common.SingleGasesData.Air;
    constant IdealGases.Common.DataRecord steam = IdealGases.Common.SingleGasesData.H2O;
    constant SI.MolarMass[2] MMX = {steam.MM, dryair.MM} "Molar masses of components";
    import Modelica.Media.Interfaces;
    import Modelica.Math;
    import Modelica.Constants;
    import Modelica.Media.IdealGases.Common.SingleGasNasa;
    import Modelica.Media.Interfaces.Choices.ReferenceEnthalpy;

    redeclare record extends ThermodynamicState "ThermodynamicState record for moist air"
    end ThermodynamicState;

    redeclare replaceable model extends BaseProperties(T(stateSelect = if preferredMediumStates then StateSelect.prefer else StateSelect.default), p(stateSelect = if preferredMediumStates then StateSelect.prefer else StateSelect.default), Xi(each stateSelect = if preferredMediumStates then StateSelect.prefer else StateSelect.default), final standardOrderComponents = true) "Moist air base properties record"
        /* p, T, X = X[Water] are used as preferred states, since only then all
                                                                                                             other quantities can be computed in a recursive sequence.
                                                                                                             If other variables are selected as states, static state selection
                                                                                                             is no longer possible and non-linear algebraic equations occur.
                                                                                                              */
        MassFraction x_water "Mass of total water/mass of dry air";
        Real phi "Relative humidity";

      protected
        MassFraction X_liquid "Mass fraction of liquid or solid water";
        MassFraction X_steam "Mass fraction of steam water";
        MassFraction X_air "Mass fraction of air";
        MassFraction X_sat "Steam water mass fraction of saturation boundary in kg_water/kg_moistair";
        MassFraction x_sat "Steam water mass content of saturation boundary in kg_water/kg_dryair";
        AbsolutePressure p_steam_sat "partial saturation pressure of steam";

      equation
        assert(T >= 190 and T <= 647, "
Temperature T is not in the allowed range
190.0 K <= (T =" + String(T) + " K) <= 647.0 K
required from medium model \"" + mediumName + "\".");
        MM = 1 / (Xi[Water] / MMX[Water] + (1.0 - Xi[Water]) / MMX[Air]);
        p_steam_sat = min(saturationPressure(T), 0.999 * p);
        X_sat = min(p_steam_sat * k_mair / max(100 * Constants.eps, p - p_steam_sat) * (1 - Xi[Water]), 1.0) "Water content at saturation with respect to actual water content";
        X_liquid = max(Xi[Water] - X_sat, 0.0);
        X_steam = Xi[Water] - X_liquid;
        X_air = 1 - Xi[Water];
        h = specificEnthalpy_pTX(p, T, Xi);
        R = dryair.R * (X_air / (1 - X_liquid)) + steam.R * X_steam / (1 - X_liquid);
//
        u = h - R * T;
        d = p / (R * T);
/* Note, u and d are computed under the assumption that the volume of the liquid
     water is negligible with respect to the volume of air and of steam
  */
        state.p = p;
        state.T = T;
        state.X = X;
// these x are per unit mass of DRY air!
        x_sat = k_mair * p_steam_sat / max(100 * Constants.eps, p - p_steam_sat);
        x_water = Xi[Water] / max(X_air, 100 * Constants.eps);
        phi = p / p_steam_sat * Xi[Water] / (Xi[Water] + k_mair * X_air);
      annotation(
        Documentation(info = "<html>
<p>This model computes thermodynamic properties of moist air from three independent (thermodynamic or/and numerical) state variables. Preferred numerical states are temperature T, pressure p and the reduced composition vector Xi, which contains the water mass fraction only. As an EOS the <b>ideal gas law</b> is used and associated restrictions apply. The model can also be used in the <b>fog region</b>, when moisture is present in its liquid state. However, it is assumed that the liquid water volume is negligible compared to that of the gas phase. Computation of thermal properties is based on property data of <a href=\"modelica://Modelica.Media.Air.DryAirNasa\"> dry air</a> and water (source: VDI-W&auml;rmeatlas), respectively. Besides the standard thermodynamic variables <b>absolute and relative humidity</b>, x_water and phi, respectively, are given by the model. Upper case X denotes absolute humidity with respect to mass of moist air while absolute humidity with respect to mass of dry air only is denoted by a lower case x throughout the model. See <a href=\"modelica://Modelica.Media.Air.MoistAir\">package description</a> for further information.</p>
</html>"));
    end BaseProperties;

    redeclare function setState_pTX "Return thermodynamic state as function of pressure p, temperature T and composition X"
      extends Modelica.Icons.Function;
      input AbsolutePressure p "Pressure";
      input Temperature T "Temperature";
      input MassFraction X[:] = reference_X "Mass fractions";
      output ThermodynamicState state "Thermodynamic state";
    algorithm
      state := if size(X, 1) == nX then ThermodynamicState(p = p, T = T, X = X) else ThermodynamicState(p = p, T = T, X = cat(1, X, {1 - sum(X)}));
      annotation(
        smoothOrder = 2,
        Documentation(info = "<html>
The <a href=\"modelica://Modelica.Media.Air.MoistAir.ThermodynamicState\">thermodynamic state record</a> is computed from pressure p, temperature T and composition X.
</html>"));
    end setState_pTX;

    redeclare function setState_phX "Return thermodynamic state as function of pressure p, specific enthalpy h and composition X"
      extends Modelica.Icons.Function;
      input AbsolutePressure p "Pressure";
      input SpecificEnthalpy h "Specific enthalpy";
      input MassFraction X[:] = reference_X "Mass fractions";
      output ThermodynamicState state "Thermodynamic state";
    algorithm
      state := if size(X, 1) == nX then ThermodynamicState(p = p, T = T_phX(p, h, X), X = X) else ThermodynamicState(p = p, T = T_phX(p, h, X), X = cat(1, X, {1 - sum(X)}));
      annotation(
        smoothOrder = 2,
        Documentation(info = "<html>
The <a href=\"modelica://Modelica.Media.Air.MoistAir.ThermodynamicState\">thermodynamic state record</a> is computed from pressure p, specific enthalpy h and composition X.
</html>"));
    end setState_phX;

    redeclare function setState_dTX "Return thermodynamic state as function of density d, temperature T and composition X"
      extends Modelica.Icons.Function;
      input Density d "Density";
      input Temperature T "Temperature";
      input MassFraction X[:] = reference_X "Mass fractions";
      output ThermodynamicState state "Thermodynamic state";
    algorithm
      state := if size(X, 1) == nX then ThermodynamicState(p = d * ({steam.R, dryair.R} * X) * T, T = T, X = X) else ThermodynamicState(p = d * ({steam.R, dryair.R} * cat(1, X, {1 - sum(X)})) * T, T = T, X = cat(1, X, {1 - sum(X)}));
      annotation(
        smoothOrder = 2,
        Documentation(info = "<html>
The <a href=\"modelica://Modelica.Media.Air.MoistAir.ThermodynamicState\">thermodynamic state record</a> is computed from density d, temperature T and composition X.
</html>"));
    end setState_dTX;

    redeclare function extends setSmoothState "Return thermodynamic state so that it smoothly approximates: if x > 0 then state_a else state_b"
      algorithm
        state := ThermodynamicState(p = Media.Common.smoothStep(x, state_a.p, state_b.p, x_small), T = Media.Common.smoothStep(x, state_a.T, state_b.T, x_small), X = Media.Common.smoothStep(x, state_a.X, state_b.X, x_small));
    end setSmoothState;

    function Xsaturation "Return absolute humidity per unit mass of moist air at saturation as a function of the thermodynamic state record"
      extends Modelica.Icons.Function;
      input ThermodynamicState state "Thermodynamic state record";
      output MassFraction X_sat "Steam mass fraction of sat. boundary";
    algorithm
      X_sat := k_mair / (state.p / min(saturationPressure(state.T), 0.999 * state.p) - 1 + k_mair);
      annotation(
        smoothOrder = 2,
        Documentation(info = "<html>
Absolute humidity per unit mass of moist air at saturation is computed from pressure and temperature in the state record. Note, that unlike X_sat in the BaseProperties model this mass fraction refers to mass of moist air at saturation.
</html>"));
    end Xsaturation;

    function xsaturation "Return absolute humidity per unit mass of dry air at saturation as a function of the thermodynamic state record"
      extends Modelica.Icons.Function;
      input ThermodynamicState state "Thermodynamic state record";
      output MassFraction x_sat "Absolute humidity per unit mass of dry air";
    algorithm
      x_sat := k_mair * saturationPressure(state.T) / max(100 * Constants.eps, state.p - saturationPressure(state.T));
      annotation(
        smoothOrder = 2,
        Documentation(info = "<html>
Absolute humidity per unit mass of dry air at saturation is computed from pressure and temperature in the thermodynamic state record.
</html>"));
    end xsaturation;

    function xsaturation_pT "Return absolute humidity per unit mass of dry air at saturation as a function of pressure p and temperature T"
      extends Modelica.Icons.Function;
      input AbsolutePressure p "Pressure";
      input SI.Temperature T "Temperature";
      output MassFraction x_sat "Absolute humidity per unit mass of dry air";
    algorithm
      x_sat := k_mair * saturationPressure(T) / max(100 * Constants.eps, p - saturationPressure(T));
      annotation(
        smoothOrder = 2,
        Documentation(info = "<html>
Absolute humidity per unit mass of dry air at saturation is computed from pressure and temperature.
</html>"));
    end xsaturation_pT;

    function massFraction_pTphi "Return steam mass fraction as a function of relative humidity phi and temperature T"
      extends Modelica.Icons.Function;
      input AbsolutePressure p "Pressure";
      input Temperature T "Temperature";
      input Real phi "Relative humidity (0 ... 1.0)";
      output MassFraction X_steam "Absolute humidity, steam mass fraction";
    protected
      constant Real k = 0.621964713077499 "Ratio of molar masses";
      AbsolutePressure psat = saturationPressure(T) "Saturation pressure";
    algorithm
      X_steam := phi * k / (k * phi + p / psat - phi);
      annotation(
        smoothOrder = 2,
        Documentation(info = "<html>
Absolute humidity per unit mass of moist air is computed from temperature, pressure and relative humidity.
</html>"));
    end massFraction_pTphi;

    function relativeHumidity_pTX "Return relative humidity as a function of pressure p, temperature T and composition X"
      extends Modelica.Icons.Function;
      input SI.Pressure p "Pressure";
      input SI.Temperature T "Temperature";
      input SI.MassFraction[:] X "Composition";
      output Real phi "Relative humidity";
    protected
      SI.Pressure p_steam_sat "Saturation pressure";
      SI.MassFraction X_air "Dry air mass fraction";
    algorithm
      p_steam_sat := min(saturationPressure(T), 0.999 * p);
      X_air := 1 - X[Water];
      phi := max(0.0, min(1.0, p / p_steam_sat * X[Water] / (X[Water] + k_mair * X_air)));
      annotation(
        smoothOrder = 2,
        Documentation(info = "<html>
Relative humidity is computed from pressure, temperature and composition with 1.0 as the upper limit at saturation. Water mass fraction is the first entry in the composition vector.
</html>"));
    end relativeHumidity_pTX;

    function relativeHumidity "Return relative humidity as a function of the thermodynamic state record"
      extends Modelica.Icons.Function;
      input ThermodynamicState state "Thermodynamic state";
      output Real phi "Relative humidity";
    algorithm
      phi := relativeHumidity_pTX(state.p, state.T, state.X);
      annotation(
        smoothOrder = 2,
        Documentation(info = "<html>
Relative humidity is computed from the thermodynamic state record with 1.0 as the upper limit at saturation.
</html>"));
    end relativeHumidity;

    /*
                                                                        redeclare function setState_psX "Return thermodynamic state as function of p, s and composition X"
                                                                          extends Modelica.Icons.Function;
                                                                          input AbsolutePressure p "Pressure";
                                                                          input SpecificEntropy s "Specific entropy";
                                                                          input MassFraction X[:]=reference_X "Mass fractions";
                                                                          output ThermodynamicState state;
                                                                        algorithm
                                                                          state := if size(X,1) == nX then ThermodynamicState(p=p,T=T_psX(s,p,X),X=X)
                                                                            else ThermodynamicState(p=p,T=T_psX(p,s,X), X=cat(1,X,{1-sum(X)}));
                                                                        end setState_psX;
                                                                    */

    redeclare function extends gasConstant "Return ideal gas constant as a function from thermodynamic state, only valid for phi<1"
      algorithm
        R := dryair.R * (1 - state.X[Water]) + steam.R * state.X[Water];
      annotation(
        smoothOrder = 2,
        Documentation(info = "<html>
The ideal gas constant for moist air is computed from <a href=\"modelica://Modelica.Media.Air.MoistAir.ThermodynamicState\">thermodynamic state</a> assuming that all water is in the gas phase.
</html>"));
    end gasConstant;

    function gasConstant_X "Return ideal gas constant as a function from composition X"
      extends Modelica.Icons.Function;
      input SI.MassFraction X[:] "Gas phase composition";
      output SI.SpecificHeatCapacity R "Ideal gas constant";
    algorithm
      R := dryair.R * (1 - X[Water]) + steam.R * X[Water];
      annotation(
        smoothOrder = 2,
        Documentation(info = "<html>
The ideal gas constant for moist air is computed from the gas phase composition. The first entry in composition vector X is the steam mass fraction of the gas phase.
</html>"));
    end gasConstant_X;

    function saturationPressureLiquid "Return saturation pressure of water as a function of temperature T in the range of 273.16 to 647.096 K"
      extends Modelica.Icons.Function;
      input SI.Temperature Tsat "Saturation temperature";
      output SI.AbsolutePressure psat "Saturation pressure";
    protected
      SI.Temperature Tcritical = 647.096 "Critical temperature";
      SI.AbsolutePressure pcritical = 22.064e6 "Critical pressure";
      Real r1 = 1 - Tsat / Tcritical "Common subexpression";
      Real a[:] = {-7.85951783, 1.84408259, -11.7866497, 22.6807411, -15.9618719, 1.80122502} "Coefficients a[:]";
      Real n[:] = {1.0, 1.5, 3.0, 3.5, 4.0, 7.5} "Coefficients n[:]";
    algorithm
      psat := exp((a[1] * r1 ^ n[1] + a[2] * r1 ^ n[2] + a[3] * r1 ^ n[3] + a[4] * r1 ^ n[4] + a[5] * r1 ^ n[5] + a[6] * r1 ^ n[6]) * Tcritical / Tsat) * pcritical;
      annotation(
        derivative = saturationPressureLiquid_der,
        Inline = false,
        smoothOrder = 5,
        Documentation(info = "<html>
<p>Saturation pressure of water above the triple point temperature is computed from temperature. </p>
<p>Source: A Saul, W Wagner: &quot;International equations for the saturation properties of ordinary water substance&quot;, equation 2.1 </p>
</html>"));
    end saturationPressureLiquid;

    function saturationPressureLiquid_der "Derivative function for 'saturationPressureLiquid'"
      extends Modelica.Icons.Function;
      input SI.Temperature Tsat "Saturation temperature";
      input Real dTsat(unit = "K/s") "Saturation temperature derivative";
      output Real psat_der(unit = "Pa/s") "Saturation pressure derivative";
    protected
      SI.Temperature Tcritical = 647.096 "Critical temperature";
      SI.AbsolutePressure pcritical = 22.064e6 "Critical pressure";
      Real r1 = 1 - Tsat / Tcritical "Common subexpression 1";
      Real r1_der = -1 / Tcritical * dTsat "Derivative of common subexpression 1";
      Real a[:] = {-7.85951783, 1.84408259, -11.7866497, 22.6807411, -15.9618719, 1.80122502} "Coefficients a[:]";
      Real n[:] = {1.0, 1.5, 3.0, 3.5, 4.0, 7.5} "Coefficients n[:]";
      Real r2 = a[1] * r1 ^ n[1] + a[2] * r1 ^ n[2] + a[3] * r1 ^ n[3] + a[4] * r1 ^ n[4] + a[5] * r1 ^ n[5] + a[6] * r1 ^ n[6] "Common subexpression 2";
    algorithm
// Approach used here is based on Baehr: "Thermodynamik", 12th edition p.204ff, "Method of Wagner"
//psat := exp(((a[1]*r1^n[1] + a[2]*r1^n[2] + a[3]*r1^n[3] + a[4]*r1^n[4] + a[5]*r1^n[5] + a[6]*r1^n[6])*Tcritical)/Tsat) * pcritical;
      psat_der := exp(r2 * Tcritical / Tsat) * pcritical * ((a[1] * (r1 ^ (n[1] - 1) * n[1] * r1_der) + a[2] * (r1 ^ (n[2] - 1) * n[2] * r1_der) + a[3] * (r1 ^ (n[3] - 1) * n[3] * r1_der) + a[4] * (r1 ^ (n[4] - 1) * n[4] * r1_der) + a[5] * (r1 ^ (n[5] - 1) * n[5] * r1_der) + a[6] * (r1 ^ (n[6] - 1) * n[6] * r1_der)) * Tcritical / Tsat - r2 * Tcritical * dTsat / Tsat ^ 2);
      annotation(
        Inline = false,
        smoothOrder = 5,
        Documentation(info = "<html>
<p>Saturation pressure of water above the triple point temperature is computed from temperature. </p>
<p>Source: A Saul, W Wagner: &quot;International equations for the saturation properties of ordinary water substance&quot;, equation 2.1 </p>
</html>"));
    end saturationPressureLiquid_der;

    function sublimationPressureIce "Return sublimation pressure of water as a function of temperature T between 190 and 273.16 K"
      extends Modelica.Icons.Function;
      input SI.Temperature Tsat "Sublimation temperature";
      output SI.AbsolutePressure psat "Sublimation pressure";
    protected
      SI.Temperature Ttriple = 273.16 "Triple point temperature";
      SI.AbsolutePressure ptriple = 611.657 "Triple point pressure";
      Real r1 = Tsat / Ttriple "Common subexpression";
      Real a[:] = {-13.9281690, 34.7078238} "Coefficients a[:]";
      Real n[:] = {-1.5, -1.25} "Coefficients n[:]";
    algorithm
      psat := exp(a[1] - a[1] * r1 ^ n[1] + a[2] - a[2] * r1 ^ n[2]) * ptriple;
      annotation(
        Inline = false,
        smoothOrder = 5,
        derivative = sublimationPressureIce_der,
        Documentation(info = "<html>
<p>Sublimation pressure of water below the triple point temperature is computed from temperature.</p>
<p>Source: W Wagner, A Saul, A Pruss: &quot;International equations for the pressure along the melting and along the sublimation curve of ordinary water substance&quot;, equation 3.5</p>
</html>"));
    end sublimationPressureIce;

    function sublimationPressureIce_der "Derivative function for 'sublimationPressureIce'"
      extends Modelica.Icons.Function;
      input SI.Temperature Tsat "Sublimation temperature";
      input Real dTsat(unit = "K/s") "Sublimation temperature derivative";
      output Real psat_der(unit = "Pa/s") "Sublimation pressure derivative";
    protected
      SI.Temperature Ttriple = 273.16 "Triple point temperature";
      SI.AbsolutePressure ptriple = 611.657 "Triple point pressure";
      Real r1 = Tsat / Ttriple "Common subexpression 1";
      Real r1_der = dTsat / Ttriple "Derivative of common subexpression 1";
      Real a[:] = {-13.9281690, 34.7078238} "Coefficients a[:]";
      Real n[:] = {-1.5, -1.25} "Coefficients n[:]";
    algorithm
//psat := exp(a[1] - a[1]*r1^n[1] + a[2] - a[2]*r1^n[2]) * ptriple;
      psat_der := exp(a[1] - a[1] * r1 ^ n[1] + a[2] - a[2] * r1 ^ n[2]) * ptriple * ((-a[1] * (r1 ^ (n[1] - 1) * n[1] * r1_der)) - a[2] * (r1 ^ (n[2] - 1) * n[2] * r1_der));
      annotation(
        Inline = false,
        smoothOrder = 5,
        Documentation(info = "<html>
<p>Sublimation pressure of water below the triple point temperature is computed from temperature.</p>
<p>Source: W Wagner, A Saul, A Pruss: &quot;International equations for the pressure along the melting and along the sublimation curve of ordinary water substance&quot;, equation 3.5</p>
</html>"));
    end sublimationPressureIce_der;

    redeclare function extends saturationPressure "Return saturation pressure of water as a function of temperature T between 190 and 647.096 K"
      algorithm
        psat := Utilities.spliceFunction(saturationPressureLiquid(Tsat), sublimationPressureIce(Tsat), Tsat - 273.16, 1.0);
      annotation(
        Inline = false,
        smoothOrder = 5,
        derivative = saturationPressure_der,
        Documentation(info = "<html>
Saturation pressure of water in the liquid and the solid region is computed using correlations. Functions for the
<a href=\"modelica://Modelica.Media.Air.MoistAir.sublimationPressureIce\">solid</a> and the <a href=\"modelica://Modelica.Media.Air.MoistAir.saturationPressureLiquid\"> liquid</a> region, respectively, are combined using the first derivative continuous <a href=\"modelica://Modelica.Media.Air.MoistAir.Utilities.spliceFunction\">spliceFunction</a>. This functions range of validity is from 190 to 647.096 K. For more information on the type of correlation used, see the documentation of the linked functions.
</html>"));
    end saturationPressure;

    function saturationPressure_der "Derivative function for 'saturationPressure'"
      extends Modelica.Icons.Function;
      input Temperature Tsat "Saturation temperature";
      input Real dTsat(unit = "K/s") "Time derivative of saturation temperature";
      output Real psat_der(unit = "Pa/s") "Saturation pressure";
    algorithm
/*psat := Utilities.spliceFunction(saturationPressureLiquid(Tsat),sublimationPressureIce(Tsat),Tsat-273.16,1.0);*/
      psat_der := Utilities.spliceFunction_der(saturationPressureLiquid(Tsat), sublimationPressureIce(Tsat), Tsat - 273.16, 1.0, saturationPressureLiquid_der(Tsat = Tsat, dTsat = dTsat), sublimationPressureIce_der(Tsat = Tsat, dTsat = dTsat), dTsat, 0);
      annotation(
        Inline = false,
        smoothOrder = 5,
        Documentation(info = "<html>
Derivative function of <a href=\"modelica://Modelica.Media.Air.MoistAir.saturationPressure\">saturationPressure</a>
</html>"));
    end saturationPressure_der;

    function saturationTemperature "Return saturation temperature of water as a function of (partial) pressure p"
      extends Modelica.Icons.Function;
      input SI.Pressure p "Pressure";
      input SI.Temperature T_min = 190 "Lower boundary of solution";
      input SI.Temperature T_max = 647 "Upper boundary of solution";
      output SI.Temperature T "Saturation temperature";
    protected
      package Internal
        extends Modelica.Media.Common.OneNonLinearEquation;

        redeclare record extends f_nonlinear_Data
            // Define data to be passed to user function
        end f_nonlinear_Data;

        redeclare function extends f_nonlinear
          algorithm
            y := saturationPressure(x);
// Compute the non-linear equation: y = f(x, Data)
        end f_nonlinear;

        // Dummy definition

        redeclare function extends solve
        end solve;
      end Internal;
    algorithm
      T := Internal.solve(p, T_min, T_max, f_nonlinear_data = Internal.f_nonlinear_Data());
      annotation(
        Documentation(info = "<html>
Computes saturation temperature from (partial) pressure via numerical inversion of the function <a href=\"modelica://Modelica.Media.Air.MoistAir.saturationPressure\">saturationPressure</a>. Therefore additional inputs are required (or the defaults are used) for upper and lower temperature bounds.
</html>"));
    end saturationTemperature;

    redeclare function extends enthalpyOfVaporization "Return enthalpy of vaporization of water as a function of temperature T, 273.16 to 647.096 K"
      protected
        Real Tcritical = 647.096 "Critical temperature";
        Real dcritical = 322 "Critical density";
        Real pcritical = 22.064e6 "Critical pressure";
        Real n[:] = {1, 1.5, 3, 3.5, 4, 7.5} "Powers in equation (1)";
        Real a[:] = {-7.85951783, 1.84408259, -11.7866497, 22.6807411, -15.9618719, 1.80122502} "Coefficients in equation (1) of [1]";
        Real m[:] = {1 / 3, 2 / 3, 5 / 3, 16 / 3, 43 / 3, 110 / 3} "Powers in equation (2)";
        Real b[:] = {1.99274064, 1.09965342, -0.510839303, -1.75493479, -45.5170352, -6.74694450e5} "Coefficients in equation (2) of [1]";
        Real o[:] = {2 / 6, 4 / 6, 8 / 6, 18 / 6, 37 / 6, 71 / 6} "Powers in equation (3)";
        Real c[:] = {-2.03150240, -2.68302940, -5.38626492, -17.2991605, -44.7586581, -63.9201063} "Coefficients in equation (3) of [1]";
        Real tau = 1 - T / Tcritical "Temperature expression";
        Real r1 = a[1] * Tcritical * tau ^ n[1] / T + a[2] * Tcritical * tau ^ n[2] / T + a[3] * Tcritical * tau ^ n[3] / T + a[4] * Tcritical * tau ^ n[4] / T + a[5] * Tcritical * tau ^ n[5] / T + a[6] * Tcritical * tau ^ n[6] / T "Expression 1";
        Real r2 = a[1] * n[1] * tau ^ n[1] + a[2] * n[2] * tau ^ n[2] + a[3] * n[3] * tau ^ n[3] + a[4] * n[4] * tau ^ n[4] + a[5] * n[5] * tau ^ n[5] + a[6] * n[6] * tau ^ n[6] "Expression 2";
        Real dp = dcritical * (1 + b[1] * tau ^ m[1] + b[2] * tau ^ m[2] + b[3] * tau ^ m[3] + b[4] * tau ^ m[4] + b[5] * tau ^ m[5] + b[6] * tau ^ m[6]) "Density of saturated liquid";
        Real dpp = dcritical * exp(c[1] * tau ^ o[1] + c[2] * tau ^ o[2] + c[3] * tau ^ o[3] + c[4] * tau ^ o[4] + c[5] * tau ^ o[5] + c[6] * tau ^ o[6]) "Density of saturated vapor";

      algorithm
        r0 := -(dp - dpp) * exp(r1) * pcritical * (r2 + r1 * tau) / (dp * dpp * tau) "Difference of equations (7) and (6)";
      annotation(
        smoothOrder = 2,
        Documentation(info = "<html>
<p>Enthalpy of vaporization of water is computed from temperature in the region of 273.16 to 647.096 K.</p>
<p>Source: W Wagner, A Pruss: \"International equations for the saturation properties of ordinary water substance. Revised according to the international temperature scale of 1990\" (1993).</p>
</html>"));
    end enthalpyOfVaporization;

    function HeatCapacityOfWater "Return specific heat capacity of water (liquid only) as a function of temperature T"
      extends Modelica.Icons.Function;
      input Temperature T "Temperature";
      output SpecificHeatCapacity cp_fl "Specific heat capacity of liquid";
    algorithm
      cp_fl := 1e3 * (4.2166 - (T - 273.15) * (0.0033166 + (T - 273.15) * (0.00010295 - (T - 273.15) * (1.3819e-6 + (T - 273.15) * 7.3221e-9))));
      annotation(
        Documentation(info = "<html>
The specific heat capacity of water (liquid and solid) is calculated using a
             polynomial approach and data from VDI-Waermeatlas 8. Edition (Db1)
</html>"),
        smoothOrder = 2);
    end HeatCapacityOfWater;

    redeclare function extends enthalpyOfLiquid "Return enthalpy of liquid water as a function of temperature T(use enthalpyOfWater instead)"
      algorithm
        h := (T - 273.15) * 1e3 * (4.2166 - 0.5 * (T - 273.15) * (0.0033166 + 0.333333 * (T - 273.15) * (0.00010295 - 0.25 * (T - 273.15) * (1.3819e-6 + 0.2 * (T - 273.15) * 7.3221e-9))));
      annotation(
        Inline = false,
        smoothOrder = 5,
        Documentation(info = "<html>
Specific enthalpy of liquid water is computed from temperature using a polynomial approach. Kept for compatibility reasons, better use <a href=\"modelica://Modelica.Media.Air.MoistAir.enthalpyOfWater\">enthalpyOfWater</a> instead.
</html>"));
    end enthalpyOfLiquid;

    redeclare function extends enthalpyOfGas "Return specific enthalpy of gas (air and steam) as a function of temperature T and composition X"
      algorithm
        h := Modelica.Media.IdealGases.Common.Functions.h_Tlow(data = steam, T = T, refChoice = ReferenceEnthalpy.UserDefined, h_off = 46479.819 + 2501014.5) * X[Water] + Modelica.Media.IdealGases.Common.Functions.h_Tlow(data = dryair, T = T, refChoice = ReferenceEnthalpy.UserDefined, h_off = 25104.684) * (1.0 - X[Water]);
      annotation(
        Inline = false,
        smoothOrder = 5,
        Documentation(info = "<html>
Specific enthalpy of moist air is computed from temperature, provided all water is in the gaseous state. The first entry in the composition vector X must be the mass fraction of steam. For a function that also covers the fog region please refer to <a href=\"modelica://Modelica.Media.Air.MoistAir.h_pTX\">h_pTX</a>.
</html>"));
    end enthalpyOfGas;

    redeclare function extends enthalpyOfCondensingGas "Return specific enthalpy of steam as a function of temperature T"
      algorithm
        h := Modelica.Media.IdealGases.Common.Functions.h_Tlow(data = steam, T = T, refChoice = ReferenceEnthalpy.UserDefined, h_off = 46479.819 + 2501014.5);
      annotation(
        Inline = false,
        smoothOrder = 5,
        Documentation(info = "<html>
Specific enthalpy of steam is computed from temperature.
</html>"));
    end enthalpyOfCondensingGas;

    redeclare function extends enthalpyOfNonCondensingGas "Return specific enthalpy of dry air as a function of temperature T"
      algorithm
        h := Modelica.Media.IdealGases.Common.Functions.h_Tlow(data = dryair, T = T, refChoice = ReferenceEnthalpy.UserDefined, h_off = 25104.684);
      annotation(
        Inline = false,
        smoothOrder = 1,
        Documentation(info = "<html>
Specific enthalpy of dry air is computed from temperature.
</html>"));
    end enthalpyOfNonCondensingGas;

    function enthalpyOfWater "Computes specific enthalpy of water (solid/liquid) near atmospheric pressure from temperature T"
      extends Modelica.Icons.Function;
      input SIunits.Temperature T "Temperature";
      output SIunits.SpecificEnthalpy h "Specific enthalpy of water";
    algorithm
/*simple model assuming constant properties:
heat capacity of liquid water:4200 J/kg
heat capacity of solid water: 2050 J/kg
enthalpy of fusion (liquid=>solid): 333000 J/kg*/
      h := Utilities.spliceFunction(4200 * (T - 273.15), 2050 * (T - 273.15) - 333000, T - 273.16, 0.1);
      annotation(
        derivative = enthalpyOfWater_der,
        Documentation(info = "<html>
Specific enthalpy of water (liquid and solid) is computed from temperature using constant properties as follows:<br>
<ul>
<li>  heat capacity of liquid water:4200 J/kg
<li>  heat capacity of solid water: 2050 J/kg
<li>  enthalpy of fusion (liquid=>solid): 333000 J/kg
</ul>
Pressure is assumed to be around 1 bar. This function is usually used to determine the specific enthalpy of the liquid or solid fraction of moist air.
</html>"));
    end enthalpyOfWater;

    function enthalpyOfWater_der "Derivative function of enthalpyOfWater"
      extends Modelica.Icons.Function;
      input SIunits.Temperature T "Temperature";
      input Real dT(unit = "K/s") "Time derivative of temperature";
      output Real dh(unit = "J/(kg.s)") "Time derivative of specific enthalpy";
    algorithm
/*simple model assuming constant properties:
heat capacity of liquid water:4200 J/kg
heat capacity of solid water: 2050 J/kg
enthalpy of fusion (liquid=>solid): 333000 J/kg*/
//h:=Utilities.spliceFunction(4200*(T-273.15),2050*(T-273.15)-333000,T-273.16,0.1);
      dh := Utilities.spliceFunction_der(4200 * (T - 273.15), 2050 * (T - 273.15) - 333000, T - 273.16, 0.1, 4200 * dT, 2050 * dT, dT, 0);
      annotation(
        Documentation(info = "<html>
Derivative function for <a href=\"modelica://Modelica.Media.Air.MoistAir.enthalpyOfWater\">enthalpyOfWater</a>.

</html>"));
    end enthalpyOfWater_der;

    redeclare function extends pressure "Returns pressure of ideal gas as a function of the thermodynamic state record"
      algorithm
        p := state.p;
      annotation(
        smoothOrder = 2,
        Documentation(info = "<html>
Pressure is returned from the thermodynamic state record input as a simple assignment.
</html>"));
    end pressure;

    redeclare function extends temperature "Return temperature of ideal gas as a function of the thermodynamic state record"
      algorithm
        T := state.T;
      annotation(
        smoothOrder = 2,
        Documentation(info = "<html>
Temperature is returned from the thermodynamic state record input as a simple assignment.
</html>"));
    end temperature;

    function T_phX "Return temperature as a function of pressure p, specific enthalpy h and composition X"
      extends Modelica.Icons.Function;
      input AbsolutePressure p "Pressure";
      input SpecificEnthalpy h "Specific enthalpy";
      input MassFraction[:] X "Mass fractions of composition";
      output Temperature T "Temperature";
    protected
      package Internal "Solve h(data,T) for T with given h (use only indirectly via temperature_phX)"
        extends Modelica.Media.Common.OneNonLinearEquation;

        redeclare record extends f_nonlinear_Data "Data to be passed to non-linear function"
            extends Modelica.Media.IdealGases.Common.DataRecord;
        end f_nonlinear_Data;

        redeclare function extends f_nonlinear
          algorithm
            y := h_pTX(p, x, X);
        end f_nonlinear;

        // Dummy definition has to be added for current Dymola

        redeclare function extends solve
        end solve;
      end Internal;
    algorithm
      T := Internal.solve(h, 190, 647, p, X[1:nXi], steam);
      annotation(
        Documentation(info = "<html>
Temperature is computed from pressure, specific enthalpy and composition via numerical inversion of function <a href=\"modelica://Modelica.Media.Air.MoistAir.h_pTX\">h_pTX</a>.
</html>"));
    end T_phX;

    redeclare function extends density "Returns density of ideal gas as a function of the thermodynamic state record"
      algorithm
        d := state.p / (gasConstant(state) * state.T);
      annotation(
        smoothOrder = 2,
        Documentation(info = "<html>
Density is computed from pressure, temperature and composition in the thermodynamic state record applying the ideal gas law.
</html>"));
    end density;

    redeclare function extends specificEnthalpy "Return specific enthalpy of moist air as a function of the thermodynamic state record"
      algorithm
        h := h_pTX(state.p, state.T, state.X);
      annotation(
        smoothOrder = 2,
        Documentation(info = "<html>
Specific enthalpy of moist air is computed from the thermodynamic state record. The fog region is included for both, ice and liquid fog.
</html>"));
    end specificEnthalpy;

    function h_pTX "Return specific enthalpy of moist air as a function of pressure p, temperature T and composition X"
      extends Modelica.Icons.Function;
      input SI.Pressure p "Pressure";
      input SI.Temperature T "Temperature";
      input SI.MassFraction X[:] "Mass fractions of moist air";
      output SI.SpecificEnthalpy h "Specific enthalpy at p, T, X";
    protected
      SI.AbsolutePressure p_steam_sat "partial saturation pressure of steam";
      SI.MassFraction X_sat "Absolute humidity per unit mass of moist air";
      SI.MassFraction X_liquid "Mass fraction of liquid water";
      SI.MassFraction X_steam "Mass fraction of steam water";
      SI.MassFraction X_air "Mass fraction of air";
    algorithm
      p_steam_sat := saturationPressure(T);
//p_steam_sat :=min(saturationPressure(T), 0.999*p);
      X_sat := min(p_steam_sat * k_mair / max(100 * Constants.eps, p - p_steam_sat) * (1 - X[Water]), 1.0);
      X_liquid := max(X[Water] - X_sat, 0.0);
      X_steam := X[Water] - X_liquid;
      X_air := 1 - X[Water];
/* h        := {SingleGasNasa.h_Tlow(data=steam,  T=T, refChoice=ReferenceEnthalpy.UserDefined, h_off=46479.819+2501014.5),
           SingleGasNasa.h_Tlow(data=dryair, T=T, refChoice=ReferenceEnthalpy.UserDefined, h_off=25104.684)}*
{X_steam, X_air} + enthalpyOfLiquid(T)*X_liquid;*/
      h := {Modelica.Media.IdealGases.Common.Functions.h_Tlow(data = steam, T = T, refChoice = ReferenceEnthalpy.UserDefined, h_off = 46479.819 + 2501014.5), Modelica.Media.IdealGases.Common.Functions.h_Tlow(data = dryair, T = T, refChoice = ReferenceEnthalpy.UserDefined, h_off = 25104.684)} * {X_steam, X_air} + enthalpyOfWater(T) * X_liquid;
      annotation(
        derivative = h_pTX_der,
        Inline = false,
        Documentation(info = "<html>
Specific enthalpy of moist air is computed from pressure, temperature and composition with X[1] as the total water mass fraction. The fog region is included for both, ice and liquid fog.
</html>"));
    end h_pTX;

    function h_pTX_der "Derivative function of h_pTX"
      extends Modelica.Icons.Function;
      input SI.Pressure p "Pressure";
      input SI.Temperature T "Temperature";
      input SI.MassFraction X[:] "Mass fractions of moist air";
      input Real dp(unit = "Pa/s") "Pressure derivative";
      input Real dT(unit = "K/s") "Temperature derivative";
      input Real dX[:](each unit = "1/s") "Composition derivative";
      output Real h_der(unit = "J/(kg.s)") "Time derivative of specific enthalpy";
    protected
      SI.AbsolutePressure p_steam_sat "partial saturation pressure of steam";
      SI.MassFraction X_sat "Absolute humidity per unit mass of moist air";
      SI.MassFraction X_liquid "Mass fraction of liquid water";
      SI.MassFraction X_steam "Mass fraction of steam water";
      SI.MassFraction X_air "Mass fraction of air";
      SI.MassFraction x_sat "Absolute humidity per unit mass of dry air at saturation";
      Real dX_steam(unit = "1/s") "Time derivative of steam mass fraction";
      Real dX_air(unit = "1/s") "Time derivative of dry air mass fraction";
      Real dX_liq(unit = "1/s") "Time derivative of liquid/solid water mass fraction";
      Real dps(unit = "Pa/s") "Time derivative of saturation pressure";
      Real dx_sat(unit = "1/s") "Time derivative of absolute humidity per unit mass of dry air";
    algorithm
      p_steam_sat := saturationPressure(T);
      x_sat := p_steam_sat * k_mair / max(100 * Modelica.Constants.eps, p - p_steam_sat);
      X_sat := min(x_sat * (1 - X[Water]), 1.0);
      X_liquid := Utilities.smoothMax(X[Water] - X_sat, 0.0, 1e-5);
      X_steam := X[Water] - X_liquid;
      X_air := 1 - X[Water];
      dX_air := -dX[Water];
      dps := saturationPressure_der(Tsat = T, dTsat = dT);
      dx_sat := k_mair * (dps * (p - p_steam_sat) - p_steam_sat * (dp - dps)) / (p - p_steam_sat) / (p - p_steam_sat);
      dX_liq := Utilities.smoothMax_der(X[Water] - X_sat, 0.0, 1e-5, (1 + x_sat) * dX[Water] - (1 - X[Water]) * dx_sat, 0, 0);
      dX_steam := dX[Water] - dX_liq;
      h_der := X_steam * Modelica.Media.IdealGases.Common.Functions.h_Tlow_der(data = steam, T = T, refChoice = ReferenceEnthalpy.UserDefined, h_off = 46479.819 + 2501014.5, dT = dT) + dX_steam * Modelica.Media.IdealGases.Common.Functions.h_Tlow(data = steam, T = T, refChoice = ReferenceEnthalpy.UserDefined, h_off = 46479.819 + 2501014.5) + X_air * Modelica.Media.IdealGases.Common.Functions.h_Tlow_der(data = dryair, T = T, refChoice = ReferenceEnthalpy.UserDefined, h_off = 25104.684, dT = dT) + dX_air * Modelica.Media.IdealGases.Common.Functions.h_Tlow(data = dryair, T = T, refChoice = ReferenceEnthalpy.UserDefined, h_off = 25104.684) + X_liquid * enthalpyOfWater_der(T = T, dT = dT) + dX_liq * enthalpyOfWater(T);
      annotation(
        Inline = false,
        smoothOrder = 1,
        Documentation(info = "<html>
Derivative function for <a href=\"modelica://Modelica.Media.Air.MoistAir.h_pTX\">h_pTX</a>.
</html>"));
    end h_pTX_der;

    redeclare function extends isentropicExponent "Return isentropic exponent (only for gas fraction!)"
      algorithm
        gamma := specificHeatCapacityCp(state) / specificHeatCapacityCv(state);
    end isentropicExponent;

    function isentropicEnthalpyApproximation "Approximate calculation of h_is from upstream properties, downstream pressure, gas part only"
      extends Modelica.Icons.Function;
      input AbsolutePressure p2 "Downstream pressure";
      input ThermodynamicState state "Thermodynamic state at upstream location";
      output SpecificEnthalpy h_is "Isentropic enthalpy";
    protected
      SpecificEnthalpy h "Specific enthalpy at upstream location";
      IsentropicExponent gamma = isentropicExponent(state) "Isentropic exponent";
    protected
      MassFraction[nX] X "Complete X-vector";
    algorithm
      X := state.X;
//  X := if reducedX then cat(1,state.X,{1-sum(state.X)}) else state.X;
      h := {Modelica.Media.IdealGases.Common.Functions.h_Tlow(data = steam, T = state.T, refChoice = ReferenceEnthalpy.UserDefined, h_off = 46479.819 + 2501014.5), Modelica.Media.IdealGases.Common.Functions.h_Tlow(data = dryair, T = state.T, refChoice = ReferenceEnthalpy.UserDefined, h_off = 25104.684)} * X;
      h_is := h + gamma / (gamma - 1.0) * (state.T * gasConstant(state)) * ((p2 / state.p) ^ ((gamma - 1) / gamma) - 1.0);
    end isentropicEnthalpyApproximation;

    redeclare function extends specificInternalEnergy "Return specific internal energy of moist air as a function of the thermodynamic state record"
        extends Modelica.Icons.Function;
        output SI.SpecificInternalEnergy u "Specific internal energy";

      algorithm
        u := specificInternalEnergy_pTX(state.p, state.T, state.X);
      annotation(
        smoothOrder = 2,
        Documentation(info = "<html>
Specific internal energy is determined from the thermodynamic state record, assuming that the liquid or solid water volume is negligible.
</html>"));
    end specificInternalEnergy;

    function specificInternalEnergy_pTX "Return specific internal energy of moist air as a function of pressure p, temperature T and composition X"
      extends Modelica.Icons.Function;
      input SI.Pressure p "Pressure";
      input SI.Temperature T "Temperature";
      input SI.MassFraction X[:] "Mass fractions of moist air";
      output SI.SpecificInternalEnergy u "Specific internal energy";
    protected
      SI.AbsolutePressure p_steam_sat "partial saturation pressure of steam";
      SI.MassFraction X_liquid "Mass fraction of liquid water";
      SI.MassFraction X_steam "Mass fraction of steam water";
      SI.MassFraction X_air "Mass fraction of air";
      SI.MassFraction X_sat "Absolute humidity per unit mass of moist air";
      Real R_gas "Ideal gas constant";
    algorithm
      p_steam_sat := saturationPressure(T);
      X_sat := min(p_steam_sat * k_mair / max(100 * Constants.eps, p - p_steam_sat) * (1 - X[Water]), 1.0);
      X_liquid := max(X[Water] - X_sat, 0.0);
      X_steam := X[Water] - X_liquid;
      X_air := 1 - X[Water];
      R_gas := dryair.R * X_air / (1 - X_liquid) + steam.R * X_steam / (1 - X_liquid);
      u := X_steam * Modelica.Media.IdealGases.Common.Functions.h_Tlow(data = steam, T = T, refChoice = ReferenceEnthalpy.UserDefined, h_off = 46479.819 + 2501014.5) + X_air * Modelica.Media.IdealGases.Common.Functions.h_Tlow(data = dryair, T = T, refChoice = ReferenceEnthalpy.UserDefined, h_off = 25104.684) + enthalpyOfWater(T) * X_liquid - R_gas * T;
      annotation(
        derivative = specificInternalEnergy_pTX_der,
        Documentation(info = "<html>
Specific internal energy is determined from pressure p, temperature T and composition X, assuming that the liquid or solid water volume is negligible.
</html>"));
    end specificInternalEnergy_pTX;

    function specificInternalEnergy_pTX_der "Derivative function for specificInternalEnergy_pTX"
      extends Modelica.Icons.Function;
      input SI.Pressure p "Pressure";
      input SI.Temperature T "Temperature";
      input SI.MassFraction X[:] "Mass fractions of moist air";
      input Real dp(unit = "Pa/s") "Pressure derivative";
      input Real dT(unit = "K/s") "Temperature derivative";
      input Real dX[:](each unit = "1/s") "Mass fraction derivatives";
      output Real u_der(unit = "J/(kg.s)") "Specific internal energy derivative";
    protected
      SI.AbsolutePressure p_steam_sat "partial saturation pressure of steam";
      SI.MassFraction X_liquid "Mass fraction of liquid water";
      SI.MassFraction X_steam "Mass fraction of steam water";
      SI.MassFraction X_air "Mass fraction of air";
      SI.MassFraction X_sat "Absolute humidity per unit mass of moist air";
      SI.SpecificHeatCapacity R_gas "Ideal gas constant";
      SI.MassFraction x_sat "Absolute humidity per unit mass of dry air at saturation";
      Real dX_steam(unit = "1/s") "Time derivative of steam mass fraction";
      Real dX_air(unit = "1/s") "Time derivative of dry air mass fraction";
      Real dX_liq(unit = "1/s") "Time derivative of liquid/solid water mass fraction";
      Real dps(unit = "Pa/s") "Time derivative of saturation pressure";
      Real dx_sat(unit = "1/s") "Time derivative of absolute humidity per unit mass of dry air";
      Real dR_gas(unit = "J/(kg.K.s)") "Time derivative of ideal gas constant";
    algorithm
      p_steam_sat := saturationPressure(T);
      x_sat := p_steam_sat * k_mair / max(100 * Modelica.Constants.eps, p - p_steam_sat);
      X_sat := min(x_sat * (1 - X[Water]), 1.0);
      X_liquid := Utilities.spliceFunction(X[Water] - X_sat, 0.0, X[Water] - X_sat, 1e-6);
      X_steam := X[Water] - X_liquid;
      X_air := 1 - X[Water];
      R_gas := steam.R * X_steam / (1 - X_liquid) + dryair.R * X_air / (1 - X_liquid);
      dX_air := -dX[Water];
      dps := saturationPressure_der(Tsat = T, dTsat = dT);
      dx_sat := k_mair * (dps * (p - p_steam_sat) - p_steam_sat * (dp - dps)) / (p - p_steam_sat) / (p - p_steam_sat);
      dX_liq := Utilities.spliceFunction_der(X[Water] - X_sat, 0.0, X[Water] - X_sat, 1e-6, (1 + x_sat) * dX[Water] - (1 - X[Water]) * dx_sat, 0.0, (1 + x_sat) * dX[Water] - (1 - X[Water]) * dx_sat, 0.0);
      dX_steam := dX[Water] - dX_liq;
      dR_gas := (steam.R * (dX_steam * (1 - X_liquid) + dX_liq * X_steam) + dryair.R * (dX_air * (1 - X_liquid) + dX_liq * X_air)) / (1 - X_liquid) / (1 - X_liquid);
      u_der := X_steam * Modelica.Media.IdealGases.Common.Functions.h_Tlow_der(data = steam, T = T, refChoice = ReferenceEnthalpy.UserDefined, h_off = 46479.819 + 2501014.5, dT = dT) + dX_steam * Modelica.Media.IdealGases.Common.Functions.h_Tlow(data = steam, T = T, refChoice = ReferenceEnthalpy.UserDefined, h_off = 46479.819 + 2501014.5) + X_air * Modelica.Media.IdealGases.Common.Functions.h_Tlow_der(data = dryair, T = T, refChoice = ReferenceEnthalpy.UserDefined, h_off = 25104.684, dT = dT) + dX_air * Modelica.Media.IdealGases.Common.Functions.h_Tlow(data = dryair, T = T, refChoice = ReferenceEnthalpy.UserDefined, h_off = 25104.684) + X_liquid * enthalpyOfWater_der(T = T, dT = dT) + dX_liq * enthalpyOfWater(T) - dR_gas * T - R_gas * dT;
      annotation(
        Documentation(info = "<html>
Derivative function for <a href=\"modelica://Modelica.Media.Air.MoistAir.specificInternalEnergy_pTX\">specificInternalEnergy_pTX</a>.
</html>"));
    end specificInternalEnergy_pTX_der;

    redeclare function extends specificEntropy "Return specific entropy from thermodynamic state record, only valid for phi<1"
      algorithm
        s := s_pTX(state.p, state.T, state.X);
      annotation(
        Inline = false,
        smoothOrder = 2,
        Documentation(info = "<html>
Specific entropy is calculated from the thermodynamic state record, assuming ideal gas behavior and including entropy of mixing. Liquid or solid water is not taken into account, the entire water content X[1] is assumed to be in the vapor state (relative humidity below 1.0).
</html>"));
    end specificEntropy;

    redeclare function extends specificGibbsEnergy "Return specific Gibbs energy as a function of the thermodynamic state record, only valid for phi<1"
        extends Modelica.Icons.Function;

      algorithm
        g := h_pTX(state.p, state.T, state.X) - state.T * specificEntropy(state);
      annotation(
        smoothOrder = 2,
        Documentation(info = "<html>
The Gibbs Energy is computed from the thermodynamic state record for moist air with a water content below saturation.
</html>"));
    end specificGibbsEnergy;

    redeclare function extends specificHelmholtzEnergy "Return specific Helmholtz energy as a function of the thermodynamic state record, only valid for phi<1"
        extends Modelica.Icons.Function;

      algorithm
        f := h_pTX(state.p, state.T, state.X) - gasConstant(state) * state.T - state.T * specificEntropy(state);
      annotation(
        smoothOrder = 2,
        Documentation(info = "<html>
The Specific Helmholtz Energy is computed from the thermodynamic state record for moist air with a water content below saturation.
</html>"));
    end specificHelmholtzEnergy;

    redeclare function extends specificHeatCapacityCp "Return specific heat capacity at constant pressure as a function of the thermodynamic state record"
      protected
        Real dT(unit = "s/K") = 1.0;

      algorithm
        cp := h_pTX_der(state.p, state.T, state.X, 0.0, 1.0, zeros(size(state.X, 1))) * dT "Definition of cp: dh/dT @ constant p";
//      cp:= SingleGasNasa.cp_Tlow(dryair, state.T)*(1-state.X[Water])
//        + SingleGasNasa.cp_Tlow(steam, state.T)*state.X[Water];
      annotation(
        Inline = false,
        smoothOrder = 2,
        Documentation(info = "<html>
The specific heat capacity at constant pressure <b>cp</b> is computed from temperature and composition for a mixture of steam (X[1]) and dry air. All water is assumed to be in the vapor state.
</html>"));
    end specificHeatCapacityCp;

    redeclare function extends specificHeatCapacityCv "Return specific heat capacity at constant volume as a function of the thermodynamic state record"
      algorithm
        cv := Modelica.Media.IdealGases.Common.Functions.cp_Tlow(dryair, state.T) * (1 - state.X[Water]) + Modelica.Media.IdealGases.Common.Functions.cp_Tlow(steam, state.T) * state.X[Water] - gasConstant(state);
      annotation(
        Inline = false,
        smoothOrder = 2,
        Documentation(info = "<html>
The specific heat capacity at constant density <b>cv</b> is computed from temperature and composition for a mixture of steam (X[1]) and dry air. All water is assumed to be in the vapor state.
</html>"));
    end specificHeatCapacityCv;

    redeclare function extends dynamicViscosity "Return dynamic viscosity as a function of the thermodynamic state record, valid from 123.15 K to 1273.15 K"
        import Modelica.Media.Incompressible.TableBased.Polynomials_Temp;

      algorithm
        eta := 1e-6 * Polynomials_Temp.evaluateWithRange({9.7391102886305869E-15, -3.1353724870333906E-11, 4.3004876595642225E-08, -3.8228016291758240E-05, 5.0427874367180762E-02, 1.7239260139242528E+01}, Cv.to_degC(123.15), Cv.to_degC(1273.15), Cv.to_degC(state.T));
      annotation(
        smoothOrder = 2,
        Documentation(info = "<html>
<p>Dynamic viscosity is computed from temperature using a simple polynomial for dry air. Range of validity is from 123.15 K to 1273.15 K. The influence of pressure and moisture is neglected. </p>
<p>Source: VDI Waermeatlas, 8th edition. </p>
</html>"));
    end dynamicViscosity;

    redeclare function extends thermalConductivity "Return thermal conductivity as a function of the thermodynamic state record, valid from 123.15 K to 1273.15 K"
        import Modelica.Media.Incompressible.TableBased.Polynomials_Temp;
        import Cv = Modelica.SIunits.Conversions;

      algorithm
        lambda := 1e-3 * Polynomials_Temp.evaluateWithRange({6.5691470817717812E-15, -3.4025961923050509E-11, 5.3279284846303157E-08, -4.5340839289219472E-05, 7.6129675309037664E-02, 2.4169481088097051E+01}, Cv.to_degC(123.15), Cv.to_degC(1273.15), Cv.to_degC(state.T));
      annotation(
        smoothOrder = 2,
        Documentation(info = "<html>
<p>Thermal conductivity is computed from temperature using a simple polynomial for dry air. Range of validity is from 123.15 K to 1273.15 K. The influence of pressure and moisture is neglected. </p>
<p>Source: VDI Waermeatlas, 8th edition. </p>
</html>"));
    end thermalConductivity;

    redeclare function extends velocityOfSound
      algorithm
        a := sqrt(isentropicExponent(state) * gasConstant(state) * temperature(state));
      annotation(
        Documentation(revisions = "<html>
<p>2012-01-12        Stefan Wischhusen: Initial Release.</p>
</html>"));
    end velocityOfSound;

    redeclare function extends isobaricExpansionCoefficient
      algorithm
        beta := 1 / temperature(state);
      annotation(
        Documentation(revisions = "<html>
<p>2012-01-12        Stefan Wischhusen: Initial Release.</p>
</html>"));
    end isobaricExpansionCoefficient;

    redeclare function extends isothermalCompressibility
      algorithm
        kappa := 1 / pressure(state);
      annotation(
        Documentation(revisions = "<html>
<p>2012-01-12        Stefan Wischhusen: Initial Release.</p>
</html>"));
    end isothermalCompressibility;

    redeclare function extends density_derp_h
      algorithm
        ddph := 1 / (gasConstant(state) * temperature(state));
      annotation(
        Documentation(revisions = "<html>
<p>2012-01-12        Stefan Wischhusen: Initial Release.</p>
</html>"));
    end density_derp_h;

    redeclare function extends density_derh_p
      algorithm
        ddhp := -density(state) / (specificHeatCapacityCp(state) * temperature(state));
      annotation(
        Documentation(revisions = "<html>
<p>2012-01-12        Stefan Wischhusen: Initial Release.</p>
</html>"));
    end density_derh_p;

    redeclare function extends density_derp_T
      algorithm
        ddpT := 1 / (gasConstant(state) * temperature(state));
      annotation(
        Documentation(revisions = "<html>
<p>2012-01-12        Stefan Wischhusen: Initial Release.</p>
</html>"));
    end density_derp_T;

    redeclare function extends density_derT_p
      algorithm
        ddTp := -density(state) / temperature(state);
      annotation(
        Documentation(revisions = "<html>
<p>2012-01-12        Stefan Wischhusen: Initial Release.</p>
</html>"));
    end density_derT_p;

    redeclare function extends density_derX
      algorithm
        dddX[Water] := pressure(state) * (steam.R - dryair.R) / ((steam.R - dryair.R) * state.X[Water] * temperature(state) + dryair.R * temperature(state)) ^ 2;
        dddX[Air] := pressure(state) * (dryair.R - steam.R) / ((dryair.R - steam.R) * state.X[Air] * temperature(state) + steam.R * temperature(state)) ^ 2;
      annotation(
        Documentation(revisions = "<html>
<p>2012-01-12        Stefan Wischhusen: Initial Release.</p>
</html>"));
    end density_derX;

    redeclare function extends molarMass
      algorithm
        MM := Modelica.Media.Air.MoistAir.gasConstant(state) / Modelica.Constants.R;
      annotation(
        Documentation(revisions = "<html>
<p>2012-01-12        Stefan Wischhusen: Initial Release.</p>
</html>"));
    end molarMass;

    function T_psX "Return temperature as a function of pressure p, specific entropy s and composition X"
      extends Modelica.Icons.Function;
      input AbsolutePressure p "Pressure";
      input SpecificEntropy s "Specific entropy";
      input MassFraction[:] X "Mass fractions of composition";
      output Temperature T "Temperature";
    protected
      package Internal "Solve s(data,T) for T with given s"
        extends Modelica.Media.Common.OneNonLinearEquation;

        redeclare record extends f_nonlinear_Data "Data to be passed to non-linear function"
            extends Modelica.Media.IdealGases.Common.DataRecord;
        end f_nonlinear_Data;

        redeclare function extends f_nonlinear
          algorithm
            y := s_pTX(p, x, X);
        end f_nonlinear;

        // Dummy definition has to be added for current Dymola

        redeclare function extends solve
        end solve;
      end Internal;
    algorithm
      T := Internal.solve(s, 190, 647, p, X[1:nX], steam);
      annotation(
        Documentation(info = "<html>
Temperature is computed from pressure, specific entropy and composition via numerical inversion of function <a href=\"modelica://Modelica.Media.Air.MoistAir.specificEntropy\">specificEntropy</a>.
</html>", revisions = "<html>
<p>2012-01-12        Stefan Wischhusen: Initial Release.</p>
</html>"));
    end T_psX;

    redeclare function extends setState_psX
      algorithm
        state := if size(X, 1) == nX then ThermodynamicState(p = p, T = T_psX(p, s, X), X = X) else ThermodynamicState(p = p, T = T_psX(p, s, X), X = cat(1, X, {1 - sum(X)}));
      annotation(
        smoothOrder = 2,
        Documentation(info = "<html>
The <a href=\"modelica://Modelica.Media.Air.MoistAir.ThermodynamicState\">thermodynamic state record</a> is computed from pressure p, specific enthalpy h and composition X.
</html>", revisions = "<html>
<p>2012-01-12        Stefan Wischhusen: Initial Release.</p>
</html>"));
    end setState_psX;

    function s_pTX "Return specific entropy of moist air as a function of pressure p, temperature T and composition X (only valid for phi<1)"
      extends Modelica.Icons.Function;
      input SI.Pressure p "Pressure";
      input SI.Temperature T "Temperature";
      input SI.MassFraction X[:] "Mass fractions of moist air";
      output SI.SpecificEntropy s "Specific entropy at p, T, X";
    protected
      MoleFraction[2] Y = massToMoleFractions(X, {steam.MM, dryair.MM}) "Molar fraction";
    algorithm
      s := Modelica.Media.IdealGases.Common.Functions.s0_Tlow(dryair, T) * (1 - X[Water]) + Modelica.Media.IdealGases.Common.Functions.s0_Tlow(steam, T) * X[Water] - Modelica.Constants.R * (Utilities.smoothMax(X[Water] / MMX[Water] * Modelica.Math.log(max(Y[Water], Modelica.Constants.eps) * p / reference_p), 0.0, 1e-9) - Utilities.smoothMax((1 - X[Water]) / MMX[Air] * Modelica.Math.log(max(Y[Air], Modelica.Constants.eps) * p / reference_p), 0.0, 1e-9));
      annotation(
        derivative = s_pTX_der,
        Inline = false,
        Documentation(info = "<html>
Specific entropy of moist air is computed from pressure, temperature and composition with X[1] as the total water mass fraction.
</html>", revisions = "<html>
<p>2012-01-12        Stefan Wischhusen: Initial Release.</p>
</html>"),
        Icon(graphics = {Text(extent = {{-100, 100}, {100, -100}}, lineColor = {255, 127, 0}, textString = "f")}));
    end s_pTX;

    function s_pTX_der "Return specific entropy of moist air as a function of pressure p, temperature T and composition X (only valid for phi<1)"
      extends Modelica.Icons.Function;
      input SI.Pressure p "Pressure";
      input SI.Temperature T "Temperature";
      input SI.MassFraction X[:] "Mass fractions of moist air";
      input Real dp(unit = "Pa/s") "Derivative of pressure";
      input Real dT(unit = "K/s") "Derivative of temperature";
      input Real dX[nX](unit = "1/s") "Derivative of mass fractions";
      output Real ds(unit = "J/(kg.K.s)") "Specific entropy at p, T, X";
    protected
      MoleFraction[2] Y = massToMoleFractions(X, {steam.MM, dryair.MM}) "Molar fraction";
    algorithm
      ds := Modelica.Media.IdealGases.Common.Functions.s0_Tlow_der(dryair, T, dT) * (1 - X[Water]) + Modelica.Media.IdealGases.Common.Functions.s0_Tlow_der(steam, T, dT) * X[Water] + Modelica.Media.IdealGases.Common.Functions.s0_Tlow(dryair, T) * dX[Air] + Modelica.Media.IdealGases.Common.Functions.s0_Tlow(steam, T) * dX[Water] - Modelica.Constants.R * (1 / MMX[Water] * Utilities.smoothMax_der(X[Water] * Modelica.Math.log(max(Y[Water], Modelica.Constants.eps) * p / reference_p), 0.0, 1e-9, (Modelica.Math.log(max(Y[Water], Modelica.Constants.eps) * p / reference_p) + X[Water] / Y[Water] * (X[Air] * MMX[Water] / (X[Air] * MMX[Water] + X[Water] * MMX[Air]) ^ 2)) * dX[Water] + X[Water] * reference_p / p * dp, 0, 0) - 1 / MMX[Air] * Utilities.smoothMax_der((1 - X[Water]) * Modelica.Math.log(max(Y[Air], Modelica.Constants.eps) * p / reference_p), 0.0, 1e-9, (Modelica.Math.log(max(Y[Air], Modelica.Constants.eps) * p / reference_p) + X[Air] / Y[Air] * (X[Water] * MMX[Air] / (X[Air] * MMX[Water] + X[Water] * MMX[Air]) ^ 2)) * dX[Air] + X[Air] * reference_p / p * dp, 0, 0));
      annotation(
        Inline = false,
        smoothOrder = 1,
        Documentation(info = "<html>
Specific entropy of moist air is computed from pressure, temperature and composition with X[1] as the total water mass fraction.
</html>", revisions = "<html>
<p>2012-01-12        Stefan Wischhusen: Initial Release.</p>
</html>"),
        Icon(graphics = {Text(extent = {{-100, 100}, {100, -100}}, lineColor = {255, 127, 0}, textString = "f")}));
    end s_pTX_der;

    redeclare function extends isentropicEnthalpy "Isentropic enthalpy (only valid for phi<1)"
        extends Modelica.Icons.Function;

      algorithm
        h_is := Modelica.Media.Air.MoistAir.h_pTX(p_downstream, Modelica.Media.Air.MoistAir.T_psX(p_downstream, Modelica.Media.Air.MoistAir.specificEntropy(refState), refState.X), refState.X);
      annotation(
        Icon(graphics = {Text(extent = {{-100, 100}, {100, -100}}, lineColor = {255, 127, 0}, textString = "f")}),
        Documentation(revisions = "<html>
<p>2012-01-12        Stefan Wischhusen: Initial Release.</p>
</html>"));
    end isentropicEnthalpy;

    package Utilities "Utility functions"
      extends Modelica.Icons.UtilitiesPackage;

      function spliceFunction "Spline interpolation of two functions"
        extends Modelica.Icons.Function;
        input Real pos "Returned value for x-deltax >= 0";
        input Real neg "Returned value for x+deltax <= 0";
        input Real x "Function argument";
        input Real deltax = 1 "Region around x with spline interpolation";
        output Real out;
      protected
        Real scaledX;
        Real scaledX1;
        Real y;
      algorithm
        scaledX1 := x / deltax;
        scaledX := scaledX1 * Modelica.Math.asin(1);
        if scaledX1 <= (-0.999999999) then
          y := 0;
        elseif scaledX1 >= 0.999999999 then
          y := 1;
        else
          y := (Modelica.Math.tanh(Modelica.Math.tan(scaledX)) + 1) / 2;
        end if;
        out := pos * y + (1 - y) * neg;
        annotation(
          derivative = spliceFunction_der);
      end spliceFunction;

      function spliceFunction_der "Derivative of spliceFunction"
        extends Modelica.Icons.Function;
        input Real pos;
        input Real neg;
        input Real x;
        input Real deltax = 1;
        input Real dpos;
        input Real dneg;
        input Real dx;
        input Real ddeltax = 0;
        output Real out;
      protected
        Real scaledX;
        Real scaledX1;
        Real dscaledX1;
        Real y;
      algorithm
        scaledX1 := x / deltax;
        scaledX := scaledX1 * Modelica.Math.asin(1);
        dscaledX1 := (dx - scaledX1 * ddeltax) / deltax;
        if scaledX1 <= (-0.99999999999) then
          y := 0;
        elseif scaledX1 >= 0.9999999999 then
          y := 1;
        else
          y := (Modelica.Math.tanh(Modelica.Math.tan(scaledX)) + 1) / 2;
        end if;
        out := dpos * y + (1 - y) * dneg;
        if abs(scaledX1) < 1 then
          out := out + (pos - neg) * dscaledX1 * Modelica.Math.asin(1) / 2 / (Modelica.Math.cosh(Modelica.Math.tan(scaledX)) * Modelica.Math.cos(scaledX)) ^ 2;
        end if;
      end spliceFunction_der;

      function smoothMax
        extends Modelica.Icons.Function;
        import Modelica.Math;
        input Real x1 "First argument of smooth max operator";
        input Real x2 "Second argument of smooth max operator";
        input Real dx "Approximate difference between x1 and x2, below which regularization starts";
        output Real y "Result of smooth max operator";
      algorithm
        y := max(x1, x2) + Math.log(exp(4 / dx * (x1 - max(x1, x2))) + exp(4 / dx * (x2 - max(x1, x2)))) / (4 / dx);
        annotation(
          smoothOrder = 2,
          Documentation(info = "<html>
<p>An implementation of Kreisselmeier Steinhauser smooth maximum</p>
</html>"));
      end smoothMax;

      function smoothMax_der
        extends Modelica.Icons.Function;
        import Modelica.Math.exp;
        import Modelica.Math.log;
        input Real x1 "First argument of smooth max operator";
        input Real x2 "Second argument of smooth max operator";
        input Real dx "Approximate difference between x1 and x2, below which regularization starts";
        input Real dx1;
        input Real dx2;
        input Real ddx;
        output Real dy "Derivative of smooth max operator";
      algorithm
        dy := (if x1 > x2 then dx1 else dx2) + 0.25 * (((4 * (dx1 - (if x1 > x2 then dx1 else dx2)) / dx - 4 * (x1 - max(x1, x2)) * ddx / dx ^ 2) * exp(4 * (x1 - max(x1, x2)) / dx) + (4 * (dx2 - (if x1 > x2 then dx1 else dx2)) / dx - 4 * (x2 - max(x1, x2)) * ddx / dx ^ 2) * exp(4 * (x2 - max(x1, x2)) / dx)) * dx / (exp(4 * (x1 - max(x1, x2)) / dx) + exp(4 * (x2 - max(x1, x2)) / dx)) + log(exp(4 * (x1 - max(x1, x2)) / dx) + exp(4 * (x2 - max(x1, x2)) / dx)) * ddx);
        annotation(
          Documentation(info = "<html>
<p>An implementation of Kreisselmeier Steinhauser smooth maximum</p>
</html>"));
      end smoothMax_der;
    end Utilities;
    annotation(
      Documentation(info = "<html>
<h4>Thermodynamic Model</h4>
<p>This package provides a full thermodynamic model of moist air including the fog region and temperatures below zero degC.
The governing assumptions in this model are:</p>
<ul>
<li>the perfect gas law applies</li>
<li>water volume other than that of steam is neglected</li></ul>
<p>All extensive properties are expressed in terms of the total mass in order to comply with other media in this library. However, for moist air it is rather common to express the absolute humidity in terms of mass of dry air only, which has advantages when working with charts. In addition, care must be taken, when working with mass fractions with respect to total mass, that all properties refer to the same water content when being used in mathematical operations (which is always the case if based on dry air only). Therefore two absolute humidities are computed in the <b>BaseProperties</b> model: <b>X</b> denotes the absolute humidity in terms of the total mass while <b>x</b> denotes the absolute humidity per unit mass of dry air. In addition, the relative humidity <b>phi</b> is also computed.</p>
<p>At the triple point temperature of water of 0.01 &deg;C or 273.16 K and a relative humidity greater than 1 fog may be present as liquid and as ice resulting in a specific enthalpy somewhere between those of the two isotherms for solid and liquid fog, respectively. For numerical reasons a coexisting mixture of 50% solid and 50% liquid fog is assumed in the fog region at the triple point in this model.</p>

<h4>Range of validity</h4>
<p>From the assumptions mentioned above it follows that the <b>pressure</b> should be in the region around <b>atmospheric</b> conditions or below (a few bars may still be fine though). Additionally a very high water content at low temperatures would yield incorrect densities, because the volume of the liquid or solid phase would not be negligible anymore. The model does not provide information on limits for water drop size in the fog region or transport information for the actual condensation or evaporation process in combination with surfaces. All excess water which is not in its vapour state is assumed to be still present in the air regarding its energy but not in terms of its spatial extent.<br><br>
The thermodynamic model may be used for <b>temperatures</b> ranging from <b>190 ... 647 K</b>. This holds for all functions unless otherwise stated in their description. However, although the model works at temperatures above the saturation temperature it is questionable to use the term \"relative humidity\" in this region. Please note, that although several functions compute pure water properties, they are designed to be used within the moist air medium model where properties are dominated by air and steam in their vapor states, and not for pure liquid water applications.</p>

<h4>Transport Properties</h4>
<p>Several additional functions that are not needed to describe the thermodynamic system, but are required to model transport processes, like heat and mass transfer, may be called. They usually neglect the moisture influence unless otherwise stated.</p>

<h4>Application</h4>
<p>The model's main area of application is all processes that involve moist air cooling under near atmospheric pressure with possible moisture condensation. This is the case in all domestic and industrial air conditioning applications. Another large domain of moist air applications covers all processes that deal with dehydration of bulk material using air as a transport medium. Engineering tasks involving moist air are often performed (or at least visualized) by using charts that contain all relevant thermodynamic data for a moist air system. These so called psychrometric charts can be generated from the medium properties in this package. The model <a href=\"modelica://Modelica.Media.Examples.PsychrometricData\">PsychrometricData</a> may be used for this purpose in order to obtain data for figures like those below (the plotting itself is not part of the model though).</p>

<p>
<img src=\"modelica://Modelica/Resources/Images/Media/Air/Mollier.png\"><br>
<img src=\"modelica://Modelica/Resources/Images/Media/Air/PsycroChart.png\">
</p>

<p>
<b>Legend:</b> blue - constant specific enthalpy, red - constant temperature, black - constant relative humidity</p>

</html>"));
  end MoistAir_package;

  model My_Media
    parameter Types.Media MediumChoosen = MoistAir;
    annotation(
      Icon(graphics = {Bitmap(origin = {3, -3}, extent = {{-103, 103}, {97, -97}}, imageSource = "iVBORw0KGgoAAAANSUhEUgAAATMAAADSCAYAAAAmNyfNAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAyFpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuNS1jMDIxIDc5LjE1NDkxMSwgMjAxMy8xMC8yOS0xMTo0NzoxNiAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvIiB4bWxuczp4bXBNTT0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL21tLyIgeG1sbnM6c3RSZWY9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS9SZXNvdXJjZVJlZiMiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIENDIChXaW5kb3dzKSIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDo3NUI5QzM0NDJFRkUxMUU1ODdFRkE1OTc4MjkyQzBENiIgeG1wTU06RG9jdW1lbnRJRD0ieG1wLmRpZDo3NUI5QzM0NTJFRkUxMUU1ODdFRkE1OTc4MjkyQzBENiI+IDx4bXBNTTpEZXJpdmVkRnJvbSBzdFJlZjppbnN0YW5jZUlEPSJ4bXAuaWlkOjc1QjlDMzQyMkVGRTExRTU4N0VGQTU5NzgyOTJDMEQ2IiBzdFJlZjpkb2N1bWVudElEPSJ4bXAuZGlkOjc1QjlDMzQzMkVGRTExRTU4N0VGQTU5NzgyOTJDMEQ2Ii8+IDwvcmRmOkRlc2NyaXB0aW9uPiA8L3JkZjpSREY+IDwveDp4bXBtZXRhPiA8P3hwYWNrZXQgZW5kPSJyIj8+D5SXXwAAQr5JREFUeNrsfQmAHFW1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"), Text(origin = {3, 11}, lineThickness = 0.5, extent = {{-43, 43}, {43, -43}}, textString = "Medium",  fontSize = 0 )}));
  end My_Media;
  annotation(
    Icon(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -100}, {100, 100}}), graphics = {Line(points = {{-76, -80}, {-62, -30}, {-32, 40}, {4, 66}, {48, 66}, {73, 45}, {62, -8}, {48, -50}, {38, -80}}, color = {64, 64, 64}, smooth = Smooth.Bezier), Line(points = {{-40, 20}, {68, 20}}, color = {175, 175, 175}), Line(points = {{-40, 20}, {-44, 88}, {-44, 88}}, color = {175, 175, 175}), Line(points = {{68, 20}, {86, -58}}, color = {175, 175, 175}), Line(points = {{-60, -28}, {56, -28}}, color = {175, 175, 175}), Line(points = {{-60, -28}, {-74, 84}, {-74, 84}}, color = {175, 175, 175}), Line(points = {{56, -28}, {70, -80}}, color = {175, 175, 175}), Line(points = {{-76, -80}, {38, -80}}, color = {175, 175, 175}), Line(points = {{-76, -80}, {-94, -16}, {-94, -16}}, color = {175, 175, 175})}));
end Media;