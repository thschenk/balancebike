use <utils.scad>;
include <variables.scad>;
use <frame.scad>;


frame_translate_y = -frame_length*cos(frame_angle);


%translate([0,frame_translate_y,-frame_height]) copy_mirror_y() {
    translate([frame_spacing_axis/2,0,0]) rotate([0,0,frame_angle]) frame();
};


basic_frame_connection_block();

old_block();

module x_sym_cube(ax,ay,az,bx,by,bz,cx,cy,cz,dx,dy,dz) {
    CubePoints = [
      [-ax, ay,  az ],  //0
      [ ax,  ay,  az ],  //1
      [ dx,  dy,  dz ],  //2
      [-dx,  dy,  dz ],  //3
      [-bx,  by,  bz ],  //4
      [ bx,  by,  bz ],  //5
      [ cx,  cy,  cz ],  //6
      [-cx,  cy,  cz ]]; //7
      
    CubeFaces = [
      [0,1,2,3],  // bottom
      [4,5,1,0],  // front
      [7,6,5,4],  // top
      [5,6,2,1],  // right
      [6,7,3,2],  // back
      [7,4,0,3]]; // left
      
    hull() {
        polyhedron( CubePoints, CubeFaces );
    }
}

module basic_frame_connection_block() {
    
    length = 60;
    
    
    intersect_cube_width = frame_spacing_front + 10;
    
    intersection() {
        translate([0,frame_translate_y,-frame_height]) frame_infill();
        
        
        translate([0,-length/2,0])
            cube([intersect_cube_width,length,2*frame_b],center=true);
    }
    
    
}
    
function frame_block_width() = 2 *( frame_spacing_front/2 + wood_thickness*cos(frame_angle));





module old_block() {
    

    angle = 25;

    c_length = 50;
    d_length = 40;
    
    ax=frame_spacing_front/2;
    ay=0;
    az=0;
    bx=ax+frame_b*sin(steer_angle)*sin(frame_angle);
    by=-frame_b*sin(steer_angle);
    bz=frame_b*cos(steer_angle);
    cy = -c_length*cos(angle) ;
    cx = ax + c_length *sin(frame_angle);
    cz = bz - c_length*sin(angle);
    dx = ax + d_length *sin(frame_angle);;
    dy = -d_length;
    dz = -d_length*sin(steer_angle);

//    qx = 5;
//    qy = 5;
//    qz = 20;
    difference() {
        x_sym_cube(ax,ay,az,bx,by,bz,cx,cy,cz,dx,dy,dz);
        //x_sym_cube(ax-qx,ay-qy,az-qz,bx-qx,by-qy,bz+qz,cx-qx,cy+qy,cz+qz,dx-qx,dy+qy,dz-qz);
    }
    
    
    ex = ax + wood_thickness*cos(frame_angle);
    ey =  0 + wood_thickness*sin(frame_angle);
    ez = 0;
    
    fx = bx + wood_thickness*cos(frame_angle);
    fy = frame_b*sin(-steer_angle) + wood_thickness*sin(frame_angle);
    fz = frame_b*cos(frame_angle)*cos(steer_angle);  
  
    hull() {
        x_sym_cube(ax,ay,az,ex,ey,ez,fx,fy,fz,bx,by,bz); 
       
        translate([-ex,ey,])
            rotate([steer_angle,0,0])
                cube([2*ex,3,frame_b]);
    }
}
