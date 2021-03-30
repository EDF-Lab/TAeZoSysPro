within TAeZoSysPro.FluidDynamics.BasesClasses;
model GasNode_two_phases
  model FogModel
    Modelica.SIunits.Density d_condensable "Density of the condensable species";
    Modelica.SIunits.Density d_sat "Saturation density of the condensable species";
    Modelica.SIunits.Pressure p_sat "Saturation pressure of the condensable species";
    Modelica.SIunits.Diameter d_drop "Diameter of equivalent droplet";
    Modelica.SIunits.Velocity Vel "Velocity of droplet";
    parameter Modelica.SIunits.Area A "Surface area through which fog drains";
    Modelica.SIunits.MassFlowRate m_flow_fog "Mass flow rate of droplet leaving the control volume";
    Modelica.SIunits.ReynoldsNumber Re "Reynolds number";
    input Medium.ThermodynamicState state;
    constant Modelica.SIunits.Density d_liquidPhase = 1000 "Density of the liquid phase of the condensation species";
    parameter Modelica.SIunits.NumberDensityOfMolecules n_drops = 150 * 1e6 "Number density of droplets in fog";
  equation
    // Temporary equations
    d_condensable = Medium.density(state) * state.X[Medium.Water];

    // Saturation condition
    p_sat = Medium.saturationPressure(Medium.temperature(state));
    d_sat = p_sat / (Modelica.Constants.R / Medium.MMX[Medium.Water] * Medium.temperature(state));

    // mass of water = number density of droplets * Volume of fluid * Volume of droplet * density of droplets
    d_drop / 2 = (max(d_condensable - d_sat, 0) / (d_liquidPhase * n_drops * 4 / 3 * Modelica.Constants.pi)) ^ (1 / 3);

    // quasi static flow: viscous friction force( Stocke's law) + bouyancy force + weight = 0
    Vel = d_liquidPhase * d_drop^2 * Modelica.Constants.g_n / (18 * Medium.dynamicViscosity(state));
    Re = Medium.density(state) * Vel * d_drop / Medium.dynamicViscosity(state);

    // mass flow rate = velocity * wet surface * amount of droplets peer wet surface * density of droplet
    m_flow_fog = Vel * A * (n_drops * Modelica.Constants.pi / 6 * d_drop ^ 3) * d_liquidPhase;
    
    annotation(
      Documentation(info = "
  <html>
    <head>
      <title>FogModel</title>
    </head>
  	
    <body lang=\"en-UK\">
      <p>
        This component makes it possible to model the dynamic behavior of the droplets of a fog. 
        I.e. the size of the droplets and their speed of fall.
      </p>
      
      <p>
        The fog appears when the amount of vapour per volume (the vapour density) present in a gas node exceeds its maximum admissible value (the saturation density of the vapour). 
        Once this limit is reached, any additional gain in moisture (or reduction in vapour pressure) would imply a liquid phase in the form of spherical drops of liquid suspended in the air node.
        The main objective of this model is not to finely represents the behavior of the real fog but rather to aviod sensible fraction of liquid in the gas node. 
      </p>
      <p>
        It is assumed that:
        <ul>
          <li> number density of droplets <b>n_drops</b> is constant (no coalescence). The default value of 150 droplets per cm3 is given for rest closed room with small amount of dust. </li>
          <li> The droplets diameter is homogeneous </li>
          <li> The fall speed is small enough to consider laminar flow arround droplets  </li>
          <li> The droplets are assumed non inertial. The weight always equal the drag force plus the buoyancy </li>              
          <li> The droplets are assumed spherical </li>        
        </ul>
      </p>
      
      <p>    
        First, the amount of liquid (droplets) derives from the difference between density of the water species and the saturation density of water in gas at current condition. Then the diameter of the droplet is computed from the equality between the amount of liquid and the product of the number of droplets and the volume of one droplet and the density of liquid (water) of the droplet. 
      </p>    
  
      <img        
        src=\"modelica://TAeZoSysPro/Information/FluidDynamics/BasesClasses/EQ_FogModel1.PNG\"
      />
  
      <p>        
        <b>Where</b>:
        <ul>
          <li> <code>d_sat</code> is the saturation density of the condensable species in the gas mixture </li>
          <li> <code>p_sat</code> is the saturation pressure of the condensable species in the gas mixture </li>
          <li> <code>R</code> is the perfect gas law constant  </li>
          <li> <code>MM</code> is the molar mass of the condensable species </li>
          <li> <code>T</code> is the temperature of the gas mixture </li>
          <li> <code>V</code> is the volume of the gas node </li>
          <li> <code>d_drop</code> is the diameter of a droplet </li>
        </ul>                                
      </p>
  
      <p>    
        The dynamic behavior of the droplet derives from the fundammental dynamic principe where the balance of forces is the weight, the drag and the buoyancy. As droplets are non inertial, the sum of these 3 forces is zero. Therefore, the velocity of droplets derives:
      </p>
  
      <img        
        src=\"modelica://TAeZoSysPro/Information/FluidDynamics/BasesClasses/EQ_FogModel2.PNG\"
      />
  
      <p>        
        <b>Where</b>:
        <ul>
          <li> <code>F<sub>drag</sub></code> is the visquous force for a sphere in a laminar </li>
          <li> <code>d<sub>fluid</sub></code> is the density of the gas mixture of the gas node. As the current model is modelling only moist, the <code>d<sub>droplet</sub></code> is fixed at 1.2 kg.m-3</li></li>        
          <li> <code>μ<sub>fluid</sub></code> is the dynamic viscosity of the gas mixture of the gas node</li>
          <li> <code>Vel</code> is the fall velocity of droplets</li>
          <li> <code>P</code> is the weight of a droplet</li>
          <li> <code>d<sub>droplet</sub></code> is the density of the liquid that the droplets is made of. As the current model is modelling only droplet of water, the <code>d<sub>droplet</sub></code> is fixed at 1000 kg.m-3</li>         
        </ul>                                
      </p> 
      
      <p>
        The drops falling 'on the floor of the gas node' are removed from the system gas node (the control volume indeed). The flow lost is therefore:
      </p>
  
      <img        
        src=\"modelica://TAeZoSysPro/Information/FluidDynamics/BasesClasses/EQ_FogModel3.PNG\"
      />
      
      <p>    
        The liquid surface is a difficult parameter to calculate in the sense that the vertical distribution of the drops is unknown. 
        The mass flow rate is therefore computed from the volume ratio. 
        First, imagine that there is no slipping between the droplet and the carrier phase (the surrounding gas). 
        Their velocities are thus equal. 
        The number density is known as it is an input parameter. 
        Knowing the diameter of the droplets and their number densities, the volume of liquid per total volume is determined. 
        Finally, the volume flow rate leaving the node is computed with the assumption of no slip condition.
      </p>
      
      <img        
        src=\"modelica://TAeZoSysPro/Information/FluidDynamics/BasesClasses/EQ_FogModel4.PNG\"
      />                           
    </body>
  </html>"));
  end FogModel;

  // additionnal package
  import Modelica.Fluid.Types;
  import Modelica.Fluid.Types.Dynamics;
  import SI = Modelica.SIunits;
  // Medium declaration
  replaceable package Medium = TAeZoSysPro.Media.MyMedia;
  Medium.BaseProperties medium(preferredMediumStates = if energyDynamics == Dynamics.SteadyState and massDynamics == Dynamics.SteadyState then false else true);
  // User defined parameters
  // Assumptions
  parameter Types.Dynamics energyDynamics = Dynamics.FixedInitial "Formulation of energy balance" annotation (
    Dialog(tab = "Assumptions", group = "Dynamics"));
  parameter Types.Dynamics massDynamics = Dynamics.FixedInitial "Formulation of mass balance" annotation (
    Dialog(tab = "Assumptions", group = "Dynamics"));
  final parameter Types.Dynamics substanceDynamics = massDynamics "Formulation of substance balance" annotation (
    Dialog(tab = "Assumptions", group = "Dynamics"));
  final parameter Types.Dynamics traceDynamics = massDynamics "Formulation of trace substance balance" annotation (
    Dialog(tab = "Assumptions", group = "Dynamics"));
  // Fixed start value
  parameter SI.AbsolutePressure p_start = 101325 "Initial absolute static pressure" annotation (
    Dialog(tab = "Initialization"));
  parameter SI.Temperature T_start = 293.15 "Initial temperature" annotation (
    Dialog(tab = "Initialization"));
  parameter Real RH_start(min = 0, max = 1) = 0.6 "Initial relative humidity (pmoisture/psat) <= 1" annotation (
    Dialog(enable = Medium.mediumName == "Moist air", tab = "Initialization"));
  //
  parameter Integer nPorts = 0 "Number of fluidport" annotation (
    Dialog(connectorSizing = true));
  parameter SI.Volume V = 1 "Geometric Volume of the gas node";
  parameter Modelica.SIunits.Area A = V ^ (2 / 3)  "Surface area through which fog drains";
  // Internal variables
  // Potential variables
  SI.Mass m "Mass of mixture";
  SI.Mass mXi[Medium.nXi] "Masses of independent components in the fluid";
  SI.Mass[Medium.nC] mC "Masses of trace substances in the fluid";
  // C need to be added here because unlike for Xi, which has medium.Xi,there is no variable medium.C
  Medium.ExtraProperty C[Medium.nC] "Trace substance mixture content";
  SI.InternalEnergy U "Internal energy of mixing";
  // Flow variables
  SI.MassFlowRate mb_flow "Mass flows across boundaries";
  SI.MassFlowRate[Medium.nXi] mbXi_flow "Substance mass flows across boundaries";
  Medium.MassFlowRate ports_mXi_flow[nPorts, Medium.nXi];
  Medium.ExtraPropertyFlowRate[Medium.nC] mbC_flow "Trace substance mass flows across boundaries";
  SI.EnthalpyFlowRate Hb_flow "Enthalpy flow across boundaries or energy source/sink";
  SI.HeatFlowRate Qb_flow "Heat flow across boundaries or energy source/sink";
  // Imported modules
  Modelica.Fluid.Interfaces.FluidPort_a fluidPort[nPorts](redeclare each
      package                                                                    Medium = Medium) annotation (
    Placement(visible = true, transformation(origin = {0, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-18, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort annotation (
    Placement(visible = true, transformation(origin = {0, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-18, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  TAeZoSysPro.FluidDynamics.Interfaces.FlowPort_a flowPort(redeclare package Medium = Medium) annotation (
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-18, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  FogModel fogModel(state = medium.state, A = A);
protected
  Real[Medium.nC] mC_scaled(min = fill(Modelica.Constants.eps, Medium.nC)) "Scaled masses of trace substances in the fluid";
  parameter Medium.ExtraProperty C_start[Medium.nC](quantity = Medium.extraPropertiesNames) = Medium.C_default;
  parameter Medium.MassFraction X_start[Medium.nX] = if Medium.mediumName == "Moist air" then cat(1, {Medium.massFraction_pTphi(p = p_start, T = T_start, phi = RH_start)}, {1 - Medium.massFraction_pTphi(p = p_start, T = T_start, phi = RH_start)}) else Medium.X_default;
initial equation
// initialization of balances
//Energy
  if energyDynamics == Dynamics.FixedInitial then
    medium.T = T_start;
  elseif energyDynamics == Dynamics.SteadyStateInitial then
    der(medium.T) = 0;
  end if;
//Mass
  if massDynamics == Dynamics.FixedInitial then
    medium.p = p_start;
  elseif massDynamics == Dynamics.SteadyStateInitial then
    der(medium.p) = 0;
  end if;
//Substances
  if substanceDynamics == Dynamics.FixedInitial then
    medium.Xi = X_start[1:Medium.nXi];
  elseif substanceDynamics == Dynamics.SteadyStateInitial then
    der(medium.Xi) = zeros(Medium.nXi);
  end if;
//Traces
  if traceDynamics == Dynamics.FixedInitial then
    mC_scaled = m * C_start[1:Medium.nC] ./ Medium.C_nominal;
  elseif traceDynamics == Dynamics.SteadyStateInitial then
    der(mC_scaled) = zeros(Medium.nC);
  end if;
equation
  assert(not (energyDynamics <> Dynamics.SteadyState and massDynamics == Dynamics.SteadyState) or Medium.singleState, "Bad combination of dynamics options and Medium not conserving mass because V is fixed.");
// Total quantities
  m = V * medium.d;
  mXi = m * medium.Xi;
  U = m * medium.u;
  mC = m * C;
// Boundary flow quantities
  for i in 1:nPorts loop
    ports_mXi_flow[i, :] = fluidPort[i].m_flow * actualStream(fluidPort[i].Xi_outflow);
  end for;
  for j in 1:Medium.nXi loop
    if j == Medium.Water then
      mbXi_flow[j] = sum(ports_mXi_flow[:, j]) + flowPort.m_flow[j] - fogModel.m_flow_fog;
    else
      mbXi_flow[j] = sum(ports_mXi_flow[:, j]) + flowPort.m_flow[j];
    end if;
  end for;
  mb_flow = sum(fluidPort.m_flow) + sum(flowPort.m_flow) - fogModel.m_flow_fog;
  Qb_flow = heatPort.Q_flow;
  Hb_flow = sum(fluidPort.m_flow .* actualStream(fluidPort.h_outflow)) - fogModel.m_flow_fog * Medium.enthalpyOfWater(medium.T) + flowPort.H_flow;
// Balance equations
// Energy
  if energyDynamics == Dynamics.SteadyState then
    0 = Hb_flow + Qb_flow;
  else
    der(U) = Hb_flow + Qb_flow;
  end if;
// Mass
  if massDynamics == Dynamics.SteadyState then
    0 = mb_flow;
  else
    der(m) = mb_flow;
  end if;
// Independant masses
  if substanceDynamics == Dynamics.SteadyState then
    zeros(Medium.nXi) = mbXi_flow;
  else
    der(mXi) = mbXi_flow;
  end if;
// Trace masses
  if traceDynamics == Dynamics.SteadyState then
    zeros(Medium.nC) = mbC_flow;
  else
    der(mC_scaled) = mbC_flow ./ Medium.C_nominal;
  end if;
  mC = mC_scaled .* Medium.C_nominal;
// port handovers
// fluidPorts
  for i in 1:nPorts loop
    fluidPort[i].p = medium.p;
    fluidPort[i].h_outflow = medium.h;
    fluidPort[i].Xi_outflow = medium.Xi;
  end for;
// flowPort
  flowPort.d = cat(1, mXi, {m - sum(mXi)}) / V;
  flowPort.T = medium.T;
// heatPort
  heatPort.T = medium.T;
  annotation (
    Documentation(info = "
<html>
  <head>
    <title>GasNode</title>
  </head>
        
  <body lang=\"en-UK\">
    <p>
      This components allows to model an ideally mixed gas volume of constant size. 
    </p>
    <p>
      It is assumed that the volume is high enough regarding the flow at boundaries to consider a zero velocity in the volume. Indeed, all the kinetic energy from boundaries is instantanetly dissipated to heat. 
    </p>
    
    <p>    
      First, the Total properties derives from the medium class herited from the BasesProperties model of the Medium package.
    </p>    

    <img        
      src=\"modelica://TAeZoSysPro/Information/FluidDynamics/BasesClasses/EQ_GasNode1.PNG\"
    />

    <p>        
      <b>Where</b>:
      <ul>
        <li> <code>m</code> is the mass contains in the gas node </li>
        <li> <code>medium.d</code> is the density of the medium in the gas node </li>
        <li> <code>V</code> is the geometrical volume of the gas node  </li>
        <li> <code>U</code> is the total internal energy in the gas node </li>
        <li> <code>medium.u</code> is the specific internal energy of the medium in the gas node </li>
        <li> <code>mXi</code> is the vector of independent mass of each species in the gas node </li>
        <li> <code>medium.Xi</code> is the vector of independent mass fraction of each species of the medium in the gas node </li>
        <li> <code>mC</code> is the vector of independent mass of each traces species in the gas node </li>
        <li> <code>c</code> is the vector of independent mass concentration of each traces species of the medium in the gas node </li>
      </ul>                                
    </p>

    <p>    
      The dynamic behavior of the total properties derives from the first principe of thermodynamics for the energy balance and from the mass conservation for the mass balance.
      The balance is performed from boundaries (ports):
    </p>

    <img        
      src=\"modelica://TAeZoSysPro/Information/FluidDynamics/BasesClasses/EQ_GasNode2.PNG\"
    />

    <img        
      src=\"modelica://TAeZoSysPro/Information/FluidDynamics/BasesClasses/EQ_GasNode3.PNG\"
      width = \"500\"
    />

    <p>        
      <b>Where</b>:
      <ul>
        <li> <code>m_flow</code> is the net mass flow rate coming of leaving the gas node from the mass flow rate balance between all the ports</li>
        <li> <code>mXi_flow</code> is the vector of net independent mass flow rate coming of leaving the gas node from the mass flow rate balance between all the ports</li>        
        <li> <code>Q_flow</code> is the net heat flow rate through the frontiers of the gas node from the heat flow rate balance of the heatPort</li>
        <li> <code>H_flow</code> is the net enthalpy flow rate from the balance between the entering and leaving enthalpy transported by the mass flow rate at boundaries </li>        
      </ul>                                
    </p>                            
  </body>
</html>"),
    Icon(graphics={  Rectangle(origin = {-7, -6}, lineColor = {0, 0, 127}, fillColor = {154, 231, 231},
            fillPattern =                                                                                             FillPattern.Sphere,
            lineThickness =                                                                                                                               0.5, extent = {{-73, 66}, {47, -54}}), Polygon(origin = {0, 80}, lineColor = {0, 0, 127}, fillColor = {154, 231, 231},
            fillPattern =                                                                                                                                                                                                        FillPattern.Sphere,
            lineThickness =                                                                                                                                                                                                        0.5, points = {{40, -20}, {-80, -20}, {-40, 20}, {80, 20}, {40, -20}}), Polygon(origin = {60, 21}, lineColor = {0, 0, 127}, fillColor = {154, 231, 231},
            fillPattern =                                                                                                                                                                                                        FillPattern.HorizontalCylinder,
            lineThickness =                                                                                                                                                                                                        0.5, points = {{-20, -81}, {-20, 39}, {20, 79}, {20, -41}, {-20, -81}}), Text(origin = {0, -81}, extent = {{-100, 11}, {100, -11}}, textString = "V = %V")}, coordinateSystem(initialScale = 0.1)));
end GasNode_two_phases;
