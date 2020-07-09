within TAeZoSysPro.HeatTransfer.Types;

type CrossFlow_arrangement = enumeration(
both_unmixed "Both fluids are unmixed", 
fluidA_mixed_fluidB_unmixed "Fluid A in mixed and B unmixed",  
fluidB_mixed_fluidA_unmixed "Fluid A in mixed and B unmixed") "Enumeration defining the configuration of a cross flows exchanger";
