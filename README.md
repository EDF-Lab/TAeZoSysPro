TAeZoSysPro
modelica library to model fluid dynamic of HVAC systems

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
The tag 2.0.1 contain a mistake that makes this version unsable. 
Corrective commit https://gitlab.pleiade.edf.fr/hvac_numerical_tools/modelica/taezosyspro/-/commit/9d1be2d5d114bc8d4eeca92806304900d0995272 was pushed in the v2.0 branch 
and in available in the tag 2.0.2
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

Changes from tag 2.0.1 in tag 2.0.2
-> Air component: the mass of volume went inside the time derivative to take account of the work of mass gain or loss from the volume
-> Correction of mistake in the linearise radiative heat transfer coefficient
-> Ventilation component: better handling of very low mass flow rate that leads to stiff system