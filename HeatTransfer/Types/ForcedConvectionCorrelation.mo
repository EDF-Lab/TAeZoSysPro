within TAeZoSysPro.HeatTransfer.Types;


type ForcedConvectionCorrelation = enumeration(
internal_pipe_ASHRAE "Dittus and Boelter correlation for the internal flow inside a cylinder", 
crossFlow_cylinder_ASHRAE "Churchill and Bernstein correlation for the external flow for cross flow over cylinder", 
flat_plate_ASHRAE "ASHRAE correlation for the external flow over a flat plate", 
Constant "Constant convection heat transfer ") "Enumeration defining the correlation of table";
