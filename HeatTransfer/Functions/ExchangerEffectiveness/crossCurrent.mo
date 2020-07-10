within TAeZoSysPro.HeatTransfer.Functions.ExchangerEffectiveness;
function crossCurrent

  extends baseFunc;
  import TAeZoSysPro.HeatTransfer.Types.CrossFlow_arrangement;
  input CrossFlow_arrangement arrangement;
  input Real Qc_A, Qc_B;

protected
  Real gamma;
  constant Real Cr_small = 1e-3;

algorithm
  if Cr<=Cr_small then
    gamma:= 0.0;
    Eff := 1-exp(-NTU);

  else

    if arrangement == CrossFlow_arrangement.both_unmixed then
      gamma := exp(-Cr*NTU^0.78)-1;
      Eff := TAeZoSysPro.FluidDynamics.Utilities.regStep(
        x = Cr-2*Cr_small,
        x_small = Cr_small,
        y1 = 1.0 - exp(NTU^(0.22)*gamma/Cr),
        y2 = 1-exp(-NTU));

    elseif arrangement == CrossFlow_arrangement.fluidA_mixed_fluidB_unmixed then
      if Qc_A == max(Qc_A, Qc_B) then
        gamma := 1-exp(-NTU);
        Eff := TAeZoSysPro.FluidDynamics.Utilities.regStep(
          x = Cr-2*Cr_small,
          x_small = Cr_small,
          y1 = (1-exp(-Cr*gamma))/Cr,
          y2 = 1-exp(-NTU));

      else
        gamma := 1-exp(-NTU*Cr);
        Eff := TAeZoSysPro.FluidDynamics.Utilities.regStep(
          x = Cr-2*Cr_small,
          x_small = Cr_small,
          y1 = (1-exp(-gamma/Cr)),
          y2 = 1-exp(-NTU));
      end if;

    elseif arrangement == CrossFlow_arrangement.fluidB_mixed_fluidA_unmixed then
      if Qc_A == max(Qc_A, Qc_B) then
        gamma := 1-exp(-NTU*Cr);
        Eff := TAeZoSysPro.FluidDynamics.Utilities.regStep(
          x = Cr-2*Cr_small,
          x_small = Cr_small,
          y1 = (1-exp(-gamma/Cr)),
          y2 = 1-exp(-NTU));

      else
        gamma := 1-exp(-NTU);
        Eff := TAeZoSysPro.FluidDynamics.Utilities.regStep(
          x = Cr-2*Cr_small,
          x_small = Cr_small,
          y1 = (1-exp(-Cr*gamma))/Cr,
          y2 = 1-exp(-NTU));

      end if;

    else
      gamma := 0.0;
      Eff := 0.0;

    end if;

  end if;

  annotation (
    Documentation(info="
<html>
  <head>
    <title>crossCurrent</title>
      <style type=\"text/css\">
      *       { font-size: 10pt; font-family: Arial,sans-serif; }
      code    { font-size:  9pt; font-family: Courier,monospace;}
      h6      { font-size: 10pt; font-weight: bold; color: green; }
      h5      { font-size: 11pt; font-weight: bold; color: green; }
      h4      { font-size: 13pt; font-weight: bold; color: green; }
      address {                  font-weight: normal}
      td      { solid #000; vertical-align:top; }
      th      { solid #000; vertical-align:top; font-weight: bold; }
      table   { solid #000; border-collapse: collapse;}
    </style>
  </head>
        
  <body lang=\"en-UK\">
    <p>
      This functions computes the exchanger effectiveness for cross current flows where:
      <ul>
      <li>Both flows are unmixed</li>
      <li>One flow is mixed an the other unmixed</li>
      </ul>
    </p>

    <h4> Both fluid are unmixed </h4>

    <p>
      The relation to compute the effectiveness derives:
    </p>
    <img
      src = \"modelica://TAeZoSysPro/Information/HeatTransfer/Functions/ExchangerEffectiveness/Eq_crossCurrent_both_unmixed.png\"
    />

    <h4> Qc_max is mixed </h4>    

    <p>
      The relation to compute the effectiveness derives:
    </p>
    <img
      src = \"modelica://TAeZoSysPro/Information/HeatTransfer/Functions/ExchangerEffectiveness/Eq_crossCurrent_Qc_max_mixed.png\"
    />

    <h4> Qc_max is unmixed </h4>    

    <p>
      The relation to compute the effectiveness derives:
    </p>
    <img
      src = \"modelica://TAeZoSysPro/Information/HeatTransfer/Functions/ExchangerEffectiveness/Eq_crossCurrent_Qc_max_unmixed.png\"
    />

    <p>
      For all relations, when Cr &le; Cr_small, the effectiveness derives.
      When Cr_small &le; Cr &le; 2*Cr_small, the effectiveness is fit by a polynom via the regStep function between its normal relation and the relation for Cr &le; Cr_small 
    </p>

    <img
      src = \"modelica://TAeZoSysPro/Information/HeatTransfer/Functions/ExchangerEffectiveness/EQ_crossCurrent_Cr=0.png\"
    />
                
  </body>
</html>"));
end crossCurrent;
