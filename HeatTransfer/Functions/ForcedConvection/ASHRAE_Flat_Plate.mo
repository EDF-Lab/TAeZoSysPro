within TAeZoSysPro.HeatTransfer.Functions.ForcedConvection;

function ASHRAE_Flat_Plate
  extends Modelica.Icons.Function;
  /* 
                                                                                   The correlation here is picked up from the ASHRAE library, chapter 3 "heat transfer" table 9 equations (T9.11). The configuration is an external fully turbulent (Re>5.10^5) flow over a plat plate. 
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
  Real n;
  //reynolds exponent
algorithm
// non declarative algorithmic
  if Velocity <> 0 then
    Rel := Velocity * caraclength / kinViscosity;
  else
    Rel := 0;
  end if;
// Rayleigh number is calculated
  Nul := 0.037 * Rel ^ (4 / 5) * pr ^ (1 / 3);
// Nusselt number is calculated
  hcv := Nul * kair / caraclength;
  annotation(
    Diagram(coordinateSystem(grid = {1, 2})));
end ASHRAE_Flat_Plate;
