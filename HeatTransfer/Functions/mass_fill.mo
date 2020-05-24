within TAeZoSysPro.HeatTransfer.Functions;

function mass_fill
  // Compute the mass of each layer for the cylindrical partial wall
  // Inputs
  input TAeZoSysPro.HeatTransfer.Types.ConductionType Conduction;
  input Modelica.SIunits.Density RhoWall;
  input Modelica.SIunits.Thickness l;
  input Modelica.SIunits.Area A = 1 "if planar geometry";
  input Modelica.SIunits.Length Length = 1 "if cylindric geometry";
  input Modelica.SIunits.Radius Rin = 1 "if cylindric geometry";
  input Modelica.SIunits.Conversions.NonSIunits.Angle_deg Degree = 360 "if cylindric geometry";
  input Integer N;
  // Outputs
  output Real MassLayer[N];
algorithm
  if Conduction == TAeZoSysPro.HeatTransfer.Types.ConductionType.Linear then
    for i in 1:N loop
      MassLayer[i] := A * l / N * RhoWall;
    end for;
  elseif Conduction == TAeZoSysPro.HeatTransfer.Types.ConductionType.Radial then
    for i in 1:N loop
      MassLayer[i] := Modelica.SIunits.Conversions.from_deg(Degree) / 2 * ((Rin + l * i / N) ^ 2 - (Rin + l * (i - 1) / N) ^ 2) * Length * RhoWall;
    end for;
  end if;
end mass_fill;
