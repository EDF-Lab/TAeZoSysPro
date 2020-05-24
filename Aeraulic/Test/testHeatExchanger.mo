within TAeZoSysPro.Aeraulic.Test;

model testHeatExchanger
  TAeZoSysPro.Aeraulic.BasesClasses.HeatExchanger heatExchanger1(N_P_sens = 66000, N_P_tot = 88000, N_Tai = 299.82, N_Twi = 278.71, N_Wai = 0.0112, N_m_flow_da = 6.4, N_m_flow_w = 4.2)  annotation(
    Placement(visible = true, transformation(origin = {0, 2}, extent = {{-24, -24}, {24, 24}}, rotation = 0)));
  TAeZoSysPro.Aeraulic.Sources.Atmosphere atmosphere1(HR_out = 0.33, T_out = 308.15, p_out(displayUnit = "Pa") = 101325 + 169) annotation(
    Placement(visible = true, transformation(origin = {-76, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  WetExchanger.Components.Tank tank1(p_out(displayUnit = "Pa") = 101325 + 35000) annotation(
    Placement(visible = true, transformation(origin = {14, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  TAeZoSysPro.Aeraulic.Sources.Atmosphere atmosphere2(HR_out = 0.6, T_out = 296.15, p_out(displayUnit = "Pa") = 101325) annotation(
    Placement(visible = true, transformation(origin = {64, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  WetExchanger.Components.Tank tank2(T_out = 293.15, p_out(displayUnit = "Pa") = 101325) annotation(
    Placement(visible = true, transformation(origin = {-12, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(heatExchanger1.port_in_Gas, atmosphere1.Fluidport[1]) annotation(
    Line(points = {{-24, 2}, {-42, 2}, {-42, 4}, {-76, 4}}, color = {0, 127, 255}));
  connect(heatExchanger1.port_out_Gas, atmosphere2.Fluidport[1]) annotation(
    Line(points = {{24, 2}, {44, 2}, {44, 4}, {64, 4}}, color = {0, 127, 255}));
  connect(heatExchanger1.port_in_Liq, tank1.Fluidport[1]) annotation(
    Line(points = {{15, 23}, {15, 41}, {14, 41}, {14, 60}}, color = {0, 127, 255}));
  connect(heatExchanger1.port_out_Liq, tank2.Fluidport[1]) annotation(
    Line(points = {{-13, 23}, {-12, 23}, {-12, 60}}, color = {0, 127, 255}));
end testHeatExchanger;
