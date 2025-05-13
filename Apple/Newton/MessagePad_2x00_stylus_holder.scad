// Newton MessagePad 2x00 stylus holder
// Copyright François Revol, 2025

/* [Printing options] */

// Optimize for FDM printers (less supports, larger details) - UNTESTED
optimize_fdm = false;

/* [Hidden] */
$fs=$preview ? 0.5 : 0.1;


module mp2x00_stylus_holder() {
    bbox = [12.7,29,4.2];
    base_h = 2.05;

    difference() {
        union() {
            // First part of the base
            translate([0,9.9/2-bbox.y/2,0]) linear_extrude(base_h, scale=[12.9/13,1]) square([13,9.9], center=true);
            // a little larger at both ends of this
            for(dy=[0,1])
                translate([0,dy*(9.9-1.2)+1.2/2-bbox.y/2,0]) linear_extrude(2.05) square([13.1,1.2], center=true);

            // some other part of the base
            linear_extrude(base_h, scale=[0.99,1]) difference() {
                hull() {
                    translate([0,-2]) square([10.7,8], center=true);
                    translate([0,10]) square([12.65,6], center=true);
                    for (dx=[-1,1])
                        translate([dx*3.3,1.6]) circle(d=6);
                }
                d2 = 40;
                for (dx=[-1,1])
                    translate([dx*(bbox.x/2+d2/2-1.0),-5]) circle(d=d2, $fn=80);
            }
            // top and bottom 
            for(dx=[-1,1], dz=[0,1])
                translate([dx*4.3,9/2+0.5-bbox.y/2,dz*base_h+(optimize_fdm?0.15:0)]) rotate([90,0,0]) cylinder(r=0.15, h=9, center=true);
            // the outside that follows the case shape
            /*render()*/ intersection() {
                translate([0, bbox.y/2-4.7/2]) linear_extrude(4.5, scale=[12.4/12.7,1]) square([12.7, 4.7], center=true);
            //translate([-6,bbox.y/2-4/2,0]) rotate([0,-90,0]) 
                translate([30,bbox.y/2-6.5,-1000-2.0]) rotate([-90,0,0]) rotate_extrude($fn=500) translate([1000,0,0]) hull() {
                    square([6.6,1]);
                    square([1,6.6]);
                    translate([4.5,4.5]) circle(r=1.5);
                }
            }
            //translate([-6,bbox.y/2-2,3.9/2]) cube(3.9, center=true);
            //translate([6,bbox.y/2-2,4.2/2]) cube(4.2, center=true);
        }
        for(dx=[-1,1])
            translate([dx*7/2,bbox.y/2-4.45,0.1-10/2]) sphere(d=10);
        for(dy=[0,1])
            translate([0,-bbox.y/2+2.4+2/2+dy*3.7,-2]) cylinder(d=2, h=8);
        // hole for the pen
        translate([0,bbox.y/2-7.15-6.5/2,-2]) cylinder(d1=6.5, d2 = 7.2, h=5);
        // XXX: max
        //translate([0,bbox.y/2-7.15-6.5/2,-2]) cylinder(d=11, h=8);
        translate([0,bbox.y/2-7.15-6.5/2,1.33]) rotate_extrude() difference() {
            translate([1,0.3]) square(4.5);
            translate([4.2,0]) circle(d=1.6);
            translate([5.7,0]) circle(d=1.5);
        }
        //if ($preview) cube(20);
    }
    
    // the side clip
    linear_extrude(1.05) difference() {
        intersection() {
            translate([8,9.9/2-bbox.y/2]) square([4, 9.9], center=true);
            union() {
                d1 = 50;
                translate([7.7-d1/2,9.9/2-bbox.y/2]) circle(d=d1, $fn=100);
                translate([6.6,9.9/2-bbox.y/2]) circle(d=3);
            }
        }
        intersection() {
            translate([8,9.9/2-bbox.y/2]) square([4, 7.9], center=true);
            union() {
                d1 = 50;
                translate([7.7-0.6-d1/2,9.9/2-bbox.y/2]) circle(d=d1, $fn=100);
            }
        }
    }

    if (!optimize_fdm) difference() {
        union() {
            translate([0,14.17,-0.2/2]) rotate([0,90,0.3]) cylinder(d=0.4, h=12.6, center=true);
            translate([0,13.6,-0.2/2]) cube([12.6,1.4,0.2], center=true);
        }
        translate([0,12.8,-5]) rotate([0,90,0]) cylinder(r=5, h=20, center=true);
    }

    // main volume from scan
    /*
    color("orange", 0.5) render() intersection() 
    {
        translate([1, 0,0]) linear_extrude(10) scale([0.7,0.75]) rotate([0,180,0]) import("scan_newton_pen_holder_002.svg", center=true);
        translate([8, 0, 2]) rotate([90,0,-90]) linear_extrude(20) scale([0.75,0.7]) import("scan_newton_pen_holder_003.svg", center=true);
    }
    */

    // DEBUG:bbox
    //if ($preview) color("green", 0.2) translate([0,0,bbox.z/2]) cube(bbox, center=true);

}

mp2x00_stylus_holder();
