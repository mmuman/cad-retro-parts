// Trackball ball holder ring for PowerBook 100 Series
// Copyright François Revol, 2023

// FIXME: WARNING: Object may not be a valid 2-manifold and may need repair!

// TODO: Might need some margins for FDM print

/* [Printing options] */

// Optimize for FDM printers (less supports, larger details)
optimize_fdm = true;

// Avoids supports when printed face-down
notches_as_indents = true;

// Keep text for FDM optimized
keep_text = true;

/* [Preview] */

flip = false;
insertion_distance = 10; // [0.0:0.1:10]

/* [Hidden] */

// we need more faces on such a small piece
$fa= $preview ? 6 : 2;
$fs= $preview ? 0.2 : 0.1;


module pb1xx_trackball_ring(optimize_fdm = false) {
    n_dz = notches_as_indents ? 0 : 0.5;
    ball_dz = 7.3;
    ball_margin = 0.5;
    border_r = 0.5;

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
        for (dy = [-1,1]) translate([0,dy*(32.7/2-2*o),0])
            hull() {
                for (d = [-1,1])
                    translate([0,d*(2-4*o),0]) sphere(d=1+2*o);
            }
    }

    color(/*"DimGrey"*/) translate([0,0,n_dz]) difference() {
        // Main body shape
        union() {
            translate([0,0,9-1.6]) cylinder(d1 = 38, d2 = 37.8, h = 1.6);
            translate([0,0,3.6]) cylinder(d = 38, h = 9-3.6-1.6);
            translate([0,0,border_r]) minkowski() {
                cylinder(d1 = 37.8-2*border_r, d2 = 38-2*border_r, h = 3.6);
                sphere(border_r);
            }
        }
        // Room for the ball
        translate([0,0,-1]) cylinder(d=27.5, h = 11);
        translate([0,0,ball_dz]) sphere(d = 30+ball_margin);
        translate([0,0,ball_dz]) difference() {
            sphere(d = 30+ball_margin+0.6);
            for (a = [0:120:240])
                rotate([0,0,60+a]) translate([0,-15,7/2-ball_dz])
                    cube([2.4,6,7], center=true);
        }
        // The clips and mating ring
        difference() {
            cylinder(d = 40, h = 10);
            // we re-add mater layer by layer
            difference() {
                cylinder(d = 40, h = 3.6);
                translate([0,0,3.5]) cube([40, 1.7, 3], center=true);
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
                /*translate([0,0,3.5]) rotate([0,0,a])
                    linear_extrude(4,twist = -10)
                        rotate([0,0,-35])
                            translate([0,18])
                                square([2,4], center = true);*/
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
                //translate([0,0,7.3]) cube([6.4,40,0.4], center=true);
                for (a = [0,180])
                    rotate([0,0,a]) {
                        translate([0.21,-20,7.4-0.11])
                            linear_extrude(0.2, scale=[0.9,1])
                                square([6.2,20], center=true);
                        //translate([0.2,-20,7.4]) 
                            //cube([6.4,20,0.2], center=true);
                        translate([6.1,-17,7.4+1.1])
                            rotate([0,20,0])
                                cube([8,6,2], center=true);
                    }
            }
            if (!optimize_fdm || keep_text) {
                translate([0,0,9-0.3]) rotate([0,0,-4.8])
                    circletext("400504-00",textsize=1.1,myfont="Arial",radius=17.5,thickness=0.2,degrees=27,top=true);
                translate([0,0,9-0.3]) rotate([0,0,-4.0])
                    circletext("3 REV B1",textsize=1.1,myfont="Arial",radius=17.5,thickness=0.2,degrees=27,top=false);
            }
        }
        // debug
        //if ($preview) cube(30);
        // Notches as indents for FDM print
        if (notches_as_indents)
            notches(o = 0.1);
    }
    
    if (!notches_as_indents)
        translate([0,0,n_dz]) notches();
    if ($preview)
        color("DimGrey", 0.2) translate([0,0,ball_dz+n_dz]) sphere(d = 30);
}


module pb1xx_trackball_opening(optimize_fdm = false) {
    module top_button(o = 0) {
        d = -o; //0.5;
        translate([0,13,0]) {//minkowski() { // too slow
            difference() {
                intersection() {
                    cube([73.5,25.5,8] - d * [2,2,2], center=true);
                    translate([0,-88,0]) cylinder(d = 200 - d, h = 20, center = true);
                }
                translate([0,-13,0]) cylinder(d = 39.8 + d*2, h = 20, center = true);
            }
            //sphere(d);
        }
    }

    color("grey",0.4) difference() {
        translate([0,0,-5]) cube([100, 80, 10], center=true);
        top_button(1);

        difference() {
            union() {
                translate([0,0,-6]) cylinder(d = 39.5, h = 40);
                translate([0,0,-10.1-6]) cylinder(d = 38.9, h = 10.2);
            }
            difference() {
                union() {
                    translate([0,0,-4-3.6]) cylinder(d = 36.5, h = 4);
                    difference() {
                        translate([0,0,-2-5.6]) cylinder(d = 40, h = 2);
                        translate([0,0,-10-6]) cylinder(d = 36, h = 10.1);
                    }
                }
                // indents for the clips, actually square but well
                for (a = [0,180])
                    rotate([0,0,90+a])
                        translate([-4.4,0,-7.5])
                            rotate([90,0,0])
                                cylinder(d=2.4, h=40);
                rotate([0,0,45]) cube([50,13.3,30], center=true);
                rotate([0,0,85]) cube([50,14,30], center=true);
            }
            intersection() {
                union()
                    for(a=[0,180])
                        hull() {
                            translate([0,0,-9.6])
                                linear_extrude(height = 6, twist = -40)
                                    rotate([0,0,a-14.5]) translate([0, (33.5+3.3)/2])
                                        square([4, 3.3], center=true);
                            rotate([0,0,a-45]) translate([-7.2, (33.5)/2-2,-10+0.5]) rotate([-90,0,0]) cylinder(d = 1, h = 3.3);
                        }
                rotate([0,0,85]) cube([50,15,20], center=true);
            }
        }
        cylinder(d = 33.1, h = 40, center=true);
        translate([0,0,-20]) rotate([0,0,-90]) cube(60);
    }
    //color("grey") top_button();
}

if ($preview) {
    pb1xx_trackball_opening();
    //insertion_distance
    echo($t);
    translate([0,0,insertion_distance*20+9-min(9,$t*20)])
        rotate([flip?180:0,0,min(0,20-$t*48)*2-40])
            pb1xx_trackball_ring(optimize_fdm);
} else {
    pb1xx_trackball_ring(optimize_fdm);
}
