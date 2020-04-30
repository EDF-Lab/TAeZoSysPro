within TAeZoSysPro.FluidDynamics.Components.Pipes;

model StaticPipe
equation

annotation (defaultComponentName="pipe",
Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}}), graphics={Rectangle(
          extent={{-100,40},{100,-40}},
          fillPattern=FillPattern.Solid,
          fillColor={95,95,95},
          pattern=LinePattern.None), Rectangle(
          extent={{-100,44},{100,-44}},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255})}));
end StaticPipe;
