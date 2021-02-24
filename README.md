# TAeZoSysPro
modelica library to model fluid dynamic of HVAC systems

# Changes from version 2.0.1
- Increase of performance by:
	-> diminution of iteration variable via a better management of explicit and implicit variables
	-> use of functions rather than equation on non linear and high order equations

- Compatibility with the new front end of the Open Modelica software (Version > 1.14)

- Management of transport and diffusion equations via Partial Derivative Equations rather than connection between multiple components

# Changes in version master
1-Minor corrections:
	- polynomialFlow: correction required to work with the version 1.16 of openModelica
	- gasConstant_X of the air Air_H2 media: correction in its declaration

2-Major corrections:
	- Correction in the called fonction to computed the derivative function of the saturation density of the MoistAir media (f4dc88331a0807266a3e40273d170f6f54fed3bb)
	- Correction in the calcualtion of the derivative function of the saturation density of the MoistAir media
	
3-Enhancements
	- FanVentilation: works with multi-species media
	- The saturation pressure fonctions have been changed to work with a MoistAir bellow the triple point condition. It does not mean that the media can model a condensable moist air bellow the triple point conditions