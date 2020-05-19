include <variables.scad>;
use <utils.scad>;
use <hinge.scad>;

handle_bar_diameter = 25; 
handle_bar_width = 400;
handle_bar_height = 400;

 
module fork_flat(d=50,h=handle_bar_height) {
    difference() {
        hull() {
            circle(d=d);
            translate([0,h]) circle(d=d);
        }
        
        // axle hole
        circle(d=8.5);
        
        translate([0,h]) circle(d=handle_bar_diameter);
    }
}


module fork_side() {
    thickness=15;
    rotate([90,0,0]) rotate([0,90,0])
        linear_extrude(height=thickness) {
            fork_flat();
        }
}



//fork_flat();
//fork_side();


module handlebar() {
    
    rotate([0,90,0]) 
        cylinder(d=handle_bar_diameter, h=handle_bar_width, center=true);
}



module steer() {
    copy_mirror_y() {
        translate([fork_spacing/2,0,0]) 
            fork_side();
    }
    
    translate([0,0,handle_bar_height]) handlebar();
    
    color("DodgerBlue") translate([0,-25,175]) hinge_steer();
}

steer();
