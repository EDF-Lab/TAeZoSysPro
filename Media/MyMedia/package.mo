within TAeZoSysPro.Media;

package MyMedia
  extends Modelica.Icons.Package;

// inherite extend the package of the media to propagate it to all components using MyMedia as default media
//extends Modelica.Media.Air.ReferenceAir.Air_pT ;
//extends Modelica.Media.Air.SimpleAir ;
extends TAeZoSysPro.Media.Air.MoistAir ;
//extends Modelica.Media.Air.MoistAir ;
  
  annotation(
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
          color={175,175,175})}),
  Documentation(info = 
"<html>
  <head>
    <title>MyMedia</title>
  </head>
        
  <body lang=\"en-UK\">
    <p>
      The objective of this class is to be used as the default Medium in each module required the definition of a Medium       . 
      This class is inherited of a Media (ReferenceAir, MoistAir, Air_H2 or any Media from the Modelica Standard Library or from TAeZoSysPro.
    </p>
    <p>
      If the user want to change the media used, it can just change the inherited media and it is propagated to all components.                
    </p>
                
  </body>
</html>"));
end MyMedia;
