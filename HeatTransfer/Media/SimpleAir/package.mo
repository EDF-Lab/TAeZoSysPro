within TAeZoSysPro.HeatTransfer.Media;

package SimpleAir
  extends Modelica.Icons.MaterialProperty;
  extends Modelica.Media.Interfaces.PartialPureSubstance(redeclare record FluidConstants = Modelica.Media.Interfaces.Types.Basic.FluidConstants, ThermoStates = Modelica.Media.Interfaces.Choices.IndependentVariables.pT, final singleState = false, mediumName = "SimpleAir", reference_p = p0 "atmospheric temperature");
  //  constant FluidConstants[nS] fluidConstants = {Modelica.Media.Interfaces.Types.Basic.FluidConstants(
  //                                  iupacName="simple air",
  //                                  casRegistryNumber="not a real substance",
  //                                  chemicalFormula="N2, O2",
  //                                  structureFormula="N2, O2",
  //                                  molarMass=Modelica.Media.IdealGases.Common.SingleGasesData.N2.MM)}
  //                              "Constant data for the fluid" ;
  constant SpecificHeatCapacity cp_const = 1005.45 "Constant specific heat capacity at constant pressure";
  constant SpecificHeatCapacity cv_const = cp_const - R_gas "Constant specific heat capacity at constant volume";
  constant SpecificHeatCapacity R_gas = Modelica.Constants.R / MM_const "Medium specific gas constant";
  constant MolarMass MM_const = 0.0289651159 "Molar mass";
  constant DynamicViscosity eta_const = 1.82e-5 "Constant dynamic viscosity";
  constant ThermalConductivity lambda_const = 0.026 "Constant thermal conductivity";
  constant Temperature T0 = 273.15 "Zero enthalpy temperature";
  constant AbsolutePressure p0 = 101325 "atmospheric temperature";

  redeclare record extends ThermodynamicState "Thermodynamic state of ideal gas"
      AbsolutePressure p "Absolute pressure of medium";
      Temperature T "Temperature of medium";
      Density d "Density of medium";
  end ThermodynamicState;

  redeclare replaceable model extends BaseProperties(T(stateSelect = if preferredMediumStates then StateSelect.prefer else StateSelect.default), p(stateSelect = if preferredMediumStates then StateSelect.prefer else StateSelect.default)) "Base properties of ideal gas"
      constant Modelica.SIunits.SpecificInternalEnergy u0 = R_gas * T0;

    equation
      p = reference_p;
      h = specificEnthalpy_pTX(p0, T, X);
      u = h - p / d + u0;
      R = R_gas;
      d = p0 / (R * T);
      MM = MM_const;
      state.T = T;
      state.p = p0;
      state.d = d;
    annotation(
      Documentation(info = "<html>
<p>
This is the most simple incompressible medium model, where
specific enthalpy h and specific internal energy u are only
a function of temperature T and all other provided medium
quantities are assumed to be constant.
</p>
</html>"));
  end BaseProperties;

  redeclare function setState_pTX "Return thermodynamic state from p, T, and X or Xi"
    extends Modelica.Icons.Function;
    input AbsolutePressure p = p0 "Pressure";
    input Temperature T "Temperature";
    input MassFraction X[:] = reference_X "Mass fractions";
    output ThermodynamicState state "Thermodynamic state record";
  algorithm
    state := ThermodynamicState(p = p, T = T, d = p / (R_gas * T));
  end setState_pTX;

  redeclare function setState_phX "Return thermodynamic state from p, h, and X or Xi"
    extends Modelica.Icons.Function;
    input AbsolutePressure p = p0 "Pressure";
    input SpecificEnthalpy h "Specific enthalpy";
    input MassFraction X[:] = reference_X "Mass fractions";
    output ThermodynamicState state "Thermodynamic state record";
  protected
    Modelica.SIunits.Temperature T;
  algorithm
    T := T0 + h / cp_const;
    state := ThermodynamicState(p = p0, T = T, d = p / (R_gas * T));
  end setState_phX;

  redeclare function extends setSmoothState "Return thermodynamic state so that it smoothly approximates: if x > 0 then state_a else state_b"
    algorithm
      state := ThermodynamicState(p = Media.Common.smoothStep(x, state_a.p, state_b.p, x_small), T = Media.Common.smoothStep(x, state_a.T, state_b.T, x_small));
  end setSmoothState;

  redeclare function extends density "Return density of ideal gas"
    algorithm
      d := state.p / (R_gas * state.T);
  end density;

  redeclare function extends specificEnthalpy "Return specific enthalpy"
      extends Modelica.Icons.Function;

    algorithm
      h := cp_const * (state.T - T0);
  end specificEnthalpy;

  redeclare function extends specificInternalEnergy "Return specific internal energy"
      extends Modelica.Icons.Function;

    algorithm
      u := cp_const * (state.T - T0) - R_gas * state.T;
  end specificInternalEnergy;

  redeclare function extends dynamicViscosity "Return dynamic viscosity"
    algorithm
      eta := eta_const;
  end dynamicViscosity;

  redeclare function extends thermalConductivity "Return thermal conductivity"
    algorithm
      lambda := lambda_const;
  end thermalConductivity;

  redeclare function extends specificHeatCapacityCp "Return specific heat capacity at constant pressure"
    algorithm
      cp := cp_const;
  end specificHeatCapacityCp;

  redeclare function extends specificHeatCapacityCv "Return specific heat capacity at constant volume"
    algorithm
      cv := cv_const;
  end specificHeatCapacityCv;

  redeclare function specificEnthalpy_pTX "Return specific enthalpy from p, T, and X or Xi"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input Temperature T "Temperature";
    input MassFraction X[nX] "Mass fractions";
    output SpecificEnthalpy h "Specific enthalpy at p, T, X";
  algorithm
    h := cp_const * (T - T0);
  end specificEnthalpy_pTX;

  redeclare function temperature_phX "Return temperature from p, h, and X or Xi"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEnthalpy h "Specific enthalpy";
    input MassFraction X[nX] "Mass fractions";
    output Temperature T "Temperature";
  algorithm
    T := h / cp_const + T0;
  end temperature_phX;

  redeclare function density_phX "Return density from p, h, and X or Xi"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEnthalpy h "Specific enthalpy";
    input MassFraction X[nX] "Mass fractions";
    output Density d "Density";
  algorithm
    d := density(setState_phX(p, h, X));
  end density_phX;

  redeclare function extends isobaricExpansionCoefficient "Returns overall the isobaric expansion coefficient beta"
    algorithm
      beta := 1 / state.T;
  end isobaricExpansionCoefficient;

  redeclare function extends isothermalCompressibility "Returns overall the isothermal compressibility factor"
    algorithm
      kappa := 1 / state.p;
  end isothermalCompressibility;

  redeclare function extends molarMass "Returns the molar mass of the medium"
    algorithm
      MM := MM_const;
  end molarMass;
end SimpleAir;
