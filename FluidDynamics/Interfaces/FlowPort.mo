within TAeZoSysPro.FluidDynamics.Interfaces;

connector FlowPort "Connector flow port"

  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium "Medium model" annotation(
    choicesAllMatching = true);
  Medium.Temperature T;
  Medium.Density[Medium.nX] d;
  flow Medium.MassFlowRate[Medium.nX] m_flow;
  flow Modelica.SIunits.EnthalpyFlowRate H_flow;
  
  annotation(
    Documentation(info = "<html>
Basic definition of the connector.<br>
<b>State variables:</b>
<ul>
<li>Temperature T</li>
<li>Density vector di</li>
</ul>

<b>Flow variables:</b>
<ul>
<li>Mass flow rate vector m_flow</li>
<li>Enthaply flow rate H_flow</li>
</ul>

If ports with different media are connected, the simulation is asserted due to the check of parameter.
</html>"));

end FlowPort;
