// Trackball ball holder ring for PowerBook 100 Series
// Copyright François Revol, 2023

// FIXME: WARNING: Object may not be a valid 2-manifold and may need repair!

// TODO: Might need some margins for FDM print

/* [Printing options] */

// Optimize for FDM printers (less supports, larger details)
optimize_fdm = true;

// Keep text for FDM optimized
keep_text = true;

/* [Hidden] */

// we need more faces on such a small piece
$fa= $preview ? 6 : 2;
$fs=0.1;


module pb1xx_trackball_ring(optimize_fdm = false) {
    n_dz = optimize_fdm ? 0 : 0.5;
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
                for (a = [0,180])
                    rotate([0,0,a])
                        translate([4.4,0,7.4+0.35])
                            rotate([90,0,0])
                                cylinder(d=2.4, h=40);
            }
            difference() {
                intersection() {
                    translate([0,0,7.3]) cylinder(d = 38, h = 1.6-0.1);
                    translate([0,0,7.3+1]) cube([11,40,2], center=true);
                }
                // Room for the ball to pass between clips
                translate([0,0,7.3-0.1]) cylinder(d = 31.0, h = 3);
                difference() {
                    translate([0,0,7.3-0.1]) cylinder(d = 33.5, h = 3);
                    for (a = [0,180])
                        rotate([0,0,a]) translate([-4.3,-16,7.4])
                            cube([2.4,5,5], center=true);
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
        if (optimize_fdm)
            notches(o = 0.1);
    }
    
    if (!optimize_fdm)
        translate([0,0,n_dz]) notches();
    if ($preview)
        color("DimGrey", 0.2) translate([0,0,ball_dz+n_dz]) sphere(d = 30);
}

pb1xx_trackball_ring(optimize_fdm);
