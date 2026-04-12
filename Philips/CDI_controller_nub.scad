// CD-i controller joystick nub
// Copyright François Revol, 2026


optimize_fdm = true;

$fn=$preview?60:360;

module nub() {
    difference() {
        r1=optimize_fdm?10:20;
        r2=30;
        union() {
            translate([0,0,0]) cylinder(d1=optimize_fdm?10:9.6,d2=15.5, h=optimize_fdm?1:0.8);
            translate([0,0,optimize_fdm?1:0.8]) cylinder(d1=15.5,d2=15.9, h=optimize_fdm?0.6:.8);
            difference() {
                translate([0,0,1.6]) cylinder(d1=15.9,d2=12.5, h=optimize_fdm?1.2:.8);
                /*if (!optimize_fdm)*/ translate([0,0,r2+1.71]) sphere(r=r2);
            }
            translate([0,0,1]) cylinder(d1=optimize_fdm?6.5:5.9,d2=5,h=7.2+1);
            translate([0,0,2+7.2]) cylinder(d1=5,d2=3.5,h=0.38);
        }
        translate([0,0,(optimize_fdm?1:0.58)-r1]) sphere(r=r1);

        //translate([0,0,9.58-5.35]) cylinder(d=3.3,h=5.351);
        margin = optimize_fdm?0.18:0;
        d1 = 3.3+margin;
        translate([0,0,9.58-1.1]) cylinder(d=d1,h=1.21);
        translate([0,0,9.58-1.1-0.2]) cylinder(d1=3.15+margin/2,d2=d1,h=.21);
        difference() {
            translate([0,0,9.58-1.1-0.2-1.8]) cylinder(d=d1,h=1.81);
            if (optimize_fdm) for (a=[0:120:359])
                rotate([0,0,a]) translate([d1/2,0,0]) cylinder(d=0.4,h=10);
        }
        translate([0,0,9.58-1.1-0.2-1.8-0.2]) cylinder(d1=3.15+margin/2,d2=d1,h=.21);
        translate([0,0,9.58-5.35]) cylinder(d=d1,h=5.351-3.25);

        if ($preview) cube(20);
    }

    //if ($preview) color("green",0.2) cylinder(d=15.9, h=9.58);
    //if ($preview) color("green",0.2) cylinder(d=15.9, h=2.35);
}

translate([0,0,9.58]) rotate([0,180,0]) nub();