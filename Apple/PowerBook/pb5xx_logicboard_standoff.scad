// PowerBook 5xx logic board standoff
// Copyright François Revol, 2025

/* [Printing options] */

// Optimize for FDM printers (less supports, larger details)
optimize_fdm = true;

/* [Hidden] */
$fs = $preview ? 0.5 : 0.1;
$fa = $preview ? 12 : 6;


module pb5xx_logicboard_standoff() {
    difference() {
        cylinder(d1=9.8,d2=9.6,h=5.9);
        translate([0,0,-0.1]) cylinder(d1=1.8,d2=2.1,h=2.8);
        translate([0,0,2.6]) cylinder(d=4.5,h=3.4);
        if ($preview) cube(10);
    }
}

pb5xx_logicboard_standoff();