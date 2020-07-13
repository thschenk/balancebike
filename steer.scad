include <variables.scad>;
use <utils.scad>;
use <hinge_named.scad>;
use <hinge.scad>;


handle_bar_diameter = 24.5; 
handle_bar_width = 400;
handle_bar_height = 400;

 
module fork_flat(d=fork_width,h=handle_bar_height) {
    difference() {
        hull() {
            circle(d=d);
            translate([0,h]) circle(d=d);
        }
        
        // axle hole
        circle(d=8.5);
        
        translate([0,h]) circle(d=hp_d2);
    }
}


module fork_side() {
    
    
    rotate([90,0,0]) rotate([0,90,0])
        linear_extrude(height=wood_thickness) {
            fork_flat();
        }
}





module handlebar() {
    rotate([0,90,0]) 
        cylinder(d=handle_bar_diameter, h=handle_bar_width, center=true);
}

module handleprotector() {
    translate([-fork_spacing/2,0,0])
        rotate([0,90,0]) rotate([0,0,-90])
            handleprotector_inner();
    
    
    copy_mirror_y()
        translate([fork_spacing/2+wood_thickness,0,0])
            rotate([0,-90,0]) rotate([0,0,90])
                handleprotector_side();

}

hp_d1 = 36;
hp_d2 = 28;
hp_d3 = 24.5+0.6;

hp_inner_margin = 0.8;

screw_hole_offset = 15;

module handleprotector_side() {
    $fn=50;
    w1=4;
    w2=40;
    difference() {
        union() {
            translate([0,0,-w1]) cylinder(d=hp_d1, h=w1);
            cylinder(d=hp_d2, h=w2);
        }
        translate([0,0,-1-w1]) cylinder(d=hp_d3 , h=w1+w2+2);
        
        
        
        translate([0, 0, screw_hole_offset + 12])
            rotate([-90,0,0]) rotate([0,0,180])
                    safecylinder(d=3,h=80,center=false);

    }
}




module handleprotector_inner() {
    $fn=50;
    
    narrow_z = 16;
    
    
    
    
    difference() {
        cylinder(d=hp_d1, h=fork_spacing);
     
        // narrowest cut
        translate([0,0,-1]) cylinder(d=hp_d3, h=fork_spacing+2);
        
        // d2 cuts (widest)
        translate([0,0,fork_spacing/2])
            copy_mirror_z() {
                translate([0,0,narrow_z])
                    cylinder(d=hp_d2+hp_inner_margin, h=50);
                
                translate([0,0,narrow_z-5.0+0.1])
                    cylinder(d2=hp_d2+hp_inner_margin, d1=hp_d3, h=5);
            }
        // bolt holes for pin
        screw_hole_heights = [screw_hole_offset, fork_spacing-screw_hole_offset];
        for (screw_hole_height=screw_hole_heights )
            translate([0,0,screw_hole_height]) {
                
                translate([0,hp_d1/2-4,0])
                    rotate([-90,0,0])
                        cylinder(d1=2,d2=7,h=5,center=false);
                
            }            
    }
}



translate([-100,0,0])
    difference() {
        union() {
            translate([0,0,0]) handleprotector_side();
            translate([0,0,12]) handleprotector_inner();
        }
        translate([-75,0,0]) cube([150,150,150]);
    }

module steer() {
    copy_mirror_y() {
        translate([fork_spacing/2,0,0]) 
            color(frame_color) 
                fork_side();
    }
    
    color(frame_color) translate([0,0,handle_bar_height]) handlebar();
    color("DodgerBlue") 
        translate([0,0,handle_bar_height])
            handleprotector();
    
    translate([0,-35,200]) {
        hinge_steer_named();
        hinge_steer_bolts();
    }
}

steer();
