within TAeZoSysPro.Aeraulic.BasesClasses;

partial model HeatExchangeurPreprocessing

parameter Modelica.SIunits.VolumeFlowRate V_flowGas = 0.0 "Volume flow rate of Gas" annotation(
    Dialog(group = "Supplier point"));
parameter Modelica.SIunits.Velocity VelGas = 0.0 "Speed of Gas" annotation(
    Dialog(group = "Supplier point"));
parameter Modelica.SIunits.PressureDifference dPGas = 0.0 "Pressure losses measured" annotation(
    Dialog(group = "Supplier point"));
parameter Modelica.SIunits.Density dGas = 0.0 "Pressure losses measured" annotation(
    Dialog(group = "Supplier point"));
//
Modelica.SIunits.Area CrossAreaGas ;
Real ksi_fixedGas ;

protected
parameter Modelica.SIunits.PressureDifference Patm = 101325 ;

equation

CrossAreaGas = V_flowGas / VelGas ;
ksi_fixedGas = 2*dPGas / (dGas * VelGas^2) ;

hae = MediumGas.enthalpyOfNonCondensingGas(Tae) + Wae * MediumGas.enthalpyOfCondensingGas(Tae) ;
WeeSat = MediumGas.k_mair * MediumGas.saturationPressure(Tee) / (mediumGasIn.p - MediumGas.saturationPressure(Tee));
hae = MediumGas.enthalpyOfNonCondensingGas(Tee) + WeeSat * MediumGas.enthalpyOfCondensingGas(Tee) ;

end HeatExchangeurPreprocessing;
