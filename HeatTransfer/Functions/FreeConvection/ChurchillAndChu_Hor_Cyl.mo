within TAeZoSysPro.HeatTransfer.Functions.FreeConvection;

function ChurchillAndChu_Hor_Cyl
  extends Modelica.Icons.Function;
  /* 
                                                                                   
                                                                                  The following Churchill and Chu correlations are pratical for an horizontal cylinder in rest environment (no forced convection). 
                                                                                  The correlation is given for a Rayleigh number < 10^12.
                                                                                      
                                                                                  */
  input Real Tportb;
  //Gas Temperature;
  input Real deltaT;
  //Temperature difference
  input Real meanT;
  //mean temperautre
  input Real caraclength;
  //External insulation diameter
  input Real rho;
  //dry air density
  input Real cp;
  //dry air specific heat
  input Real kinViscosity;
  //dry air velocity
  input Real kair;
  //dry air thermal conductivity
  input Real pr;
  //Prandtl number
  output Real hcv;
  //convection coefficient
protected
  constant Real g = Modelica.Constants.g_n;
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
  if alpha <> 0 and kinViscosity <> 0 then
    Ral := g * beta * abs(deltaT) * caraclength ^ 3 / (alpha * kinViscosity);
  else
    Ral := 0;
  end if;
// Rayleigh number is calculated
//When alpha and velocity equal to 0, Ral eqal to 0 because divide by 0 is forbidden
  Nul := (0.6 + 0.387 * Ral ^ (1 / 6) / (1 + (0.559 / pr) ^ (9 / 16)) ^ (8 / 27)) ^ 2;
// Nusselt number is calculated with the ChurchilL and Chu correlation
  hcv := Nul * kair / caraclength;
  annotation(
    Diagram(coordinateSystem(grid = {1, 2})));
end ChurchillAndChu_Hor_Cyl;
