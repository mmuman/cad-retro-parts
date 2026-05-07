// Apple Caddy Drive Shock Mount
// Copyright François Revol, 2026

optimize_fdm = true;

bbox = [12,14.3,17];

base_height = 11;

base_bbox = [bbox.x, bbox.y, base_height];

insert_bbox = [7,4,1];

lock_bbox = [insert_bbox.x+2,6.3,5];

spring_post_D = 4.3;

$fn = $preview ? 60 : 120;

module shock_mount() {
    module spheroid(o=0) {
        intersection() {
            translate([0,0,-0.8]) scale([2,1,1.4]) sphere(d=base_bbox.y-o);
            cube(base_bbox-o*[-1,1,1.0], center=true);
        }
    }
    translate([0,0,base_bbox.z/2]) difference() {
        spheroid();
        // alignment checks
        /*
        if ($preview) translate([0,0,2]) %cube([bbox.x, 11, base_bbox.z], center=true);
        if ($preview) translate([0,0,-2]) %cube([bbox.x, 12.7, base_bbox.z], center=true);
        if ($preview) color("blue", 0.2) translate([0,0,0]) %cube([bbox.x, bbox.y-2*2, base_bbox.z-2*1.1], center=true);
        */
        difference() {
            spheroid(o=2.2);
            translate([0,0,-base_bbox.z/2]) cylinder(d=spring_post_D,h=4.6);
            hull() for(dz=[-1,1])
                translate([0,0,base_bbox.z/2+dz*1.5]) sphere(d=spring_post_D-0.3);
        }
        for (dx=[-1,1])
            translate([dx*(bbox.x/2+0.5),0,0])
                cylinder(d=bbox.y/5, h=bbox.z, center=true);
        #translate([0,0,-base_bbox.z/2-0.01]) cylinder(d=3, h=3.5);
        translate([0,0,-base_bbox.z/2+3.5-0.01]) cylinder(d1=3, d2=2, h=0.5);
        if ($preview) translate([0,0,-20]) cube(100);
        if (optimize_fdm)
            translate([0,base_bbox.y/4,-base_bbox.z/2+0.3]) rotate([0,180,0]) linear_extrude(0.4) text("316", size=2, halign="center", valign="center");
    }
    translate([0,0,base_bbox.z+insert_bbox.z/2]) cube(insert_bbox, center=true);
    translate([0,0,base_bbox.z+insert_bbox.z]) linear_extrude(lock_bbox.z, scale=[1,0]) square([lock_bbox.x,lock_bbox.y], center=true);
    if (!optimize_fdm)
        translate([0,base_bbox.y/4,0]) rotate([0,180,0]) linear_extrude(0.4) text("316", size=2, halign="center", valign="center");
}

translate($preview?[0,0,0]:[0,0,bbox.x/2])
    rotate($preview?[0,0,0]:[0,90,0])
        shock_mount();