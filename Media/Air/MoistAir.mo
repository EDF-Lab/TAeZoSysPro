within TAeZoSysPro.Media.Air;

package MoistAir

  extends Modelica.Media.Interfaces.PartialMedium(redeclare replaceable record FluidConstants = Modelica.Media.Interfaces.Types.IdealGas.FluidConstants, mediumName = "Moist air", substanceNames = {"water", "air"}, final reducedX = true, final singleState = false, reference_X = {0.01, 0.99}, reference_T = 293.15, Temperature(min = 190, max = 647), ThermoStates = Modelica.Media.Interfaces.Choices.IndependentVariables.dTX);
  import Modelica.Media.Interfaces.Types.ExtraProperty;
  constant Integer Water = 1 "Index of water (in substanceNames, massFractions X, etc.)";
  constant Integer Air = 2 "Index of air (in substanceNames, massFractions X, etc.)";
  constant Real k_mair = steam.MM / dryair.MM "Ratio of molar weights";

  record dryair
    constant SI.SpecificHeatCapacity R = Modelica.Media.IdealGases.Common.SingleGasesData.Air.R;
    constant SI.MolarMass MM = Modelica.Media.IdealGases.Common.SingleGasesData.Air.MM;
    constant SI.SpecificHeatCapacityAtConstantPressure cp = 1006.4 "Specific heat capacity of dry air at 293.15K (20°C)";
  end dryair;

  record steam
    constant SI.SpecificHeatCapacity R = Modelica.Media.IdealGases.Common.SingleGasesData.H2O.R;
    constant SI.MolarMass MM = Modelica.Media.IdealGases.Common.SingleGasesData.H2O.MM;
    constant SI.SpecificEnergy h_lv = 2453.55e3 "Enthalpy of vaporization of water at 293.15K (20°C)";
    constant SI.SpecificHeatCapacityAtConstantPressure cp = 1886.0 "Specific heat capacity of steam at 293.15K (20°C)";
  end steam;

  record water
    constant SI.SpecificHeatCapacityAtConstantPressure cp = 4181 "Specific heat capacity of liquid water at 293.15K (20°C)";
  end water;

  constant SI.MolarMass[2] MMX = {steam.MM, dryair.MM} "Molar masses of components";
  constant FluidConstants[nS] fluidConstants = {Modelica.Media.IdealGases.Common.FluidData.H2O, Modelica.Media.IdealGases.Common.FluidData.N2} "Constant data for the fluid";
  import SI = Modelica.SIunits;
  import Modelica.SIunits;

  redeclare record extends ThermodynamicState "Thermodynamic state variables of moist air"
      Density d "density of medium";
      Temperature T "Temperature of medium";
      MassFraction[nX] X(start = reference_X) "Mass fractions (= (component mass)/total mass  m_i/m)";
  end ThermodynamicState;

  redeclare replaceable model extends BaseProperties(T(stateSelect = if preferredMediumStates then StateSelect.prefer else StateSelect.default), d(stateSelect = if preferredMediumStates then StateSelect.prefer else StateSelect.default), Xi(each stateSelect = if preferredMediumStates then StateSelect.prefer else StateSelect.default), final standardOrderComponents = true) "Moist air base properties record"
      /* d, T, X = X[Water] are used as preferred states, since only then all
           other quantities can be computed in a recursive sequence.
           If other variables are selected as states, static state selection
           is no longer possible and non-linear algebraic equations occur.
            */
      Real phi "Relative humidity";
      MassFraction X_liquid "Mass fraction of liquid or solid water";
      MassFraction X_steam "Mass fraction of steam water";
      MassFraction X_air "Mass fraction of air";
      Density d_sat "Steam water density of saturation boundary in kg_water/m3";

    equation
      assert(T >= 190 and T <= 647, "
Temperature T is not in the allowed range
190.0 K <= (T =" + String(T) + " K) <= 647.0 K
required from medium model \"" + mediumName + "\".");
      MM = 1 / (Xi[Water] / MMX[Water] + (1.0 - Xi[Water]) / MMX[Air]);
      d_sat = saturationDensity(T);
      X_liquid = max(d * X[Water] - d_sat, 0) / d;
      X_steam = Xi[Water] - X_liquid;
      X_air = 1 - Xi[Water];
      h = h_dTX(d, T, Xi);
//      R = dryair.R * (X_air / (1 - X_liquid)) + steam.R * X_steam / (1 - X_liquid);
      R = r_dTX(d, T, Xi);
//
      u = h - R * T;
//    u = X_air*720*(T-reference_T) + X_steam*(1000*(T-reference_T)+steam.h_lv) + X_liquid*4185*(T-reference_T);
//    u = h - p/d;
      p = d * (1 - X_liquid) * R * T;
