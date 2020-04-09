within TAeZoSysPro.HeatTransfer.Types;

type MeshGrid = enumeration(
    uniform
      "Uniform grid with equal spacing between vertices",
    biotAndUniform "Uniform grid with equal spacing between vertices execpted for boundary segments with a specing from biot number",
    geometricalGrowth "Grid with geometrical growth spacing between vertices",
    biotAndGeometricalGrowth
      "Grid with geometrical growth spacing between vertices  execpted for boundary segments with a specing from biot number")
  "Enumeration to define the function used to mesh the domain" ; 
