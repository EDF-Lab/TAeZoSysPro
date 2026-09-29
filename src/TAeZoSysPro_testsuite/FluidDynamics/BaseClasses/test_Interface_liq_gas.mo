within TAeZoSysPro_testsuite.FluidDynamics.BaseClasses;

model test_Interface_liq_gas

  model LiquidNode_simulated

    parameter Modelica.SIunits.Temperature T = 273.15 + 90;
    parameter Modelica.SIunits.Pressure p = 101325;
    Modelica.Fluid.Interfaces.FluidPort_b port_liquidNode(redeclare package Medium = Modelica.Media.Water.WaterIF97_ph)
      annotation (
        Placement(visible = true, transformation(origin = {2, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {2, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  equation

    port_liquidNode.h_outflow = Modelica.Media.Water.WaterIF97_pT.specificEnthalpy_pT(p = p, T = T);

  end LiquidNode_simulated;

  TAeZoSysPro.FluidDynamics.BasesClasses.Interface_liq_gas interFace_liq_gas(A = 1)
    annotation (
      Placement(visible = true, transformation(origin = {-3.55271e-15, 3.33067e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature T_interface(T(displayUnit = "K") = 378.15)
    annotation (
      Placement(visible = true, transformation(origin = {-70, -52}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  TAeZoSysPro.FluidDynamics.Sources.Atmosphere atmosphere
    annotation (
      Placement(visible = true, transformation(origin = {-40, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant F_view(k = 1)
    annotation (
      Placement(visible = true, transformation(origin = {50, 30}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  LiquidNode_simulated liquidNode_simulated(T = T_interface.T, p = atmosphere.p)
    annotation (
      Placement(visible = true, transformation(origin = {50, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation

  //  port_liquidNode.h_outflow = Modelica.Media.Water.WaterIF97_ph.specificEnthalpy_pT(
  //    p =interFace_liq_gas.p,
  //    T = 273.15+90);
  //  port_liquidNode.Xi_outflow = Modelica.Media.Water.WaterIF97_ph.X_default[1:Modelica.Media.Water.WaterIF97_ph.nXi];
  //  port_liquidNode.C_outflow = Modelica.Media.Water.WaterIF97_ph.C_default;
  connect(T_interface.port, interFace_liq_gas.heatPort_a)
    annotation (
      Line(points = {{-60, -52}, {-12, -52}, {-12, -18}, {-12, -18}}, color = {191, 0, 0}));
  connect(atmosphere.Heatport, interFace_liq_gas.port_rad)
    annotation (
      Line(points = {{-40, 52}, {-14, 52}, {-14, 18}, {-14, 18}}, color = {191, 0, 0}));
  connect(atmosphere.Flowport, interFace_liq_gas.flowPort_b)
    annotation (
      Line(points = {{-40, 60}, {14, 60}, {14, 18}, {14, 18}}, color = {0, 85, 255}));
  connect(F_view.y, interFace_liq_gas.F_view)
    annotation (
      Line(points = {{40, 30}, {-2, 30}, {-2, 18}, {-2, 18}}, color = {0, 0, 127}));
  connect(liquidNode_simulated.port_liquidNode, interFace_liq_gas.fluidPort_a)
    annotation (
      Line(points = {{50, -50}, {12, -50}, {12, -18}, {12, -18}}, color = {0, 127, 255}));

  annotation (
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-6, Interval = 0.002));

end test_Interface_liq_gas;
