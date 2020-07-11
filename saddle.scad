include <variables.scad>;
use <frame.scad>;
use <wheels.scad>;
use <utils.scad>;
use <scad-utils/morphology.scad>;
use <MCAD/nuts_and_bolts.scad>;
use <hardware.scad>;

saddle_pin_width=35;
saddle_pin_thickness=27;
saddle_pin_spacing=0.3;


mount_length = 110;
bolt_y_offset = 15;
bolts_yz = [[mount_length/2-bolt_y_offset,15],
            [mount_length/2-bolt_y_offset,60],
            [-mount_length/2+bolt_y_offset, 25]];
bolt_x_offset = 10;

x0 = frame_spacing_axis/2 - saddle_y*sin(frame_angle);

wall = 7;

module saddle() {
    r = 5;
    w1 = 40;
    w2 = 80;
    length = 160;
    y_offset = 20;
    
    hull() 
        copy_mirror_y() {
            translate([w1/2-r, length/2-r+y_offset,0])
                cylinder(r=r, h=wood_thickness);
            translate([w2/2-r, -length/2-r+y_offset,0])
                cylinder(r=r, h=wood_thickness);
        }
}

module saddle_to_pin_connection() {
    wall_width = 4;
    height = 20;
    r = 13;
    $fn=50;
    
    difference() {
        
        hull()
            for (x=[-1,1])
                for (y=[-1,1])
                    translate([x*(saddle_pin_thickness/2+wall_width-r),y*(32+wall_width-r)])
                        cylinder(r=r, h=height);
        
        cube([saddle_pin_thickness+saddle_pin_spacing,
            saddle_pin_width+saddle_pin_spacing, 200],center=true);
        
        for (i=[-1,1])
            translate([0,i*27,6]) {
                scale([1,1,3]) nutHole(8, tolerance=0.1);
                cylinder(d=8.2,h=40,center=true);
            }
            
        
        for (i=[-1,1])
            translate([0,i*8, height*3/5])
                rotate([0,90,0]) rotate([0,0,90]) 
                    safecylinder(d=5,h=80,center=true,$fn=20);
        
    }
}


module saddle_pin() {
    saddle_pin_height = 170;
    translate([0,0,100-saddle_pin_height/2])
        cube([saddle_pin_thickness,saddle_pin_width,saddle_pin_height], center=true);
}


module saddle_mount_2d() {
    
    
    
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
            [x1-wall,y1],
            [x3-wall,y3],
            [0, y3],
            [0, y4],
            [x4-wall, y4],
            [x2-wall,y2],
            [x2,y2]]);
    
  
}





module saddle_mount_solid() {    
    
        intersection() {
            translate([0,-saddle_y,0]) frame_infill();
            
            translate([0,0,150])
                cube([frame_spacing_axis, mount_length, 300],center=true);
            
            translate([0,0,0])
                linear_extrude(200, convexity=3)
                    fillet(r=10, $fn=60)
                        saddle_mount_2d();
        }       
}



module saddle_mount() {    
    $fn=30;
    
    difference() {
        saddle_mount_solid();
        
        // pin hole
        cube([saddle_pin_thickness+saddle_pin_spacing, saddle_pin_width+saddle_pin_spacing, 200],center=true);
        
        // material saving
        copy_mirror_y() {
            r=3;
            h=200;
            
            y1 =  saddle_pin_width/2-r;
            y2 = -saddle_pin_width/2+r;
            x1a = saddle_pin_thickness/2+wall+r;
            x2a = saddle_pin_thickness/2+wall+r;

            x1b = x0 - y1*sin(frame_angle) - wall - r;
            x2b = x0 - y2*sin(frame_angle) - wall - r;

            hull() {
                $fn=30;
                translate([x1a,y1]) cylinder(r=r,h=h,center=true);
                translate([x2a,y2]) cylinder(r=r,h=h,center=true);
                translate([x1b,y1]) cylinder(r=r,h=h,center=true);
                translate([x2b,y2]) cylinder(r=r,h=h,center=true);
            }
        }
        
        // nut holes
        copy_mirror_y() {
                for (bolt_yz=bolts_yz) {
                    bolt_x = x0 - bolt_yz[0]*sin(frame_angle) - bolt_x_offset;
                    translate([bolt_x, bolt_yz[0], bolt_yz[1]])
                        rotate([0,0,frame_angle])
                            rotate([0,90,0]) 
                                rotate([0,0,90]) 
                                union() {
                                    nutHole(8, tolerance=0.1);
                                    safecylinder(d=8,h=40);
                                }
                }
        }
        
        // bolt holes for pin
        bolt_hole_heights = [20, 50];
        for (bolt_hole_height=bolt_hole_heights)
            translate([0,0,bolt_hole_height]) {
                rotate([-90,0,0]) rotate([0,0,180])
                    safecylinder(d=5,h=80,center=false);
                
                translate([0,saddle_pin_width/2 + wall - 5 +0.3,0])
                    rotate([-90,0,0])
                        cylinder(d1=5,d2=8,h=5,center=false);
                
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


saddle_offset = 50;

module saddle_complete() {
    color("SpringGreen") saddle_mount();
    color(frame_color) translate([0, 0, saddle_offset+100]) saddle();
    color(frame_color) translate([0,0, saddle_offset]) saddle_pin();
    color("SpringGreen") translate([0, 0, saddle_offset+100]) rotate([180,0,0]) saddle_to_pin_connection();
    saddle_frame_bolts();
}



translate([0,-saddle_y,0]) %frame_3d();
saddle_complete();
//saddle_mount_2d();

translate([0,-saddle_y,0]) color("LightSlateGray", 0.3) back_wheel();

//saddle_mount();
//color(frame_color) translate([0,0, saddle_offset+5]) saddle_pin();

translate([100,0,0]) saddle_to_pin_connection();
