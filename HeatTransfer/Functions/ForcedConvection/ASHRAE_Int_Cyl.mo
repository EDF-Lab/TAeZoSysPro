within TAeZoSysPro.HeatTransfer.Functions.ForcedConvection;

function ASHRAE_Int_Cyl
  extends Modelica.Icons.Function;
  /* 
                                                                                   The correlation here is picked up from the ASHRAE library, chapter 3 "heat transfer" table 9 equations (T9.5)b and (T9.6)b. The configuration is an internal fully turbulent (Re>10000) flow in a pipe. The correlation depends on whether the wall are cooler or warmer than the fluid.  
                                                                                  */
  input Real deltaT;
  //Temperature difference
  input Real caraclength;
  //Hydraulic diameter
  input Real Velocity;
  //characteristique velocity
  input Real kinViscosity;
  //dry air kinectic Viscosity
  input Real kair;
  //dry air thermal conductivity
  input Real pr;
  //Prandtl number
  output Real hcv;
  //convection coefficient
protected
  Real Rel;
  //Reynolds number
  Real Nul;
  //Nul is the nusselt number with the Churchill and Chu correlation
  Real n;
  //reynolds exponent
algorithm
// non declarative algorithmic
//cooling or heating mode selection
/* 
- Twall > T mean fluid => heating mode
- Twall < T mean fluid => cooling mode  
*/
  if deltaT > 0 then
    n := 0.4;
  elseif deltaT < 0 then
    n := 0.3;
  else
    n := 0.35;
  end if;
//heating mode
//cooling mode
// unknown mode
  if Velocity <> 0 then
    Rel := Velocity * caraclength / kinViscosity;
  else
    Rel := 0;
  end if;
// Rayleigh number is calculated
  Nul := 0.023 * Rel ^ (4 / 5) * pr ^ n;
// Nusselt number is calculated
  hcv := Nul * kair / caraclength;
  annotation(
    Diagram(coordinateSystem(grid = {1, 2})));
end ASHRAE_Int_Cyl;
