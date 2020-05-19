

module back_wheel() {
    rotate([0,90,0]) {
        cylinder(d=310, h=55, center=true);
        cylinder(d=60, h=58, center=true);
        cylinder(d=9.5, h=175, center=true);
        
        translate([0,0,29]) cylinder(d=38, h=14);
        translate([0,0,29+14]) cylinder(d=20, h=10);
        
        translate([0,0,-29-15]) cylinder(d=36, h=15);
        translate([0,0,-29-15-10]) cylinder(d=20, h=10);
        
    }
}


module front_wheel() {
    rotate([0,90,0]) {
        cylinder(d=310, h=55, center=true);
        cylinder(d=30.5, h=75.5, center=true);
        cylinder(d=16, h=100, center=true);
        cylinder(d=8, h=140, center=true);
    }
}


back_wheel();

translate([0,400,0]) front_wheel();
