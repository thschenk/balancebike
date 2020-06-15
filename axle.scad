
include <variables.scad>;
use <frame.scad>;
use <wheels.scad>;
use <utils.scad>;





frame_y_offset = -2;

inner_h = (wood_thickness==9) ? 11 : 15;
outer_h = (wood_thickness==9) ? 12 : 12;

axle_clamp_inner_x = 53;
axle_clamp_outer_x = axle_clamp_inner_x+inner_h+0.4;

module axle_clamp_inner() {
    
    difference() {
        cylinder(d1=20,d2=20+2*inner_h,h=inner_h);
        
        
        cylinder(d=9.8, h=40,center=true);
        
        rotate([0,-90,0])
            translate([-axle_clamp_inner_x,frame_y_offset,0])
                frame_3d();
        
                
        // marking
        translate([0,-12.5,inner_h-0.5])
            cylinder(d=2, h=2, $fn=10);
        
    }
}

module axle_clamp_outer() {
    
    difference() {
        cylinder(d1=20+2*outer_h,d2=20,h=outer_h);
        
        
        cylinder(d=9.8, h=40,center=true);
        
        rotate([0,-90,0])
            translate([-axle_clamp_outer_x,frame_y_offset,0])
                frame_3d();
    }
}


module axle_clamps() {
    copy_mirror_y() {
        
        translate([axle_clamp_inner_x,0,0])
            rotate([0,90,0])
                axle_clamp_inner();

        translate([axle_clamp_outer_x,0,0])
                rotate([0,90,0])
                    axle_clamp_outer();
        
    }
}


axle_clamp_inner();

translate([70,0,0]) axle_clamp_outer();

translate([200,0,0]) difference() {
    union() {
        translate([0,frame_y_offset,0]) frame_3d();

        back_wheel(tire=false);

        %axle_clamps();

        
    }
    
    translate([-200,-200,0]) cube([400,400,400]);
}



module axle_clamps_print() {
    spacing=18;
    
    copy_mirror_y() {
        
        translate([spacing,-spacing,0])
            axle_clamp_inner();
        
        translate([spacing,spacing,outer_h])
            rotate([180,0,0])
                axle_clamp_outer();
    }
}



