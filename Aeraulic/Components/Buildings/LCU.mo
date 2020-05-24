within TAeZoSysPro.Aeraulic.Components.Buildings;

model LCU
  //Medias
  replaceable package Medium = Media.MyMedia;
  replaceable package Mediumda = HeatTransfer.Media.MyMedia;
  // parameters
  parameter Boolean K_fixed = true "Fixed global heat exchange coefficient";
  parameter TAeZoSysPro.HeatTransfer.Types.ExchangerType ExchangeMode = TAeZoSysPro.HeatTransfer.Types.ExchangerType.CounterFlow "Heat exchanger type";
  parameter Integer ExchangerMethod = 1 "1 for NUT method. 2 for LMTD";
  parameter Boolean FanBeforeCoolingCoil = false "fan position : upstream or downstream the cooling coil";
  //
  parameter Modelica.SIunits.Temperature Twater_in = 273.15 "inlet temperature of water";
  //
  parameter Modelica.SIunits.Area Aexchanger = 0 "Exchanger Area";
  parameter Modelica.SIunits.Area Ainlet = 0 "Air inlet cross section";
  parameter Modelica.SIunits.Length Dp = 0 "Water Pipe diameter exchanger";
  //
  parameter Modelica.SIunits.CoefficientOfHeatTransfer Kref = 0 "Global heat transfer coefficient at sizing point" annotation(
    Dialog(group = "manufacturer's data"));
  parameter Modelica.SIunits.VolumeFlowRate QvAir_ref = 0 "Air inlet flow at sizing point" annotation(
    Dialog(group = "manufacturer's data"));
  parameter Modelica.SIunits.Temperature MeanTref = 273.15 "mean inlet/outlet temperature at sizing point" annotation(
    Dialog(group = "manufacturer's data"));
  parameter Modelica.SIunits.CoefficientOfHeatTransfer h = Kref "heat transfer coefficient";
  //
  parameter Modelica.SIunits.Power FanAeraulicPower = 0 "power (electrical or aeraulic) from fan given to gas";
  // Internal variables
  Real NTU "Number of Exchanger Heat Transfer Units (NTU)";
  Real Cr "Ration of thermal condutance";
  Modelica.SIunits.Efficiency Eff "Exchanger effectiveness";
  Modelica.SIunits.SpecificHeatCapacity CpGas "Specific heat capacity of gas";
  Modelica.SIunits.SpecificHeatCapacity CpLiquid "Specific heat capacity of gas";
  Modelica.SIunits.ThermalConductance QcGas "Fluid thermal conductance of gas";
  Modelica.SIunits.ThermalConductance QcLiquid "Fluid thermal conductance of liquid";
  Modelica.SIunits.Temperature Tair_in "Inlet gas temperature";
  Modelica.SIunits.Temperature Tair_out "Outlet gas temperature";
  Modelica.SIunits.Temperature Tair_exchanger_out "after exchanger gas temperature ";
  Modelica.SIunits.Temperature Twater_out "Outlet gas temperature";
  Modelica.SIunits.Temperature DeltaT1 "Temperature difference for LMTD calculation";
  Modelica.SIunits.Temperature DeltaT2 "Temperature difference for LMTD calculation";
  Modelica.SIunits.Temperature DeltaTm "Temperature difference for LMTD calculation";
  Modelica.SIunits.EnergyFlowRate Q_flow_max "Maximal power exchangeable in always counter flow";
  Modelica.SIunits.Power Pexchanged "Power exchanged from exchanger";
  Modelica.SIunits.Power P_LCU "Power between inlet and outlet LCU";
  Modelica.SIunits.CoefficientOfHeatTransfer K;
  Modelica.SIunits.CoefficientOfHeatTransfer hcv_int "Air heat transfer coefficient";
  // Imported Components
  Modelica.Blocks.Interfaces.RealInput Qair annotation(
    Placement(visible = true, transformation(origin = {-96, 78}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-102, -82}, extent = {{-18, -18}, {18, 18}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput Qwater annotation(
    Placement(visible = true, transformation(origin = {-92, -14}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-102, 82}, extent = {{-18, -18}, {18, 18}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput Qmair annotation(
    Placement(visible = true, transformation(origin = {58, 12}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {102, -82}, extent = {{-18, -18}, {18, 18}}, rotation = 0)));
  TAeZoSysPro.Aeraulic.Interfaces.FlowPort_a port_a(replaceable package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {0, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, -88}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  TAeZoSysPro.Aeraulic.Interfaces.FlowPort_b port_b(replaceable package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-1, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, 96}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
protected
  Modelica.SIunits.DynamicViscosity muAir "dynamic viscosity of air";
  Modelica.SIunits.DynamicViscosity muAir_ref "dynamic viscosity of air at sizing point";
  Modelica.SIunits.Density dAir "density of air";
  Modelica.SIunits.Density dFan "density of air at fan inlet";
  Modelica.SIunits.ThermalConductivity kAir "Thermal conductivity of air";
  Modelica.SIunits.ThermalConductivity kAir_ref "Thermal conductivity of air at sizing point";
  Modelica.SIunits.CoefficientOfHeatTransfer href;
equation
// Thermodynamic properties calculation
  CpGas = 1005;
  CpLiquid = 4199;
  muAir = 1.85e-5;
  muAir_ref = 1.85e-5;
  dAir = 1.177;
  kAir = 0.0262;
  kAir_ref = 0.0262;
/*The fan works at constant volume flow rate.
The mass flow rate has to be calculated with the density at the fan inlet */
  dFan = 1.177;
/*MediumGas.density_pT(p = MediumGas.reference_p, T = if FanBeforeCoolingCoil then port_a1.T else Tair_exchanger_out)*/
// Thermal conductance
  QcGas = Qair * dFan * CpGas;
  QcLiquid = Qwater * 1000 * CpLiquid;
// Heat exchange coefficient
  href = TAeZoSysPro.HeatTransfer.Functions.ForcedConvection.ASHRAE_Ext_Cyl(caraclength = Dp, Velocity = QvAir_ref / Ainlet, kinViscosity = muAir_ref / (Medium.reference_p / (287 * MeanTref)), kair = kAir_ref, pr = muAir_ref * CpGas / kAir_ref);
  hcv_int = TAeZoSysPro.HeatTransfer.Functions.ForcedConvection.ASHRAE_Ext_Cyl(caraclength = Dp, Velocity = Qair / Ainlet, kinViscosity = muAir / dAir, kair = kAir, pr = muAir * CpGas / kAir);
  1 / K = if K_fixed == true then 1 / h else 1 / Kref - 1 / href + 1 / hcv_int;
//
  Cr = min(QcGas, QcLiquid) / max(QcGas, QcLiquid);
  NTU = K * Aexchanger / min(QcGas, QcLiquid);
  Q_flow_max = min(QcGas, QcLiquid) * (Tair_in - Twater_in);
// Check to verify that the user has chosen either 1 or 2 for ExchangerMethod
  assert(ExchangerMethod < 3, "user has chosen wrong exchanger method", AssertionLevel.error);
// NTU method :
  if ExchangerMethod == 1 then
// set all variables for LMTD method to 0
    DeltaT1 = 0.0;
    DeltaT2 = 0.0;
    DeltaTm = 0.0;
    if ExchangeMode == TAeZoSysPro.HeatTransfer.Types.ExchangerType.CounterFlow then
      if Cr == 1.0 then
        Eff = NTU / (1 + NTU);
      else
        Eff = (1 - exp(-NTU * (1 - Cr))) / (1 - Cr * exp(-NTU * (1 - Cr)));
      end if;
    elseif ExchangeMode == TAeZoSysPro.HeatTransfer.Types.ExchangerType.ParallelFlow then
      Eff = (1 - exp(-NTU * (1 - Cr))) / (1 + Cr);
    else
      Eff = 0;
    end if;
  elseif ExchangerMethod == 2 then
// set all variables for NTU method to 0
    Eff = 0.0;
    if ExchangeMode == TAeZoSysPro.HeatTransfer.Types.ExchangerType.CounterFlow then
      DeltaT1 = Tair_in - Twater_out;
      DeltaT2 = Tair_out - Twater_in;
    elseif ExchangeMode == TAeZoSysPro.HeatTransfer.Types.ExchangerType.ParallelFlow then
      DeltaT1 = Tair_in - Twater_in;
      DeltaT2 = Tair_out - Twater_out;
    else
// User must have declared HvacMod in a wrong way, counter flow heat excahnger is used
      DeltaT1 = Tair_in - Twater_out;
      DeltaT2 = Tair_out - Twater_in;
    end if;
    DeltaTm = Modelica.Fluid.Utilities.regStep(x = min(DeltaT1, DeltaT2) - 1e-5, y1 = (DeltaT1 - DeltaT2) / log(DeltaT1 / DeltaT2), y2 = 0, x_small = 5e-6);
  else
// set all variables  to 0
    DeltaT1 = 0.0;
    DeltaT2 = 0.0;
    DeltaTm = 0.0;
    Eff = 0.0;
    assert(ExchangerMethod < 3, "user has chosen wrong exchanger method", AssertionLevel.error);
  end if;
  Pexchanged = if ExchangerMethod == 1 then Eff * Q_flow_max elseif ExchangerMethod == 2 then K * Aexchanger * DeltaTm else 0;
  QcGas * (Tair_in - Tair_exchanger_out) = Pexchanged;
  Pexchanged + QcLiquid * (Twater_in - Twater_out) = 0;
  if FanBeforeCoolingCoil == true then
    FanAeraulicPower = QcGas * (Tair_in - port_a.T) "The fan is situated after the exchanger";
    Tair_out = Tair_exchanger_out;
  else
    FanAeraulicPower = QcGas * (Tair_out - Tair_exchanger_out) "The fan is situated after the exchanger";
    Tair_in = port_a.T;
  end if;
  P_LCU = FanAeraulicPower - Pexchanged;
// port balance
  Qmair = Qair * dFan;
  port_a.m_flow = Qmair * 1 / sum(port_a.di) * port_a.di;
  port_a.m_flow + port_b.m_flow = fill(0, Medium.nX);
  port_a.H_flow = Qmair * port_a.h;
  port_a.H_flow + port_b.H_flow + P_LCU = 0;
  annotation(
    uses(Modelica(version = "3.2.2")),
    Diagram(coordinateSystem(grid = {1, 2}, initialScale = 0.1)),
    Icon(graphics = {Rectangle(origin = {0, 2}, fillColor = {255, 170, 127}, fillPattern = FillPattern.Solid, extent = {{-60, 40}, {60, -40}}), Rectangle(origin = {0, 2}, fillColor = {255, 170, 0}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-80, 20}, {80, -20}}), Rectangle(origin = {49, 52}, fillColor = {255, 170, 127}, fillPattern = FillPattern.Solid, extent = {{-11, 10}, {11, -10}}), Rectangle(origin = {-49, -48}, fillColor = {255, 170, 127}, fillPattern = FillPattern.Solid, extent = {{-11, 10}, {11, -10}}), Line(origin = {90, 12}, rotation = 180, points = {{-6, 0}, {6, 0}}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Rectangle(origin = {7, 58}, fillColor = {238, 238, 238}, extent = {{-81, -4}, {65, -108}}), Text(origin = {-44, 67}, lineThickness = 1, extent = {{22, -7}, {-58, 9}}, textString = "Qwater m3/s",  fontSize = 0 ), Text(origin = {-48, -67}, lineThickness = 1, extent = {{10, -7}, {-58, 9}}, textString = "Qair m3/s",  fontSize = 0 ), Line(origin = {-50, -48}, points = {{0, -6}, {0, 6}}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {0, -28}, points = {{-25, 0}, {25, 0}}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {-1, 32}, points = {{-25, 0}, {25, 0}}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {48, 53}, points = {{0, -5}, {0, 5}}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {-1, 12}, rotation = 180, points = {{-25, 0}, {25, 0}}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {-90, 14}, rotation = 180, points = {{-6, 0}, {6, 0}}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {-90, -8}, points = {{-6, 0}, {6, 0}}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {90, -8}, points = {{-6, 0}, {6, 0}}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {-1, -8}, points = {{-25, 0}, {25, 0}}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}), Text(origin = {72, -69}, lineThickness = 1, extent = {{12, -9}, {-58, 9}}, textString = "Qmair kg/s",  fontSize = 0 )}, coordinateSystem(initialScale = 0.1)));
end LCU;
