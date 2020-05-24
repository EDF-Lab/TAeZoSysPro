within TAeZoSysPro.HeatTransfer.Functions.FreeConvection;

function Recknagel_Vert_Plate
  extends Modelica.Icons.Function;
  /*
                                                                                  Function to compute the heat transfer coefficient for a vertical flat plate
                                                                                  */
  input Real deltaT;
  //temperature difference
  input Real meanT;
  //mean temperautre
  output Real hcv;
  //convection coefficient
protected
  constant Real recknagelcoef = 9.7;
  //Recknagel coefficient
algorithm
  hcv := recknagelcoef * (abs(deltaT) / meanT) ^ (1 / 3);
//equation hcv is the variable convective heat exchange coefficient and is related to Recknagel correlation
  annotation(
    Diagram(coordinateSystem(grid = {1, 2})));
end Recknagel_Vert_Plate;
