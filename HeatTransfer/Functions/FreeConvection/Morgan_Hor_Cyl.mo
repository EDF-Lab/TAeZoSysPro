within TAeZoSysPro.HeatTransfer.Functions.FreeConvection;

function Morgan_Hor_Cyl
  extends Modelica.Icons.Function;
  /* 
                                                                                   
                                                                                  KURY_SOFINEL_2017
                                                                                  
                                                                                  The following morgan correlations are pratical for an horizontal cylinder is rest environment (no forced convection). 
                                                                                  The correlation are given for a range of Rayleigh number. 
                                                                                      
                                                                                  */
  input Real Tportb;
  //Gas Temperature ;
  input Real deltaT;
  //Temperature difference
  input Real meanT;
  //mean temperautre
  input Real caraclength;
  // External insulation diameter
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
  Real C;
  //Morgan constant to calculate the Nusselt
protected
  Real n;
  //Morgan constant exponent to calculate the Nusselt
protected
  Real Nul;
  //Nul is the nusselt number with the Churchill and Chu correlation
algorithm
// non declarative algorithmic
  alpha := kair / (rho * cp);
// alpha is calculated, lookup table could be used
  beta := 1 / Tportb;
// beta is calculated
  Ral := g * beta * abs(deltaT) * caraclength ^ 3 / (alpha * kinViscosity);
// Rayleigh number is calculated
  if Ral >= 10 ^ (-10) and Ral <= 10 ^ (-2) then
    C := 0.675;
    n := 0.058;
    Nul := C * Ral ^ n;
  elseif Ral > 10 ^ (-2) and Ral <= 10 ^ 2 then
    C := 1.02;
    n := 0.148;
    Nul := C * Ral ^ n;
  elseif Ral > 10 ^ 2 and Ral <= 10 ^ 4 then
    C := 0.85;
    n := 0.188;
    Nul := C * Ral ^ n;
  elseif Ral > 10 ^ 4 and Ral <= 10 ^ 7 then
    C := 0.48;
    n := 0.25;
    Nul := C * Ral ^ n;
  elseif Ral > 10 ^ 7 and Ral <= 10 ^ 12 then
    C := 0.125;
    n := 1 / 3;
    Nul := C * Ral ^ n;
  end if;
  assert(Ral < 10 ^ (-10) or Ral > 10 ^ 12, "Rayleigh is out of range", level = AssertionLevel.error);
  hcv := Nul * kair / caraclength;
  annotation(
    Diagram(coordinateSystem(grid = {1, 2})));
end Morgan_Hor_Cyl;
