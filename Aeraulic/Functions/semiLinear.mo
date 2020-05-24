within TAeZoSysPro.Aeraulic.Functions;

function semiLinear
  // Inputs
  input Real x;
  input Real a "PositiveSlope";
  input Real b "NegativeSlope";
  // Output
  output Real y;
algorithm
  if x > 0 then
    y := a * x;
  else
    y := b * x;
  end if;
end semiLinear;
