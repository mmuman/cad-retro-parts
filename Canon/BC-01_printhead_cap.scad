// Print head cap for the Canon BC-01 and compatible cartridge
// Copyright François Revol, 2026


head_bbox = [16.1,12,4.8];

bbox = [20-1,16,8];

//if ($preview) color("orange", 0.4) translate([0,0,head_bbox.z/2]) cube(head_bbox, center=true);


//if ($preview) color("green", 0.4) translate([0,-4/2,bbox.z/2]) cube(bbox, center=true);

$fn = 60;

translate([0,0,8]) rotate([0,180,0]) difference() {
    translate([0,1,bbox.z/2]) cube(bbox, center=true);
    //4.95
    translate([0,4/2,-0.01]) linear_extrude(4.01) {
        square([16.05,10.8], center=true);
    }
    difference() {
        translate([0,4/2-10.8/2,4-0.01]) linear_extrude(0.95+0.2, scale=[14/16,9/10]) {
            translate([0,10.8/2]) square([16.05,10.8], center=true);
        }
        translate([0,-0.5,4.6]) linear_extrude(1.1) difference() {
            offset(1) square([7.5,2.5], center=true);
            offset(0.5) square([7.5,2.5], center=true);
        }
    }
    for(dx=[-1,1])
        translate([dx*(16.05-1.7+1)/2,-3.3,0]) rotate([90,0,0])
        hull() for(dy=[-1,1]) translate([0,dy*2,0]) cylinder(d1=1.7,d2=0.8, h=1);
}
