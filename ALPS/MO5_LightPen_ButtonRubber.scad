// ALPS PushButton rubber part replacement for MO5 lightpens
// Copyright François Revol, 2023

// Requires a conductive rubber-like material.

// TODO: Might need some margins for FDM print

/* [Printing options] */

// Optimize for FDM printers (less supports, larger details)
optimize_fdm = true;

/* [Hidden] */

// we need more faces on such a small piece
$fa= $preview ? 6 : 2;
$fs= $preview ? 0.2 : 0.1;

module MO5_ALPS_PushButton_Rubber(optimize_fdm = false) {
    out_d = 5.1;
    in_d = 4.0;
    total_h = 3.0;
    out_h = total_h - 1;
    stem_d = 2.5;
    stem_h = 2.0;
    
    union() {

        // The outer part
        difference() {
            cylinder(h = out_h, d = out_d);
            translate([0,0,-1])
                cylinder(h = out_h + 2, d = in_d);
            if ($preview)
                cube(10);
        }

        // Measurement test
        //#translate([0,0,total_h - 2*0.5]) cylinder(d=stem_d+1,h=0.5);

        // The flexible joint
        difference() {
            delta = 0.55;
            translate([0,0,out_h-delta])
                scale([1,1,0.5])
                    sphere(d = out_d - 0.2);
            translate([0,0,out_h-delta-0.5])
                scale([1,1,0.5])
                    sphere(d = out_d - 0.2);
            if ($preview)
                cube(10);
        }

        // The stem
        translate([0,0,total_h - stem_h])
            cylinder(h = stem_h, d = stem_d);
    }

}

MO5_ALPS_PushButton_Rubber(optimize_fdm);
