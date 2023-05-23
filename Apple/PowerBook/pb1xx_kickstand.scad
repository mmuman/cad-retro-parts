// Kickstand for PowerBook 100 Series
// Copyright François Revol, 2023

// TODO: check angles
// TODO: check screw pitch
// TODO: split the softer part away?

/* [Printing options] */

// Optimize for FDM printers (less supports, larger details)
optimize_fdm = true;

// Pre-thread for the official screw
pre_thread = true;



/* [Preview] */



/* [Hidden] */

// we need more faces on such a small piece
$fa= $preview ? 6 : 2;
$fs= $preview ? 0.2 : 0.1;


module pb1xx_kickstand(optimize_fdm = false) {
    screw_pos = [(11-15.9)/2, (11-15.9)/2, 0];
    total_h = 14.0;

    module step_indent() {
        translate([0,0,-0.1])
            for (a = [0,180])
                rotate([0,0,a])
                    linear_extrude(1.3, scale=[1,0.5], slices = 50)
                        polygon([[0,0],[11.5,3],[11.5,-3]]);
    }

    difference() {
        // main volume
        union() {
            cyl_r = 2;
            foot_r = 0.5;
            intersection() {
                minkowski() {
                    intersection() {
                        sr = 35;
                        //cylinder(d1 = 33, d2 = 31.6, 9.5);
                        translate([0,0,-0.1])
                            cylinder(d1 = 33 - 2*cyl_r, d2 = 31.6-1.4-2*cyl_r, 2*9.5);
                        translate([0,0,total_h-0.5-sr])
                            sphere(r = sr-cyl_r);
                    }
                    sphere(r = cyl_r);
                }
                cylinder(d = 35, h = 20);
            }
            
            difference() {
                minkowski() {
                    intersection() {
                        hull() {
                            for (dx = [0, 34.6-8.6-0.3])
                                translate([dx, 0, foot_r])
                                    cylinder(d1 = 9.6-2*foot_r, d2 = 8.6-2*foot_r, h = 15);
                        }
                        cr = 150;
                        translate([0,10/2,total_h-cr]) rotate([90,0,0])
                            cylinder(r = cr-foot_r, h = 10, $fa = $fa/4);
                    }
                    sphere(r = foot_r);
                }
                translate([34.6-8.6-0.3, 0, 0])
                    difference() {
                        linear_extrude(12.5, scale=2)
                            translate([-0.3,0])
                                square([0.6,10], center=true);
                        cube([2, 8.4, 2*11.4], center=true);
                    }
            }
        }

        // main cavity
        difference() {
            union() {
                translate([0,0,-0.1]) intersection() {
                    sr = 30;
                    union() {
                        //cylinder(d1 = 27.6, d2 = 26.6, 8.2);
                        cylinder(d1 = 27.6, d2 = 25.6, 2*8.2);
                        translate(screw_pos-[0,0,0.1])
                            cylinder(d1 = optimize_fdm ? 23 : 23.8, d2 = 22, h = 8.5);
                    }
                    translate([0,0,11.3-sr])
                        sphere(r = sr);
                }
                intersection() {
                    translate([26/2,0,5.9])
                    cube([22, 3.8, 12], center=true);
                    cr = 140;
                    translate([0,10/2,11.2-cr]) rotate([90,0,0])
                        cylinder(r = cr, h = 10);
                }
            }
            translate(screw_pos + [0,0,7]) {
                difference() {
                    od = optimize_fdm ? 22 : 21.5;
                    id = optimize_fdm ? 17 : 17.7;
                    cylinder(d = od, h = 4.6);
                    cylinder(d = id, h = 10, center=true);
                    for (a = [15,45])
                        rotate([0,0,90+a])
                            step_indent();
                    //DEBUG:#translate([0,0,.7]) rotate([0,0,-45]) cube([25, 5.4, 1.4], center=true);
                }
                difference() {
                    od = optimize_fdm ? 16.0 : 15.0;
                    id = optimize_fdm ? 11.0 : 12.0;
                    cylinder(d = od, h = 4.6);
                    cylinder(d = id, h = 10, center=true);
                    for (a = [15,45])
                        rotate([0,0,a])
                            step_indent();
                    //DEBUG:#translate([0,0,.7]) rotate([0,0,45]) cube([25, 3.6, 1.4], center=true);
                }
                for (a = [0,90])
                    translate([0,0,4.6/2])
                        rotate([0,0,a-10])
                            difference() {
                                cl = optimize_fdm ? 18 : 14;
                                cube([1.5, cl, 4.6], center=true);
                                cube([3,3,5], center=true);
                            }
            }
            // turn stops
            for (a = [-147,68]) //FIXME
                rotate([0,0,a])
                    translate([0,27.6/2,9/2-1])
                        rotate([90,0,0])
                            linear_extrude(1.7, scale=[0.2,1])
                                square([1.5, 9], center=true);
                
        }
        //DEBUG: triangulate the turn stops
        //#translate([-2.5,-3,.7]) rotate([0,0,-40]) cube([23.2, 2, 1], center=true);
        //#translate([11,-4.6,.7]) rotate([0,0,63]) cube([14, 2, 1], center=true);
        //#translate([1,3,.7]) rotate([0,0,-5]) cube([24.2, 2, 1], center=true);
        // DEBUG: thickness check:
        //#rotate([0,0,-130]) translate([31.8/2,0,0]) cube([1.2, 1, 10], center=true);
        // DEBUG:
        //if ($preview) rotate([0,0,0]) cube(40);
    }
    // screw post
    translate(screw_pos-[0,0,5.0])
        difference() {
            union() {
                if (optimize_fdm)
                    translate([0,0,12.0])
                        cylinder(d1 = 5.8, d2 = 9, h = 4.6);
                cylinder(d = 5.8, h = 17);
            }
            translate([0,0,-0.1]) cylinder(d = 2.0, h = 15.5);
            translate([0,0,-0.1]) cylinder(d1 = 2.5, d2 = 2.0, h = 2);
            if (pre_thread) {
                step = 1.15; // FIXME!
                translate([0,0,-0.1]) linear_extrude(14, scale = 0.8, twist = -14*360/step, $fn = 16)
                    translate([0.3,0])
                        circle(r=1);
            }
            //if ($preview) rotate([0,0,0]) cube(40);
        }
    // bounds
    if (false)
        color("white", 0.2)
            translate([(47-33)/2,0,14.2/2])
                cube([47,33,14.2/*19*/], center=true);
}


translate([0,0,$preview?0:14.2])
    rotate([$preview?0:180,0,0])
        pb1xx_kickstand(optimize_fdm);
