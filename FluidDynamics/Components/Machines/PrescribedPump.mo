within TAeZoSysPro.FluidDynamics.Components.Machines;

model PrescribedPump "Pump with ideally controlled speed"

  extends BaseClasses.PartialPump ;

equation

  N = N_nominal ;

end PrescribedPump;
