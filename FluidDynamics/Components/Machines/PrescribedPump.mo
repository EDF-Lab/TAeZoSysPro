within TAeZoSysPro.FluidDynamics.Components.Machines;

model PrescribedPump "Pump with ideally controlled speed"

  extends BaseClasses.PartialPump ;
  
//User defined parameters
  parameter Boolean use_N_in = false "Get the rotational speed from the input connector" ;
  parameter Modelica.SIunits.Conversions.NonSIunits.AngularVelocity_rpm N_const = N_nominal "Constant rotational speed" annotation(Dialog(enable = not use_N_in));
  
//Imported modules
  Modelica.Blocks.Interfaces.RealInput N_in(unit="rev/min") if use_N_in "Prescribed rotational speed" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,100}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,100})));

protected
  Modelica.Blocks.Interfaces.RealInput N_in_internal(unit="rev/min")
    "Needed to connect to conditional connector";

equation
  // Connect statement active only if use_p_in = true
  connect(N_in, N_in_internal);
  
  // Internal connector value when use_p_in = false
  if not use_N_in then
    N_in_internal = N_const;
  end if;
  
  // Set N with a lower limit to avoid singularities at zero speed
  N = max(N_in_internal,1e-3) "Rotational speed";


end PrescribedPump;
