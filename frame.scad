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
    a=90;
    b=70;
    outer_x = frame_length;
    outer_y = frame_height;
    d_axis = 22;

    difference() {
        union() {
            translate([0,-a/2])
                two_arc_frame(a=a,b=b,steer_angle=steer_angle,
                    outer_x=outer_x,outer_y=outer_y+a/2);
            circle(d=a);
        }
        circle(d=d_axis);
    }
}

module frame() {
    thickness=15;
    rotate([90,0,0]) rotate([0,90,0])
        linear_extrude(height=thickness) {
            frame_2d();
        }
}

//two_arc_frame();
//frame_2d();

//
//module frame() {
//    copy_mirror_y() {
//        translate([frame_spacing_axis/2,0,0])
//            rotate([0,0,frame_angle])
//                single_frame();
//    };
//}
//








