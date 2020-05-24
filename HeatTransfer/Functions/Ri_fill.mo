within TAeZoSysPro.HeatTransfer.Functions;

function Ri_fill
  // Inputs
  input Modelica.SIunits.Thickness l;
  input Modelica.SIunits.Radius Rin;
  input Integer N;
  // Outputs
  output Real Rivalues[N];
algorithm
  for i in 1:N loop
    Rivalues[i] := Rin + l * (i - 1) / N;
  end for;
end Ri_fill;
