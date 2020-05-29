use <MCAD/nuts_and_bolts.scad>;

nut_bump_M8();
translate([0,40,0]) bolt_M8();

module nut_bump_M8(h=10, tol=0.1) {
    
    rotate([0,-90,0]) 
        difference() {
            cylinder(d1=20+2*h, d2=20, h=h);
            
            translate([0,0,h+0.01])
                mirror([0,0,1]) 
                    rotate([0,0,90])
                        nutHole(8, tolerance=tol);
            
            translate([0,0,-1])
                cylinder(d=8+tol, h=h);
        }
}

module bolt_M8(length=30) {
    rotate([0,90,0])
        color("silver")
            union() {
                translate([0,0,-length])
                    cylinder(d=8,h=length-5);
                
                difference() {
                    translate([0,0,-5])
                        cylinder(d1=8,d2=15,h=5);
                    
                    cylinder(d=5, h=6, $fn = 6, center=true);
                }
            }
}