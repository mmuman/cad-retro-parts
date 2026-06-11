// Rubber handle for the Atari VCS joystick
// Copyright 2026, François Revol

/*[Printing]*/

optimize_fdm = true;

EXPORT_SUPPORTS_BLOCKER = false;

/*[Model]*/

total_height = 78.5;

// Beware, STL size in MB is about as many
$fn=$preview ? 60 : 240;

module rod()
{
    cylinder(d1 = 13, d2 = 10.3, h=76.5);
}

module handle() {
    handle_r = 3;

    module shape1(d=20, r=handle_r) {
        offset(r) offset(-r) circle(d=d, $fn=6);
    }
    module shape2(d=20, r=handle_r, a) {
        rotate([0,0,a]) translate([d/2-r+r*cos(30),0]) circle(d=0.5, $fn=6);
    }
    module ridges(r=1.5) {
        points = [
            [10,6+r,1],
            [13,6+r,1],
            [15,12-r,-1],
            [17,6.5+r,1],
            [19,10-r,-1],
            [21,3+r,1],
            [23,7.5-r,-1],
            [55/2-4.5+r,r,1]+(optimize_fdm?[0,0,0]:[0.2,.6,0])
        ];
        difference() {
            for (i = [0:len(points)-1]) {
                difference() {
                    hull() {
                        translate(points[i]) circle(r=r);
                        if (i == 0)
                            translate(points[i+1]) circle(r=r);
                    }
                    translate(points[i]+[0,points[i].z*r])
                        square([r*3,r]*2,center=true);
                }
                if (i > 0)
                    hull() {
                        translate(points[i-1]+[r-r/3,0]) circle(r=r/3);
                        translate(points[i]+[-r+r/3,0]) circle(r=r/3);
                }
            }
            for (i = [0:len(points)-2]) {
                hull() {
                    translate(points[i]) circle(r=r/3);
                    //translate(points[i]+[0,points[i].z*.5]) circle(r=r/3);
                    if (i==0)
                        translate(points[i+1]) circle(r=r/3);
                }
            }
        }
        translate([55/2-3+3,0]+(optimize_fdm?[0,0]:[0,0.4]))
            rotate(optimize_fdm?[0,0,0]:[0,0,-5])
                translate([-3.5,0])
                square([3.5,optimize_fdm?2.0:2.2]);
    }

    difference() {
        union() {
            translate([0,0,15]) 
                hull() {
                    linear_extrude(0.01) shape1();
                    translate([0,0,total_height-15-0.5]) linear_extrude(0.01) shape1(20-2);
                }
            translate([0,0,total_height-0.5]) 
                hull() {
                    linear_extrude(0.01) shape1(20-2);
                    translate([0,0,0.5]) linear_extrude(0.01) offset(handle_r) offset(-handle_r) circle(d=20-2-1, $fn=6);
                }
            translate([0,0,7]) cylinder(d1=23,d2=22,h=8);
            translate([0,0,15]) cylinder(d1=22,d2=16,h=2);
            rotate_extrude() 
            ridges();
        }
        for(a=[0:60:359])
            hull() {
                translate([0,0,16.1-0.1]) linear_extrude(0.01) shape2(a=a);
                translate([0,0,total_height]) linear_extrude(0.01) shape2(20-2, a=a);
                }

        // room for the handle bar
        cylinder(d1 = 13, d2 = 10.8, h=76.51);
        translate([0,0,76.5]) cylinder(d1 = 10.8, d2 = 8, h=0.5);
        translate([0,0,6]) cylinder(d1=18,d2=17.5,h=8);
        translate([0,0,14]) cylinder(d1=17.5,d2=12,h=2);

        if ($preview) cube(100);
                
    }
}

if (!EXPORT_SUPPORTS_BLOCKER || $preview) {
    /*color("darkgrey")*/ handle();
}

if (EXPORT_SUPPORTS_BLOCKER || $preview) {
    color("orange", 0.2) cylinder(d = 18, h = 80);
}

if ($preview)
    color("white", 0.2) rod();

// bounding box
//color("green", 0.2) cylinder(d = 55, h = total_height);