/* Note, is computed under the assumption that the volume of the liquid
         water is negligible with respect to the volume of air and of steam
      */
      state.d = d;
      state.T = T;
      state.X = X;
      phi = min(d * X[Water], d_sat) / d_sat;
    annotation(
      Documentation(info = "<html>
  <p>
    This model computes thermodynamic properties of moist air from three independent (thermodynamic or/and numerical) state variables. 
    Preferred numerical states are temperature T, density d and the reduced composition vector Xi, which contains the water mass fraction only. 
    As an EOS the <strong>ideal gas law</strong> is used and associated restrictions apply. 
    The model can also be used in the <strong>fog region</strong>, when moisture is present in its liquid state. 
    However, it is assumed that the liquid water volume is negligible compared to that of the gas phase. 
    Computation of thermal properties is based on property data of <a href=\"modelica://Modelica.Media.Air.DryAirNasa\"> dry air</a> and water (source: VDI-W&auml;rmeatlas), respectively. 
    Besides the standard thermodynamic variables <strong>absolute and relative humidity</strong>, x_water and phi, respectively, are given by the model. 
    Upper case X denotes absolute humidity with respect to mass of moist air while absolute humidity with respect to mass of dry air only is denoted by a lower case x throughout the model. 
    See <a href=\"modelica://Modelica.Media.Air.MoistAir\">package description</a> for further information.
  </p>
</html>"));
  end BaseProperties;

  redeclare function extends setState_pTX
    protected
      SI.MassFraction X_sat "Absolute humidity per unit mass of moist air at saturation";
      SI.MassFraction X_steam "Mass fraction of gaseous water (kg gas water / kg moist air)";

    algorithm
      assert(if size(X, 1) == nX then X[Air] > 1e-4 else 1 - X[Water] > 1e-4, "Too little dry air in the mixture to compute the density", AssertionLevel.error);
      X_sat := k_mair / (p / min(saturationPressure(T), 0.999 * p) - 1 + k_mair);
      X_steam := min(X_sat, X[Water]);
      state := if size(X, 1) == nX then ThermodynamicState(d = p * (1 - X_steam / (X_steam + k_mair * X[Air])) / (dryair.R * T * X[Air]), T = T, X = X) else ThermodynamicState(d = p * (1 - X_steam / (X_steam + k_mair * (1 - X[Water]))) / (dryair.R * T * (1 - X[Water])), T = T, X = cat(1, X, {1 - sum(X)}));
    annotation(
      smoothOrder = 2,
      Documentation(info = "<html>
    The <a href=\"modelica://Modelica.Media.Air.MoistAir.ThermodynamicState\">thermodynamic state record</a> is computed from pressure p, temperature T and composition X. </br>
    If X[Air]&lt;1e-4, the density cannot be computed in case of diphasique water since p and T remain contant.
  
    
  </html>"));
  end setState_pTX;

  redeclare function extends setState_phX
    protected
      SI.MassFraction X_sat "Absolute humidity per unit mass of moist air at saturation";
      SI.MassFraction X_steam "Mass fraction of gaseous water (kg gas water / kg moist air)";
      SI.Temperature T "Temperature";

    algorithm
      state := if size(X, 1) == nX then ThermodynamicState(d = d_phX(p = p, h = h, X = X), T = T_phX(p = p, h = h, X = X), X = X) else ThermodynamicState(d = d_phX(p = p, h = h, X = X), T = T_phX(p = p, h = h, X = X), X = cat(1, X, {1 - sum(X)}));
    annotation(
      smoothOrder = 2,
      Documentation(info = "<html>
  The <a href=\"modelica://Modelica.Media.Air.MoistAir.ThermodynamicState\">thermodynamic state record</a> is computed from pressure p, specific enthalpy h and composition X.
  </html>"));
  end setState_phX;

  redeclare function extends setState_dTX
    algorithm
      state := if size(X, 1) == nX then ThermodynamicState(d = d, T = T, X = X) else ThermodynamicState(d = d, T = T, X = cat(1, X, {1 - sum(X)}));
    annotation(
      smoothOrder = 2,
      Documentation(info = "<html>
  The <a href=\"modelica://Modelica.Media.Air.MoistAir.ThermodynamicState\">thermodynamic state record</a> is computed from density d, temperature T and composition X.
  </html>"));
  end setState_dTX;

  redeclare function extends setSmoothState "Return thermodynamic state so that it smoothly approximates: if x > 0 then state_a else state_b"
    algorithm
      state := ThermodynamicState(d = Modelica.Media.Common.smoothStep(x, state_a.d, state_b.d, x_small), T = Modelica.Media.Common.smoothStep(x, state_a.T, state_b.T, x_small), X = Modelica.Media.Common.smoothStep(x, state_a.X, state_b.X, x_small));
  end setSmoothState;

  function Xsaturation "Return absolute humidity per unit mass of moist air at saturation as a function of the thermodynamic state record"
    extends Modelica.Icons.Function;
    input ThermodynamicState state "Thermodynamic state record";
    output MassFraction X_sat "Steam mass fraction of sat. boundary";
  algorithm
    X_sat := saturationDensity(state.T) / (saturationDensity(state.T) + state.d * state.X[Air]);
    annotation(
      smoothOrder = 2,
      Documentation(info = "<html>
  Absolute humidity per unit mass of moist air at saturation is computed from density and temperature in the state record. Note, that this mass fraction refers to mass of moist air at saturation.
  </html>"));
  end Xsaturation;

  function xsaturation "Return absolute humidity per unit mass of dry air at saturation as a function of the thermodynamic state record"
    extends Modelica.Icons.Function;
    input ThermodynamicState state "Thermodynamic state record";
    output MassFraction x_sat "Absolute humidity per unit mass of dry air";
  algorithm
    x_sat := saturationDensity(state.T) / (state.d * state.X[Air]);
    annotation(
      smoothOrder = 2,
      Documentation(info = "<html>
  Absolute humidity per unit mass of dry air at saturation is computed from density and temperature in the thermodynamic state record.
  </html>"));
  end xsaturation;

  function xsaturation_pT "Return absolute humidity per unit mass of dry air at saturation as a function of pressure p and temperature T"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SI.Temperature T "Temperature";
    output MassFraction x_sat "Absolute humidity per unit mass of dry air";
  algorithm
    assert(p - saturationPressure(T) >= 1e-4, "p_sat(T) is too close to p", AssertionLevel.error);
    x_sat := k_mair * saturationPressure(T) / max(100 * Modelica.Constants.eps, p - saturationPressure(T));
    annotation(
      smoothOrder = 2,
      Documentation(info = "<html>
  Absolute humidity per unit mass of dry air at saturation is computed from pressure and temperature. The function is valid for p-p_sat(T)&ge; 1e-4
  </html>"));
  end xsaturation_pT;

  function massFraction_pTphi "Return steam mass fraction as a function of relative humidity phi and temperature T"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input Temperature T "Temperature";
    input Real phi "Relative humidity (0 ... 1.0)";
    output MassFraction X_steam "Absolute humidity, steam mass fraction";
  protected
    AbsolutePressure psat = saturationPressure(T) "Saturation pressure";
  algorithm
    X_steam := phi * k_mair / (k_mair * phi + p / psat - phi);
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
  protected
    SI.Density d_sat "Saturation density of water in mosit air";
  algorithm
    d_sat := saturationDensity(state.T);
    phi := min(state.d * state.X[Water] - d_sat) / d_sat;
    annotation(
      smoothOrder = 2,
      Documentation(info = "<html>
  Relative humidity is computed from the thermodynamic state record with 1.0 as the upper limit at saturation.
  </html>"));
  end relativeHumidity;

  function gasConstant "Return ideal gas constant as a function from thermodynamic state, remains valid with liquid water in the mixture"
    extends Modelica.Icons.Function;
    input ThermodynamicState state "Thermodynamic state";
    output SI.SpecificHeatCapacity R "Mixture gas constant";
  protected
    MassFraction X_liquid "Mass fraction of liquid or solid water";
    Density d_sat "Steam water density of saturation boundary in kg_water/m3";
  algorithm
    d_sat := saturationDensity(state.T);
    X_liquid := max(state.d * state.X[Water] - d_sat, 0) / state.d;
    R := dryair.R * (1 - state.X[Water]) / (1 - X_liquid) + steam.R * (state.X[Water] - X_liquid) / (1 - X_liquid);
    annotation(
      smoothOrder = 2,
      Documentation(info = "<html>
  The ideal gas constant for moist air is computed from <a href=\"modelica://Modelica.Media.Air.MoistAir.ThermodynamicState\">thermodynamic state</a> where the mass fractions of dry air and steam are corrected of the mass fraction of liquid that does not count for the gas contant calculation.
</html>"));
  end gasConstant;

  function r_dTX "Return ideal gas constant as a function from thermodynamic d, T and X, remains valid with liquid water in the mixture"
  input SI.Density d "Density";
  input SI.Temperature T "Temperature";
  input SI.MassFraction X[:] "Mass fractions of moist air";
  output SI.SpecificHeatCapacity R "Mixture gas constant";
  protected
    MassFraction X_liquid "Mass fraction of liquid or solid water";
    Density d_sat "Steam water density of saturation boundary in kg_water/m3";
  algorithm
    d_sat := saturationDensity(T);
    X_liquid := max(d * X[Water] - d_sat, 0) / d;
    R := dryair.R * (1 - X[Water]) / (1 - X_liquid) + steam.R * (X[Water] - X_liquid) / (1 - X_liquid);
    annotation(
      derivative = r_dTX_der,
      Documentation(info = "<html>
  The ideal gas constant for moist air is computed from the density d, temperature T and composition X where the mass fractions of dry air and steam are corrected of the mass fraction of liquid that does not count for the gas contant calculation.
</html>"));
  end r_dTX;

  function r_dTX_der "Return ideal gas constant derivative as a function from thermodynamic d, T and X, remains valid with liquid water in the mixture"
    input SI.Density d "Density";
    input SI.Temperature T "Temperature";
    input SI.MassFraction X[:] "Mass fractions of moist air";
    input Real dd(unit = "kg/(m3.s)") "Density derivative";
    input Real dT(unit = "K/s") "Temperature derivative";
    input Real dX[:](each unit = "1/s") "Composition derivative";
    output Real R_der(unit = "J/(kg.s.K)") "Time derivative of specific enthalpy";
  protected
    SI.MassFraction X_liquid "Mass fraction of liquid or solid water";
    SI.MassFraction X_steam "Mass fraction of steam water";
    SI.MassFraction X_air "Mass fraction of air";
    SI.Density d_sat "Steam water density of saturation boundary in kg_water/m3";
    Real dX_steam(unit = "1/s") "Time derivative of steam mass fraction";
    Real dX_air(unit = "1/s") "Time derivative of dry air mass fraction";
    Real dX_liq(unit = "1/s") "Time derivative of liquid/solid water mass fraction";
    Real dd_sat(unit = "kg/(m3.s)") "Time derivative of saturation density";
  
  algorithm
    d_sat := saturationDensity(T);
    X_liquid := Utilities.smoothMax(X[Water] - d_sat / d, 0.0, 1e-5);
    X_steam := X[Water] - X_liquid;
    X_air := 1 - X[Water];
    
    dd_sat := saturationDensity_der(T, dT);
    dX_liq := Utilities.smoothMax_der(
      X[Water] - d_sat / d, 0.0, 1e-5, 
      dX[Water] - dd_sat/d + d_sat * dd / d^2, 0, 0);
    dX_steam := dX[Water] - dX_liq;
    dX_air := -dX[Water];
    
    R_der := (dryair.R * dX_air + steam.R * dX_steam) / (1 - X_liquid) + dX_liq / (1 - X_liquid)^2 * (dryair.R * X_air + steam.R * X_steam) 
  
    annotation(
      Documentation(info = "<html>
  The ideal gas constant derivative for moist air is computed from the density d, temperature T and composition X where the mass fractions of dry air and steam are corrected of the mass fraction of liquid that does not count for the gas contant calculation.
</html>"));
  end r_dTX_der;

  function gasConstant_X "Return ideal gas constant as a function from composition X (only valid for phi<1)"
    extends Modelica.Icons.Function;
    input SI.MassFraction X[:] "Gas phase composition";
    output SI.SpecificHeatCapacity R "Ideal gas constant";
  algorithm
    R := dryair.R * (1 - X[Water]) + steam.R * X[Water];
    annotation(
      smoothOrder = 2,
      Documentation(info = "<html>
      The ideal gas constant for moist air is computed from the gas phase composition. 
      The first entry in composition vector X is the steam mass fraction of the gas phase. 
      This function assumed a fully gas mixture thus remains valid for a relative humidity bellow or equal to 1.
    </html>"));
  end gasConstant_X;

  function moleToMassFractions "Return mass fractions X from mole fractions"
    extends Modelica.Icons.Function;
    input SI.MoleFraction moleFractions[:] "Mole fractions of mixture";
    input MolarMass[:] MMX "Molar masses of components";
    output SI.MassFraction X[size(moleFractions, 1)] "Mass fractions of gas mixture";
  protected
    MolarMass Mmix = moleFractions * MMX "Molar mass of mixture";
  algorithm
    for i in 1:size(moleFractions, 1) loop
      X[i] := moleFractions[i] * MMX[i] / Mmix;
    end for;
    annotation(
      smoothOrder = 5);
  end moleToMassFractions;

  function massToMoleFractions "Return mole fractions from mass fractions X"
    extends Modelica.Icons.Function;
    input SI.MassFraction X[:] "Mass fractions of mixture";
    input SI.MolarMass[:] MMX "Molar masses of components";
    output SI.MoleFraction moleFractions[size(X, 1)] "Mole fractions of gas mixture";
  protected
    Real invMMX[size(X, 1)] "Inverses of molar weights";
    SI.MolarMass Mmix "Molar mass of mixture";
  algorithm
    for i in 1:size(X, 1) loop
      invMMX[i] := 1 / MMX[i];
    end for;
    Mmix := 1 / (X * invMMX);
    for i in 1:size(X, 1) loop
      moleFractions[i] := Mmix * X[i] / MMX[i];
    end for;
    annotation(
      smoothOrder = 5);
  end massToMoleFractions;

  replaceable function saturationDensity "Return saturation density of steam as a function of temperature T"
    extends Modelica.Icons.Function;
    input Temperature T "Saturation temperature";
    output Density dsat "Saturation density";
  algorithm
    dsat := saturationPressure(T) / (steam.R * T);
    annotation(
      derivative = saturationDensity_der,
      Inline = true,
      Documentation(info = "<html>
  Saturation density of steam is computed as function of the Temperature using the saturation pressure function <a href=\"modelica://Modelica.Media.Water.IF97_Utilities.BaseIF97.Basic.psat;\"> psat</a> and the perfect gas law.
</html>"));
  end saturationDensity;

  replaceable function saturationDensity_der "Derivative function for 'saturationDensity'"
    extends Modelica.Icons.Function;
    input Temperature T "Saturation temperature";
    input Real dTsat(unit = "K/s") "Time derivative of saturation temperature";
    output Real dsat_der(unit = "kg/m3/s") "Saturation pressure";
  algorithm
//    dsat_der := 1 / steam.R * saturationPressure_der(T, dTsat)   * (Modelica.Media.Water.IF97_Utilities.BaseIF97.Basic.dptofT(T) / T - Modelica.Media.Water.IF97_Utilities.BaseIF97.Basic.psat(T) / T ^ 2) * dTsat;
  dsat_der := 1 / steam.R * (saturationPressure_der(T, dTsat) / T - saturationPressure(T) / T^2 * dTsat) 
    annotation(
      Inline = false,
      smoothOrder = 5,
      Documentation(info = "<html>
  Derivative function of <a href=\"modelica://TAeZoSysPro.Media.Air.MoistAir.saturationDensity\">saturationDensity</a>
  </html>"));
  end saturationDensity_der;

  replaceable function saturationPressure "Return saturation pressure of water as a function of temperature T between 190 and 647.096 K"
    extends Modelica.Icons.Function;
    input Temperature Tsat "Saturation temperature";
    output AbsolutePressure psat "Saturation pressure";
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

  replaceable function saturationPressure_der "Derivative function for 'saturationPressure'"
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

  replaceable function saturationPressureLiquid "Return saturation pressure of water as a function of temperature T in the range of 273.15K to 647.096K (region 4 from the IF97 definition)"
    extends Modelica.Icons.Function;
    input SI.Temperature Tsat "Saturation temperature";
    output SI.AbsolutePressure psat "Saturation pressure";
  protected
//    SI.Temperature Tcritical = 647.096 "Critical temperature";
//    SI.AbsolutePressure pcritical = 22.064e6 "Critical pressure";
//    Real r1 = 1 - Tsat / Tcritical "Common subexpression";
//    Real a[:] = {-7.85951783, 1.84408259, -11.7866497, 22.6807411, -15.9618719, 1.80122502} "Coefficients a[:]";
//    Real n[:] = {1.0, 1.5, 3.0, 3.5, 4.0, 7.5} "Coefficients n[:]";
    constant SI.Temperature T_limit_low = 273.16; 
    constant SI.Temperature T_limit_high = 679.096;
    SI.Temperature T "Temperature in definition range";     
  algorithm
//   psat := exp(((a[1]*r1^n[1] + a[2]*r1^n[2] + a[3]*r1^n[3] + a[4]*r1^n[4]
//      + a[5]*r1^n[5] + a[6]*r1^n[6])*Tcritical)/Tsat)*pcritical;
    T := max(Tsat, T_limit_low); 
    psat := Modelica.Media.Water.IF97_Utilities.BaseIF97.Basic.psat(T);
    annotation(
      derivative = saturationPressureLiquid_der,
      Inline = false,
      smoothOrder = 5,
      Documentation(info = "<html>
  <p>Saturation pressure of water above the triple point temperature is computed from temperature.</p>
  <p>Source: A Saul, W Wagner: &quot;International equations for the saturation properties of ordinary water substance&quot;, equation 2.1</p>
  </html>"));
  end saturationPressureLiquid;

  replaceable function saturationPressureLiquid_der "Derivative function for 'saturationPressureLiquid'"
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
  <p>Saturation pressure of water above the triple point temperature is computed from temperature.</p>
  <p>Source: A Saul, W Wagner: &quot;International equations for the saturation properties of ordinary water substance&quot;, equation 2.1</p>
  </html>"));
  end saturationPressureLiquid_der;

  replaceable function sublimationPressureIce "Return sublimation pressure of water as a function of temperature T between 190 and 273.16 K"
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

  replaceable function sublimationPressureIce_der "Derivative function for 'sublimationPressureIce'"
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

  replaceable function enthalpyOfVaporization "Return vaporization enthalpy of condensing fluid"
    extends Modelica.Icons.Function;
    input Temperature T "Temperature";
    output SpecificEnthalpy r0 "Vaporization enthalpy";
  algorithm
    r0 := water.cp * (reference_T - T) + steam.h_lv + steam.cp * (T - reference_T);
    annotation(
      Inline = true,
      smoothOrder = 5,
      Documentation(info = "<html>
        <p>Enthalpy of vaporization of water is computed from temperature.</p>
        <p>As the enthalpy is a state function, it does not depend on the transformation path.
           Therefore, the enthalpy of vaporisation at a given temperature is computed from the enthalpy of vaporisation at 2°C corrected by the sensible enthalpy diffence between the temperature T and 0°C </p>
      </html>"));
  end enthalpyOfVaporization;

  replaceable function enthalpyOfLiquid "Return enthalpy of liquid water as a function of temperature T(use enthalpyOfWater instead)"
    extends Modelica.Icons.Function;
    input Temperature T "Temperature";
    output SpecificEnthalpy h "Liquid enthalpy";
  algorithm
    h := water.cp * (T - reference_T);
    annotation(
      Inline = true,
      smoothOrder = 5,
      Documentation(info = "<html>
      <p>Specific enthalpy of water is computed from temperature and constant specific heat capacity.</p>
    </html>"));
  end enthalpyOfLiquid;

  replaceable function enthalpyOfGas "Return specific enthalpy of gas (air and steam) as a function of temperature T and composition X (only valide for phi<1)"
    extends Modelica.Icons.Function;
    input Temperature T "Temperature";
    input MassFraction[:] X "Vector of mass fractions";
    output SpecificEnthalpy h "Specific enthalpy";
  algorithm
    h := (steam.cp * (T - reference_T) + steam.h_lv) * X[Water] + dryair.cp * (T - reference_T) * (1.0 - X[Water]);
    annotation(
      Inline = true,
      smoothOrder = 5,
      Documentation(info = "<html>
    Specific enthalpy of moist air is computed from temperature and constant specific heat capacity, provided all water is in the gaseous state. The first entry in the composition vector X must be the mass fraction of steam. For a function that also covers the fog region please refer to <a href=\"modelica://TAeZoSysPro.Media.Air.MoistAir.h_dTX\">h_dTX</a>.
</html>"));
  end enthalpyOfGas;

  replaceable function enthalpyOfCondensingGas "Return specific enthalpy of steam as a function of temperature T"
    extends Modelica.Icons.Function;
    input Temperature T "Temperature";
    output SpecificEnthalpy h "Specific enthalpy";
  algorithm
    h := steam.cp * (T - reference_T) + steam.h_lv;
    annotation(
      Inline = true,
      smoothOrder = 5,
      Documentation(info = "<html>
    Specific enthalpy of steam is computed from temperature and constant specific heat capacity.
</html>"));
  end enthalpyOfCondensingGas;

  replaceable function enthalpyOfNonCondensingGas "Return specific enthalpy of dry air as a function of temperature T"
    extends Modelica.Icons.Function;
    input Temperature T "Temperature";
    output SpecificEnthalpy h "Specific enthalpy";
  algorithm
    h := dryair.cp * (T - reference_T);
    annotation(
      Inline = true,
      smoothOrder = 5,
      Documentation(info = "<html>
    Specific enthalpy of dry air is computed from temperature  and constant specific heat capacity.
</html>"));
  end enthalpyOfNonCondensingGas;

  function enthalpyOfWater "Computes specific enthalpy of water (solid/liquid) near atmospheric pressure from temperature T"
    extends Modelica.Icons.Function;
    input SIunits.Temperature T "Temperature";
    output SIunits.SpecificEnthalpy h "Specific enthalpy of water";
  protected
    constant SI.SpecificHeatCapacity cp_ice = 2050 "Specific heat capacity of ice";
  algorithm
/*simple model assuming constant properties:
    heat capacity of solid water: 2050 J/kg
    enthalpy of fusion (liquid=>solid): 333000 J/kg*/
    h := Utilities.spliceFunction(water.cp * (T - 273.15), cp_ice * (T - 273.15) - 333000, T - 273.16, 0.1);
    annotation(
      derivative = enthalpyOfWater_der,
      Documentation(info = "<html>
  Specific enthalpy of water (liquid and solid) is computed from temperature using constant properties as follows:<br>
  <ul>
  <li>  heat capacity of liquid water:water(record).cp J/kg</li>
  <li>  heat capacity of solid water: 2050 J/kg</li>
  <li>  enthalpy of fusion (liquid=>solid): 333000 J/kg</li>
  </ul>
  Pressure is assumed to be around 1 bar. This function is usually used to determine the specific enthalpy of the liquid or solid fraction of moist air.
  </html>"));
  end enthalpyOfWater;

  function enthalpyOfWater_der "Derivative function of enthalpyOfWater"
    extends Modelica.Icons.Function;
    input SIunits.Temperature T "Temperature";
    input Real dT(unit = "K/s") "Time derivative of temperature";
    output Real dh(unit = "J/(kg.s)") "Time derivative of specific enthalpy";
  protected
    constant SI.SpecificHeatCapacity cp_ice = 2050 "Specific heat capacity of ice";
  algorithm
/*simple model assuming constant properties:
    heat capacity of solid water: 2050 J/kg
    enthalpy of fusion (liquid=>solid): 333000 J/kg*/
//h:=Utilities.spliceFunction(water.cp*(T-273.15),2050*(T-273.15)-333000,T-273.16,0.1);
    dh := Utilities.spliceFunction_der(water.cp * (T - 273.15), cp_ice * (T - 273.15) - 333000, T - 273.16, 0.1, water.cp * dT, cp_ice * dT, dT, 0);
    annotation(
      Documentation(info = "<html>
  Derivative function for <a href=\"modelica://Modelica.Media.Air.MoistAir.enthalpyOfWater\">enthalpyOfWater</a>.
  
  </html>"));
  end enthalpyOfWater_der;

  redeclare function extends pressure "Returns pressure of ideal gas as a function of the thermodynamic state record"
    protected
      SI.MassFraction X_liquid "Mass fraction of liquid or solid water";
      SI.MassFraction X_steam "Mass fraction of steam water";
      SI.MassFraction X_air "Mass fraction of air";
      SI.Density d_sat "Steam water density of saturation boundary in kg_water/m3";

    algorithm
      d_sat := saturationDensity(state.T);
      X_liquid := max(state.d * state.X[Water] - d_sat, 0) / state.d;
      X_steam := state.X[Water] - X_liquid;
      X_air := 1 - state.X[Water];
      p := state.d * (dryair.R * X_air + steam.R * X_steam) * state.T;
    annotation(
      smoothOrder = 5,
      Documentation(info = "<html>
      <p>Pressure is returned from the thermodynamic state record input from the density and the temparture applying the ideal gas law.<p>
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
    extends Modelica.Icons.UnderConstruction;
    input AbsolutePressure p "Pressure";
    input SpecificEnthalpy h "Specific enthalpy";
    input MassFraction[:] X "Mass fractions of composition";
    output Temperature T "Temperature";
  protected
    SI.MoleFraction Y[2] "Mole fraction of species in the medium";
    SI.MassFraction X_liq "Mass fraction of liquid";
    SI.Temperature T_sat "Steam saturation temperature at given steam pressure";
    SI.MassFraction X_steam "Mass fraction of steam in medium";
    Integer i;
  algorithm
    i := 0;
//h = X_air*dryair.cp*(T_sat-T_ref)+X_steam*(steam.cp*(T_sat-T_ref)+h_lv)+(1-X_air-X_steam)*water.cp*(T_sat-T_ref)
    T := (h - X[Water] * steam.h_lv) / (X[Air] * dryair.cp + X[Water] * steam.cp) + reference_T;
    Y := massToMoleFractions(X = X, MMX = MMX);
    T_sat := Modelica.Media.Water.IF97_Utilities.BaseIF97.Basic.tsat(p * Y[Water]);
//Modelica.Utilities.Streams.print("T_sat = "+String(T_sat)+", i="+String(i)) ;
    if T < T_sat then
      while abs((T - T_sat) / T_sat) > 1e-5 loop
        T := T_sat;
        X_steam := (h - (X[Air] * (dryair.cp - water.cp) + water.cp) * (T - reference_T)) / ((steam.cp - water.cp) * (T - reference_T) + steam.h_lv);
        X_liq := X[Water] - X_steam;
        Y := massToMoleFractions(X = {X_steam / (1 - X_liq), (1 - X_steam) / (1 - X_liq)}, MMX = MMX);
        T_sat := Modelica.Media.Water.IF97_Utilities.BaseIF97.Basic.tsat(p * Y[Water]);
        i := i + 1;
      end while;
      T := T_sat;
    else
      X_steam := X[Water];
      X_liq := 0.0;
    end if;
/* liquid water*/
//Modelica.Utilities.Streams.print("T_sat = "+String(T_sat)+", X_steam = "+String(X_steam)+", X_liq = "+String(X_liq)) ;
//Modelica.Utilities.Streams.print("sum_X = "+String((X_steam + X[Air])/(1-X_liq))) ;
//Modelica.Utilities.Streams.print("i = "+String(i)) ;
    annotation(
      Documentation(info = "<html>
      <p>
        Temperature is computed from pressure, specific enthalpy and composition. 
        Loop over the saturation temperature is performed for the fog region and for dry mixture, 
        the temperature is computed from analytic inversion of the enthalpy relation with respect to the temperature. 
      </p>
      
    </html>"));
  end T_phX;

  redeclare function extends density "Returns density as a function of the thermodynamic state record"
    algorithm
      d := state.d;
    annotation(
      smoothOrder = 2,
      Documentation(info = "<html>
    Density is returned from the thermodynamic state record input as a simple assignment.
  </html>"));
  end density;

  function d_phX "Returns density as a function of pressure p, enthalpy h and composition X"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEnthalpy h "Specific enthalpy";
    input MassFraction X[:] = reference_X "Mass fractions";
    output Density d "Density";
  protected
    SI.Temperature T;
    SI.MassFraction X_steam "Steam mass fraction in the medium";
    SI.MassFraction X_liquid "Liquid water mass fraction in the medium";
    SI.MolarMass MMmix "Molar mass of gas mixture";
  algorithm
    T := T_phX(p = p, h = h, X = X);
    X_steam := (h - (X[Air] * (dryair.cp - water.cp) + water.cp) * (T - reference_T)) / ((steam.cp - water.cp) * (T - reference_T) + steam.h_lv);
    X_steam := min(X_steam, X[Water]);
    X_liquid := max(X[Water] - X_steam, 0.0);
    MMmix := (X_steam / (1 - X_liquid) / steam.MM + X[Air] / (1 - X_liquid) / dryair.MM) ^ (-1);
    d := p / (Modelica.Constants.R / MMmix * T);
    annotation(
      smoothOrder = 2,
      Documentation(info = "<html>
        Density is returned from the pressure p, specific enthalpy h and composition X.
      </html>"));
  end d_phX;

  redeclare function extends specificEnthalpy "Return specific enthalpy of moist air as a function of the thermodynamic state record"
    algorithm
      h := h_dTX(state.d, state.T, state.X);
    annotation(
      smoothOrder = 2,
      Documentation(info = "<html>
  Specific enthalpy of moist air is computed from the thermodynamic state record. The fog region is included for both, ice and liquid fog.
  </html>"));
  end specificEnthalpy;

  function h_dTX "Return specific enthalpy of moist air as a function of density d, temperature T and composition X"
    extends Modelica.Icons.Function;
    input SI.Density d "Density";
    input SI.Temperature T "Temperature";
    input SI.MassFraction X[:] "Mass fractions of moist air";
    output SI.SpecificEnthalpy h "Specific enthalpy at p, T, X";
  protected
    SI.MassFraction X_liquid "Mass fraction of liquid or solid water";
    SI.MassFraction X_steam "Mass fraction of steam water";
    SI.MassFraction X_air "Mass fraction of air";
    SI.Density d_sat "Steam water density of saturation boundary in kg_water/m3";
  algorithm
    d_sat := saturationDensity(T);
    X_liquid := max(d * X[Water] - d_sat, 0) / d;
    X_steam := X[Water] - X_liquid;
    X_air := 1 - X[Water];
//h := X_air*dryair.cp*(T-273.15) + X_steam*(steam.cp*(T-273.15)+steam.h_lv) + enthalpyOfWater(T)*X_liquid;
    h := X_air * dryair.cp * (T - reference_T) + X_steam * (steam.cp * (T - reference_T) + steam.h_lv) + X_liquid * water.cp * (T - reference_T);

    annotation(
      Inline = false,
      derivative=h_dTX_der,
      Documentation(info = "<html>
  Specific enthalpy of moist air is computed from density, temperature and composition with X[1] as the total water mass fraction. The fog region is included for both, ice and liquid fog.
  </html>"));
  end h_dTX;

  function h_dTX_der "Derivative function of h_dTX"
    extends Modelica.Icons.Function;
    input SI.Density d "Density";
    input SI.Temperature T "Temperature";
    input SI.MassFraction X[:] "Mass fractions of moist air";
    input Real dd(unit = "kg/(m3.s)") "Density derivative";
    input Real dT(unit = "K/s") "Temperature derivative";
    input Real dX[:](each unit = "1/s") "Composition derivative";
    output Real h_der(unit = "J/(kg.s)") "Time derivative of specific enthalpy";
  protected
    SI.MassFraction X_liquid "Mass fraction of liquid or solid water";
    SI.MassFraction X_steam "Mass fraction of steam water";
    SI.MassFraction X_air "Mass fraction of air";
    SI.Density d_sat "Steam water density of saturation boundary in kg_water/m3";
    Real dX_steam(unit = "1/s") "Time derivative of steam mass fraction";
    Real dX_air(unit = "1/s") "Time derivative of dry air mass fraction";
    Real dX_liq(unit = "1/s") "Time derivative of liquid/solid water mass fraction";
    Real dd_sat(unit = "kg/(m3.s)") "Time derivative of saturation density";
  algorithm
    d_sat := saturationDensity(T);
    X_liquid := Utilities.smoothMax(max(d * X[Water] - d_sat, 0) / d, 0.0, 1e-5);
    X_steam := X[Water] - X_liquid;
    X_air := 1 - X[Water];
    dX_air := -dX[Water];
    dd_sat := saturationDensity_der(T, dT);
    dX_liq := Utilities.smoothMax_der(max(d * X[Water] - d_sat, 0) / d, 0.0, 1e-5, (d * dX[Water] + dd * X[Water] - dd_sat) / d - (d * X[Water] - d_sat) / (d * d) * dd, 0, 0);
    dX_steam := dX[Water] - dX_liq;
    h_der := X_air * dryair.cp * dT + dX_air * dryair.cp * (T - reference_T) + X_steam * steam.cp * dT + dX_steam * (steam.h_lv + steam.cp * (T - reference_T)) + X_liquid * water.cp * dT + dX_liq * water.cp * (T - reference_T);
    annotation(
      Inline = false,
      smoothOrder = 1,
      Documentation(info = "<html>
  Derivative function for <a href=\"modelica://Modelica.Media.Air.MoistAir.h_pTX\">h_dTX</a>.
  </html>"));
  end h_dTX_der;

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
    X_sat := min(p_steam_sat * k_mair / max(100 * Modelica.Constants.eps, p - p_steam_sat) * (1 - X[Water]), 1.0);
    X_liquid := max(X[Water] - X_sat, 0.0);
    X_steam := X[Water] - X_liquid;
    X_air := 1 - X[Water];
    h := (X_steam * steam.cp + X_air * dryair.cp) * (T - reference_T) + X_steam * steam.h_lv + enthalpyOfWater(T) * X_liquid;
    annotation(
      derivative = h_pTX_der,
      Inline = false,
      Documentation(info = "<html>
        <p>
          Specific enthalpy of moist air is computed from pressure, temperature and composition with X[1] as the total water mass fraction. 
          The fog region is included for both, ice and liquid fog.
        </p>
        <p>
          This function is only valid for a mass fraction of air X[Air] > 1e-4. 
          Otherwise, when the mixture is fully composed of water, the ratio between steam and liquid water cannot be determine since the pressure p and the temperature T remains constant whatever the ratio.
        </p>
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
    h_der := X_air * dryair.cp * dT + dX_air * dryair.cp * (T - reference_T) + X_steam * steam.cp * dT + dX_steam * (steam.h_lv + steam.cp * (T - reference_T)) + X_liquid * enthalpyOfWater_der(T = T, dT = dT) + dX_liq * enthalpyOfWater(T);
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
    AbsolutePressure p1 "Upstream pressure";
  algorithm
    h := {steam.cp * (state.T - reference_T), dryair.cp * (state.T - reference_T)} * state.X;
    p1 := state.d * (state.X[Water] * steam.R + (1 - state.X[Water]) * dryair.R) * state.T;
    h_is := h + gamma / (gamma - 1.0) * (state.T * gasConstant_X(state.X)) * ((p2 / p1) ^ ((gamma - 1) / gamma) - 1.0);
  end isentropicEnthalpyApproximation;

  redeclare function extends specificInternalEnergy "Return specific internal energy of moist air as a function of the thermodynamic state record"
      extends Modelica.Icons.Function;

    algorithm
      u := specificInternalEnergy_dTX(state.d, state.T, state.X);
    annotation(
      smoothOrder = 2,
      Documentation(info = "<html>
  Specific internal energy is determined from the thermodynamic state record, assuming that the liquid or solid water volume is negligible.
  </html>"));
  end specificInternalEnergy;

  function specificInternalEnergy_dTX "Return specific internal energy of moist air as a function of density d, temperature T and composition X"
    extends Modelica.Icons.Function;
    input SI.Density d "Density";
    input SI.Temperature T "Temperature";
    input SI.MassFraction X[:] "Mass fractions of moist air";
    output SI.SpecificInternalEnergy u "Specific internal energy";
  protected
    SI.MassFraction X_liquid "Mass fraction of liquid or solid water";
    SI.MassFraction X_steam "Mass fraction of steam water";
    SI.MassFraction X_air "Mass fraction of air";
    SI.MassFraction d_sat "Steam water density of saturation boundary in kg_water/m3";
    Real R_gas "Ideal gas constant";
  algorithm
    d_sat := saturationDensity(T);
    X_liquid := max(d * X[Water] - d_sat, 0) / d;
    X_steam := X[Water] - X_liquid;
    X_air := 1 - X[Water];
    R_gas := dryair.R * X_air / (1 - X_liquid) + steam.R * X_steam / (1 - X_liquid);
    u := X_steam * steam.cp * (T - reference_T) + X_air * dryair.cp * (T - reference_T) + enthalpyOfWater(T) * X_liquid - R_gas * T;
    annotation(
      derivative = specificInternalEnergy_dTX_der,
      Documentation(info = "<html>
  Specific internal energy is determined from density d, temperature T and composition X, assuming that the liquid or solid water volume is negligible.
  </html>"));
  end specificInternalEnergy_dTX;

  function specificInternalEnergy_dTX_der "Derivative function for specificInternalEnergy_dTX"
    extends Modelica.Icons.Function;
    input SI.Density d "Density";
    input SI.Temperature T "Temperature";
    input SI.MassFraction X[:] "Mass fractions of moist air";
    input Real dd(unit = "kg/(m3.s)") "Density derivative";
    input Real dT(unit = "K/s") "Temperature derivative";
    input Real dX[:](each unit = "1/s") "Mass fraction derivatives";
    output Real u_der(unit = "J/(kg.s)") "Specific internal energy derivative";
  protected
    SI.MassFraction X_liquid "Mass fraction of liquid or solid water";
    SI.MassFraction X_steam "Mass fraction of steam water";
    SI.MassFraction X_air "Mass fraction of air";
    SI.Density d_sat "Steam water density of saturation boundary in kg_water/m3";
    SI.SpecificHeatCapacity R_gas "Ideal gas constant";
    Real dX_steam(unit = "1/s") "Time derivative of steam mass fraction";
    Real dX_air(unit = "1/s") "Time derivative of dry air mass fraction";
    Real dX_liq(unit = "1/s") "Time derivative of liquid/solid water mass fraction";
    Real dd_sat(unit = "kg/(m3.s)") "Time derivative of saturation density";
    Real dR_gas(unit = "J/(kg.K.s)") "Time derivative of ideal gas constant";
  algorithm
    d_sat := saturationDensity(T);
    X_liquid := Utilities.spliceFunction(max(d * X[Water] - d_sat, 0) / d, 0.0, max(d * X[Water] - d_sat, 0) / d, 1e-6);
    X_steam := X[Water] - X_liquid;
    X_air := 1 - X[Water];
    R_gas := steam.R * X_steam / (1 - X_liquid) + dryair.R * X_air / (1 - X_liquid);
    dd_sat := saturationDensity_der(T, dT);
    dX_liq := Utilities.spliceFunction_der((d * X[Water] - d_sat) / d, 0.0, (d * X[Water] - d_sat) / d, 1e-6, (d * dX[Water] + dd * X[Water] - dd_sat) / d - (d * X[Water] - d_sat) / (d * d) * dd, 0.0, (d * dX[Water] + dd * X[Water] - dd_sat) / d - (d * X[Water] - d_sat) / (d * d) * dd, 0.0);
    dX_air := -dX[Water];
    dX_steam := dX[Water] - dX_liq;
    dR_gas := (steam.R * (dX_steam * (1 - X_liquid) + dX_liq * X_steam) + dryair.R * (dX_air * (1 - X_liquid) + dX_liq * X_air)) / (1 - X_liquid) / (1 - X_liquid);
    u_der := h_dTX_der(d, T, X, dd, dT, dX) - R_gas * dT - dR_gas * T annotation(
      Documentation(info = "<html>
  Derivative function for <a href=\"modelica://Modelica.Media.Air.MoistAir.specificInternalEnergy_dTX\">specificInternalEnergy_dTX</a>.
  </html>"));
  end specificInternalEnergy_dTX_der;

  redeclare function extends specificEntropy "Return specific entropy from thermodynamic state record"
    algorithm
      s := s_dTX(state.d, state.T, state.X);
    annotation(
      Inline = false,
      smoothOrder = 2,
      Documentation(info = "<html>
      Specific entropy is calculated from the thermodynamic state record, assuming ideal gas behavior and including entropy of mixing. Liquid but not solid water is taken into account.
  </html>"));
  end specificEntropy;

  function s_dTX "Return specific entropy of moist air as a function of density d, temperature T and composition X"
    extends Modelica.Icons.Function;
    input SI.Density d "Density";
    input SI.Temperature T "Temperature";
    input SI.MassFraction X[:] "Mass fractions of moist air";
    output SI.SpecificEntropy s "Specific entropy at p, T, X";
  protected
    SI.Pressure p[2] "Vector of partial pressure of water and dry air";
    SI.MassFraction X_liquid "Mass fraction of liquid or solid water";
    SI.MassFraction X_steam "Mass fraction of steam water";
    SI.MassFraction X_air "Mass fraction of air";
    SI.MassFraction d_sat "Steam water density of saturation boundary in kg_water/m3";
  algorithm
    d_sat := saturationDensity(T);
    X_liquid := max(d * X[Water] - d_sat, 0) / d;
    X_steam := X[Water] - X_liquid;
    X_air := 1 - X[Water];
    p[Water] := d * X_steam * steam.R * T;
    p[Air] := d * X_air * dryair.R * T;
    s := X_air * dryair.cp * Modelica.Math.log(T / reference_T) + X_steam * steam.cp * Modelica.Math.log(T / reference_T) - Modelica.Constants.R * (Utilities.smoothMax(X_steam / MMX[Water], 0.0, 1e-9) * Modelica.Math.log(max(p[Water], Modelica.Constants.eps) / reference_p) + Utilities.smoothMax(X_air / MMX[Air], 0.0, 1e-9) * Modelica.Math.log(max(p[Air], Modelica.Constants.eps) / reference_p)) + X_liquid * water.cp * Modelica.Math.log(T / reference_T) + X_liquid * enthalpyOfVaporization(T) / T;
    annotation(
      derivative = s_dTX_der,
      Inline = false,
      Documentation(info = "<html>
  Specific entropy of moist air is computed from density, temperature and composition with X[1] as the total water mass fraction.
  </html>"));
  end s_dTX;

  function s_dTX_der "Derivative function of h_dTX"
    extends Modelica.Icons.UnderConstruction;
    input SI.Density d "Density";
    input SI.Temperature T "Temperature";
    input SI.MassFraction X[:] "Mass fractions of moist air";
    input Real dd(unit = "kg/(m3.s)") "Derivative of density";
    input Real dT(unit = "K/s") "Derivative of temperature";
    input Real dX[nX](each unit = "1/s") "Derivative of mass fractions";
    output Real ds(unit = "J/(kg.K.s)") "Specific entropy at p, T, X";
  protected
    SI.Pressure p[2] "Vector of partial pressure of water and dry air";
    SI.MassFraction X_liquid "Mass fraction of liquid or solid water";
    SI.MassFraction X_steam "Mass fraction of steam water";
    SI.MassFraction X_air "Mass fraction of air";
    SI.MassFraction d_sat "Steam water density of saturation boundary in kg_water/m3";
    Real dp[2](unit = "Pa/s") "Time derivative of vector of partial pressure of water and dry air";
    Real dX_steam(unit = "1/s") "Time derivative of steam mass fraction";
    Real dX_air(unit = "1/s") "Time derivative of dry air mass fraction";
    Real dX_liq(unit = "1/s") "Time derivative of liquid/solid water mass fraction";
    Real dd_sat(unit = "kg/(m3.s)") "Time derivative of saturation density";
  algorithm
    d_sat := saturationDensity(T);
    X_liquid := Utilities.smoothMax(max(d * X[Water] - d_sat, 0) / d, 0.0, 1e-5);
    X_steam := X[Water] - X_liquid;
    X_air := 1 - X[Water];
    p[Water] := d * X_steam * steam.R * T;
    p[Air] := d * X_air * dryair.R * T;
    dX_air := -dX[Water];
//dd_sat = dd_sat/dp*dp/dT*dT
    dd_sat := Modelica.Media.Water.IF97_Utilities.BaseIF97.Regions.drhov_dp(Modelica.Media.Water.IF97_Utilities.BaseIF97.Basic.psat(T)) * Modelica.Media.Water.IF97_Utilities.BaseIF97.Basic.psat_der(T, dT);
    dX_liq := Utilities.smoothMax_der(max(d * X[Water] - d_sat, 0) / d, 0.0, 1e-5, d * dX[Water] + dd * X[Water] - dd_sat, 0, 0);
    dX_steam := dX[Water] - dX_liq;
    dp[Water] := dd * X_steam * steam.R * T + d * (dX_steam * steam.R * T + X_steam * steam.R * dT);
    dp[Air] := dd * X_air * dryair.R * T + d * (dX_air * dryair.R * T + X_air * dryair.R * dT);
    ds := (1 - X[Water]) * dryair.cp * dT / T + dX_air * dryair.cp * Modelica.Math.log(T / reference_T) + X[Water] * steam.cp * dT / T + dX[Water] * Modelica.Math.log(T / reference_T) - Modelica.Constants.R * (1 / MMX[Water] * (Utilities.smoothMax_der(X[Water], 0.0, 1e-9, dX[Water], 0.0, 0.0) * Modelica.Math.log(max(dp[Water], Modelica.Constants.eps) / reference_p) + dp[Water] / p[Water] * Utilities.smoothMax(X[Water], 0.0, 1e-9)) + 1 / MMX[Air] * (Utilities.smoothMax_der(X[Air], 0.0, 1e-9, dX[Air], 0.0, 0.0) * Modelica.Math.log(max(p[Air], Modelica.Constants.eps) / reference_p) + dp[Air] / p[Air] * Utilities.smoothMax(X[Air], 0.0, 1e-9))) + dX_liq * water.cp * Modelica.Math.log(T / reference_T) + X_liquid * water.cp * dT / T;
    annotation(
      Inline = false,
      smoothOrder = 1,
      Documentation(info = "<html>
  Specific entropy of moist air is computed from density, temperature and composition with X[1] as the total water mass fraction.
  </html>"));
  end s_dTX_der;

  redeclare function extends specificGibbsEnergy "Return specific Gibbs energy as a function of the thermodynamic state record, only valid for phi<1"
      extends Modelica.Icons.Function;

    algorithm
      g := h_dTX(state.d, state.T, state.X) - state.T * specificEntropy(state);
    annotation(
      smoothOrder = 2,
      Documentation(info = "<html>
  The Gibbs Energy is computed from the thermodynamic state record for moist air with a water content below saturation.
  </html>"));
  end specificGibbsEnergy;

  redeclare function extends specificHelmholtzEnergy "Return specific Helmholtz energy as a function of the thermodynamic state record, only valid for phi<1"
      extends Modelica.Icons.Function;

    algorithm
      f := h_dTX(state.d, state.T, state.X) - gasConstant(state) * state.T - state.T * specificEntropy(state);
    annotation(
      smoothOrder = 2,
      Documentation(info = "<html>
  The Specific Helmholtz Energy is computed from the thermodynamic state record for moist air with a water content below saturation.
  </html>"));
  end specificHelmholtzEnergy;

  redeclare function extends specificHeatCapacityCp "Return specific heat capacity at constant pressure as a function of the thermodynamic state record"
    protected
      SI.Density d_sat "Steam water density of saturation boundary in kg_water/m3";
      SI.MassFraction X_liquid;
      SI.MassFraction X_steam;
      SI.MassFraction X_air;

    algorithm
      d_sat := saturationDensity(state.T);
      X_liquid := max(state.d * state.X[Water] - d_sat, 0) / state.d;
      X_steam := state.X[Water] - X_liquid;
      X_air := 1 - state.X[Water];
      cp := steam.cp * X_steam + dryair.cp * X_air + water.cp * X_liquid;
//    cp := steam.cp*state.X[Water] + dryair.cp*(1-state.X[Water]);
    annotation(
      Inline = false,
      smoothOrder = 2,
      Documentation(info = "<html>
    The specific heat capacity at constant pressure <strong>cp</strong> is computed from temperature and composition for a mixture of steam (X[1]) and dry air. Solid water region is excluded.
  </html>"));
  end specificHeatCapacityCp;

  redeclare function extends specificHeatCapacityCv "Return specific heat capacity at constant volume as a function of the thermodynamic state record, only valide for phi<1"
    algorithm
      cv := (steam.cp - steam.R) * state.X[Water] + (dryair.cp - dryair.R) * (1 - state.X[Water]);
    annotation(
      Inline = true,
      smoothOrder = 2,
      Documentation(info = "<html>
  The specific heat capacity at constant density <strong>cv</strong> is computed from temperature and composition for a mixture of steam (X[1]) and dry air. All water is assumed to be in the vapor state.
  </html>"));
  end specificHeatCapacityCv;

  redeclare function extends dynamicViscosity "Return dynamic viscosity as a function of the thermodynamic state record, valid from 123.15 K to 1273.15 K"
      import Modelica.Media.Incompressible.TableBased.Polynomials_Temp;

    algorithm
      eta := 1.81063e-5;
    annotation(
      smoothOrder = 5,
      Documentation(info = "<html>
  <p>Dynamic viscosity is constant and the value is computed from the NIST at the reference temperature and pressure and for dry air</p>
  </html>"));
  end dynamicViscosity;

  redeclare function extends thermalConductivity "Return thermal conductivity as a function of the thermodynamic state record, valid from 123.15 K to 1273.15 K"
      import Modelica.Media.Incompressible.TableBased.Polynomials_Temp;
      import Cv = Modelica.SIunits.Conversions;

    algorithm
      lambda := 0.0258738;
    annotation(
      smoothOrder = 2,
      Documentation(info = "<html>
  <p>Thermal conductivity is constant and the value is computed from the NIST at the reference temperature and pressure and for dry air</p>
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

  redeclare function extends isentropicEnthalpy "Isentropic enthalpy (only valid for phi<1)"
      extends Modelica.Icons.Function;

    algorithm
      h_is := isentropicEnthalpyApproximation(p2 = p_downstream, state = refState);
    annotation();
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
end MoistAir;
