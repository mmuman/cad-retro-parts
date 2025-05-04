// PowerBook 5xx Screen rubber bumper
// Copyright François Revol, 2025

/* [Printing options] */

// Optimize for FDM printers (less supports, larger details)
optimize_fdm = true;

/* [Hidden] */
$fs = $preview ? 0.5 : 0.1;
$fa = $preview ? 12 : 6;


module pb5xx_screen_bumper() {
    radius = optimize_fdm ? 0.4 : 0.2;
    difference() {
        union() {
            // not clean on the junction, let's do it simpler
            /*translate([0,0,radius]) render() minkowski() {
                cylinder(d1=5.7-2*radius,d2=6.3-2*radius,h=5.9-radius);
                sphere(r=radius);
            }*/
            cylinder(d1=5.7-radius,d2=5.7,h=radius);
            translate([0,0,radius]) cylinder(d1=5.7,d2=6.3,h=5.9-radius);
            translate([0,0,5.9]) scale([1,1,0.67]) sphere(d=6.3);
        }
        if (!optimize_fdm) scale([1,1,0.5]) sphere(d=5);
        translate([0,0,-0.1]) cylinder(d=3.2,h=6);
        translate([0,0,5.9]) scale([1,1,0.8]) sphere(d=3.2);
        if ($preview) cube(10);
    }
    // bounding box
    if ($preview) color("green", 0.2) cylinder(d=6.3,h=8);
}

pb5xx_screen_bumper();