use <frame.scad>;
use <wheels.scad>;
use <steer.scad>;
use <utils.scad>;
use <hinge.scad>;
include <variables.scad>;


// Frame
difference() {
    union() {
        copy_mirror_y() {
            color(frame_color) 
                translate([frame_spacing_axis/2,0,0])
                    rotate([0,0,frame_angle])
                        frame();
        };

        translate([0, frame_length, frame_height])
            rotate([steer_angle,0,0])
                translate([0,hinge_frame_y_offset(),0])
                    color("SpringGreen")
                        hinge_frame();


        // Steer
        translate([0,front_wheel_y,0]) 
            rotate([steer_angle,0,0])
                    steer();

        // Wheels
        color("LightSlateGray") back_wheel();
        color("LightSlateGray") translate([0,front_wheel_y,0]) front_wheel();
    }
}




