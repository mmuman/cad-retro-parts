// PowerBook 1xx Battery door cover
// Copyright François Revol, 2024

/* [Print options] */

// Optimize for FDM printers (less supports, larger details)
optimize_fdm = false;

/* [Hidden] */
$fn = 30;

// References:

// model export from:
// https://www.thingiverse.com/thing:5249730
//translate([2.5,0,10]) import("Powerbook1x0BatteryCover.stl");

// 3D scan by Ron's Computer Videos
// https://thangs.com/designer/RonsCompVids/3d-model/PowerBook%201xx%20Series%20Battery%20Cover-972309
// too heavy to be loaded directly in OpenSCAD.
//import("PB_BAT1.stl");


function pb1xx_battery_cover_bbox() = [116,28,7];

module pb1xx_battery_cover_basic_shape() {
    bbox = pb1xx_battery_cover_bbox();

    hull() {
        r1 = 5;
        translate([116/2-r1,28/2-r1])
            circle(r1);
        r2 = 7;
        translate([116/2-r2,-28/2+r2])
            circle(r2);
        translate([-116/2+4.6+1/2-2,0])
            square([1,bbox.y], center=true);
    }
}

module pb1xx_battery_cover() {
    bottom_r = 2.0;
    bbox = pb1xx_battery_cover_bbox();

    difference() {
        minkowski() {
            translate([0,0,bottom_r]) linear_extrude(10)
                offset(r = -bottom_r)
                    pb1xx_battery_cover_basic_shape();
            sphere(bottom_r);
        }
        translate([0,0,bbox.z*1.5])
            cube(bbox+[1,1,0],center=true);
        // inside cutout
        translate([0,0,2.55])
            linear_extrude(7)
                offset(r = -1)
                    difference() {
                        pb1xx_battery_cover_basic_shape();
                        translate([bbox.x/2,6.9])
                            square([2,1], center=true);
                    }
        translate([0,0,7-.5])
            linear_extrude(1,scale=[1.005,1.01])
                offset(r = -1)
                    difference() {
                        pb1xx_battery_cover_basic_shape();
                        translate([bbox.x/2,6.9])
                            square([2,1], center=true);
                    }


        // walls removed near the clip
        translate([-82+116/2-15-1, -(bbox.y-3)/2,-1]) {
            cube([30,3,20], center=true);
            translate([1,-1,0]) cube([30,3,20], center=true);
        }
        translate([-82+116/2-1, -(bbox.y-3)/2+0.51,-1])
            cylinder(h=20, r=1);
        translate([-116/2+2+1.5, -(bbox.y-4)/2,-1])
            difference() {
            cube([5,5,20], center=true);
            translate([2.5,2.5,0]) cylinder(h=20,r=1.5, center=true);
        }
        translate([-116/2+2, 0,-1])
            cube([5,30,20], center=true);
        translate([-116/2+1.4, 0,-1])
            rotate([0,0,-8])
                cube([5,30,20], center=true);
        // a little ridge
        translate([0,6.9,0]) {
            cube([bbox.x+2,1,2], center=true);
            translate([bbox.x/2,0,0]) cube([2,1,20], center=true);
        }
        // Some grip to help slide the thing
        if (optimize_fdm) {
            for(dx=[0:4]) {
                translate([-bbox.x/2+10+dx*4, -2, 0])
                    rotate([90, 0, 0])
                        cylinder(h = 8, r = 1, center=true);
            }
            translate([-bbox.x/2+32, -2, 0])
                cylinder(r = 2, h = 1.8, center=true, $fn = 3);
        }
    }

    // The retaining clip
    translate([-bbox.x/2+4.3,-5.3,3.0])
        difference() {
            cube([8.6,6,2.5],center=true);
            translate([5,0,0]) rotate([0,45,0]) cube([8,8,2], center=true);
            translate([-6,0,0]) rotate([0,45,0]) cube([8,8,2], center=true);
            translate([-6,0,0.5]) rotate([0,-45,0]) cube([8,8,2], center=true);
    translate([-0.3,0,-0.5]) rotate([90,0,0]) cylinder(h = 10, d=1, center=true);
    translate([-1.35,0,-1]) cube([2.0,8,2], center=true);
    translate([-0.8,0,-1.5]) cube([2.0,8,2], center=true);
    }

