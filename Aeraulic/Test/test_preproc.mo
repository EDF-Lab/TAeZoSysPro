within TAeZoSysPro.Aeraulic.Test;

model test_preproc

parameter Modelica.SIunits.MassFlowRate m_flow_drygas = 6.4 ;
parameter Modelica.SIunits.MassFlowRate m_flow_liq = 4.2;
parameter Modelica.SIunits.Temperature Tae = 26.67 + 273.15 "Inlet temperature of air" ;
parameter Modelica.SIunits.Temperature Tee = 5.56 + 273.15 "Inlet temperature of water" ;
parameter Modelica.SIunits.MassFraction Wae = 0.0112 "Mass of water peer mass of dry air at saturation at inlet" ;
parameter Modelica.SIunits.Power P_exc = 88000 "Total power" ;
parameter Modelica.SIunits.Power P_sens = 66000 "Sensible power";
parameter Modelica.SIunits.Pressure p_Gaz_in = 101325 + 169 ;

Real KSGas(final quantity= "CoefficientOfHeatTransfer", final unit="W.kg/J") "Constant heat conductance for gas side" ;
Real KSLiq(final quantity= "CoefficientOfHeatTransfer", final unit="W.kg/J") "Constant heat conductance for liquid side" ;
Real KS_overall(final quantity= "CoefficientOfHeatTransfer", final unit="W.kg/J") "Global heat conductance" ;

equation

(KSGas, KSLiq,) = BasesClasses.HE_ThermalPreproc(m_flow_drygas, m_flow_liq, Tae, Tee, Wae, P_exc, P_sens, p_Gaz_in) ;
KS_overall = 0.0 ;
end test_preproc;
