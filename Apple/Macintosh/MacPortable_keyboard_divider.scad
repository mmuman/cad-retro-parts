// Keyboard divider for Macintosh Portable
// Copyright François Revol, 2026


top_height = 14.95;
bottom_height=17.05;

bbox = [111.4, 11.05, top_height+bottom_height];

top_angle = 3;
bottom_angle = 5.75;


$fn=60;


module divider() {

    module shape1() {
        polygon([
            [6.7,0],
            [6.6,12.1],
            [11.9,11.3],
            [11.9,11.85],
            [13.2,11.8],
            [13.4,14.95],
            [105.5,10.2],// actually a bit lower but we'll shave that
            [105.6,8.1],
            [106.5,8],
            [106.9,6],
            [111,5.7],
            [111.4,0],
            [108.1,0],
            [107.9,2.25],
            [103.7,2.4],
            [103.5,6.1],
            [15,11.3],
            [14.8,7.8],
            [9.9,8],
            [9.7,0],
        ]);
    }

    module shape2() {
        polygon([
            [6.7,0],
            [6.6,12.1],
            [11.9,11.3],
            [11.9,11.85],
            [13.2,11.8],
            [13.4,14.95],
            [105.5,10.2],
            [105.6,8.1],
            [106.5,8],
            [106.9,6],
            [111,5.7],
            [111.4,0],
            [111.4,-20],
            [9.5,-20],
            [9.5,0],
        ]);
    }

    difference() {
        union() {
            for (dx=[29.5, 61.5, 89])
                translate([dx-bbox.x/2,0,-10.5]) cylinder(d1=2.35, d2=2.30, h=(dx<80?21:20));
            translate([29.5-bbox.x/2,0,-10.5-0.3]) cylinder(d1=1.25, d2=2.35, h=0.3);


            for (dy=[-1,1])
                translate([2-bbox.x/2,dy*5.5/2,-16.35]) cylinder(d=2.35, h=16.35);

            difference() {
                intersection() {
                    translate([9-bbox.x/2+100/2,0,-17.35]) linear_extrude(30, scale=[1,2.1/1.2]) square([100,1.2], center=true);
                    translate([-bbox.x/2,6.2/2,0]) rotate([90,0,0]) linear_extrude(6.2) shape2();
                }
                translate([29.5-bbox.x/2,0,-15]) cylinder(d1=7, d2=5.7, h=11);
            }

            translate([9.7/2-bbox.x/2,0,-bottom_height]) intersection() {
                linear_extrude(bottom_height) difference() {
                    square([9.7,9.6], center=true);
                    translate([-2.9,0]) square([9.4,5.8], center=true);
                }
                linear_extrude(bottom_height, scale=[9.7/9.3,1]) square([9.3,10], center=true);
                translate([-9.4/2,0,0]) rotate([0,-bottom_angle,0]) translate([9.4/2,0,0]) union() {
                    linear_extrude(1.5, scale=[1,9/8]) square([20,8], center=true);
                    translate([0,0,1.5]) linear_extrude(bottom_height-1.5, scale=[1,9.6/9]) square([20,9], center=true);
                }
            }

            translate([bbox.x/2-3.1/2,0,-6.25]) intersection() {
                linear_extrude(6.25, scale=[3.10/2.95,1]) square([2.95,bbox.y], center=true);
                translate([-3.1/2,0,0]) rotate([0,-bottom_angle,0]) translate([3.1/2,0,0]) union() {
                    linear_extrude(1.5, scale=[1,10.9/10.2]) square([10,10.2], center=true);
                    translate([0,0,1.5]) linear_extrude(bottom_height-1.5, scale=[1,11.05/10.9]) square([10,10.9], center=true);
                }
            }

            translate([-bbox.x/2,6.2/2,0]) rotate([90,0,0]) linear_extrude(6.2) shape1();
        }
        translate([-bbox.x/2,0,-bottom_height]) rotate([0,-bottom_angle,0]) translate([0,-20/2,-20]) cube([120,20,20]);
        translate([13.4-bbox.x/2,0,top_height]) rotate([0,top_angle,0]) translate([-13.4,-20/2,0]) cube([120,20,20]);
    }

}


if ($preview) {
    divider();
    //color("green", 0.2) translate([0,0,bbox.z/2-bottom_height]) cube(bbox, center=true);
} else {
    rotate([0,180-top_angle,0]) 
        translate([bbox.x/2-13.4,0,-14.95])
            divider();
}