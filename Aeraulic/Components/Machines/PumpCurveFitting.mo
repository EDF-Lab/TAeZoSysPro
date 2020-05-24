within TAeZoSysPro.Aeraulic.Components.Machines;

model PumpCurveFitting
  parameter Real[:, :] Table "couple (Volume flow, pressure difference)" annotation(
    HideResult = true);
  parameter Integer OrderPolyFitting = 3 "order of the polynome taht fits the fan curve";
  final parameter Integer N = size(Table[:, 1], 1) "numberOfRows";
  Real[OrderPolyFitting + 1] Coeff "[^0,^1,^2,^3]";
protected
  Real[N, OrderPolyFitting + 1] A;
equation
  for i in 1:OrderPolyFitting + 1 loop
    A[:, i] = Table[:, 1] .^ (i - 1.0);
  end for;
  Coeff = Modelica.Math.Matrices.leastSquares(A = A, b = Table[:, 2]);
end PumpCurveFitting;
