use <frame.scad>;
use <wheels.scad>;
use <steer.scad>;
use <utils.scad>;
use <hinge.scad>;
use <saddle.scad>;
use <hardware.scad>;
use <axle.scad>;
include <variables.scad>;


// Frame
difference() {
    union() {
        
        // Frame wood
        color(frame_color) frame_3d();

        // Hinge frame
        translate([0, frame_length, frame_height])
            rotate([steer_angle,0,0])
                translate([0,hinge_frame_y_offset(),0])
                    union(){
                        hinge_frame();
                        frame_bolts();
                    }

        translate([0,saddle_y,0]) saddle_complete();
                    
        color("DodgerBlue") axle_clamps();

        // Steer
        translate([0,front_wheel_y,0]) 
            rotate([steer_angle,0,0])
                    steer();

        // Wheels
        color("LightSlateGray")
            back_wheel();
        
        color("LightSlateGray")
            translate([0,front_wheel_y,0])
                front_wheel();
                
        
    }
}




