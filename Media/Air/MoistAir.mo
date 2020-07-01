within TAeZoSysPro.Media.Air;

package MoistAir
  extends Modelica.Media.Interfaces.PartialMedium(
    redeclare replaceable record FluidConstants = 
      Modelica.Media.Interfaces.Types.IdealGas.FluidConstants,
    mediumName="Moist air",
    substanceNames={"water","air"},
    final reducedX=true,
    final singleState=false,
    reference_X={0.01,0.99},
    Temperature(min=190, max=647),
    ThermoStates=Modelica.Media.Interfaces.Choices.IndependentVariables.dTX);

  redeclare replaceable record extends ThermodynamicState
    "Thermodynamic state variables of moist air"
    Density d "density of medium";
    Temperature T "Temperature of medium";
    MassFraction[nX] X(start=reference_X)
      "Mass fractions (= (component mass)/total mass  m_i/m)";
  end ThermodynamicState;

  constant FluidConstants[nS] fluidConstants = {IdealGases.Common.FluidData.H2O,IdealGases.Common.FluidData.N2} "Constant data for the fluid";
  
  replaceable function gasConstant
    "Return ideal gas constant as a function from thermodynamic state, only valid for phi<1"
    extends Modelica.Icons.Function;
    input ThermodynamicState state "Thermodynamic state";
    output SI.SpecificHeatCapacity R "Mixture gas constant";
    
  algorithm 
    R := dryair.R*(1 - state.X[Water]) + steam.R*state.X[Water];
    annotation (smoothOrder=2, Documentation(info="<html>
The ideal gas constant for moist air is computed from <a href=\"modelica://Modelica.Media.Air.MoistAir.ThermodynamicState\">thermodynamic state</a> assuming that all water is in the gas phase.
</html>"));
  end gasConstant;
  
  function moleToMassFractions "Return mass fractions X from mole fractions"
    extends Modelica.Icons.Function;
    input SI.MoleFraction moleFractions[:] "Mole fractions of mixture";
    input MolarMass[:] MMX "Molar masses of components";
    output SI.MassFraction X[size(moleFractions, 1)]
      "Mass fractions of gas mixture";
  protected 
    MolarMass Mmix=moleFractions*MMX "Molar mass of mixture";
  algorithm 
    for i in 1:size(moleFractions, 1) loop
      X[i] := moleFractions[i]*MMX[i]/Mmix;
    end for;
    annotation (smoothOrder=5);
  end moleToMassFractions;

  function massToMoleFractions "Return mole fractions from mass fractions X"
    extends Modelica.Icons.Function;
    input SI.MassFraction X[:] "Mass fractions of mixture";
    input SI.MolarMass[:] MMX "Molar masses of components";
    output SI.MoleFraction moleFractions[size(X, 1)]
      "Mole fractions of gas mixture";
  protected 
    Real invMMX[size(X, 1)] "Inverses of molar weights";
    SI.MolarMass Mmix "Molar mass of mixture";
  algorithm 
    for i in 1:size(X, 1) loop
      invMMX[i] := 1/MMX[i];
    end for;
    Mmix := 1/(X*invMMX);
    for i in 1:size(X, 1) loop
      moleFractions[i] := Mmix*X[i]/MMX[i];
    end for;
    annotation (smoothOrder=5);
  end massToMoleFractions;

  replaceable partial function saturationPressure
    "Return saturation pressure of condensing fluid"
    extends Modelica.Icons.Function;
    input Temperature Tsat "Saturation temperature";
    output AbsolutePressure psat "Saturation pressure";
  end saturationPressure;

  replaceable partial function enthalpyOfVaporization
    "Return vaporization enthalpy of condensing fluid"
    extends Modelica.Icons.Function;
    input Temperature T "Temperature";
    output SpecificEnthalpy r0 "Vaporization enthalpy";
  end enthalpyOfVaporization;

  replaceable partial function enthalpyOfLiquid
    "Return liquid enthalpy of condensing fluid"
    extends Modelica.Icons.Function;
    input Temperature T "Temperature";
    output SpecificEnthalpy h "Liquid enthalpy";
  end enthalpyOfLiquid;

  replaceable partial function enthalpyOfGas
    "Return enthalpy of non-condensing gas mixture"
    extends Modelica.Icons.Function;
    input Temperature T "Temperature";
    input MassFraction[:] X "Vector of mass fractions";
    output SpecificEnthalpy h "Specific enthalpy";
  end enthalpyOfGas;

  replaceable partial function enthalpyOfCondensingGas
    "Return enthalpy of condensing gas (most often steam)"
    extends Modelica.Icons.Function;
    input Temperature T "Temperature";
    output SpecificEnthalpy h "Specific enthalpy";
  end enthalpyOfCondensingGas;

  replaceable partial function enthalpyOfNonCondensingGas
    "Return enthalpy of the non-condensing species"
    extends Modelica.Icons.Function;
    input Temperature T "Temperature";
    output SpecificEnthalpy h "Specific enthalpy";
  end enthalpyOfNonCondensingGas;

end MoistAir;
