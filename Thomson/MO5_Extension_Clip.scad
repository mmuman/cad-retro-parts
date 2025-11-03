// Holding clip for the MO5 Extension
// Copyright François Revol, 2025

// I didn't have the original part to model it,
// only the drawing from the user manual and the cases to measure.

optimize_fdm = true;

difference() {
    union() {
       translate([0,0,2]) cube([53.5/*-0.5*/,32,2+2], center=true);
        for (dx=[-1,1])
            translate([dx*(46.5+10)/2,+(optimize_fdm?-11.5/2:0)-0.5,4/2]) cube([10,8+(optimize_fdm?11.5:0),4], center=true);
        for (dx=[-1,1],dy=optimize_fdm ? [-1:1] :[-1,1]) {
            translate([dx*(46.5+3.5-1.5+((optimize_fdm && dy<=0)?5:0))/2,dy*8-4,4]) rotate([0,0,0]) linear_extrude(5, scale=[0.8,0.9]) square([4.5+((optimize_fdm && dy<=0)?5:0),optimize_fdm?1.5:1.6], center=true);
        }
    }
    translate([0,0,2-(optimize_fdm?0.5:0)]) linear_extrude(2.1+(optimize_fdm?0.5:0), scale=[36/32.5,1]) square([32.5,35], center=true);
    translate([0,0,2+2+3/2]) cube([46.5,35,3], center=true);
    for (dx=[-1,1])
        translate([dx*(46.5+10+6.5)/2,1.5,1.3+4/2]) cube([10,6,4], center=true);
}