include <variables.scad>;
use <utils.scad>;

module two_arc_frame(a, b, steer_angle, outer_x, outer_y) {

    inner_offset_y = a;
    inner_x = outer_x - b*sin(steer_angle);
    inner_y = outer_y - inner_offset_y + b*cos(steer_angle);

    outer_r = outer_x*outer_x/(2*outer_y) + outer_y/2;
    outer_angle = asin(outer_x/outer_r);

    inner_r = inner_x*inner_x/(2*inner_y) + inner_y/2;
    inner_angle = asin(inner_x/inner_r);

    n = 50;

    points_outer_arc = [
        for(a = [0:1:n])
            [outer_r * cos(outer_angle*a/n-90),
             outer_r * sin(outer_angle*a/n-90) + outer_r]
    ];
    points_inner_arc = [
        for(a = [n:-1:0])
            [inner_r * cos(inner_angle*a/n-90),
             inner_r * sin(inner_angle*a/n-90) + inner_r + inner_offset_y]
    ];

        
    polygon(concat(points_outer_arc, points_inner_arc));
}



module frame_2d() {
    outer_x = frame_length;
    outer_y = frame_height;
    d_axis = 22;

    $fn=60;

    difference() {
        union() {
            translate([0,-frame_a/2])
                two_arc_frame(a=frame_a,b=frame_b,steer_angle=steer_angle,
                    outer_x=outer_x,outer_y=outer_y+frame_a/2);
            circle(d=frame_a);
        }
        circle(d=d_axis);
    }
}

module frame() {
    rotate([90,0,0]) rotate([0,90,0])
        linear_extrude(height=wood_thickness, convexity=10) {
            frame_2d();
        }
}



module frame_3d() {
    copy_mirror_y()
        translate([frame_spacing_axis/2,0,0])
            rotate([0,0,frame_angle])
                frame();

}

module frame_infill() {
//    copy_mirror_y()
//        translate([frame_spacing_axis/2,0,0])
//            rotate([0,0,frame_angle])
    
    rotation_point = frame_spacing_axis/2 / tan(frame_angle);
    
    magical_extra_translation = 2.5;
    
    echo(frame_angle);
    echo(tan(frame_angle));
    echo(rotation_point);
    
    rotate([0,0,90])
        translate([rotation_point-magical_extra_translation,0,0])
            rotate([0,0,-frame_angle])
                rotate_extrude(angle=frame_angle*2, convexity=3)
                    translate([-rotation_point,0])
                        frame_2d();

}


rotate([0,0,-17]) frame_2d();
//frame();
//frame_3d();
//frame_infill();







