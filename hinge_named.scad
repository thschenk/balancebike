use <hinge.scad>;

module hinge_steer_cut_mask(connections=true) {
    font="Arial Rounded MT Bold:style=Regular";
    
    difference() {
        text("DAAN", halign="center", valign="center", font=font, size=17);


        if (connections) {
            width=1;

            // connect the D
            d_x = -26;
            for (ax=[d_x]) 
                translate([ax+width/2,0]) 
                    square([width, 30], center=true);                

            
            // connect the A's
            for (ax=[-8.8, 7.75]) 
                translate([ax,0]) 
                    square([width, 30], center=true);        
            
            // connect the N
    //        for (ax=[21]) 
    //            translate([ax+width/2,0]) 
    //                square([width, 30], center=true);                
        }
    }
    
    // fill the D gap
//    dx1=-30;
//    dx2=-20.4;
//    dy=6.5;
//    *translate([dx1,-dy]) square([dx2-dx1,2*dy]);
//    
//    // fill the A gaps
//    ay1=-3;
//    ay2=7;
//    adx=4;    
//    *for (ax=[-9, 8]) 
//        translate([ax,0]) 
//            polygon([[-adx, ay1], [adx, ay1], [0, ay2]]);
}

module hinge_steer_named() {
    
    cut_offset_y = 60 - 1.5;
    
    cut_offset_z = 40;
    
    cut_depth = 10;
    
    
    difference() {
        hinge_steer();
        
        translate([0,cut_offset_y, cut_offset_z])
            rotate([0,0,180])
                rotate([90,0,0]) {
                    
                    translate([0,0,-cut_depth])
                        linear_extrude(cut_depth+0.1, convexity=10)
                            hinge_steer_cut_mask(connections=true);
                    
                    translate([0,0,0])
                        linear_extrude(cut_depth, convexity=10)
                            hinge_steer_cut_mask(connections=false);
                }
    }
}



color("DodgerBlue") translate([0,100,0]) rotate([0,0,180]) hinge_steer_named();

color("white") translate([0,51,40]) cube([80,10,100], center=true);

hinge_steer_cut_mask();

translate([0,-80]) {
    rotate([0,0,180])
    difference() {
        square([100,70],center=true);
        hinge_steer_cut_mask();        
    }
}