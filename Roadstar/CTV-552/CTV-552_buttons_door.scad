// Button door for the Roadstar CTV-552
// Copyright François Revol, 2025

// Fill some volumes to limit supports, thicker walls, remove unneeded features.
optimize_fdm = true;


$fa = $preview ? $fa : $fa/4;
$fs = $preview ? $fs : $fs/4;

module button_door() {
    face_th = 1.5+(optimize_fdm?1:0);
    side_th = 3+(optimize_fdm?0.2:0);

    module door_hull_shape(o) {
        hull() {
            intersection() {
                translate([8-35,25/2]) circle(r=35+o);
                square([8, 25]);
            }
            translate([2.0,1.5]) circle(r=4.0+o);
            translate([-8.0,27.5/2-2.5-o]) square([4-o,27.5], center=true);
        }
    }

    module door_hull(o) {
        intersection() {
            translate([0,1000+1.7,0]) rotate([0,0,-10-90]) rotate_extrude(angle=20, $fn=360*($preview?1:2)) translate([1000,2.5]) {
                difference() {
                    door_hull_shape(0);
                    if (o)
                        door_hull_shape(o);
                }
            }
            if (o) intersection() {
                translate([232/2-32-106.8/2,-2.05,27.6/2]) cube([106.8,8.5,27.6], center=true);
                translate([232/2-32-106.8/2,-2.05,27.6/2+4.5]) rotate([45,0,0]) cube([110,30,30], center=true);
            }
        }
    }

    // the actual door face
    door_hull(-face_th);

    // the two sides with axis
    difference() {
        for(dx=[-1,1]) intersection() {
            door_hull(0);
            union() {
                translate([232/2-32-(1+dx)*106.8/2,6.2-5.8/2,7.4-5.8/2]) {
                    rotate([0,dx*90,0]) cylinder(d=5.8,h=side_th);
                }
                translate([232/2-32-(1+dx)*106.8/2-(1-dx)*side_th/2,-5,1.5]) {
                    difference() {
                        cube([side_th,9,28]);
                        translate([-1,8,-1]) rotate([dx>0?6:0,0,0]) cube([5,9,30]);
                    }
                }
            }
        }
        translate([232/2-32-106.8-5,6.2-5.8/2,7.4-5.8/2]) rotate([0,90,0]) cylinder(d=3.3, h=120);
    }
    // the lock
    translate([232/2-32-106.8/2,-3.3,27.6-5]) rotate([-90,0,0]) {
        linear_extrude(8.0) square([4,2], center=true);
        translate([0,0,6.5]) linear_extrude(1.5) square([5.4,2], center=true);
        translate([0,0,8]) linear_extrude(1.5, scale=[0.5,1]) square([5.4,2], center=true);
        linear_extrude(3, scale=[1,0.4]) square([2,5], center=true);
    }
    //#translate([232/2-32-(1)*106.8/2-2,-3.3,27.6-5]) cube([55,10,10]);
    // text
    if (!optimize_fdm) translate([232/2-32-56,-3,25.5]) rotate([73,0,2.5]) linear_extrude(2) text("\u25B3 PUSH OPEN", font="DejaVu Sans", size=optimize_fdm ? 4.2:2, halign="left", valign="top");
}

button_door();



// bbox

if (false && $preview) {/*
color("green", 0.4) intersection() {
    translate([0,1000,0]) cylinder(r=1000, h= 27.5, $fn=360);
    cube([232,50,60], center=true);
}

color("blue", 0.4) {
    translate([-232/2+93.5/2,0,0]) cube([93.5,50,60], center=true);
    translate([232/2-32/2,0,0]) cube([32,50,60], center=true);
}
*/

color("yellow", 0.4) {
    translate([232/2-32-106.8/2,0,27.6/2]) cube([106.8,12.6,27.6], center=true);
}
}
