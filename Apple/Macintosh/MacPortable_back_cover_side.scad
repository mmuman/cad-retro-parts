// Back cover side for the Macintosh Portable
// Copyright François Revol, 2026

// [Printing]

optimize_fdm = true;

// [Options]

first_slot = 1; // [0:Nothing,1:Floppy,2:BlueSCSI Full SD - UNTESTED]

second_slot = 0; // [0:Nothing,1:Floppy - UNTESTED,2:BlueSCSI Full SD - UNTESTED]

// TODO: BSCSI LED! (&only?)

// [Hidden]
//$fn=30;
$fn = $preview?8:0;

$fs = $preview ? 2 : 0.5;

module back_cover_side() {
    bbox = [152.2, 53.5,21.3];
    base_bbox = [152.2, 53.5,5.25];
    corner_r = 3.0;
    groove_r = 1.5;

    module clip1() {
        clip_r = 0.5;
        clip_th = optimize_fdm ? 3 : 1.6;
        difference() {
            minkowski() {
                linear_extrude(19.8-1.8-clip_r, scale=[17.4/18.5, 1.22/1.6])
                    translate([0,-clip_r-clip_th/2])
                        square([18.5,clip_th]-clip_r*[2,2], center=true);
                sphere(r=clip_r);
            }
            translate([0,0,11.9-1.8+3.4/2]) cube([8.5,10,3.4], center=true);
            // internal reinforcement
            for (dx=(optimize_fdm?[-1,1]:[]))
                translate([8*dx,-1.5,0]) cylinder(d=0.5,h=17.9);
        }
    }

    module clip2() {
        clip_r = 0.5;
        translate([0.3,28.2,3.3]) difference() {
            translate([1,0,-1]) cube([6,9,19]);
            translate([5/2-0.1,10/2-0.1,20/2+5.23-3.3]) difference() {
                cube([5,10,20], center=true);
                translate([5/2,0-1,11.1-20/2]) linear_extrude(5,scale=[0.2,1]) square([4,11], center=true);
            }
            translate([7.3,10/2-0.3,optimize_fdm?10:0]) difference() {
                rotate([0,0,-9]) linear_extrude(20/(optimize_fdm?2:1)) square([2,10], center=true);
            }
            if (optimize_fdm) {
                // internal reinforcement
                for (dy=[0:2])
                    translate([5.8-dy/4,8-dy*2,-1]) cylinder(d=0.8,h=17.9);
            } else {
                translate([6.1,0,0]) cube([2,10,10.5]);
                translate([6.1,0,18-2-2.5]) cube([2,10,2]);
            }
        }
        if (optimize_fdm) {
            translate([4.8,28.2+15.5,3.3]) difference() {
                linear_extrude(21, scale=[0.2,1]) square([5,5]);
                translate([3,2,9.5]) rotate([0,0,-30]) linear_extrude(8.5) square([3,10], center=true);
                // internal reinforcement
                translate([1,4,-1]) cylinder(d=0.8,h=18);
            }
            translate([4.8,28.2,18+3.3]) cube([1.0,9,3]);
            translate([4.8,28.2,21+3.3]) cube([1.0,20.5,2]);
        }
    }

    module clip3() {
        clip_r = 0.5;
        translate([131,31.8,3.3]) difference() {
            translate([-1,0,-1]) linear_extrude(16.7+1) square([7.5,7.9]);
            translate([5/2-4-0.1,10/2-0.5,0]) rotate([0,0,10])
                linear_extrude(17,scale=optimize_fdm?1.3:1) square([optimize_fdm?3:5,10], center=true);
            translate([5.2/2+2-0.1,10/2-0.3,16.7/2+5.23-3.3]) rotate([0,0,180+10]) difference() {
                cube([5.2,10,16.7], center=true);
                translate([5/2,0-1,11.2-16.7/2]) linear_extrude(5,scale=[0.2,1]) square([4,11], center=true);
            }
            // internal reinforcement
            for (dy=(optimize_fdm?[-1:1]:[]))
                translate([1-dy/2,4+2*dy,-1]) cylinder(d=0.8,h=16.6+1);
        }
    }

    for(dx=[0,1])
        translate([40+dx*57.8,bbox.y-3.25,1.8]) clip1();
    clip2();
    clip3();

    module base_shape1(y=27.5) {
        hull() {
            translate([0,bbox.y-y]) square([123,y]);
            translate([138-14,bbox.y-14]) circle(r=14);
        }
    }

    module base_shape(cutout=true) {
        base_shape1();
        difference() {
            translate([0,bbox.y-50]) square([155,50-14]);
            if (cutout) translate([138+16,bbox.y-14]) circle(r=16);
        }
    }

    module opening_floppy(slot=0) {
        // No idea where it should be for slot 1.
        slot_delta = [0,slot*/*19.5*/27.4,0];
        translate([27,-2.3,0]+slot_delta) linear_extrude(20,center=true) square([95, 6.3]);
        // paperclip hole
        if (slot)
            translate([20+3.5/2,3.1-3.5/2,0]+slot_delta) cylinder(d=1.85, h=20, center=true);
        else
            translate([20+3.5/2,3.1-3.5/2,0]) linear_extrude(20,center=true) square([3.5, 3.5], center=true);
    }

