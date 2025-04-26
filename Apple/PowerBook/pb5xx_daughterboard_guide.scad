// PowerBook 5xx daughterboard guide
// Copyright François Revol, 2025

/* [Printing options] */

// Optimize for FDM printers (less supports, larger details) - UNIMPLEMENTED
optimize_fdm = true;

/* [Preview] */


/* [Hidden] */
$fs=0.1;

module pb5xx_daughterboard_guide() {
    difference() {
        linear_extrude(4.8, scale=[1,0.905]) square([52,2.5], center=true);
        translate([0,0,2.6]) linear_extrude(1.4) square([43.3,5], center=true);
        translate([0,0,2.6]) linear_extrude(4) square([40.3,5], center=true);
    }
    for (dx=[-1,1]) {
        // screw post
        translate([dx*54/2,0,0]) difference() {
            cylinder(d1=5.1,d2=4.8,h=8.8);
            translate([0,0,-1]) cylinder(d=2,h=10);
        }
        translate([dx*51/2,0,4.8]) difference() {
            linear_extrude(4, scale=[0.3,0.905]) square([10,0.8], center=true);
            translate([dx*10/2,0,0]) cube(10, center=true);
        }
        translate([dx*62/2,0,0]) difference() {
            linear_extrude(8.8, scale=[1,1.1/1.4]) square([3.5,1.4], center=true);
            translate([dx*1.8,0,-0.1]) linear_extrude(0.8, scale=[0.1,1]) square([5.2,2], center=true);
        }
        translate([dx*(68-1.6)/2,0,0.7])
            linear_extrude(8.3, scale=[1.1/1.4,3.3/3.6]) square([1.4,3.6], center=true);
    }
    //DEBUG:bbox
    //if ($preview) color("green", 0.2) translate([0,0,9/2]) cube([67.8,5.2,9], center=true);
}

pb5xx_daughterboard_guide();