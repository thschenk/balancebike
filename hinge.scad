use <MCAD/bearing.scad>;
use <scad-utils/morphology.scad>;
use <utils.scad>;
include <variables.scad>;
use <frame.scad>;
use <hinge_frame_connection.scad>;

hinge_height = 70;
outer_height = 12;
spacing = 1;
inner_height = hinge_height-2*outer_height-2*spacing;

hinge_diameter = 24;
hole_diameter = 5.3;
hinge_space_diameter = hinge_diameter + 2;

bearing_cut_diameter = 16.3;
bearing_cut_height = 5.2;

$fn=50;


wall_width = 5;

module hinge_steer_shape_flat() {
    fillet(r=6) union() {
        
        difference() { 
            translate([-fork_spacing/2,10])
                square([fork_spacing, fork_width]);
            
            translate([-fork_spacing/2+wall_width,10+wall_width])
                square([fork_spacing-2*wall_width, fork_width-2*wall_width]);
        
        }
        
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
        
        
        extra_diameter = 25;
        // cut out for inner hinge
        translate([0,-extra_diameter/2,outer_height])
            cylinder(d=hinge_space_diameter+extra_diameter, h=inner_height+2*spacing);
        
        // cut out for square inner hinge
//        cut_w=60;
//        cut_d=4.99;
//        translate([-cut_w/2,-1,outer_height])
//            cube([cut_w,cut_d+1,inner_height+2*spacing]);        
    }
}


function hinge_frame_y_offset() = 16;



module hinge_frame() {
    //hinge_frame_length = 50;
    
    fbw = frame_block_width();
    
    difference() {
        union() {
            
            translate([0,-18]) 
                rotate([0,0,0])
                    basic_frame_connection_block();        
            
            cylinder(d=hinge_diameter, h=hinge_height);
            
            translate([-fbw/2,-17,0]) cube([fbw,17,hinge_height]);
            
            
        }
        cylinder(d=hole_diameter, h=hinge_height);
        
        copy_mirror_y() {
            translate([fbw/2+5,0,0])
               cut_cylinder(d=fbw-hinge_diameter+2*5,h=hinge_height);
        }
        
        
        extra_diameter = 25;
        // cut outs for outer hinges
        translate([0,extra_diameter/2,0])
            cut_cylinder(d=hinge_space_diameter+extra_diameter, h=outer_height+spacing, top=0);
        
        translate([0,extra_diameter/2,hinge_height-outer_height-spacing])
            cut_cylinder(d=hinge_space_diameter+extra_diameter, h=outer_height+spacing, bottom=0);
        
        
        // cut outs for bearings
        translate([0,0,outer_height+spacing+inner_height-bearing_cut_height])
            cut_cylinder(d=bearing_cut_diameter, h=bearing_cut_height, bottom=0);
        
        translate([0,0,outer_height+spacing])
            cut_cylinder(d=bearing_cut_diameter, h=bearing_cut_height, top=0);
        
        
    }
}



hinge_test_spacing = 20;
hinge_test_rotation = 0;

difference() {
    union() {
        color("DodgerBlue") translate([0,hinge_test_spacing,0])
            rotate([0,0,hinge_test_rotation])
                hinge_steer();
        
        color("SpringGreen") hinge_frame();

        // two bearings
        bearing_heights = [outer_height+spacing, outer_height+spacing+inner_height-5];
        for(bearing_height=bearing_heights) 
            color("silver")
                translate([0,0,bearing_height]) bearing(model=625);
        

    }
    
    // side cut
    //translate([0,-150,-10]) cube([100,300,200]);
    
    // back-cut
    //translate([-100.1,-150,-10]) cube([100,300,200]);
    
    // top-cut
    //translate([-100.1,-150,35]) cube([200,300,200]);
    
}












