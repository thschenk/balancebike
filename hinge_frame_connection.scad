use <utils.scad>;
include <variables.scad>;
use <frame.scad>;



function frame_block_width() = 45;
frame_translate_y = -frame_length*cos(frame_angle);


*%rotate([-steer_angle,0,0])
    translate([0,frame_translate_y,-frame_height])
        frame_3d();

basic_frame_connection_block();




module basic_frame_connection_block() {
    difference() {
        basic_frame_connection_block_a();
            
        translate([0,0,-1])
            linear_extrude(height=100)
                offset(r=-7)
                    projection(cut=true)
                        basic_frame_connection_block_a();
    }

    basic_frame_connection_block_b();
}

module basic_frame_connection_block_a() {
    
    length = 60;
    
    intersect_cube_width = frame_spacing_axis;
    
    intersection() {
        rotate([-steer_angle,0,0])
            translate([0,frame_translate_y,-frame_height])
                frame_infill();
            
        
        translate([0,-length/2,frame_b])
            cube([intersect_cube_width,length,2*frame_b],center=true);
    }   
}


module basic_frame_connection_block_b() {
    
    bw = frame_block_width();
    difference() {
        translate([-bw/2,-0.1,0])
            cube([bw,10,frame_b]);
        
        rotate([-steer_angle,0,0])
            translate([0,frame_translate_y,-frame_height])
                frame_3d();


        ax=frame_spacing_front/2;
        bx=ax+frame_b*sin(steer_angle)*sin(frame_angle);
        
        copy_mirror_y()
            translate([bx,0,frame_b])
                rotate([0,0,frame_angle])
                    translate([0,-20,-2])
                        cube([wood_thickness+1,20,4]);
    }
    
}

