// Parametric Tube Cutting Jig
// Copyright François Revol, 2026

// inspirations:
// https://www.thingiverse.com/thing:3446947


// Outer diameter of the tube
tube_OD = 4;

// Length of the tube to cut at
tube_length = 3;

// Margin for the outer diameter
tube_OD_margin = 0.2;

// Thickness of the blade itself - exoknife is 0.5
blade_thickness = 0.5;

label = "Portable Trackball";

$fn = 60;

input_y = max(20, tube_OD*2.5);
end_y = max(10, tube_OD*0.5);
bbox = [input_y + tube_length + end_y, tube_OD*2, tube_OD*1.6];

difference() {
    union() {
        linear_extrude(tube_OD*.5) square([bbox.x, bbox.y], center=true);
        translate([input_y/2-bbox.x/2,0,0]) linear_extrude(bbox.z) square([input_y,bbox.y], center=true);
        translate([bbox.x/2-end_y/2,0,0]) linear_extrude(bbox.z, scale=[1,0.4]) square([end_y,bbox.y], center=true);
        for (dx = [0:(tube_length-2)/10]) difference() {
            translate([bbox.x/2-end_y-tube_length+dx*10,0,0]) linear_extrude(bbox.z, scale=[0.5,1]) square([blade_thickness*10,bbox.y], center=true);
            hull() for (dz=[0,1])
                translate([bbox.x/2-end_y-tube_length+(dx?0:blade_thickness*3)+dx*10,0,tube_OD*(1+dz)]) rotate([0,90,0]) cylinder(d = tube_OD + tube_OD_margin, h=blade_thickness*10, center=true);
        }
    }
    // the tube
    translate([-bbox.x/2-1,0,tube_OD]) rotate([0,90,0]) cylinder(d = tube_OD + tube_OD_margin, h=input_y + tube_length+1);
    translate([-bbox.x/2-1,0,tube_OD]) rotate([0,90,0]) cylinder(d1 = tube_OD + tube_OD_margin * 8, d2 = tube_OD, h=tube_OD/2);
    // blade
    translate([bbox.x/2-end_y-tube_length,0,tube_OD*0.4]) linear_extrude(bbox.z) square([blade_thickness, bbox.y*2], center=true);
    translate([-end_y,0,tube_OD]) linear_extrude(bbox.z) square([bbox.x, tube_OD*0.4], center=true);
    //#translate([bbox.x/2-end_y-tube_length+blade_thickness*3+min(tube_length,tube_OD*0.3)/2,0,tube_OD*0.5]) rotate([0,90,90]) scale([0.2,1]) cylinder(d = min(tube_length,tube_OD*0.3), h=bbox.y*2, center=true);
    translate([bbox.x/2-end_y-tube_length+blade_thickness*3,0,tube_OD*0.5]) cylinder(d = tube_OD*0.5, h=bbox.z*2, center=true);
    // labels
    translate([0,-bbox.y/4*0,-0.1]) linear_extrude(0.5) rotate([180,0,0]) text(label, size=bbox.y/3, halign="center", valign="center");
}


if ($preview) {
    color("blue", 0.2) translate([bbox.x/2-end_y-tube_length,0,tube_OD]) rotate([0,90,0]) cylinder(d=tube_OD, h=tube_length);
}