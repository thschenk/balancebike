use <hinge_named.scad>;
include <variables.scad>;
use <hinge.scad>;
use <saddle.scad>;
use <axle.scad>;

/*
Printed on 30 may 2020, with Cura 4.4:

Generic settings
    height 0.15
    infill overlap 20
    speed 45
    temp 200
    support Y
    support density 20%
    adhesion brim
    wall thickness 1.5
  


Printed on 11 june 2020, with Cura 4.4:
Hinge Frame 

    height 0.15
    infill overlap 20
    speed 45
    temp 200
    support Y
    Support only touching baseplate
    use towers N
    support density 20%
    adhesion skirt
    wall thickness 1
    bottom layers 3
    top layers 3


Printed on 11 june 2020, with Cura 4.4:
Hinge Steer

    height 0.15
    infill overlap 20
    speed 45
    temp 200
    support Y
    Support everywhere
    Support overhang angle 30  --> to make the N fully supported
    use towers N
    support density 15%
    adhesion skirt
    wall thickness 1.2
    bottom layers 3
    top layers 3


Printed on 12 june 2020, with Cura 4.4:
Saddle mount

    height 0.2
    infill overlap 20
    infill 40%
    Gradual infill steps 2
    speed 45
    temp 200
    support N
    adhesion skirt
    wall thickness 1.2
    bottom layers 3
    top layers 3
    

*/


//hinge_frame();
hinge_steer_named();
//saddle_mount();
//axle_clamps_print();
