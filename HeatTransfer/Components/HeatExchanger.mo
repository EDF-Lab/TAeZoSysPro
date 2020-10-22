within TAeZoSysPro.HeatTransfer.Components;
model HeatExchanger
  extends BasesClasses.PartialHeatExchanger;
  import TAeZoSysPro.HeatTransfer.Functions.ExchangerEffectiveness;
  import TAeZoSysPro.HeatTransfer.Functions.ExchangerHeatTransferCoeff;
  //
  replaceable package MediumA = TAeZoSysPro.Media.MyMedia;
  replaceable package MediumB = TAeZoSysPro.Media.MyMedia;
  MediumA.ThermodynamicState stateA;
  MediumB.ThermodynamicState stateB;

  // Imported Modules
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_A_in annotation (
    Placement(visible = true, transformation(origin = {-88, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port_A_out annotation (
    Placement(visible = true, transformation(origin = {96, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_B_in annotation (
    Placement(visible = true, transformation(origin = {82, -82}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {70, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port_B_out annotation (
    Placement(visible = true, transformation(origin = {-92, 94}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-70, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput m_flowA annotation (
    Placement(visible = true, transformation(origin = {-78, -50}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-100, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput m_flowB annotation (
    Placement(visible = true, transformation(origin = {34, -78}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {40, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

  //
  replaceable function effectiveness = ExchangerEffectiveness.counterCurrent;
  replaceable function heatTransferCoeff = ExchangerHeatTransferCoeff.baseFun;

equation

  stateA = MediumA.setState_pTX(p=MediumA.reference_p, T = T_A_in);
  stateB = MediumB.setState_pTX(p=MediumB.reference_p, T = T_B_in);

  T_A_in = port_A_in.T;
  T_B_in = port_B_in.T;

  Qc_A = m_flowA * MediumA.specificHeatCapacityCp(stateA);
  Qc_B = m_flowB * MediumB.specificHeatCapacityCp(stateB);

  h_global = heatTransferCoeff();

  Eff = effectiveness(NTU = NTU, Cr = Cr);


  // port handovers
  port_A_in.Q_flow = 0;
  port_B_in.Q_flow = 0;
  port_A_out.Q_flow = Qc_A * (port_A_out.T - T_A_out);
  port_B_out.Q_flow = Qc_B * (port_B_out.T - T_B_out);

annotation(Documentation(info = "
<html>
  <head>
    <title>HeatExchanger</title>
  </head>
        
  <body lang=\"en-UK\">
    <p>
      This component models a dry heat exchanger.
      It uses an inheritance of the component <b>PartialHeatExchanger</b> and supply value for:
      <ul>
        <li> The mass flow rates of fluid A and B </li>
        <li> The specific heat capacities of fluid A and B</li>        
        <li> The function to computes the efficiency. By default, counter current exchanger is considered </li>
        <li> The function to computes the Heat transfer coefficient. By default, constant user defined value is considered </li>                                
      </ul>                        
    </p>

    <p>
      The function <b>effectiveness</b> to compute the effectiveness <b>Eff</b> is a replaceable function.
      Therefore, all the functions from the 'Functions.ExchangerEffectiveness' package or new user defined functions can be used.
    </p>
    
    <p>
      The function <b>heatTransferCoeff</b> to compute the global heat transfer coefficient between fluid A and B <b>h_global</b> is a replaceable function.
      Therefore, all the functions from the 'Functions.ExchangerHeatTransferCoeff' package or new user defined functions can be used.
    </p>
                
  </body>
</html>"));
end HeatExchanger;
