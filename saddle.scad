include <variables.scad>;
use <frame.scad>;
use <wheels.scad>;
use <utils.scad>;
use <scad-utils/morphology.scad>;
use <MCAD/nuts_and_bolts.scad>;
use <hardware.scad>;

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
    saddle_frame_bolts();
}



mount_length = 110;

module saddle_mount_2d() {
    wall = 10;
    
    x0 = frame_spacing_axis/2 - saddle_y*sin(frame_angle);
    y1 = -mount_length/2;
    y2 = mount_length/2;
    x1 = x0 - y1*sin(frame_angle);
    x2 = x0 - y2*sin(frame_angle);
    
    y3 = -saddle_pin_width/2 - wall;
    y4 = saddle_pin_width/2 + wall;
    x3 = x0 - y3*sin(frame_angle);
    x4 = x0 - y4*sin(frame_angle);  
    
    copy_mirror_y() 
        polygon([[x1,y1], 
            [x1-8,y1],
            [x3-8,y3],
            [0, y3],
            [0, y4],
            [x4-8, y4],
            [x2-8,y2],
            [x2,y2]]);
    
  
}





module saddle_mount_solid() {    
    
        intersection() {
            translate([0,-saddle_y,0]) frame_infill();
            
            translate([0,0,150])
                cube([frame_spacing_axis, mount_length, 300],center=true);
            
            translate([0,0,0])
                linear_extrude(200, convexity=3)
                    fillet(r=10)
                        saddle_mount_2d();
        }       
}

bolt_y_offset = 15;
bolts_yz = [[-mount_length/2+bolt_y_offset, 44],
             [mount_length/2-bolt_y_offset,15]];
bolt_x_offset = 12;

x0 = frame_spacing_axis/2 - saddle_y*sin(frame_angle);


module saddle_mount() {    
    
    
    difference() {
        saddle_mount_solid();
        
        // nut holes
        copy_mirror_y() {
                for (bolt_yz=bolts_yz) {
                    bolt_x = x0 - bolt_yz[0]*sin(frame_angle) - bolt_x_offset;
                    translate([bolt_x, bolt_yz[0], bolt_yz[1]])
                        rotate([0,0,frame_angle])
                            rotate([0,90,0]) 
                                union() {
                                    rotate([0,0,90]) nutHole(8, tolerance=0.1);
                                    cylinder(d=8,h=40);
                                }
                }
        }
        
    }
    

}


module saddle_frame_bolts() {
        // bolts
    copy_mirror_y() {
                for (bolt_yz=bolts_yz) {
                    bolt_x = x0 - bolt_yz[0]*sin(frame_angle) - bolt_x_offset;
                    translate([bolt_x, bolt_yz[0], bolt_yz[1]])
                        rotate([0,0,frame_angle])
                            translate([28,0,0]) 
                                bolt_M8(length=25);
                }
        }
}


translate([0,-saddle_y,0]) %frame_3d();
saddle_complete();
//saddle_mount_2d();

translate([0,-saddle_y,0]) color("LightSlateGray", 0.3) back_wheel();

//saddle_mount();
//color(frame_color) translate([0,0, saddle_offset+5]) saddle_pin();

