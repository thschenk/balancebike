
module copy_mirror_y() {
    for(i=[0:1]) mirror(v= [i,0,0]) children();
};


module copy_mirror_x() {
    for(i=[0:1]) mirror(v= [0,i,0]) children();
};

module cut_cylinder(d,h,center=false,margin=0.1,bottom=1,top=1) {
    translate([0,0,-margin*bottom]) cylinder(d=d, h=h+(bottom+top)*margin,center=center);
}