within TAeZoSysPro.HeatTransfer.Functions.FreeConvection;

function ChurchillAndChu_Vert_Plate
  extends Modelica.Icons.Function;
  /*
                                                                                  Function to compute the heat transfer coefficient for a vertical flat plate
                                                                                  */
  input Real Tportb;
  //temperature of gas;
  input Real deltaT;
  //Temperature difference
  input Real caraclength;
  // Wall height
  input Real rho;
  // density
  input Real cp;
  // specific heat
  input Real eta;
  // kinematic viscosity
  input Real kair;
  // thermal conductivity
  input Real pr;
  //Prandtl number
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
  //Nul is the nusselt number with the Churchill and Chu correlation
algorithm
// non declarative algorithmic
  alpha := kair / (rho * cp);
// alpha is calculated, lookup table could be used
  beta := 1 / Tportb;
// beta is calculated
  Ral := g * beta * abs(deltaT) * caraclength ^ 3 / (alpha * eta);
// Rayleigh number is calculated
  Nul := (0.825 + 0.387 * Ral ^ (1 / 6) / (1 + (0.492 / pr) ^ (9 / 16)) ^ (8 / 27)) ^ 2;
// Nusselt number is calculated with the ChurchilL and Chu correlation
  hcv := Nul * kair / caraclength;
  annotation(
    Diagram(coordinateSystem(grid = {1, 2})));
end ChurchillAndChu_Vert_Plate;
