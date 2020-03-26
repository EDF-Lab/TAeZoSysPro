within TAeZoSysPro;

package Media

extends Modelica.Icons.Package;

annotation (preferredView="info",
  Documentation(
  info="
<html>
  <p>
    This library contains <a href=\"modelica://Modelica.Media.Interfaces\">interface</a>
    definitions for media and the following <strong>property</strong> models for
    single and multiple substance fluids with one and multiple phases:
  </p>
  
  <ul>
    <li> <a href=\"modelica://Modelica.Media.Air\">Air models:</a><br>
         SimpleAir, MoistAir, AirH2 </li>
  </ul>
  
  <p>
    The following parts are useful, when newly starting with this library:
  </p>
  
  <ul>
    <li> <a href=\"modelica://Modelica.Media.UsersGuide\">Modelica.Media.UsersGuide</a>.</li>
    <li> <a href=\"modelica://Modelica.Media.UsersGuide.MediumUsage\">Modelica.Media.UsersGuide.MediumUsage</a>
         describes how to use a medium model in a component model.</li>
    <li> <a href=\"modelica://Modelica.Media.UsersGuide.MediumDefinition\">
         Modelica.Media.UsersGuide.MediumDefinition</a>
         describes how a new fluid medium model has to be implemented.</li>
    <li> <a href=\"modelica://Modelica.Media.UsersGuide.ReleaseNotes\">Modelica.Media.UsersGuide.ReleaseNotes</a>
         summarizes the changes of the library releases.</li>
    <li> <a href=\"modelica://Modelica.Media.Examples\">Modelica.Media.Examples</a>
         contains examples that demonstrate the usage of this library.</li>
  </ul>
  
  <p>
    Copyright &copy; 1998-2019, Modelica Association and contributors
  </p>
</html>", 
  revisions="
<html>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={
        Line(
          points = {{-76,-80},{-62,-30},{-32,40},{4,66},{48,66},{73,45},{62,-8},{48,-50},{38,-80}},
          color={64,64,64},
          smooth=Smooth.Bezier),
        Line(
          points={{-40,20},{68,20}},
          color={175,175,175}),
        Line(
          points={{-40,20},{-44,88},{-44,88}},
          color={175,175,175}),
        Line(
          points={{68,20},{86,-58}},
          color={175,175,175}),
        Line(
          points={{-60,-28},{56,-28}},
          color={175,175,175}),
        Line(
          points={{-60,-28},{-74,84},{-74,84}},
          color={175,175,175}),
        Line(
          points={{56,-28},{70,-80}},
          color={175,175,175}),
        Line(
          points={{-76,-80},{38,-80}},
          color={175,175,175}),
        Line(
          points={{-76,-80},{-94,-16},{-94,-16}},
          color={175,175,175})}));
end Media;
