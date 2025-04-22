// Rubber feet for the Macintosh Portable
// Copyright François Revol, 2025

optimize_fdm = true;

//$fa = 0.5;
$fn=30;

/* [Hidden] */
d = 3.7;
bh_adjust = (optimize_fdm ? 0.2 : 0);
bh = 1.6 + bh_adjust;
l = 18.45;
r = 0.3;

module foot_base(d=d, l=l) {
    // the base
    difference() {
        minkowski() {
            hull() {
                for (h = [0,bh-0.1-r])
                    translate([0,0,r+h])
                        linear_extrude(0.1)
                            for (dy = [-1,1])
                                translate([0,dy*(l-d)/2,0]) circle(d=d-(h?0:.3)-2*r);
            }
            sphere(r=r);
        }
        // truncate the top
        translate([0,0,bh+r]) cube([5,20,2*r], center=true);
    }
}

module foot_flat() {

    // base
    difference() {
        foot_base(l=optimize_fdm ? l+0.2:l);
        // 4 indents for flexibility
        for (dy=optimize_fdm?[]:[-1.5:1:1.5])
            translate([0,dy*1.8,bh]) cube([d*2,0.9,1], center=true);
    }

    // the clips
    ch = 3.3;
    for (dy=[-1,1])
        translate([0,dy*12.7/2,bh]) rotate([0,0,dy*90]) {
            linear_extrude(ch, scale=[1.5/1.7,0.8]) translate([-1.7/2,0,0]) square([1.7,2], center=true);
            linear_extrude(ch, scale=[1.5/2.5,2/3]) translate([-2.5/2,0,0]) square([2.5,0.9], center=true);
            translate([0,0,2.3+0.2]) linear_extrude(0.3, scale=[1.0*2/0.2,optimize_fdm?1.44:0.98]) translate([2.5/2*0,0,0]) square([0.2,1.73], center=true);
            translate([0,0,2.3+0.5]) linear_extrude(1-0.5, scale=[optimize_fdm?1.3:1.1,0.95]) translate([2.5/2*0,0,0]) square([2.0,optimize_fdm ? 2.5 : 1.69], center=true);
        }
    // DEBUG
    //#translate([0,0,bh+2.6/2]) cube([d,12.9,2.6], center=true);
    //#cube([d,12.9,5], center=true);

    // DEBUG: bbox
    //#cube([d,18.45,5], center=true);
}

module foot_angled() {
    angle = 84;
    ar = 3;

    // base
    for (a = [0,180-angle]) {
        dy = a ? -1 : 1;
        translate([0,0,bh]) rotate([a,0,0]) translate([0,dy*0.15,-bh])
            union() {
                difference() {
                    foot_base(d=d+0.1);
                    translate([0,dy*(l/2-1.4),0]) cube(l, center=true);
                }
                difference() {
                    translate([0,-dy*l*0.2,bh]) linear_extrude(6.4, scale=[1.2/1.6,0.9]) square([1.6,8], center=true);
                    translate([0,-dy*l*0.4,bh+2.4/2-0.2]) cube([4,2.4,2.4], center=true);
                    translate([0,-dy*l*0.408,bh+2.4-0.21]) linear_extrude(0.4, scale=[1,0.01]) square([2,2.4+0.3], center=true);
                    // avoids smashing in the mirrored part
                    translate([0,0*dy*l*0.4,bh+6.4]) cube([4,7,2], center=true);
                }
            }
    }
    // the round part of the base
    translate([0,bh_adjust-0.03-ar/2,ar+0.0]) rotate([-90,90-angle,-90])
        rotate_extrude(angle = angle-180)
            projection(cut = true)
                rotate([90,0,90]) translate([0,0,-ar])
                    foot_base(d=d+0.1);
    //#cylinder(r = 3);
    // DEBUG: bbox
    //#translate([0,1.5-10.6/2,10.6/2]) cube([4,10.6,10.6], center=true);

    // the friction-fit clip
}

for (i=[0:4])
    translate([5*i,0,0]) foot_flat();

for (i=[0:1])
    translate([7+5*i,12.5,0]) rotate([0,0,i*180-90]) foot_angled();
