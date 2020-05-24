within TAeZoSysPro.HeatTransfer.Functions.FreeConvection;

function Cibse_Vert_Plate
  extends Modelica.Icons.Function;
  /*
                                                                                  Function to compute the heat transfer coefficient for a vertical flat plate
                                                                                  */
  input Real deltaT;
  //Temperature difference
  input Real Tportb;
  //temperature of gas
  input Real caraclength;
  // Wall height
  input Real rho;
  //density
  input Real cp;
  //specific heat
  input Real eta;
  //kinematic viscosity
  input Real kair;
  //thermal conductivity
  output Real hcv;
  //convection coefficient
protected
  constant Real g = 9.807;
  // (final quantity="Acceleration", final unit="m/s2");
protected
  Real alpha;
  //alpha is the thermal diffusivity
protected
  Real Ral;
  //Rayleight number
protected
  Real beta;
  //beta is the volumetric thermal expansion coeffcient
protected
  Real Nul;
  //Nul is the nusselt number with the Cibse correlation
protected
  constant Real Ral_min = 10 ^ 4;
  //min boundary Rayleigh number
protected
  constant Real Ral_medium = 10 ^ 9;
  //medium boundary Rayleigh number
protected
  constant Real Ral_max = 10 ^ 13;
  // max boundary rayleigh number
protected
  constant Real Nul0 = 0;
  //Nusselt 0 number
algorithm
  alpha := kair / (rho * cp);
// alpha is calculated, lookup table could be used
  beta := 1 / Tportb;
// beta is calculated
  Ral := g * beta * abs(deltaT) * caraclength ^ 3 / (alpha * eta);
// Rayleigh number is calculated
  if Ral >= Ral_min and Ral <= Ral_medium then
    Nul := 0.59 * Ral ^ (1 / 4);
  elseif Ral > Ral_medium and Ral <= Ral_max then
    Nul := 0.10 * Ral ^ (1 / 3);
  else
    Nul := Nul0;
  end if;
//Nusselt number is calculated with Cibse correlation and Rayleigh boundaries
//Nusselt number is calculated with Cibse correlation and Rayleigh boundaries
//when Rayleigh is out of boundaries, Nusselt number is equal to 0
  hcv := Nul * kair / caraclength;
// variable convective heat exchange is calculated
  annotation(
    Diagram(coordinateSystem(grid = {1, 2})));
end Cibse_Vert_Plate;
