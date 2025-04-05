// ORIC Reset (NMI) button
//
// Copyright François Revol, 2025
// Licenced under CC-BY-SA

$fa = 0.1;
$fn = 20;


ORIC_case_bottom_angle = 10;
b1_bbox = [214, 145.5, 33];

variant = 1; // [0:clip-on button,1:clip-in case]

print_orientation = 1; // [0:normal,1:upside-down]

// 9.6x7.7

module ORIC_case_bottom() {
    difference() {
        union() {
            rotate([ORIC_case_bottom_angle,0,0]) difference() {
                cube(b1_bbox);
                translate(2*[1,1,-1]) cube(b1_bbox - 4*[1,1,0]);
            }
            translate([140,90,33+10]) cylinder(d=64.8, h=2);
        }
        translate([140,90,33+10+2]) {
            cylinder(d=64.8, h=11);
            for (dx = [-1, 1], dy = [0:5])
                translate([dx*(3+14.8)/2, (dy-2.5)*(3+2.95), 0]) cube([14.8, 2.8, 10], center=true);
            //#cube([32.8,32.8,10], center=true);
        }
    }
}


module ORIC_NMI_switch() {
    color("white", 0.4) translate([0,0,11.3/2]) cube([11.8, 9.8, 11.3], center=true);
    color("black") translate([0,0,11.3-6/2+1.1]) {
        cube([9.9, 7.8, 6], center=true);
        translate([0,0,(6+4)/2]) cube([6.6, 6, 4], center=true);
        translate([0,0,(6+4+1)/2]) cube([8, 6, 3], center=true);
    }
}

// too complex, and requires opening the machine
module ORIC_NMI_button_v1() {
    radius = 1;
    color("green", 0.4) {
        difference() {
            translate([0,0,5/2]) cube([9.8+1/*11.8-2.8+1*/, 7.9+1/*9.8-1.8*/, 5], center=true);
            //translate([0,0,3]) linear_extrude(4, scale=[0.5,0.5]) square([8,6], center=true);
            translate([0,0,-1]) linear_extrude(5, scale=[0.2,1]) square([6,10], center=true);
            translate([0,0,-1]) linear_extrude(4, scale=[0.1,0.3]) square([11,8.5], center=true);
            if ($preview) cube(8); // DEBUG
            translate([0,0,(4.4)/2]) cube([7.7, 6.4, 4.4], center=true);
            translate([0,0,(4.4+1)/2]) cube([8.3, 6.4, 3.4], center=true);
            for (dy=[-1,1])
                translate([0,dy*2.8,0]) cube([15,0.8,7], center=true);
        }
        translate([0,0,5])
            linear_extrude(3, scale = 0.5) square([9.7+1,7.9+1], center=true);
        translate([0,0,6+20/2]) {
            minkowski() {
                intersection() {
                    cube([9-2-2*radius, 8-2.5-2*radius, 20], center=true);
                translate([-140-66,-90-15,-33-12-11.5-1]) rotate([ORIC_case_bottom_angle,0,0]) cube(b1_bbox);
                }
                sphere(r=radius);
            }
        }
    }
    //translate([10,0,4]) color("blue", 0.5) cube([4,4,8.5]);
}

module ORIC_NMI_button_v2() {
    radius = 0.5;
    color("blue", 0.4) {
        translate([0,0,4.5+10/2]) {
            difference() {
                minkowski() {
                    intersection() {
                        union() {
                            cube([9.7-0.2-2*radius, 7.7-0.2-2*radius, 10+2*radius], center=true);
                            translate([0,0,1.6]) rotate([ORIC_case_bottom_angle,0,0]) cube([10, 8.5, 0.1], center=true);
                        }
                    translate([-140-66,-90-15,-33-12-6.5+1.6-radius]) rotate([ORIC_case_bottom_angle,0,0]) cube(b1_bbox);
                    }
                    sphere(r=radius);
                }
                hull() for(dx=[-1,1], dz=[-1,1]) {
                    translate([dx*1.8,0,dz-2.6]) rotate([90,0,0]) cylinder(d=3, h=10, center=true);
                }
            }
            // there the case is
            //#translate([0,0,-1]) rotate([ORIC_case_bottom_angle,0,0]) cube([9, 8, 3], center=true);
            /*for (dx=[-1,1])
                translate([dx*4.6,0,-3.2]) sphere(d=1.5);*/
            for (dx=[-1,1])
                translate([dx*4.5,0,-3.5]) rotate([10,dx*20,0]) cube([1,2,2], center=true);
        }
    }
}

if ($preview)  {
    //translate([-140,-90,-33-12]) color("red", 0.6) ORIC_case_bottom();
    translate([0,0,0]) ORIC_NMI_switch();
}


if (variant == 1) {
    print_translate = print_orientation ? [0,0,11.95-0.495] : [0,0,-3.5];
    print_rotate = print_orientation ? [180-ORIC_case_bottom_angle,0,0] : [0,0,0];
    translate($preview ? [0,0,12.5] : print_translate)
        rotate($preview ? [0,0,0] : print_rotate)
            ORIC_NMI_button_v2();
} else {
    print_translate = print_orientation ? [0,0,11.85] : [0,0,0];
    print_rotate = print_orientation ? [180-ORIC_case_bottom_angle,0,0] : [0,0,0];
    translate($preview ? [0,0,12.5] : print_translate)
        rotate($preview ? [0,0,0] : print_rotate)
            ORIC_NMI_button_v1();
}
