// ADB Mouse II ball holder ring
// Copyright François Revol, 2024-2025

// TODO: Might need some margins for FDM print

// see also:
// https://www.myminifactory.com/object/3d-print-apple-desktop-bus-mouse-ii-replacement-ball-cover-52489

/* [Printing options] */

// Optimize for FDM printers (less supports, larger details)
optimize_fdm = true;

// Keep text for FDM optimized
keep_text = true;

/* [Preview] */

flip = false;
insertion_distance = 0; // [0.0:0.1:10]

/* [Hidden] */

// we need more faces on such a small piece
$fa= $preview ? 6 : 2;
$fs= $preview ? 0.2 : 0.1;


module adbm2_ball_ring(optimize_fdm = false) {
    ball_dz = 9.3;
    ball_margin = 0.5;
    border_r = 0.5;
    clip_a = 75;

    // taken from https://forum.openscad.org/bend-text-tp24201p24206.html
    module circletext(mytext,textsize=20,myfont="Arial",radius=100,thickness=1,degrees=360,top=true){
        chars=len(mytext)+1;
        for (i = [1:chars]) {
            rotate([0,0,(top?1:-1)*(degrees/2-i*(degrees/chars))])
                translate([0,(top?1:-1)*radius-(top?0:textsize/2),0])
                    linear_extrude(thickness)
                        text(mytext[i-1],halign="center",font=myfont,size=textsize);
        }
    }

    module notches(o = 0) {
        intersection() {
            difference() {
                cylinder(d = 33.3, h=0.6);
                cylinder(d = 15.0, h=0.7);
            }
            // Why such a weird shape, oh well.
            for(a = [0,180]) {
                nd = 50;
                no = 3;
                rotate([0,0,a]) difference() {
                    translate([12,nd/2-no,0]) translate([0,-7.77/2,0]) cylinder(d = nd, h = 1);
                    translate([12,nd/2-no,0]) translate([0,+7.77/2,0]) cylinder(d = nd, h = 3, center=true);
                    rotate([0,0,90]) cube(nd);
                }
            }
        }
    }

