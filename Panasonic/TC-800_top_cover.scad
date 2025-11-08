// Panasonic TC-800 top buttons cover
// Copyright 2025, François Revol

// Modeled after the photo at:
// https://www.radiomuseum.org/r/panasonic_color_television_tc_800eu.html

//optimize_fdm = true;

$fn=30;

// bbox
//color("green", 0.2) translate([0,0,15/2*0]) cube([128, 55, 15]/*, center=true*/);

module tc800_top_cover() {

    module shape1() {
        difference() {
            square([bbox.x-12, 40]);
            translate([72,30]) square([22, 15]);
        }
    }

    base_r = 1;
    base_h = 7;
    bbox = [128, 55, base_h];

    a1 = -2.55;

    //if ($preview) color("yellow", 0.3) cube([bbox.x,bbox.y,base_h]);
    translate([0,0,-2.1]) {
        difference() {
            rotate([-a1,0,0]) minkowski() {
                difference() {
                    translate(base_r*[1,1,1]) cube([bbox.x,bbox.y,base_h+3]-2*base_r*[1,1,1]);
                    // main slope
                    translate([0,bbox.y,0.65]) rotate([a1,0,0]) translate([-1,-bbox.y-1,-5]) cube([bbox.x+5,bbox.y+5,5]);
                }
                sphere(r=base_r);
            }
            translate([-1,1,base_h]) cube([bbox.x+2,bbox.y,10]);
            // fingernail indent
            translate([bbox.x/2, bbox.y, base_h]) scale([1,4/10,2/10]) sphere(d=20);
            // room for the axis clips
            for (dx=[0,1])
                translate([(bbox.x-10)*dx-0.1,-1,base_h-2]) cube([10.2,12,6]);
            // room for the preset switch
            translate([(bbox.x-13),bbox.y-18,base_h-4]) cube([6,10,7]);
        }
        if ($preview) {
            color("green",0.2) translate([0,55-8,0]) cube([10,8,10]);
            color("green",0.2) translate([-2,2,base_h-3-4/2]) cube([10,10,3]);
        }

        translate([6,8,base_h]) linear_extrude(2) difference() {
            offset(r=.8) shape1();
            offset(r=-.8) shape1();
            translate([-5,-6]) square([bbox.x,10]);
            translate([72+14/2,25]) square([8, 15]);
        }

        translate([6+72+22/2-9.5/2,8+30+5/2,base_h]) rotate([90,0,0]) linear_extrude(5) difference() {
                square([9.5, 7]);
                difference() {
                    hull() for (dx=[-1,1],dy=[-1,1])
                        translate([9.5/2+dx*2,7+5*dy]) circle(d=2);
                    for (dx=[-1,1])
                    translate([9.5/2+dx*3.5,5.5]) circle(d=3);
                    //#translate([9/2,8.5]) circle(d=5);
                }
            }

        // clips around the axis
        for (dx=[-1,1])
            translate([bbox.x/2+dx*(bbox.x/2-5), 5, base_h]) difference() {
                union() {
                    hull() for(dy=[-1,1])
                        translate([0,4+dy*4,0]) rotate([0,90,0]) cylinder(d=6,h=5, center=true);
                    rotate([0,90,0]) cylinder(d=7,h=5, center=true);
                }
                hull() for(dy=[-1,1])
                        translate([0,dy*6,0]) rotate([0,90,0]) cylinder(d=2,h=6, center=true);
                    rotate([0,90,0]) cylinder(d=4,h=6, center=true);
            }

        // nub to force the preset switch to normal
        translate([(bbox.x-13),bbox.y-28,base_h-5]) linear_extrude(12, scale=[1,0.3]) square([7,15]);
    }
}

difference() {
scale([1,1,1]) tc800_top_cover();
//rotate([0,0,35]) cube(180, center=true);
}