    module opening_bluescsi_fsd(slot=0) {
        // No idea where it should be for slot 0.
        slot_delta = [0,slot*/*19.5*/27.4,0];
        translate([56.5,0.6-2.9,0]+slot_delta) linear_extrude(20,center=true) square([25, 5]);
    }

    difference() {
        union() {
            minkowski() {
                difference() {
                    minkowski() {
                        translate([0,0,corner_r]) linear_extrude(5) difference() {
                            offset(-corner_r) base_shape();
                        }
                        sphere(r=corner_r-groove_r);
                    }
                    // grooves
                    groove_th = 1.25+2*groove_r;
                    translate([0,23.75-groove_r/*bbox.y-28.6-groove_th*/,0]) {
                        cube([200,groove_th,1.7+groove_r]);
                        cube([1.3+groove_r,groove_th,10]);
                    }
                    translate([0,0,0]) {
                        cube([200,bbox.y-47.6+groove_r,1.7+groove_r]);
                        cube([1.3+groove_r,bbox.y-47.6+groove_r,10]);
                    }
                    translate([152.2-groove_r,0,0])
                        cube([groove_th+5,30,10]);
                }
                sphere(r=groove_r);
            }
            // little patch due to the 16mm cylinder
            translate([145.2,23.75-5-groove_r,groove_r+0.02]) minkowski() {
                cube([5.5,5,1]);
                sphere(r=groove_r);
            }
            translate([groove_r,6.1,1.75]+[146.9,0,5]/2) rotate([90,0,0]) linear_extrude(6.1,scale=[0.995,0.7]) offset(groove_r) offset(-groove_r) square([146.9,5], center=true);
        }
        translate([-1,-1,5.25]) cube([200,60,10]);
        // we can't use hull on concave objects so we cheat with scale.
        translate([bbox.x/2,bbox.y/2,3.3]) linear_extrude(2, scale=[1.02,1.03]) translate([-bbox.x/2,-bbox.y/2,0]) {
            offset(-4.3) base_shape(cutout=true);
            offset(-4.3) translate([0,5.9]) square([200,25.7+4.5]);
        }
        translate([bbox.x/2,bbox.y/2,3.6]) linear_extrude(2, scale=[1.02,1.03]) translate([-bbox.x/2,-bbox.y/2,0]) offset(-4.3) {
            base_shape(cutout=true);
            translate([0,-5]) square([200,24]);
        }

        /*translate([bbox.x/2,bbox.y/2,5.25-2.6]) linear_extrude(2, scale=[1.02,1.03]) translate([-bbox.x/2,-bbox.y/2,0]) offset(-1.9) {
            base_shape1();
            //translate([0,-1]) square([200,20]);
        }*/
        /*translate([bbox.x/2,bbox.y/2,5.25-2.6]) linear_extrude(2, scale=[1.02,1.03]) translate([-bbox.x/2,-bbox.y/2,0]) offset(-4.3) {
            base_shape(cutout=true);
            translate([0,-1]) square([200,20]);
        }
        */
        translate([0,0,5.25-2.6]) difference() {
            hull() {
                linear_extrude(0.1) offset(1.5) offset(delta=corner_r-1.5) offset(-1.6-corner_r) base_shape1(y=32);
                translate([0,0,2.7]) linear_extrude(0.1) offset(1.5) offset(delta=corner_r-1.5) offset(-1.4-corner_r) base_shape1(y=32);
            }
            translate([0,0,-0.1]) linear_extrude(3) {
                offset(-4.5) base_shape();
                square([10,26.25]);
            }
            //translate([0,0,2]) linear_extrude(0.1) offset(-1.5) base_shape1();

        }
        translate([0,0,4]) rotate([20,0,0]) cube(10);
        translate([148,0,1.7]) rotate([0,0,-4]) cube(30);
        translate([148-2+0.1,2,0]) difference() {
            rotate([0,0,-90]) cube(7);
            cylinder(r=2,h=9);
        }
        //#cube(1.3);
        //#cube(23.7);
        //#translate([0,bbox.y-28.6-2,0]) cube(1.25);
        // floppy holes
        for (slot=[0:1]) {
            s = [first_slot,second_slot][slot];
            if (s == 1)
                opening_floppy(slot);
            if (s == 2)
                opening_bluescsi_fsd(slot);
        }
        //if ($preview) cube(30);
    }

    // part number
    the_font = "Montserrat Thin,QTHowardType";
    translate([69,bbox.y-16,3.3]) linear_extrude(0.2) text("815-1113-11"/*"815-1113-\U00246A"*/, font=the_font, halign="center", valign="center", size=4); // circled 11
    translate([69,bbox.y-21,3.3]) linear_extrude(0.2) text("2", font=the_font, halign="center", valign="center", size=4);

    //color("green", 0.2) cube(bbox);
    //if ($preview) color("green", 0.2) cube(base_bbox);
}

back_cover_side();
