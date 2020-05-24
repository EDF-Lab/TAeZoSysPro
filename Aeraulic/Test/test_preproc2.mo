within TAeZoSysPro.Aeraulic.Test;

model test_preproc2
  TAeZoSysPro.Aeraulic.BasesClasses.Prepross prepross1(m_flow_drygas = 6.4, m_flow_liq = 4.2, Tae = 26.67 + 273.15, Tee = 5.56 + 273.15, Wae = 0.0112, P_exc = 88000, P_sens = 66000, p_Gaz_in = 101325 + 169 ) annotation(
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
end test_preproc2;
