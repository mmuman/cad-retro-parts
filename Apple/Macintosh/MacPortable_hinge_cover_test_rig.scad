// Test rig for Hinge cover for the Macintosh Portable
// Copyright François Revol, 2026




cylinder(d=36, h=1);
cylinder(d=22.8, h=32+4);
translate([0,-18/2,(27+4)/2]) cube([5, 18, 27+4], center=true);
for (dz=[0:5])
    translate([0,-18/2,1.5/2+(dz/5)*(27-1.5)+4]) cube([8.9, 18, 1.5], center=true);
