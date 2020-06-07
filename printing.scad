use <hinge_named.scad>;
include <variables.scad>;
use <hinge.scad>;

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
     
*/

intersection() {
    translate([0,0,frame_b]) rotate([180,0,0]) hinge_steer_named();
    cube([40,40,50], center=true);
}


intersection(){
    translate([57,-17,-30]) rotate([0,0,90]) hinge_steer_named();
    translate([-10,-51,0])  cube([20,38,21]);
}





translate([0,30]) intersection() {
    rotate([0,0,180]) hinge_frame();
    cube([40,40,50], center=true);
}


translate([-5,112,0])
    intersection() {
        
        rotate([0,0,-frame_angle]) hinge_frame();
        
        translate([0,-65,0])
            cube([40,30,20]);
    }