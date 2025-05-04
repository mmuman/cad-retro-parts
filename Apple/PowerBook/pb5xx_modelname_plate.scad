// PowerBook 5xx screen modelname plate
// Copyright François Revol, 2025

/* [Printing options] */

model_name = "520c"; // [520,520c,540,540c]

// Optimize for FDM printers (less supports, larger details) - removes the curve
optimize_fdm = true;

/* [Preview] */


/* [Hidden] */
$fs=0.2;

module pb5xx_modelname_plate(body=true) {

    module curve() {
        face_radius = 100; // guessed but seems not to bad
        if (!optimize_fdm) translate([0,0,0.2-face_radius]) rotate([0,90,0]) cylinder(r=face_radius,h = 35, center=true, $fa=1);
    }
    module the_text(o=0) {
        fonts = "Apple Garamond ITC,EB Garamond:style=Regular";

        // minkowski is way too slow with text
        for(dx=o ? [-1:1]:[0], dy=o ? [-1:1]:[0]) {
            translate([dx*o,dy*o,0]) {
                // No thin style, so just scale it a bit
                texts = [
                    model_name,
                    "PowerBook"
                ];
                for (t=[0,1])
                    difference() {
                        translate([0,4.7*(t-0.5),0.3]) rotate([180,0,180]) linear_extrude(0.4) scale([0.9,1]) text(texts[t], size=3.4, font=fonts, halign="center", valign="center");
                        if (!$preview && (o == 0)) curve();
                    }
                //translate([0,4.7/2,0.3]) rotate([180,0,0]) linear_extrude(0.4) scale([0.9,1]) text(texts[t], size=3.4, font=fonts, halign="center", valign="center");
                //translate([0,-4.7/2,0]) cube([18.1,3.4,2], center=true);
            }
            //cube(o, center=true);
        }
    }

    if (body) color("DimGrey") difference() {
        union() {
            intersection() {
                translate([0,0,1.6/2]) cube([30.7,12.9,1.6], center=true);
                //top and bottom chamfers
                translate([0,0,1.148]) rotate([14,0,0]) cube([31,12.3,6], center=true);
                translate([0,0,0.8]) rotate([9,0,0]) cube([31,12.5,6], center=true);
            }
            // the clips
            for (dx=[-1,1]) mirror([(1+dx)/2,0,0]) translate([27.7/2,-1.5,1.6]) {
                intersection() {
                    union() {
                        linear_extrude(2.5) square([0.9,6], center=true);
                        translate([(1.5-0.9)/2,0,1.6]) linear_extrude(0.9, scale=[0.5,1]) square([1.5,6], center=true);
                        //#translate([0,-4,3]) cube(2.2, center=true);
                        for (dy=[-1,1])
                            translate([-0.4,0.3+dy*1.2,-0.2]) rotate([10,0,0])
                                linear_extrude(2.6, scale=[0.1,1]) square([optimize_fdm ? 1.8 : 0.7,optimize_fdm ? 1:0.6], center=true);
                    }
                    translate([0,-0.2,1]) rotate([14,0,0]) cube([31,5.7,6], center=true);
                    translate([0,0.3,1]) rotate([9,0,0]) cube([31,6,6], center=true);
                }
            }
            //#cube([24.7,10,10], center=true);
        }
        curve();
        //translate([0,0,0.2/2]) cube([31,5,0.2], center=true);
        the_text(o=0.1);
        if (!optimize_fdm) rotate([0,0,180]) translate([0,0,1.6-0.2]) difference() {
            linear_extrude(0.3, scale=[1.05,1.04]) offset(2) offset(-2) square([15.3, 7.1], center=true);
            translate([0,0,-0.1]) linear_extrude(0.2) {
                translate([-2,1,0]) text("REV A", size=1, halign="right", valign="center");
                translate([0,-1,0]) text("815-1669", size=1, halign="right", valign="center");
                translate([2,-1,0]) text("CAV.1", size=1, halign="left", valign="center");
            }
        }
    } else {
        color("white") the_text();
    }

    // DEBUG:bbox
    //if ($preview) color("green", 0.2) translate([0,0,4.1/2]) cube([30.7,12.9,4.1], center=true);
}

pb5xx_modelname_plate();
pb5xx_modelname_plate(body=false);
