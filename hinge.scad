use <MCAD/bearing.scad>;
use <scad-utils/morphology.scad>;
use <utils.scad>;
include <variables.scad>;
use <frame.scad>;

hinge_height = 70;
outer_height = 12;
spacing = 1;
inner_height = hinge_height-2*outer_height-2*spacing;

hinge_diameter = 24;
hole_diameter = 5.3;
hinge_space_diameter = hinge_diameter + 1;

bearing_cut_diameter = 16.3;
bearing_cut_height = 5.2;

$fn=50;


module hinge_steer_shape_flat() {
    fillet(r=10) union() {
        translate([-fork_spacing/2,5])
            square([fork_spacing,15]);
        
        circle(d=hinge_diameter);
    }
}


//hinge_steer_shape_flat();

module hinge_steer() {
    difference() {
        linear_extrude(height=hinge_height, convexity=10) {
            hinge_steer_shape_flat();
        }
        
        // bolt hole
        cut_cylinder(d=hole_diameter, h=hinge_height);
        
        // cut out for inner hinge
        translate([0,0,outer_height])
            cylinder(d=hinge_space_diameter, h=inner_height+2*spacing);
        
        // cut out for square inner hinge
        cut_w=60;
        cut_d=4.99;
        translate([-cut_w/2,-1,outer_height])
            cube([cut_w,cut_d+1,inner_height+2*spacing]);        
    }
}


function hinge_frame_y_offset() = 18;



module hinge_frame() {
    hinge_frame_length = 50;
    difference() {
        union() {
            translate([-frame_spacing_front/2,-hinge_frame_length-6,0]) 
                cube([frame_spacing_front,hinge_frame_length,hinge_height]);
                
            cylinder(d=hinge_diameter, h=hinge_height);
        }
        cylinder(d=hole_diameter, h=hinge_height);
        
        // cut outs for outer hinges
        cut_cylinder(d=hinge_space_diameter, h=outer_height+spacing, top=0);
        translate([0,0,hinge_height-outer_height-spacing])
            cut_cylinder(d=hinge_space_diameter, h=outer_height+spacing, bottom=0);
        
        translate([0,0,outer_height+spacing+inner_height-bearing_cut_height])
            cut_cylinder(d=bearing_cut_diameter, h=bearing_cut_height, bottom=0);
        
        translate([0,0,outer_height+spacing])
            cut_cylinder(d=bearing_cut_diameter, h=bearing_cut_height, top=0);
        
        
    }
}



hinge_test_spacing = 30;

difference() {
    union() {
        translate([0,hinge_test_spacing,0]) hinge_steer();
        hinge_frame();
    }
    
    // side cut
    //translate([0,-150,-10]) cube([100,300,200]);
    
    // back-cut
    //translate([-100.1,-150,-10]) cube([100,300,200]);
    
    %translate([0,0,outer_height+spacing]) bearing(model=625);
    %translate([0,0,outer_height+spacing+inner_height-5])
        bearing(model=625);
}









