within TAeZoSysPro.HeatTransfer.BasesClasses;

model HeatExchanger
  type NumericalMethod = enumeration(NTU, LMTD);
  type FluidModels = enumeration(Air, Water);
  parameter Types.ExchangerType exchangerType = Types.ExchangerType.CounterFlow;
  parameter NumericalMethod numericalMethod = NumericalMethod.NTU;
  parameter FluidModels FluidA = FluidModels.Air ;
  parameter FluidModels FluidB = FluidModels.Water ;
  //
  parameter Modelica.SIunits.Area A = 1.0 "equivalent exchange surface";
  //Internal variables
  Real NTU "Number of transfer unit";
  Real Cr "Ration of thermal condutance";
  Modelica.SIunits.Efficiency Eff "Exchanger effectiveness";
  Modelica.SIunits.ThermalConductance QcFluidA "thermal flow rate unit";
  Modelica.SIunits.ThermalConductance QcFluidB "thermal flow rate unit";
  Modelica.SIunits.TemperatureDifference LMTD "mean temperature difference";
  Modelica.SIunits.TemperatureDifference dTA, dTB "temperature difference";
  Modelica.SIunits.Temperature TA_in, TA_out, TB_in, TB_out;
  Modelica.SIunits.Power Pex "exchanged power";
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_in_FluidA annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port_out_FluidA annotation(
    Placement(visible = true, transformation(origin = {102, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_in_FluidB annotation(
    Placement(visible = true, transformation(origin = {-68, 88}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-68, 88}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port_out_FluidB annotation(
    Placement(visible = true, transformation(origin = {66, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {66, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput Qv_fluidB annotation(
    Placement(visible = true, transformation(origin = {-68, 64}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {-80, 64}, extent = {{-14, -14}, {14, 14}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput Qv_fluidA annotation(
    Placement(visible = true, transformation(origin = {-68, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-80, -64}, extent = {{-14, -14}, {14, 14}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput K_overall "Global heat transfer coeffcient" annotation(
    Placement(visible = true, transformation(origin = {6, -76}, extent = {{-20, -20}, {20, 20}}, rotation = 90), iconTransformation(origin = {84, 64}, extent = {{14, -14}, {-14, 14}}, rotation = 0)));
equation
// Shorter variables
  TA_in = port_in_FluidA.T;
  TB_in = port_in_FluidB.T ;
//
  dTA = TA_in - TA_out;
  dTB = TB_in - TB_out ;
// thermal flow rate
  if FluidA == FluidModels.Air then
    QcFluidA = Qv_fluidA * 1.2 * 1005;
  else
    QcFluidA = Qv_fluidA * 1000 * 4180;
  end if;
if FluidB == FluidModels.Air then 
  QcFluidB = Qv_fluidB * 1.2 * 1005 ;
else
  QcFluidB = Qv_fluidB * 1000 * 4180 ;
end if;
// exchange balance
  Cr = min(QcFluidA, QcFluidB) / max(QcFluidA, QcFluidB);
  if Qv_fluidA < 1e4 * Modelica.Constants.small or Qv_fluidB < 1e4 * Modelica.Constants.small then
// loop to manage the zero flow
    NTU = 0.0;
    Eff = 0.0;
    LMTD = 0.0;
    Pex = 0.0;
    if Qv_fluidA < 1e4 * Modelica.Constants.small and Qv_fluidA < 1e4 * Modelica.Constants.small then
      TA_out = TA_in;
      TB_out = TB_in;
    elseif Qv_fluidB < 1e4 * Modelica.Constants.small then
      TB_out = TA_in;
      TA_out = TA_in;
    else
      TA_out = TB_in;
      TB_out = TB_in;
    end if;
  else
    NTU = K_overall * A / min(QcFluidA, QcFluidB);
//
    if numericalMethod == NumericalMethod.NTU then
      if exchangerType == Types.ExchangerType.CounterFlow then
        Eff = TAeZoSysPro.Aeraulic.Functions.regStep(x = abs(Cr - 1.0) - 0.1, y1 = (1 - exp(-NTU * (1 - Cr))) / (1 - Cr * exp(-NTU * (1 - Cr))), y2 = NTU / (1 + NTU), x_small = 0.05);
      elseif exchangerType == Types.ExchangerType.ParallelFlow then
        Eff = (1 - exp(-NTU * (1 - Cr))) / (1 + Cr);
      end if;
      LMTD = (max([TA_in, TA_out, TB_in, TB_out]) - min([TA_in, TA_out, TB_in, TB_out])) * Eff / NTU;
      Pex = Eff * min(QcFluidA, QcFluidB) * (max([TA_in, TA_out, TB_in, TB_out]) - min([TA_in, TA_out, TB_in, TB_out]));
    elseif numericalMethod == NumericalMethod.LMTD then
      if exchangerType == Types.ExchangerType.CounterFlow then
        if TA_in > TB_in then
          LMTD = TAeZoSysPro.Aeraulic.Functions.regStep(x = abs(Cr - 1.0) - 0.1, y1 = (TA_in - TB_out - (TA_out - TB_in)) / ln((TA_in - TB_out) / (TA_out - TB_in)), y2 = TA_in - TA_out, x_small = 0.05);
        else
          LMTD = TAeZoSysPro.Aeraulic.Functions.regStep(x = abs(Cr - 1.0) - 0.1, y1 = (TB_in - TA_out - (TB_out - TA_in)) / ln((TB_in - TA_out) / (TB_out - TA_in)), y2 = TB_in - TB_out, x_small = 0.05);
        end if;
      elseif exchangerType == Types.ExchangerType.ParallelFlow then
        if TA_in > TB_in then
          LMTD = (TA_in - TB_in - (TA_out - TB_out)) / ln((TA_in - TB_in) / (TA_out - TB_out));
        else
          LMTD = (TB_in - TA_in - (TB_out - TA_out)) / ln((TB_in - TA_in) / (TB_out - TA_out));
        end if;
        NTU = (max([TA_in, TA_out, TB_in, TB_out]) - min([TA_in, TA_out, TB_in, TB_out])) * Eff / LMTD;
        Pex = K_overall * A * LMTD;
      end if;
    end if;
    if TA_in > TB_in then
      Pex = QcFluidA * (TA_in - TA_out);
    else
      Pex = QcFluidB * (TB_in - TB_out);
    end if;
    QcFluidA * dTA + QcFluidB * dTB = 0.0;
  end if;  

port_out_FluidA.Q_flow = QcFluidA * (TA_out - port_out_FluidA.T) ;
port_out_FluidB.Q_flow = QcFluidB * (TB_out - port_out_FluidB.T) ;
// use port_in as temperature sensor
  port_in_FluidA.Q_flow = 0.0;
  port_in_FluidB.Q_flow = 0.0;

  annotation(
    Diagram(graphics = {Rectangle(origin = {2, -2}, lineThickness = 0.5, extent = {{-84, 76}, {84, -80}}), Line(origin = {3, 2.15119}, points = {{-71, 77.8488}, {-71, -74.1512}, {-3, -2.15119}, {71, -78.1512}, {71, 77.8488}}, thickness = 0.5), Line(origin = {-84, 0}, points = {{-8, 0}, {8, 0}}, thickness = 0.5), Line(origin = {85.9847, -0.259542}, points = {{-8, 0}, {8, 0}}, thickness = 0.5)}, coordinateSystem(initialScale = 0.1)),
    Icon(graphics = {Rectangle(origin = {2, -2}, lineThickness = 0.5, extent = {{-84, 76}, {78, -80}}), Line(origin = {3, 2.15119}, points = {{-59, 75.8488}, {-47, -44.1512}, {-3, -2.15119}, {43, -44.1512}, {59, 75.8488}}, thickness = 0.5), Line(origin = {-84, 0}, points = {{-8, 0}, {8, 0}}, thickness = 0.5), Line(origin = {81.9847, -0.259542}, points = {{-8, 0}, {8, 0}}, thickness = 0.5), Text(origin = {-92, -78}, lineThickness = 0.5, extent = {{-14, 8}, {72, -26}}, textString = "Qv fluidA m3/s",  fontSize = 0 ), Text(origin = {-92, 52}, lineThickness = 0.5, extent = {{-14, 8}, {72, -26}}, textString = "Qv fluidB m3/s",  fontSize = 0 ), Text(origin = {24, 52}, lineThickness = 0.5, extent = {{-14, 8}, {72, -26}}, textString = "Heat exchange coeff",  fontSize = 0 ), Text(origin = {61, -95}, lineThickness = 0.5, extent = {{-19, 7}, {19, -7}}, textString = "KURY - EDVANCE",  fontSize = 0 )}, coordinateSystem(initialScale = 0.1)));

end HeatExchanger;
