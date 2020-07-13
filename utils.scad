
module copy_mirror_y() {
    for(i=[0:1]) mirror(v= [i,0,0]) children();
};


module copy_mirror_x() {
    for(i=[0:1]) mirror(v= [0,i,0]) children();
};

module cut_cylinder(d,h,center=false,margin=0.1,bottom=1,top=1) {
    translate([0,0,-margin*bottom]) cylinder(d=d, h=h+(bottom+top)*margin,center=center);
}


module safecylinder(d, h, center = false) {
 r = d/2;
 x1 = r*cos(180/4);
 x2 = 2*x1 - r;
 y = x1;
 
 cylinder(d=d, h=h, center=center);
 linear_extrude(h, center=center) polygon([[-x1,y],[x1,y],[x2,d/2],[-x2,d/2]]);
}

module round_cube(l=40,w=30,h=20,r=5,$fn=30){
	hull(){ 
		translate ([r, r, 0]) cylinder (h = h, r=r);
		translate ([r, w-r, 0]) cylinder (h = h, r=r);
		translate ([l-r,w-r, 0]) cylinder (h = h, r=r);
		translate ([l-r, r, 0]) cylinder (h = h, r=r);
	}
}