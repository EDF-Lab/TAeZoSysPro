within TAeZoSysPro.HeatTransfer.Functions.FreeConvection;

function Ground
  extends Modelica.Icons.Function;
  /*
                                                                                  Function to compute the heat transfer coefficient for horizontal flat ground
                                                                                  */
  input Real Tporta;
  //temperature port a --> temperature from the Wall;
  input Real Tportb;
  //temperature port b --> temperature from the air;
  input Real deltaT;
  //Temperature difference
  input Real meanT;
  //mean temperautre
  input Real perimeter;
  // Wall height
  input Real rho;
  //dry air density
  input Real cp;
  //dry air specific heat
  input Real velocity;
  //dry air velocity
  input Real kair;
  //dry air thermal conductivity
  input Real area;
  //horizontale ground area
  output Real hcv;
  //convection coefficient
protected
  constant Real g = 9.807;
  // (final quantity="Acceleration", final unit="m/s2");

  Real alpha;
  //alpha is the thermal diffusivity

  Real caraclength;
  //caraclenght of horizontale ground

  Real Ral;
  //Rayleight number

  Real beta;
  //beta is the volumetric thermal expansion coeffcient

  Real Nul;
  //Nul is the nusselt number
  
constant Real Ral_1 = 200, Ral_2 = 10 ^ 4, Ral_3 = 8 * 10 ^ 6 ;
  
  Modelica.SIunits.NusseltNumber Nu_up, Nu_buffer ;
  Real x_small "shift value to enter in the polynomial fitting to remove discontinuities";
  
algorithm
// non declarative algorithmic
  caraclength := area / perimeter;
// caraclength is calculated
  alpha := kair / (rho * cp);
// alpha is calculated, lookup table could be used
  beta := 1 / Tportb;
// beta is calculated 1/(absolute air temperature)
  if alpha <> 0 and velocity <> 0 then
    Ral := g * beta * abs(deltaT) * caraclength ^ 3 / (alpha * velocity);
  else
    Ral := 0;
  end if;
// Rayleigh number is calculated
//When alpha and velocity equal to 0, Ral eqal to 0 because divide by 0 is forbidden

  // initialization
  x_small := 0 ;
  Nu_up := 0 ;
  Nu_buffer := 0 ;

//Nul is calculated according to Table 10 from ASHRAE handbook chapter 3 heat transfer
if deltaT > 0 then

    if Ral < Ral_1 then
      x_small:= Ral_1/100 ; 
      Nu_buffer := 0.96 * Ral ^ (1 / 6);
      Nu_up := 0.59 * Ral ^ (1 / 4);
      Nul := Modelica.Fluid.Utilities.regStep(x = Ral_1-Ral-x_small, x_small = x_small, y1 = Nu_buffer, y2 = Nu_up) ;
      
    elseif Ral >= Ral_1 and Ral < Ral_2 then
      x_small:= Ral_2/100 ; 
      Nu_buffer := 0.59 * Ral ^ (1 / 4);
      Nu_up := 0.54 * Ral ^ (1 / 4);
      Nul := Modelica.Fluid.Utilities.regStep(x = Ral_2-Ral-x_small, x_small = x_small, y1 = Nu_buffer, y2 = Nu_up) ;
      
    elseif Ral >= Ral_2 and Ral < Ral_3 then
      x_small:= Ral_3/100 ; 
      Nu_buffer := 0.54 * Ral ^ (1 / 4);
      Nu_up := 0.15 * Ral ^ (1 / 3);
      Nul := Modelica.Fluid.Utilities.regStep(x = Ral_3-Ral-x_small, x_small = x_small, y1 = Nu_buffer, y2 = Nu_up) ;
      
    elseif Ral >= Ral_3  then
      Nul := 0.15 * Ral ^ (1 / 3);
      
    end if ;
    
    assert(not(Ral < 1), "the Rayleigh number <1 is out of the range of the correlation", level = AssertionLevel.warning) ;
    assert(not(Ral > 1.5*10^9), "the Rayleigh number >1.5*10^9 is out of the range of the correlation", level = AssertionLevel.warning) ;
  
  else
  
    Nul := 0.27 * Ral ^ (1 / 4);
    assert(not(Ral < 10^5), "the Rayleigh number <10^5 is out of the range of the correlation", level = AssertionLevel.warning) ;
    assert(not(Ral > 10^10), "the Rayleigh number >10^9 is out of the range of the correlation", level = AssertionLevel.warning) ;

  end if;
// Ral is out of bound!
// Ral is out of bound!
  hcv := Nul * kair / caraclength;
// variable convective heat exchange is calculated
  annotation(
    Diagram(coordinateSystem(grid = {1, 2})));
end Ground;
