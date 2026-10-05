// Cable and Battery Doors for Thomson/Pathé Marconi/… EL 1466 M
// Copyright 2026, François Revol

// References (for model name):
// https://www.doctsf.com/hifivox-el-1466-m/f41787
// https://electrovintage.com/products/electrophone-pathe-marconi-el1466

/* [Variant] */

variant = 0; // [0:Cable Door,1:Battery Door]

/* [Printing] */

optimize_fdm = true;

/* [Preview] */

preview_color = "OrangeRed"; // [White,OrangeRed:Orange - use ColorFabb Vermillon RAL 2002 ]

/* [Hidden] */

r1 = 2;

plate_bbox = variant ? [109.5,134.3,3.1] : [134, 82, 3.1];

hinges = variant ? [[19-plate_bbox.x/2,4],[plate_bbox.x/2-33,12]] : [[22-plate_bbox.x/2,12],[plate_bbox.x/2-22,12]];

$fn = 20;

module hinge(l) {
    // actually a slope, but well
    b = [7.9,2.8];
    difference() {
        linear_extrude(3.1) square(b, center=true);
        if (optimize_fdm)
            translate([0,b.y,-0.01]) linear_extrude(0.5, scale=[1,0.1]) translate([0,-b.y/2]) square(b+[1,0], center=true);
    }
    for (dx=[-1,1])
        translate([dx*(b.x-1.3)/2,0]) linear_extrude(3, scale=[1,2.8/(2*l)]) translate([0,-l/2]) square([1.3,l], center=true);
}

module clip() {
    difference() {
        rotate([-3,0,0]) {
            difference() {
                hull() {
                    translate([0,0,15]) rotate([0,90,0]) cylinder(d=5, h=10, center=true);
                    translate([0,0,-1]) rotate([0,90,0]) cylinder(d=8, h=10, center=true);
                }
                hull() {
                    translate([0,0,15]) rotate([0,90,0]) cylinder(d=optimize_fdm?2.3:2.7, h=20, center=true);
                    translate([0,0,-1]) rotate([0,90,0]) cylinder(d=5, h=20, center=true);
                }
            }
            // approximation
            translate([0,-3.8,0.8]) linear_extrude(1, scale=[1,8]) square([6,0.2], center=true);
        }
        rotate(optimize_fdm ? [0,0,0] : [5,0,0]) translate([0,0,-10]) cube([20,20,20], center=true);
    }
    for(dx=[-1,1]) translate([dx*(10-1.5)/2,3.4,plate_bbox.z]) linear_extrude(7, scale=[1,0]) translate([0,2.7/2,0]) square([1.5,2.7], center=true);
    // approximation
    for(dx=[-1,1]) rotate([-6,0,0]) translate([dx*(10-1.5)/2,-3.4,plate_bbox.z+1]) difference() {
        linear_extrude(6.35, scale=[1,0]) translate([0,-3/2,0]) square([1.5,3], center=true);
        if (optimize_fdm) {
            translate([0,-3,-0.1]) linear_extrude(0.8, scale=[1,0]) translate([0,1.5]) square([1.7,3], center=true);
        }
    }
}

color(preview_color) {
    linear_extrude(plate_bbox.z) difference() {
        offset(r1) offset(-r1) square([plate_bbox.x,plate_bbox.y], center=true);
        translate([0,-plate_bbox.y/2]) square([12,11], center=true);
    }
    for (h = hinges) translate([h.x,plate_bbox.y/2,plate_bbox.z]) hinge(h.y);
    translate([0,3-plate_bbox.y/2,0]) clip();
}