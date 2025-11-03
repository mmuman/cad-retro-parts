// Tip for the Thomson LightPen v2
// Copyright 2025, François Revol

// Make it sturdier, should avoid breaking when inserting.
optimize_fdm = false;


$fn = 60;

module lightpen_tip() {
    d1_extra = 0;//optimize_fdm ? 1 : 0;
    d2 = optimize_fdm ? 6.0 : 5.5;
    s1_d = optimize_fdm ? 1.2 : 1.4;

    difference() {
        union() {
            cylinder(d1=5.5+d1_extra, d2=7.5+d1_extra, h=5.9);
            translate([0,0,5.9]) cylinder(d=6.6, h=2);
            translate([0,0,7.9]) cylinder(d1=6.6, d2=d2, h=1.1);
            translate([0,0,9]) cylinder(d=d2, h=3.6);
        }
        difference() {
            translate([0,0,-0.1]) cylinder(d1=4.8, d2=4.5 + (optimize_fdm ? 0.3 : 0), h=12.8);
            for(a=[45:90:360]) {
                echo(a);
                rotate([0,0,a]) translate([2.5,0,9.5]) sphere(d=s1_d);
            }
        }
        if (!optimize_fdm) translate([0,0,8.5]) hull() for (dz = [0,1])
            translate([0,0,dz*5]) rotate([0,90,0]) cylinder(d=0.8+dz*0.4,h=optimize_fdm ? 5 : 8, center=true);
        if ($preview) cube(20);
    }
    //if ($preview) color("pink", 0.2) cylinder(d=3.5, h=12.6);
    //if ($preview) color("green", 0.2) cylinder(d=7.5, h=12.6);
}

lightpen_tip();
