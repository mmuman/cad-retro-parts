// Tip for the Thomson LightPen v2
// Copyright 2025, François Revol

// TODO
optimize_fdm = true;


$fn = 60;

module lightpen_tip() {
    difference() {
        union() {
            cylinder(d1=5.5, d2=7.5, h=5.9);
            translate([0,0,5.9]) cylinder(d=6.6, h=2);
            translate([0,0,7.9]) cylinder(d1=6.6, d2=5.5, h=1.1);
            translate([0,0,9]) cylinder(d=5.5, h=3.6);
        }
        difference() {
            translate([0,0,-0.1]) cylinder(d1=4.8, d2=4.5, h=12.8);
            for(a=[45:90:360]) {
                echo(a);
                rotate([0,0,a]) translate([2.5,0,9.5]) sphere(d=1.4);
            }
        }
        translate([0,0,8.5]) hull() for (dz = [0,1])
            translate([0,0,dz*5]) rotate([0,90,0]) cylinder(d=0.8+dz*0.4,h=8, center=true);
        if ($preview) cube(20);
    }
    //if ($preview) color("pink", 0.2) cylinder(d=3.5, h=12.6);
    //if ($preview) color("green", 0.2) cylinder(d=7.5, h=12.6);
}

lightpen_tip();
