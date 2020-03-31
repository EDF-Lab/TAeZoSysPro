within TAeZoSysPro.HeatTransfer.Types;

type FreeConvectionCorrelation = enumeration(
vertical_plate_ASHRAE "Churchill & Chu correlation for a flat vertical plate", 
vertical_plate_Recknagel "Recknagel correlation for a flat vertical plate",  
ground_ASHRAE "Lloyd and Moran correlation for a horizontal ground plate", 
ceiling_ASHRAE "Lloyd and Moran correlation for a horizontal ceiling plate", 
horizontal_cylinder_ASHRAE "Churchill & Chu correlation for the external flow around an horizontal cylinder", 
Constant "Constant convective heat transfer coefficient") "Enumeration defining the correlation of table";
