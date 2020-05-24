within TAeZoSysPro.Aeraulic.BasesClasses;

function HE_ThermalPreproc
//
  replaceable package Medium = TAeZoSysPro.Aeraulic.Media.MyMedia;
  //
  input Modelica.SIunits.MassFlowRate m_flow_drygas ;
  input Modelica.SIunits.MassFlowRate m_flow_liq ;
  input Modelica.SIunits.Temperature Tae "Inlet temperature of air" ;
  input Modelica.SIunits.Temperature Tee "Inlet temperature of water" ;
  input Modelica.SIunits.MassFraction Wae "Mass of water peer mass of dry air at saturation at inlet" ;
  input Modelica.SIunits.Power P_exc "Total power" ;
  input Modelica.SIunits.Power P_sens "Sensible power";
  input Modelica.SIunits.Pressure p_Gaz_in ;
  //
  output Real KSGas(final quantity= "CoefficientOfHeatTransfer", final unit="W.kg/J") "Constant heat conductance for gas side" ;
  output Real KSLiq(final quantity= "CoefficientOfHeatTransfer", final unit="W.kg/J") "Constant heat conductance for liquid side" ;
  output Modelica.SIunits.VolumeFlowRate Qva ;
  
  protected
  //Internal variables
  Modelica.SIunits.Temperature Tas "Outlet temperature of air" ;
  Modelica.SIunits.Temperature Tms "dewpoint temperature" ;
  Modelica.SIunits.Temperature Tr "Condensated film temperature" ;
  
  Modelica.SIunits.Enthalpy LMHD "Mean logarithmic enthalpy" ;
  //
  Modelica.SIunits.MassFraction Was "Mass of water peer mass of dry air at saturation at outlet" ;
  Modelica.SIunits.MassFraction WeeSat "Mass of water peer mass of dry air at saturation at inlet water temperature" ;
  Modelica.SIunits.MassFraction Wms "" ;
  //
  Modelica.SIunits.SpecificEnthalpy hae "specific enthalpy of moist air peer mass of dry air at gas inlet" ;
  Modelica.SIunits.SpecificEnthalpy has "specific enthalpy of moist air peer mass of dry air at gas outlet" ;
  Modelica.SIunits.SpecificEnthalpy heeSat "fictive specific enthalpy of moist air at inlet water temperature" ;
  Modelica.SIunits.SpecificEnthalpy hr "dewpoint specific enthalpy" ;
  Modelica.SIunits.SpecificEnthalpy hesSat "specific enthalpy of condensated film" ;
  Modelica.SIunits.SpecificEnthalpy hlat ;
  Modelica.SIunits.SpecificEnthalpy hms ;
//
  Modelica.SIunits.Power P_lat "Latent power" ;
  //
  Modelica.SIunits.Pressure Pae ;
  Modelica.SIunits.Pressure Pve ;
  Modelica.SIunits.Pressure Pas ;
  Modelica.SIunits.Pressure Pms ;
//
  Modelica.SIunits.Density da "density of dry air" ;
//
  Modelica.SIunits.SpecificHeatCapacity cp_air, cp_eau, cp_vap, cp_sat ;
//
  Modelica.SIunits.Efficiency EffInf ;
//
  Real KS_overall(final quantity= "CoefficientOfHeatTransfer", final unit="W.kg/J") "Constant heat conductance for liquid side" ;

//
  Real c1, c2, c3, c4, c5, delta ;
   
algorithm

//
cp_air := 1005;
cp_eau := 3800 ;
cp_vap := 1830 ;

// coefficient for saturation curve fitting
c1 := 2.401 ;
c2 := 35.537 ;
c3 := 638.3347 ;

/***** if statement to check is a condensable species is modelled *****/
  if Medium.mediumName == "MoistAir" then
    //
    da := p_Gaz_in * Medium.MMX[Medium.Water] / (Modelica.Constants.R * Tae) / (Medium.k_mair + Wae) ;
    Qva := m_flow_drygas / da ;
    //Calculation of air and fictive water properties
    hae := Medium.enthalpyOfNonCondensingGas(Tae) + Wae * Medium.enthalpyOfCondensingGas(Tae) ;
    WeeSat := Medium.k_mair * Medium.saturationPressure(Tee) / (p_Gaz_in - Medium.saturationPressure(Tee)) ;
    heeSat := Medium.enthalpyOfNonCondensingGas(Tee) + WeeSat * Medium.enthalpyOfCondensingGas(Tee) ;
    
    //
    has := hae - P_exc / m_flow_drygas ;
    P_lat := P_exc - P_sens ;
    hlat := hae - P_lat / m_flow_drygas ;
    Was := (hlat - Medium.enthalpyOfNonCondensingGas(Tae)) / Medium.enthalpyOfCondensingGas(Tae) ;
//    //has := Medium.enthalpyOfNonCondensingGas(Tas) + WeeSat * Medium.enthalpyOfCondensingGas(Tas) ;
    Tas := (has - Was*Medium.liquidWater.LHea) / (cp_air + Was * cp_vap) + 273.15 ;
    
    Pve := p_Gaz_in * Wae / (Medium.k_mair + Wae) ;
    Tr := Medium.saturationTemperature(Pve) ;
    hr := Medium.enthalpyOfNonCondensingGas(Tr) + Wae * Medium.enthalpyOfCondensingGas(Tr);
    cp_sat := (hr - heeSat) / (Tr - Tee);
    hesSat := heeSat + cp_sat / cp_eau / m_flow_liq * P_exc ;
    LMHD := ((hae - hesSat) - (has-heeSat)) / log( (hae - hesSat) / (has-heeSat) ) ;
    KS_overall := P_exc / LMHD ;
    
    
    Pae := p_Gaz_in * Wae / (Medium.k_mair + Wae) ;
    Pas := p_Gaz_in * Was / (Medium.k_mair + Was) ;
    c4 := (Pae - Pas) / (Tae - Tas) ;
    c5 := Pae - c4*(Tae-273.15) ;
    delta := (c2 - c4)^2 - 4 * c1 * (c3 - c5) ;
    if delta > 1e-15 then
        Tms := (-(c2-c4)+delta^0.5)/(2*c1) + 273.15 ;
        Pms := c4 * (Tms-273.15) + c5 ;
        Wms := Medium.k_mair * Pms / (p_Gaz_in - Pms) ;
        hms := Medium.enthalpyOfNonCondensingGas(Tms) + Wms * Medium.enthalpyOfCondensingGas(Tms) ;
        EffInf := (hae - has) / (hae - hms) ;
        KSGas := - m_flow_drygas * (cp_air + Wae * cp_vap) * log(1-EffInf) ;
        KSLiq := cp_sat / (1/KS_overall - (cp_air + Wae * cp_vap)/KSGas) ;
    else
        Tms := 0.0 ;
        Pms := 0.0 ;
        Wms := 0.0 ;
        hms := 0.0 ;
        EffInf := 0.0 ;
        KSGas := 0.0 ;
        KSLiq := 0.0 ;
        assert(true, "no condensation can occur", level = AssertionLevel.error);
    
    end if ;

else

    assert(true, "current media not model in the heat exchanger", level = AssertionLevel.error);

end if;


  annotation(
    Diagram(coordinateSystem(initialScale = 0.1)),
    Icon(coordinateSystem(initialScale = 0.1)));

end HE_ThermalPreproc;
