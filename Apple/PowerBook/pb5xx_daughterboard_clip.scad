// PowerBook 5xx Modem port cover
// Copyright François Revol, 2025

/* [Printing options] */

// Optimize for FDM printers (less supports, larger details) - UNIMPLEMENTED
optimize_fdm = true;

/* [Hidden] */
$fs = $preview ? 0.5 : 0.1;
$fa = $preview ? 12 : 6;


module pb5xx_daughterboard_clip() {
    radius = 0.2;
    difference() {
        union() {
            minkowski() {
                hull() {
                    translate([3/2,0,3.4/2-radius]) cube([3,3,3.4]-radius*[0,2,0], center=true);
                    translate([8.7-3/2,0,-radius]) cylinder(d=3-2*radius, h=3.4);
                }
                sphere(radius);
            }
            translate([2.8-1.3/2,0,3.4+1.4-1.3*(0.2/2)]) scale([1,1,0.2]) sphere(d=1.3);
            // little nub
            translate([2.8-1.3/2,0,3.4]) cylinder(d=1.3, h=1.4-1.3*(0.2/2));
            // T shaped thingy
            translate([8-1.8/2,0,3.4]) cylinder(d=1.8, h=1.7);
            hull() {
                for (dx=[-1,1])
                    translate([8-1.8/2+dx*1.4,0,3.4+1.8-0.8-dx*0.2]) cylinder(d=1.8, h=0.7+dx*0.2);
            }
        }
        // shave the minkowski
        translate([10/2,0,-1/2]) cube([10,5,1], center=true);
        translate([-1/2,0,5/2-1]) cube([1,5,5], center=true);
        // bottom cutouts
        translate([4.9+5/2,0,0]) cube([5,5,1.8*2], center=true);
        translate([0,0,0]) cube([3*2,5,1.2*2], center=true);
        translate([3.2-1.4/2,0,0]) cube([1.4,5,2.2*2], center=true);
        translate([1.8,0,1.2-0.1]) linear_extrude(1.1, scale=[0.01,1]) square([1.4,5], center=true);
    }
    //if ($preview) color("green", 0.2) translate([9.4/2,0,5.1/2]) cube([9.4,3,5.1], center=true);
}

translate([0,0,$preview?0:3/2])
    rotate([$preview?0:90,0,0])
        pb5xx_daughterboard_clip();