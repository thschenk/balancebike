

module two_arc_frame(a=80, b=60, steer_angle=13, outer_x=700, outer_y=200) {

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

two_arc_frame();