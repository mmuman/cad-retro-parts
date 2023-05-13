// Atari Mega ST battery cover remake
// Copyright François Revol, 2023

/* [Printing options] */

// Optimize for FDM printing (less supports, thicker planes…). Otherwise you get the exact model of the original part.
optimize_fdm = false;

print_orientation = 0; // [0:Face down - may still need supports,1:Vertically - may still need supports]

/* [Hidden] */

// we need more faces on such a small piece
$fa=6;
$fs=0.1;


module mega_st_battery_cover(optimize_fdm=false, print_orientation=0) {

    // Not counting details
    bounds = [60.8, 44.9, 5.6];

    module roofs(inside = false) {
        // Work around a bug in 2021.01-6
        // (volume disapears for more than 6 items)
        rotate([inside?180:0,0,0])
            render() {
                l = inside ? 56 : 70;
                for(i = [0:8]) {
                    d = [0,i*5.0-23.6,0] + (inside ? [0,1.2,-5]:[0,0,-3]);
                    translate(d) intersection() {
                        translate([0,2,0.6])
                            cube([l, 6, 6], center=true);
                        translate([0,3.7,1])
                            rotate([85,0,0])
                                cube([l, 6, 6], center=true);
                        translate([0,1,0])
                            rotate([-45,0,0])
                                cube([l, 6, 6], center=true);
                    }
                }
            }
    }

    translate([0,0,bounds.z/2]) union() {
        difference() {
            // main volume
            cube(bounds, center=true);
            //that's the plain part
            //#translate([0,0,(bounds.z-2.2)/2]) cube([70,50,2.2], center=true);

            translate([0,bounds.y/2+3.8,0])
                rotate([-5,0,0])
                    cube([70, 8, 8], center=true);
            translate([0,-bounds.y/2-3.8,0])
                rotate([5,0,0])
                    cube([70, 8, 8], center=true);

            roofs();

            roofs(true);

            // space for the clip
            translate([0, (bounds.y-5.2)/2+0.1]) cube([13,5.3, 10], center=true);

            //if ($preview) cube(50); // DEBUG
        }

        // The two little clips
        for (sx = [-1,1])
            translate([sx*20,-bounds.y/2,bounds.z/2+0.7]) cube([9, 3.4, 1.4], center=true);

        // The main clip
        translate([0,bounds.y/2-3.3,1.3-bounds.z/2]) {
            difference() {
                union() {
                    linear_extrude(8.5, scale=[1,0.93])
                        square([9, 6.6], center=true);
                    translate([0,0,8.5]) rotate([0,90,0])
                        cylinder(d = 6.2, h = 9, center=true);
                    if (optimize_fdm)
                        translate([0,3.2,0]) intersection() {
                            rotate([0,90,0])
                                cylinder(r = 1.3, h = 9, center=true);
                            translate([0,0,-1]) cube([9, 1.7, 2], center=true);
                        }
                    else
                        translate([0,3.2,0.5])
                            cube([9, 1.7, 1], center=true);

                        translate([0,3.2,bounds.z-1.3+0.2+0.6/2])
                            difference() {
                                union() {
                                    cube([9, 1.7, 0.6], center=true);
                                    translate([0,0,0.6/2])
                                        linear_extrude(0.6, scale=[1,0.01])
                                            square([9,1.7], center=true);
                                }
                                if (!optimize_fdm)
                                    cube([6, 2, 4], center=true);
                            }
                }
                translate([0,0.2,-0.1]) union() {
                    sc = 1;//TODO: test this: optimize_fdm ? 0.8 : 1;
                    linear_extrude(8.3, scale=[1,0.9 * sc])
                        square([11, 4.3], center=true);
                    translate([0,0,8.5]) rotate([0,90,0])
                        cylinder(d = 3.9 * sc, h = 11, center=true);
                }
                if (!optimize_fdm) for (sx = [-1,1])
                    translate([sx*4.5,3,0]) cube([3, 3, 9], center=true);
            }
        }

        translate([0,2.8, bounds.z/2]) linear_extrude(0.3)
            text("2", valign="center", halign="center", size=2, font="Clear Sans Thin:style=Regular,Arial");
        translate([0,-2.2, bounds.z/2]) linear_extrude(0.3)
            text("C 1 0 0 0 2 9", valign="center", halign="center", size=2, font="Clear Sans Thin:style=Regular,Arial");
        translate([0,-7, bounds.z/2]) linear_extrude(0.3)
            text("remake: mmu_man", valign="center", halign="center", size=1, font="Clear Sans Thin:style=Regular,Arial");
    }
}

mega_st_battery_cover(optimize_fdm, print_orientation);

