// Hinge lock clip for the Macintosh Portable
// Copyright François Revol, 2025

// [Printing]

print_orientation = 1; // [0: vertical - no support but can break, 1: on the side - needs supports]

optimize_fdm = true;

// [Hidden]
$fn=30;

module hinge_clip() {
    difference() {
        union() {
            // handle
            hull() {
                linear_extrude(1.6) square([14,1.7], center=true);
                for(dx = [-1,1])
                    translate([dx*(14/2-1.5),9.7-1.7/2-1.5/2,0]) cylinder(r=1.5, h=1.6);
            }
            // the clip itself
            linear_extrude(5) square([14,1.7], center=true);
            linear_extrude(14.5-1.6) square([9.9,1.7], center=true);
            translate([0,0,14.5-1.6]) linear_extrude(1.6, scale=[0.9,0.3]) square([9.9,1.7], center=true);
            linear_extrude(28.1) square([3.9,1.7], center=true);
            // bulge
            translate([0,0,28.1-2.5]) rotate([0,90,0]) cylinder(r=2.5,h=3.9, center=true);
        }
        // slight angle on the handle
        rotate([1.8,0,0]) translate([0,10/2,-1/2]) cube([15,10,1], center=true);
        // 2 cuts
        for (dx=[-1,1])
            hull()
                for (dz=[-1,1])
                    translate([dx*(3.9+1.1)/2,0,14.5+dz*7]) rotate([90,0,0]) cylinder(d=1.1,h=3, center=true);
        // only keep one side on the bulge
        translate([0,+2.35,28.1-2.5]) cube([5,3,5], center=true);
        // labels, because why not
        if (!optimize_fdm) difference() {
            hull()
                for(dz=[0,1])
                    translate([0,1.6/2,6+dz*12]) rotate([-90,0,0]) cylinder(d=2.1,h=0.3);
            translate([0,1.6/2-0.2,12]) rotate([-90,-90,0]) linear_extrude(0.5) text("815-1109-REV.", size=1.3, halign="center", valign="center");
        }
        if (!optimize_fdm) difference() {
            translate([0,1.6/2,20.5]) rotate([-90,0,0]) cylinder(d=2.1,h=0.3);
            translate([0,1.6/2-0.2,20.5]) rotate([-90,-90+45,0]) linear_extrude(0.5) text("03", size=1.0, halign="center", valign="center");
        }
        if (!optimize_fdm) difference() {
            for (dx=[-1,1])
                 translate([dx*4,1.6/2,12]) rotate([-90,0,0]) cylinder(d=1.6,h=0.3);
            translate([4,1.6/2-0.2,12]) rotate([-90,-90-45,0]) linear_extrude(0.5) text("A", size=0.9, halign="center", valign="center");
        }
    }
}

p_r = print_orientation == 0 ? [-1.8,0,0]:[0,-90,0];
p_t = print_orientation == 0 ? [0,0,0]:[0,0,14/2];

translate(p_t) rotate(p_r) hinge_clip();
