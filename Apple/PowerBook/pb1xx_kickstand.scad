// Kickstand for PowerBook 100 Series
// Copyright François Revol, 2023

/* [Printing options] */

// Optimize for FDM printers (less supports, larger details)
optimize_fdm = true;

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
                    linear_extrude(1, scale=[1,0.5])
                        polygon([[0,0],[12,3],[12,-3]]);
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
                            cylinder(d1 = 24.6, d2 = 24, h = 8.5);
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
                    cylinder(d = 21.5, h = 4.6);
                    cylinder(d = 17.7, h = 10, center=true);
                    for (a = [15,45])
                        rotate([0,0,90+a])
                            step_indent();
                }
                difference() {
                    cylinder(d = 15.0, h = 4.6);
                    cylinder(d = 12.0, h = 10, center=true);
                    for (a = [15,45])
                        rotate([0,0,a])
                            step_indent();
                }
                for (a = [0,90])
                    translate([0,0,4.6/2])
                        rotate([0,0,a-10])
                            cube([1.5, 14, 4.6], center=true);
            }
            for (a = [-150,70]) //FIXME
                rotate([0,0,a])
                    translate([0,27.6/2,9/2])
                        rotate([90,0,0])
                            linear_extrude(1.5, scale=[0,1])
                                square([1.5, 9], center=true);
                
        }
        //if ($preview) cube(40);
    }
    // screw post
    translate(screw_pos-[0,0,5.0])
        difference() {
            cylinder(d = 5.8, h = 17);
            translate([0,0,-0.1]) cylinder(d = 2.0, h = 15.5);
        }
    // bounds
    if (false)
        color("white", 0.2)
            translate([(47-33)/2,0,14.2/2])
                cube([47,33,14.2/*19*/], center=true);
}


translate([0,0,$preview?0:14.2])
    rotate([$preview?0:180,0,0])
        pb1xx_kickstand();
