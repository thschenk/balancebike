use <MCAD/bearing.scad>;
use <scad-utils/morphology.scad>;
use <utils.scad>;
include <variables.scad>;
use <frame.scad>;
use <hinge_frame_connection.scad>;
use <hardware.scad>;
use <MCAD/nuts_and_bolts.scad>;


hinge_height = 70;
outer_height = 12;
spacing = 1;
inner_height = hinge_height-2*outer_height-2*spacing;

hinge_diameter = 24;
hole_diameter = 5.3;
hinge_space_diameter = hinge_diameter + 2;

bearing_cut_diameter = 16.3;
bearing_cut_height = 5.2;
bearing_cut_diameter_inner = 12;

$fn=50;


back_wall_width = 6;
front_wall_width = 4;

side_wall_width = 10;

module hinge_steer_shape_flat() {
    fillet(r=7) union() {
        
        difference() { 
            translate([-fork_spacing/2,10])
                square([fork_spacing, fork_width]);
            
            translate([-fork_spacing/2+side_wall_width,10+back_wall_width])
                square([fork_spacing-2*side_wall_width, fork_width-back_wall_width-front_wall_width]);
        
        }
        
        circle(d=hinge_diameter);
        
        translate([-hinge_diameter/2, 10])
            square([hinge_diameter, 4]);

    }
}


//hinge_steer_shape_flat();

steer_nut_z = [20, hinge_height-20];
steer_nut_y = 10+fork_width/2;

module hinge_steer() {
    
    
    color("DodgerBlue") difference() {
        
        union() {
            linear_extrude(height=hinge_height, convexity=10) {
                hinge_steer_shape_flat();
            }
        }
        
        // bolt hole
        cut_cylinder(d=hole_diameter, h=hinge_height);
        
        // bolt hole square
        translate([0,0,hinge_height+2-3.75])
            cube([5.8, 5.8, 4], center=true);
        
        extra_diameter = 25;
        
        // cut out for inner hinge
        translate([0,-extra_diameter/2,outer_height])
            cylinder(d=hinge_space_diameter+extra_diameter, h=inner_height+2*spacing);


            copy_mirror_y() {
                nut_x = fork_spacing/2-side_wall_width-0.01;
                
                for (z=steer_nut_z)
                    translate([nut_x,steer_nut_y, z])
                        rotate([0,90,0]) 
                            union() {
                                rotate([0,0,90]) nutHole(8, tolerance=0.1);
                                cylinder(d=8,h=80,center=true);
                            }
             }

               
    }
    
    
}

module hinge_steer_bolts() {
    copy_mirror_y() {
        nut_x = fork_spacing/2+0.05+15;
        
        for (z=steer_nut_z)
            translate([nut_x,steer_nut_y, z])
                    rotate([0,0,0]) 
                             bolt_M8(length=25);
     }    
}


function hinge_frame_y_offset() = 16;


nut_x = 6.7-3.5;
nut_y = -48;
nut_z = [10, 40];
nut_from_top_bottom = 20;



module hinge_frame() {
    //hinge_frame_length = 50;
    
    fbw = frame_block_width();
    
    


    color("SpringGreen")
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
            cut_cylinder(d=hinge_space_diameter+extra_diameter,
                   h=outer_height+spacing, bottom=0);
        
        
        // cut outs for bearings
        translate([0,0,outer_height+spacing+inner_height-bearing_cut_height])
            cut_cylinder(d=bearing_cut_diameter, h=bearing_cut_height, bottom=0);
        
        translate([0,0,outer_height+spacing+inner_height-bearing_cut_height-1])
            cut_cylinder(d=bearing_cut_diameter_inner, h=bearing_cut_height, bottom=0);
        
        
        translate([0,0,outer_height+spacing])
            cut_cylinder(d=bearing_cut_diameter, h=bearing_cut_height, top=0);
        
        translate([0,0,outer_height+spacing+1])
            cut_cylinder(d=bearing_cut_diameter_inner, h=bearing_cut_height, top=0);
        
        
        // nut holes
        copy_mirror_y() {
                for (z=nut_z)
                    translate([nut_x, nut_y, z])
                        rotate([0,0,frame_angle]) 
                            rotate([0,90,0]) 
                                union() {
                                    rotate([0,0,90]) nutHole(8, tolerance=0.1);
                                    //cylinder(d=8,h=40);
                                    rotate([0,0,90]) safecylinder(d=8,h=40);
                                }
        }
             
        
        // cut top
        //translate([0,0,200-55]) cube([200,200,200],center=true);
        
    }
    
}


module frame_bolts() {
            // nut holes
        copy_mirror_y() {
                for (z=nut_z)
                    translate([30, nut_y+2, z])
                        rotate([0,0,frame_angle]) 
                            rotate([0,0,0]) 
                                    bolt_M8(length=25);
        }
}


hinge_test_spacing = 30;
hinge_test_rotation = 0;


*hinge_steer_shape_flat();

difference() {
    union() {
        translate([0,hinge_test_spacing,0])
            rotate([0,0,hinge_test_rotation]) {
                hinge_steer();
                hinge_steer_bolts();
            }
        
        hinge_frame();
        
        *frame_bolts();

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












