within TAeZoSysPro.Media.Air;

package SimpleAir

  extends Modelica.Icons.VariantsPackage;
  
  import Cv = Modelica.SIunits.Conversions ;
  
  constant Modelica.Media.Interfaces.Types.TwoPhase.FluidConstants
      airConstants(
      chemicalFormula="N2+O2+Ar",
      structureFormula="N2+O2+Ar",
      casRegistryNumber="1",
      iupacName="air",
      molarMass=0.02896546,
      criticalTemperature=132.5306,
      criticalPressure=3.786e6,
      criticalMolarVolume=0.02896546/342.68,
      triplePointTemperature=63.05 "From N2",
      triplePointPressure=0.1253e5 "From N2",
      normalBoilingPoint=78.903,
      meltingPoint=0,
      acentricFactor=0.0335,
      dipoleMoment=0.0,
      hasCriticalData=true,
      hasFundamentalEquation=true,
      hasAccurateViscosityData=true,
      hasAcentricFactor=true);

extends Modelica.Media.Interfaces.PartialPureSubstance(
        mediumName="Air",
        substanceNames={"air"},
        singleState=false);

  constant SpecificHeatCapacity cp_const = 1005.45
    "Constant specific heat capacity at constant pressure";
  constant SpecificHeatCapacity cv_const=cp_const - R_gas
    "Constant specific heat capacity at constant volume";
  constant SpecificHeatCapacity R_gas = Modelica.Constants.R/0.0289651159 "Medium specific gas constant";
  constant MolarMass MM_const = 0.0289651159 "Molar mass";
  constant DynamicViscosity eta_const = 1.82e-5 "Constant dynamic viscosity";
  constant ThermalConductivity lambda_const = 0.026 "Constant thermal conductivity";
  constant Temperature T_min = Cv.from_degC(0) "Minimum temperature valid for medium model";
  constant Temperature T_max = Cv.from_degC(100) "Maximum temperature valid for medium model";
  constant Temperature T0= 293.15 "Zero enthalpy temperature NIST standard";
  constant FluidConstants[nS] fluidConstants "Fluid constants";


redeclare record extends ThermodynamicState "Thermodynamic state"
    Temperature T "Temperature";
    AbsolutePressure p "Pressure";
  end ThermodynamicState;

      
redeclare model extends BaseProperties(
        T(stateSelect=if preferredMediumStates then StateSelect.prefer else StateSelect.default),
        p(stateSelect=if preferredMediumStates then StateSelect.prefer else StateSelect.default)) "Base properties of ideal gas"
    equation
      assert(T >= T_min and T <= T_max, "
Temperature T (= " + String(T) + " K) is not
in the allowed range (" + String(T_min) + " K <= T <= " + String(T_max) + " K)
required from medium model \"" + mediumName + "\".
");
      h = specificEnthalpy_pTX(T = T) ;
      u = specificInternalEnergy_pTX(T = T) ;
      R = R_gas;
      d = density_pTX(T = T);
      MM = MM_const;
      state.T = T;
      state.p = p;
      annotation (Documentation(info="<html>
<p>
This is the most simple incompressible medium model, where
specific enthalpy h and specific internal energy u are only
a function of temperature T and all other provided medium
quantities are assumed to be constant.
</p>
</html>"));
    end BaseProperties;

  model test_BaseProperties
  
    TAeZoSysPro.Media.Air.SimpleAir.BaseProperties medium ;
  
  equation
  
    medium.p = 101325 ;
    medium.T = 293.15 ;

  end test_BaseProperties;
  
  redeclare function specificEnthalpy_pTX
    "Computes specific enthalpy as a function of pressure and temperature"
    extends Modelica.Icons.Function;
    input AbsolutePressure p = 101325 "Pressure";
    input Temperature T "Temperature";
    input MassFraction X[:] = X_default ;
    output SpecificEnthalpy h "Specific enthalpy";
    
  algorithm
  
    h := cp_const * (T - T0);
    
    annotation (
      Inline=true,
      derivative(zeroDerivative = p, zeroDerivative = X) = specificEnthalpy_pTX_der,
      inverse(T = temperature_phX(p = p, X = X, h = h)) );
    
  end specificEnthalpy_pTX;
  
  function specificEnthalpy_pTX_der
    "Computes derivative specific enthalpy with respect to temperature"
    extends Modelica.Icons.Function;
    output Real dh(final unit="J/(kg.K)") "Specific enthalpy";
    
  algorithm
  
    dh := cp_const;
    
    annotation (Inline=true) ;
    
  end specificEnthalpy_pTX_der;

  redeclare function temperature_phX
    "Computes specific enthalpy as a function of pressure and temperature"
    extends Modelica.Icons.Function;
    input AbsolutePressure p = 101325 "Pressure";
    input SpecificEnthalpy h "Specific enthalpy";
    input MassFraction X[:] = X_default ;
    output Temperature T "Temperature";
    
  algorithm
  
    T := h / cp_const + T0 ;
    
    annotation (
      Inline=true,
      inverse(h = specificEnthalpy_pTX(p = p, X = X, T = T)));
    
  end temperature_phX;
  
  function specificInternalEnergy_pTX
    "Computes specific internal energy as a function of pressure and temperature"
    extends Modelica.Icons.Function;
    input AbsolutePressure p = 101325 "Pressure";
    input Temperature T "Temperature";
    input MassFraction X[:] = X_default ;
    output SpecificInternalEnergy u "Specific internal energy";
    
  algorithm
  
    u := cv_const * (T - T0);
    
    annotation (
      Inline=true,
      derivative(zeroDerivative = p, zeroDerivative = X) = specificInternalEnergy_pTX_der );
    
  end specificInternalEnergy_pTX;

  function specificInternalEnergy_pTX_der
    "Computes derivative of specific internal energy with respect to the temperature"
    extends Modelica.Icons.Function;
    output Real du(final unit="J/(kg.K)") "Specific enthalpy";
    
  algorithm
  
    du := cv_const;
    
    annotation (Inline=true) ;
    
  end specificInternalEnergy_pTX_der;

  function density_pTX
    "Computes specific enthalpy as a function of pressure and temperature"
    extends Modelica.Icons.Function;
    input AbsolutePressure p = 101325 "Pressure";
    input Temperature T "Temperature";
    input MassFraction X[:] = X_default ;
    output Density d "Density";
    
  algorithm
  
    d := p / (R_gas * T);
    
    annotation (
      Inline=true,
      derivative = density_pTX_der );
    
  end density_pTX;

  function density_pTX_der
    "Computes specific enthalpy as a function of pressure and temperature"
    extends Modelica.Icons.Function;
    input AbsolutePressure p = 101325 "Pressure";
    input Temperature T "Temperature";
    input MassFraction X[:] = X_default ;
    input Modelica.SIunits.PressureDifference dp = 1 "Elementary pressure difference";
    input Modelica.SIunits.TemperatureDifference dT = 1 "Elementary temperature difference";
    
    output DerDensityByTemperature dd "differential of density";
    
  algorithm
  
    dd := dp / (R_gas * T) - p * dT / (R_gas * T^2);
    
    annotation (
      Inline=true );
    
  end density_pTX_der;
  
end SimpleAir;
