within TAeZoSysPro.HeatTransfer.Functions.ForcedConvection;

function ASHRAE_Ext_Cyl
  extends Modelica.Icons.Function;
  /* 
                                                                                   The correlation here is picked up from the ASHRAE library, chapter 3 "heat transfer" table 9 equations (T9.13)d. The configuration is an external flow for a cross flow over cylinder. 
                                                                                  */
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
algorithm
// non declarative algorithmic
  if Velocity <> 0 then
    Rel := Velocity * caraclength / kinViscosity;
  else
    Rel := 0;
  end if;
// Rayleigh number is calculated
  Nul := 0.3 + 0.62 * Rel ^ (1 / 2) * pr ^ (1 / 3) / (1 + (0.4 / pr) ^ (2 / 3)) ^ (1 / 4) * (1 + (Rel / 282000) ^ (5 / 8)) ^ (4 / 5);
// Nusselt number is calculated
  hcv := Nul * kair / caraclength;
  annotation(
    Diagram(coordinateSystem(grid = {1, 2})));
end ASHRAE_Ext_Cyl;
