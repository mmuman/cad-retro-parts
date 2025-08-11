// VAIO N Series power cable clip
// Copyright François Revol, 2025


cable_diameter = 3.4; // [2:0.1:5]

//$fn=10;
//$fs = $preview ? 0.5 : 0.02;
$fn = $preview ? 8 : 20;

module VAIO_N_cable_clip(cd = 3.4) {
    cable_margin = 0.4;
    // original's bounding box:
    //bbox = [7.1, 12, 13.8];
    bbox = [2*cd+0.3, 3.5*cd+0.1, 4*cd+0.2];
    //echo(bbox);
    logo_w = bbox.z*11.4/13.6;
    or1 = (2*cd-0.1)/2;
    ir1 = (cd-cable_margin)/2;
    or2 = (0.7*cd-0.08)/2;
    ir2 = (cd-cable_margin)/2;
    radius = 0.4;
    color("violet") translate([0,0,radius]) difference() {
        minkowski() {
            difference() {
                linear_extrude (bbox.z-2*radius) offset(-radius) {
                    difference() {
                        union() {
                            for (dx=[-1,1])
                            hull() {
                                translate([0,bbox.y/2-or1]) circle(r=or1);
                                //for (dx=[-1,1])
                                    translate([dx*(bbox.x/2-or2),or2-bbox.y/2]) circle(r=or2);
                            }
                        }
                        
                        difference() {
                            union() {
                                for (dy=[-1,1]) hull() {
                                    translate([0,dy*(ir2+or2)-bbox.y/2]) circle(r=ir2);
                                translate([0*(bbox.x/2-or2),or2-bbox.y/2]) circle(r=or2);
                                }


                            }
                            for (dx=[-1,1])
                                translate([dx*(bbox.x/2-or2),or2-bbox.y/2]) circle(r=or2);

                        }
            
                        translate([0,bbox.y/2-or1]) circle(r=ir1);
                        //translate([0,bbox.y/2-or1-ir1-3-ir2]) circle(r=ir2);
                        translate([0,ir2+or2-bbox.y/2]) circle(r=ir2);
                        translate([-bbox.x/2,-ir1/2]) rotate([0,0,45]) square([bbox.x*1.5,2*or2], center=true);
                    }
                }
            }
            sphere(r=radius);
        }
        //
        translate([bbox.x/2-0.9,-1,(bbox.z-logo_w)/2]) rotate([90,-90,90+1]) linear_extrude(1) scale(0.0016*logo_w) import("Vaio.svg");
    }
    if ($preview)
        color("white", 0.2) translate([0,0,bbox.z/2]) cube(bbox, center=true);
}


VAIO_N_cable_clip(cable_diameter);
//translate([-15,0,0]) VAIO_N_cable_clip(5);
