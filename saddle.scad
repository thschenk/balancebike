include <variables.scad>;
use <frame.scad>;
use <wheels.scad>;
use <utils.scad>;

module saddle() {
    
    // widths
    a=70;
    b=40;
    c=50;
    
    // lengths
    d=150;
    e=50;
    
    // back side
    angle=40;
    
    // bottom
    h=20;
    bw=20;

    points_a = [
        [ a/2,  0],
        [ b/2,  d],
        [-b/2,  d],
        [-a/2,  0],
    ];

    points_b = [
        [ a/2,  0],
        [-a/2,  0],
        [-c/2, -e],
        [ c/2, -e]
    ];

     
    minkowski() {
        union() {
            
            hull() {
                linear_extrude(height=1)
                    polygon(points = points_a);
                
                
                translate([-bw/2,0,-h]) rotate([asin(h/d),0,0]) cube([bw, d, 1]);
            }
            
            rotate([-angle,0,0])
                linear_extrude(height=1)
                    polygon(points = points_b);
            
        }
        sphere(r=10, $fn=9);
    }
}

saddle_pin_width=40;
module saddle_pin() {
    saddle_pin_height = 170;
    translate([0,0,100-saddle_pin_height/2]) cube([2*wood_thickness,saddle_pin_width,saddle_pin_height], center=true);
}

saddle_offset = 0;

module saddle_complete() {
    color("SpringGreen") saddle_mount();
    color("SpringGreen") translate([0,-60, saddle_offset+110]) saddle();
    color(frame_color) translate([0,0, saddle_offset+5]) saddle_pin();
}





module saddle_mount_solid() {
    mount_length = 80;
    
    translate([0,-saddle_y,0])
        intersection() {
            frame_infill();
            
            translate([0,saddle_y,150])
                cube([frame_spacing_axis, mount_length, 300],center=true);
        }       
}

saddle_mount_wall_width=5;
saddle_mount_wood_spacing=0.3;

module saddle_mount() {
    difference() {
        saddle_mount_solid();
        
        linear_extrude(height=300,center=true,convexity=10)
          offset(r=3) offset(delta=-3)
            difference() {
            
                // inner wall
                offset(r=-saddle_mount_wall_width) 
                    projection()
                        saddle_mount_solid();
                
                // vertical pin support bars
                copy_mirror_y()
                    translate([wood_thickness+saddle_mount_wood_spacing+saddle_mount_wall_width/2,0])
                        square([saddle_mount_wall_width,300],center=true);
                
                // horizontal pin support bars
                copy_mirror_x()
                    translate([0,saddle_mount_wood_spacing+saddle_pin_width/2+saddle_mount_wall_width/2])
                        square([300,saddle_mount_wall_width],center=true);
                
                // horizontal pin support sides 
                copy_mirror_y()
                    translate([150+wood_thickness+saddle_mount_wood_spacing,0])
                        square([300,saddle_mount_wall_width],center=true);
            }
    }
}




//translate([0,-saddle_y,0])%frame_infill();
//saddle_complete();
//color("LightSlateGray", 0.3) back_wheel();

saddle_mount();
color(frame_color) translate([0,0, saddle_offset+5]) saddle_pin();

