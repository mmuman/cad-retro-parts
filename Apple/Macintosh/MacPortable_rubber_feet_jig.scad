// Test jig for Rubber feet for the Macintosh Portable
// Copyright François Revol, 2026

$fn=60;

translate([0,10,0]) difference() {
    h = 4.2-0.3;
    linear_extrude(h) square([22,8],center=true);
    translate([0,0,h-1.15]) hull() for(dx=[-1,1]) translate([dx*15/2,0,0]) cylinder(d=3.8,h=2);
    for(dx=[-1,1]) translate([dx*10.25/2,0,0]) cube([3,2.4,10], center=true);
}


module face(z,h,d,ox=0) {
    angle = 84;
    angles = [0,-180+angle];
    o = [-1,1];
    difference() {
        union() {
            for (i=[0,1]) {
                translate([0,0,z]) rotate([0,angles[i],0]) translate([o[i]*10/2,0,-h]) linear_extrude(h) square([10,8],center=true);
            }
            translate([0,0,z]) difference() {
                rotate([90,0,0]) cylinder(r=h,h=8, center=true);
                translate([-10/2,0,10/2]) cube(10, center=true);
            }
        }
        hull() {
            for (i=[0,1]) {
                translate([0,0,z]) rotate([0,angles[i],0]) translate([o[i]*(9.5/2-ox),0,-10]) cylinder(d=d,h=22, center=true);
            }
        }
    }
}

{
    h = 3.2;

    face(h, h, d=4);
    face(h, h-1, d=1.5, ox=1); // opening is square but well
    if ($preview) color("orange", 0.2) translate([-1.6,0,0]) cube([9.75,10,20],center=true);
    if ($preview) color("blue", 0.2) translate([-0.2,0,0]) cube([7,10,20],center=true);
}


