within TAeZoSysPro.Media.Air;

package Air_H2
  extends Modelica.Media.Interfaces.PartialMixtureMedium(
    mediumName="Air_H2",
    substanceNames={"dihydrogen","air"},
    final reducedX=true,
    final singleState=false,
    reference_X={0.001,0.999},
    reference_T = 293.15,
    Temperature(min=190, max=647),
    ThermoStates=Modelica.Media.Interfaces.Choices.IndependentVariables.pTX);

  constant Integer H2=1
    "Index of dihydrogen (in substanceNames, massFractions X, etc.)";
  constant Integer Air=2
    "Index of air (in substanceNames, massFractions X, etc.)";
  constant Real k_mair=dihydrogen.MM/dryair.MM "Ratio of molar weights";

  record dryair
    constant Modelica.SIunits.SpecificHeatCapacityAtConstantPressure cp = 1005 "cp(p_ref, T_ref)";
    constant Modelica.SIunits.MolarMass MM = Modelica.Media.IdealGases.Common.SingleGasesData.Air;
    constant Real R(final unit="J/(kg.K)") = Modelica.Constants.R / MM;
    constant Modelica.SIunits.DynamicViscosity eta = 1.8e-5 "eta(p_ref, T_ref)";
  end dryair;

  record dihydrogen
    constant Modelica.SIunits.SpecificHeatCapacityAtConstantPressure cp = 14287 "cp(p_ref, T_ref)";
    constant Modelica.SIunits.MolarMass MM = Modelica.Media.IdealGases.Common.SingleGasesData.H2; 
    constant Real R(final unit="J/(kg.K)") = Modelica.Constants.R / MM;
    constant Modelica.SIunits.DynamicViscosity eta = 8.8e-5 "eta(p_ref, T_ref)";
    constant Modelica.SIunits.ThermalConductivity lambda = 1.8248 "lambda(p_ref, T_ref)";
  end dihydrogen;
  
  redeclare replaceable model extends BaseProperties(
    preferredMediumStates=true,
    T(stateSelect=if preferredMediumStates then StateSelect.prefer else
          StateSelect.default),
    p(stateSelect=if preferredMediumStates then StateSelect.prefer else
          StateSelect.default),
    Xi(each stateSelect=if preferredMediumStates then StateSelect.prefer
           else StateSelect.default),
    final standardOrderComponents=true) "Moist air base properties record"

    /* p, T, X = X[Water] are used as preferred states, since only then all
     other quantities can be computed in a recursive sequence.
     If other variables are selected as states, static state selection
     is no longer possible and non-linear algebraic equations occur.
      */
  equation
    h = specificEnthalpy_pTX(
      p,
      T,
      X);
    u = h - R*T;
    R = H2.R*Xi[H2] + dryair.R*(1-Xi[H2]);
    d = p/(R*T);
    MM = Modelica.Constants.R/R;
    state.p = p;
    state.T = T;
    state.X = X;
  end BaseProperties;
  
  redeclare function extends gasConstant
  algorithm
    R := dihydrogen.R*state.X[H2] + dryair.R*(1-state.X[H2]);
  end gasConstant ;
  
  function gasConstant_X
    extends Modelica.Icons.Function;
    input Modelica.SIunits.MassFraction X[:];
    output Real R(final unit="J/(kg.K)");
  algorithm
    R := dihydrogen.R*X[H2] + dryair.R*(1-state.X[H2]);
  end gasConstant_X ;
  
  redeclare function extends setState_pTX
  algorithm
      state.p := p;
      state.T := T;  
    if size(X, 1) == nX then
      state.X := X;
    else
      state.X := cat(1, X, {1.0-sum(X)});       
    end if ;
  end setState_pTX;
  
  redeclare function extends setState_phX
  algorithm
    state.p := p;
    state.T := Temperature_hX(h=h, X=X); 
    if size(X, 1) == nX then
      state.X := X;
    else
      state.X := cat(1, X, {1.0-sum(X)});       
    end if ;
  end setState_phX;
  
  redeclare function extends setState_dTX
  algorithm
    state.p := pressure_dTX(d=d, T=T, X=X);
    state.T := T; 
    if size(X, 1) == nX then
      state.X := X;
    else
      state.X := cat(1, X, {1.0-sum(X)});       
    end if ;
  end setState_dTX;
  
  redeclare function extends dynamicViscosity
  protected
    Modelica.SIunits.MoleFraction Y[nX];
  algorithm
    Y := massToMoleFractions(X=state.X, MMX={dihydrogen.MM, dryair.MM});
    eta := dihydrogen.eta * Y[H2] + dryair.eta * (1-Y[H2]);
  end dynamicViscosity ;

  redeclare function extends thermalConductivity
  protected
    Modelica.SIunits.MoleFraction Y[nX];
  algorithm
    Y := massToMoleFractions(X=state.X, MMX={dihydrogen.MM, dryair.MM});
    lambda := dihydrogen.lambda * Y[H2] + dryair.lambda * (1-Y[H2]);
  end thermalConductivity;
  
  redeclare function extends pressure
  algorithm
    p := state.p;
  end pressure;
  
  redeclare function extends temperature
  algorithm
    T := state.T;
  end temperature;
  
  redeclare function extends density
  algorithm
    d := pressure(state) / (gasConstant(state.X)*temperature(state));
  end density;
  
  redeclare function extends specificEnthalpy
  algorithm
    h := (state.X[H2]*dihydrogen.cp+(1-state.X[H2])*dryair.cp) * (temperature(state)-reference_T) ;
  end specificEnthalpy;
  
  redeclare function extends specificInternalEnergy
  algorithm
    u := specificEnthalpy(state) - gasConstant(state)*temperature(state) ;
  end specificInternalEnergy;
  
  redeclare function extends specificHeatCapacityCp
  algorithm
    cp := state.X[H2]*dihydrogen.cp + (1.0-state.X[H2])*dryair.cp   ;
  end specificHeatCapacityCp;
  
  redeclare function extends specificHeatCapacityCv
  algorithm
    cv := state.X[H2]*(dihydrogen.cp-dihydrogen.R) + (1.0-state.X[H2])*(dryair.cp-dryair.R)   ;
  end specificHeatCapacityCv;

  redeclare function extends isentropicExponent
  algorithm
    gamma := specificHeatCapacityCp(state) / specificHeatCapacityCv(state)   ;
  end isentropicExponent;
  
  redeclare function extends VelocityOfSound
  algorithm
    a := sqrt(isentropicExponent(state)*gasConstant(state)*temperature(state))   ;
  end VelocityOfSound;
  
  redeclare function extends isobaricExpansionCoefficient
  algorithm
    beta := 1/temperature(state);
  end isobaricExpansionCoefficient;
  
  redeclare function extends isothermalCompressibility
  algorithm
    beta := 1/pressure(state);
  end isothermalCompressibility; 
  
  redeclare function extends density_derp_T
  algorithm
    ddpT := 1/(gasConstant(state)*temperature(state));
  end density_derp_T;
  
  redeclare function extends density_derT_p
  algorithm
    ddpT := -density(state)/temperature(state);
  end density_derT_p;    

  redeclare function extends density_derX
  algorithm
    dddX[Water] := - pressure(state)/temperature(state) * (dihydrogen.R - dryair.R)/(((dihydrogen.R - dryair.R)
      *state.X[Water] + dryair.R)^2);
    dddX[Air] := - pressure(state)/temperature(state) * (dryair.R - dihydrogen.R)/((dihydrogen.R + (dryair.R - dihydrogen.R)*
      state.X[Air])^2);
  end density_derX;
  
  redeclare function extends MolarMass
  algorithm
    MM := Modelica.Constants.R/gasConstant(state);
  end MolarMass;
  
  function temperature_hX
    input Modelica.SIunits.SpecificEnthalpy h;
    input Modelica.SIunits.MassFraction X[:];
    output Modelica.SIunits.Temperature T;
  algorithm
    T := h / (X[H2] * dihydrogen.cp + (1-X[H2])*dryair.cp) + reference_T ;
  end temperature_hX;
  
  function pressure_dTX
    input Modelica.SIunits.Density d;
    input Modelica.SIunits.Temperature T;
    input Modelica.SIunits.MassFraction X[:];
    output Modelica.SIunits.Pressure p;
  algorithm
    p := d * gasConstant_X(X) * T ;
  end pressure_dTX;
  
  redeclare function extends specificEnthalpy_pTX
    input Modelica.SIunits.Pressure p = reference_p;
    input Modelica.SIunits.Temperature T;
    input Modelica.SIunits.MassFraction X[:];
    output Modelica.SIunits.SpecificEnthalpy h;
  algorithm
    h := (dihydrogen.cp*X[H2] + dryair.cp*(1-X[H2]))*(T-reference_T);
  end specificEnthalpy_pTX;  
  
end Air_H2;