    translate([0,0,0]) difference() {
        // Main body shape
        union() {
            difference() {
                translate([0,0,1.8]) cylinder(d = 31.95, h = 4.75-1.8);
                cylinder(d = 23.1, h = 5);
            }
            translate([0,0,border_r]) difference() {
                minkowski() {
                    cylinder(d1 = 34.9-2*border_r, d2 = 35-2*border_r, h = 1.8/*-2*border_r*/);
                    sphere(border_r);
                }
                translate([0,0,1.8-border_r]) cylinder(d = 40, h = 10*border_r);
            }
            if (!optimize_fdm || keep_text) {
                translate([0,0,1.8-0.1]) rotate([0,0,-90])
                    circletext("400905-0",textsize=1.0,myfont="Arial",radius=10.0,thickness=0.2,degrees=45,top=true);
                translate([0,0,1.8-0.1]) rotate([0,0,-90])
                    circletext("11",textsize=1.1,myfont="Arial",radius=10.0,thickness=0.2,degrees=10,top=false);
            }
        }
        // Room for the ball
        translate([0,0,-1]) cylinder(d=13.45, h = 11);
        translate([0,0,-1]) cylinder(d1=10, d2=18, h = 4);
        // The clips and mating ring
        for (i=[0,1]) {
            rotate([0,0,clip_a-5+180*i]) translate([27/2,0,2]) cylinder(d = 1.1, h=2.8);
        }
        for (v = [
                // sides, start angle, shape, angle
                [[0,1], 0,[25.8/2, 4], 25],
        ]) {
            for (i=v[0]) {
                rotate([0,0,clip_a+v[1]+180*i]) translate([0,0,1.8+v[2].y/2]) rotate_extrude(angle = v[3]) translate([v[2].x/2,0,0]) square(v[2], center=true);
            }
        }
        for (v = [
                // sides, start angle, delta, box, x angle
                [[1], 12, [0,0.3,0], [20, 5, 0.7], 0],
                [[1], 12, [0,0.6,0], [20, 1.3, 1.5], 0],
                [[1], 12, [0,0,2.9], [20, 6, 0.7], -5],
                [[0], 12, [0,0.3,0], [20, 5, 1], 0],
                [[0,1], 12, [0,0,0], [20, 3.4, 1.2], 0],
                [[0,1], 0, [0,1.2,0], [24, 2.4, 1.2], 0],
                [[0,1], 12, [0,2.7,0], [20, 0.3, 5], 0]
                ]) {
            for (i=v[0]) {
                rotate([0,0,clip_a+v[1]+180*i]) translate([v[3].x/2,0,1.8+v[3].z/2]) translate(v[2]) rotate([v[4],0,0]) cube(v[3], center=true);
            }
        }
        translate([0,0,1.8]) difference() {
            cylinder(d=35,h=4);
            cylinder(d=25.7,h=1.4);
            difference() {
                cylinder(d=32,h=3);
                cylinder(d=optimize_fdm?28:30,h=3);
                for (v = [
                        // sides, start angle, delta, box, x angle
                        [[0,1], 12-12, [0,-20,-2.2], [25, 40, 20], 18],
                        [[0,1], 12, [0,20,0], [25, 40, 20], 0],
                        ]) {
                    for (i=v[0]) {
                        rotate([0,0,clip_a+v[1]+180*i]) translate([v[3].x/2,0,v[3].z/2]) translate(v[2]) rotate([v[4],0,0]) cube(v[3], center=true);
                    }
                }
            }
            for (v = [
                    // sides, start angle, delta, box, x angle
                    [[0,1], 12, [0,0,0], [25, 5, 4], 0],
                    [[0,1], 0, [0,1.2,0], [24, 3*2.4, 4], 0],
                    ]) {
                for (i=v[0]) {
                    rotate([0,0,clip_a+v[1]+180*i]) translate([v[3].x/2,0,v[3].z/2]) translate(v[2]) rotate([v[4],0,0]) cube(v[3], center=true);
                }
            }
        }
        // There's probably some useless stuff down there, copied from the PB1xx trackball ring code
        difference() {
            cylinder(d = 40, h = 10);
            // we re-add mater layer by layer
            difference() {
                cylinder(d = 40, h = 3.6);
                //#translate([0,0,3.5]) cube([40, 1.7, 3], center=true);
                if (!optimize_fdm || keep_text)
                    translate([0,0,3.5-0.1]) rotate([0,0,50])
                        circletext("remake by mmu_man",textsize=1.1,myfont="Arial",radius=17.5,thickness=0.3,degrees=70,top=false);
            }
            difference() {
                cylinder(d = 33.1, h = 7.3);
                //translate([0,0,7.4]) cube([6.4,40,0.2], center=true);
                for (a = [0,180])
                    rotate([0,0,a]) {
                        /*translate([0.2,-20,7.4-0.1])
                            linear_extrude(0.2, scale=[0.8,1])
                                square([6.4,20], center=true);*/
                        //translate([0.2,-20,7.4]) 
                            //cube([6.4,20,0.2], center=true);
                        translate([4.4,0,7.4+0.35])
                            rotate([90,0,0])
                                cylinder(d=2.45, h=40);
                    }
            }
            intersection() {
                difference() {
                    cylinder(d = 38, h = 7.3);
                    cylinder(d = 33.5, h = 8);
                }
                union() {
                    for (a = [0,180])
                        rotate([0,0,a])
                            translate([4.4,0,7.4+0.35])
                                rotate([90,0,0])
                                    cylinder(d=2.4, h=40);
                }
            }
            // Some extra supports for the clips
            if (optimize_fdm) for (a = [0,180]) {
                rotate([0,-40,a-6])
                    translate([9.1,18,-1])
                        cube([1.5,10,8], center=true);
            }
            difference() {
                intersection() {
                    translate([0,0,7.3]) cylinder(d = 38, h = 1.6-0.1);
                    union() {
                        translate([0,0,7.3+1]) cube([11,40,2], center=true);
                        if (optimize_fdm) {
                            //#rotate([0,0,-6]) translate([0,0,7.3+1]) cube([11,40,2], center=true);
                            rotate([0,0,-6]) translate([0,0,7.3]) linear_extrude(2, scale=[0.75,1]) square([11+2.5,40], center=true);
                        }
                    }
                }
                // Room for the ball to pass between clips
                translate([0,0,7.3-0.1]) cylinder(d = 31.0, h = 3);
                difference() {
                    fdm_delta = optimize_fdm ? 3 : 0;
                    translate([0,0,7.3-0.1]) cylinder(d = 33.5, h = 3);
                    for (a = [0,180])
                        rotate([0,0,a]) translate([-4.3-fdm_delta/2,-16,7.4])
                            cube([2.4 + fdm_delta,5,5], center=true);
                }
                for (a = [0,180])
                    rotate([0,0,a]) {
                        translate([0.21,-20,7.4-0.11])
                            linear_extrude(0.2, scale=[0.9,1])
                                square([6.2,20], center=true);
                        translate([6.1,-17,7.4+1.1])
                            rotate([0,20,0])
                                cube([8,6,2], center=true);
                    }
            }
        }
        // the two notches to help turn the part
        rotate([0,0,10])
            notches(o = 0.1);
        // paper clip hole to force open?
        rotate([0,0,-90]) translate([(35/2)-3.7,0,-1]) cylinder(d=1.5, h = 4);
    }

    if ($preview && 0)
        color("DimGrey", 0.2) translate([0,0,ball_dz]) sphere(d = 22);
}


if ($preview) {
    echo($t);
    //translate([0,0,insertion_distance*20+9-min(9,$t*20)])
        //rotate([flip?180:0,0,min(0,20-$t*48)*2-40])
            //color("#bdbdb2")
                //render()
                    adbm2_ball_ring(optimize_fdm);
} else {
    adbm2_ball_ring(optimize_fdm);
}