    // Some grip to help slide the thing
    if (!optimize_fdm) {
        for(dx=[0:4]) {
            translate([-bbox.x/2+10+dx*4, -2, 0])
                rotate([90, 0, 0])
                    cylinder(h = 8, r = 1, center=true);
        }
        translate([-bbox.x/2+32, -2, 0])
            cylinder(r = 2, h = 1.8, center=true, $fn = 3);
    }

    // Tabs to slide on the case
    module slide_tab(l = 4.6) {
        hull() {
            for (dx = [-1, 1])
                translate([dx*l/2,0,0]) cylinder(d = 1, h = optimize_fdm?2.15:2);
        }
    }
    for (side=[[1,[-45,-16,10,36]], [-1,[-18,10,36]]]) {
        dy = side[0];
        for (dx = side[1]) {
            translate([dx,dy*(bbox.y/2-0.5),bbox.z-1.5]) rotate([dy*90,0,0])  slide_tab(l = dx < -17 ? 8.6 : 4.6);
            if (optimize_fdm)
                translate([dx,dy*(bbox.y/2-3.0+.45),bbox.z-5.0])
                    linear_extrude(4,scale=[0.8,0.1])
                        translate([0,-dy*3/2])
                            square([(dx < -17 ? 10:6)+2,3], center=true);
        }
    }

    // Battery clips
    for (dy=[-1,1], dx=[-1,1]) {
        translate([9.5+dx*14,0.55+dy*8.1,3.5]) {
            difference() {
                intersection() {
                    cube([8,3.5,3], center=true);
                    rotate([dy*13,0,0]) cube([8,2.6,8], center=true);
                }
                for(d=[-1,1])
                    translate([d*1.7,dy*2.4,0]) cube([2,3,8], center=true);
            }
        }
    }
}

module pb1xx_battery_cover_battery_preview() {
    radius = 1;
    difference() {
        linear_extrude(2.61, scale=[1,12.6/13.6]) square([83.7,13.6],center = true);
        translate([0,0,-1]) cube([90,8.7,10],center=true);
    }
    minkowski() {
        difference() {
            translate([0,0,2.6+50]) cube([102,20.8,100]-[1,1,1]*2*radius, center=true);
            translate([20,0,100+5]) rotate([90,0,0]) cylinder(r=15,h=30,center=true);
        }
        sphere(r=radius, $fn = 20);
    }
}

module pb1xx_battery_cover_case_preview() {
    bbox = pb1xx_battery_cover_bbox();

    difference() {
        union() {
            translate([0,0,4.5])
                linear_extrude(5)
                    pb1xx_battery_cover_basic_shape();
            linear_extrude(5)
                offset(r = -1)
                    pb1xx_battery_cover_basic_shape();
        }
        translate([bbox.x/2,6.9,-1])
            linear_extrude(20)
                square([8,3], center=true);
        translate([0,0,-1])
            linear_extrude(20)
                offset(r = -1 - 1.5)
                    pb1xx_battery_cover_basic_shape();
        translate([-bbox.x/2,0])
            cube([20,bbox.y,20],center=true);
    }
}

// bounding box
//color("green", 0.3) translate([0,0,7.35/2]) cube([116,28,7.35], center=true);

// XXX: meshlab project expects it there
//translate([0,0,10])
difference() {
    union() {
        pb1xx_battery_cover();
        //cube([25,6,18]);
    }
    //translate([0,0,-1]) cube([20,2,20]);
}


if ($preview) {
    translate([0,0,2.6]) color("pink", 0.6) pb1xx_battery_cover_case_preview();
    translate([0,0.55,2.6]) color("white", 0.3) pb1xx_battery_cover_battery_preview();
}











