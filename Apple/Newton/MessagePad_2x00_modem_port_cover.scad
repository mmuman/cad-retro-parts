// Newton MessagePad 2x00 Modem port cover
// Copyright François Revol, 2025

/* [Printing options] */

// Variant
variant = 0; // [0:Original plain cover,1:MicroSD - UNIMPLEMENTED]


// Optimize for FDM printers (less supports, larger details) - UNIMPLEMENTED
optimize_fdm = true;

/* [Preview] */

preview_parts = true;


/* [Hidden] */
$fs=0.2;

module mp2x00_modem_cover(variant = 0) {
    difference() {
        // positive volumes
        union() {
            linear_extrude(2.55, scale=[13.58/13.5,11.8/11.7]) square([13.5, 11.7], center=true);
            translate([0,0,2.55]) linear_extrude(3.13, scale=[13.45/13.58,11.6/11.8]) square([13.58, 11.8], center=true);
            // little nub on the top
            translate([13.58/2-1.14-3.85/2, 11.8/2-0.1,2.65+1.88/2]) rotate([-90,0,0]) hull() for(dx=[-1,1]) translate([dx*(3.85-1.88)/2,0,0]) cylinder(d=1.88, h=1.36);
            // bottom nub
            translate([0, -11.8/2+0.1,2.5+1.14/2]) rotate([90,0,0]) linear_extrude(1.47) square([4.96,1.14], center=true);
            // side nubs
            for (dx=[-1,1])
                translate([dx*13.58/2, 4.93/2-11.8/2,2.5-1.27/2]) rotate([0,dx*90,0]) linear_extrude(1.47) square([1.27,4.93], center=true);
        }
        translate([0,0,1.7]) linear_extrude(10) square([10.9,9.14], center=true);
    }
    // bbox
    //if ($preview) color("green", 0.2) translate([0,0,5.74/2]) cube([13.6,11.9,5.74], center=true);
}



//color("grey") 
mp2x00_modem_cover(variant);
