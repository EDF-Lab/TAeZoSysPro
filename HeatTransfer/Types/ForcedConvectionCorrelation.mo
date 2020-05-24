within TAeZoSysPro.HeatTransfer.Types;

type ForcedConvectionCorrelation = enumeration(
ASHRAE_internal_cylinder "ASHRAE correlation for the internal flow inside a cylinder", 
ASHRAE_external_cylinder "ASHRAE correlation for the external flow for cross flow over cylinder", 
ASHRAE_flat_plate "ASHRAE correlation for the external flow over a flat plate", 
Constant "Constant convection heat transfer ") "Enumeration defining the correlation of table";
