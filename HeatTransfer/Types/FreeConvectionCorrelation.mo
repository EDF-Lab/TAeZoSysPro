within TAeZoSysPro.HeatTransfer.Types;

type FreeConvectionCorrelation = enumeration(
ChurchillAndChu_vertical_plate "Churchill & Chu correlation for a flat vertical plate", 
Recknagel_vertical_plate "Recknagel correlation for a flat vertical plate", 
Cibse_vertical_plate "Cibse correlation for a flat vertical plate", 
Ground "horizontal ground plate", 
Ceiling "horizontale ground plate", 
ChurchillAndChu_horizontal_cylinder "ChurchillAndChu correlation for the external flow arround an horizontal cylinder", 
Morgan_horizontal_cylinder "Morgans correlations for the external flow arround an horizontal cylinder", 
Constant "Constant convection heat transfer ") "Enumeration defining the correlation of table";
