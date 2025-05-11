// Newton MessagePad 2x00 reset button
// Copyright François Revol, 2025

/* [Printing options] */


// Optimize for FDM printers (less supports, larger details) - UNIMPLEMENTED
optimize_fdm = true;

/* [Preview] */

preview_parts = true;


/* [Hidden] */
$fs=$preview ? 0.5 : 0.2;

module mp2x00_reset_button() {
    difference() {
        cylinder(d=4.8, h=2.5);
        cylinder(d=1.44, h=1.9*2, center=true);
    }
    translate([4.8/2,0,1.35]) linear_extrude(1.15, scale=[1,1/1.1]) square([0.74*2, 1.1], center=true);
    minkowski() {
        radius = 0.4;
        difference() {
            translate([0,0,2.5]) cylinder(d=2.7-radius, h=0.7-radius);
            translate([0,0,2.5+0.1]) cylinder(d1=0.1, d2=3.5, h=0.7-0.1-radius+0.1);
        }
        sphere(r=radius);
    }
}

mp2x00_reset_button();
