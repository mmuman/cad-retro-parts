// Macintosh HDI-20 External 1.44MB Floppy Drive rubber feet
// Copyright 2026, François Revol

bbox = [14.8, 4, 3.85];

base_height = 1.85;

$fn = $preview ? 60 : 120;

main_r = 6;

optimize_fdm = true;

intersection() {
    union() {
        linear_extrude(base_height, scale=[bbox.x/(bbox.x-0.2),bbox.y/(bbox.y-0.2)]) square([bbox.x-0.2,bbox.y-0.2], center=true);
        for (dx=[-1,1]) {
            translate([dx*(bbox.x/2-2),0,base_height]) {
                clip_slope = optimize_fdm ? 0.4 : 0.2;
                linear_extrude(2, scale=[0.3,2.3/2.5]) translate([-dx*2.6/2,0,0]) square([2.6,2.5], center=true);
                translate([0,0,1-clip_slope]) linear_extrude(clip_slope, scale=[100,1]) translate([dx*.01/2,0,0]) square([0.01,2.4], center=true);
                translate([0,0,1]) linear_extrude(1, scale=[1,2.3/2.4]) translate([dx*1/2,0,0]) square([1,2.4], center=true);
            }
        }
    }
    translate([0,0,main_r-(optimize_fdm?0.05:0)]) scale([1,optimize_fdm?0.7:1,1]) rotate([0,90,0]) cylinder(r=main_r, h=bbox.x*2, center=true);
}

//if ($preview) color("green", 0.2) translate([0,0,bbox.z/2]) cube(bbox, center=true);