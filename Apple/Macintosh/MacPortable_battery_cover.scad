// Battery cover for the Macintosh Portable
// Copyright François Revol, 2026

// [Printing]

optimize_fdm = true;

// Add built-in supports
//builtin_supports = true;

/*[Hidden]*/

$fn=40;


bbox = [145.2,126,32+1];

module battery_symbol_outline() {
    square([10,5], center=true);
    for (dx=[-1,1])
        translate([dx*3,1]) square([1.7,6], center=true);
}

module prong(base=[5,2.4], length=6.1) {
    linear_extrude(length-0.6) square(base, center=true);
    translate([0,0,length-0.6]) linear_extrude(0.6, scale=[0.8,0.5]) square(base, center=true);
}

module spring_clip(sub=false) {
    if (sub) {
        translate([0,0,-6]) linear_extrude(10) {
            hull()
                for (dx=[-1,1])
                    translate([dx*7.1/2,2]) circle(d=2);
            for (dx=[-1,1])
                hull()
                    for (dy=[0,1])
                        translate([dx*7.1/2,2-dy*19.5]) circle(d=2);
        }
        translate([0,2-20/2,-4-5/2+0.5]) rotate([3,0,0]) cube([7,20,5], center=true);
    } else {
        translate([0,0,0]) rotate([0,90,0]) cylinder(d=2, h=5, center=true);
    }
}

module battery_spring(sub=false) {
    if (sub) {
        translate([0,0,-5]) linear_extrude(10) {
            for (dx=[-1,1])
                hull()
                    for (dy=[0,1])
                        translate([dx*4.4/2,1-dy*14]) circle(d=2.1);
        }
        //if(!optimize_fdm) translate([0,2-20/2,-4-5/2+0.5]) rotate([3,0,0]) cube([7,20,5], center=true);
        translate([0,0.1,0]) linear_extrude(2+(optimize_fdm?0.5:1), scale=[1,0]) translate([0,-8/2]) square([3,8], center=true);
        translate([0,0.1,-3]) linear_extrude(3.01, scale=[1,0.85]) square([3,18.8], center=true);
    } else {
        translate([0,0,0]) linear_extrude(3.3, scale=[1,0]) translate([0,-14/2]) square([2.4,14], center=true);
    }
}

module holder_clip(sub=false) {
    if (sub) {
        translate([0,0,4.4]) linear_extrude(10) hull()
            for (dx=[-1,1],dy=[-1,1])
                translate([dx*15.3/2,3/2-dy*33.2]) circle(d=3);
        translate([0,0,-1]) linear_extrude(10) for (dx=[-1,1])
            hull()
                for (dy=[-1,1])
                    translate([dx*15.3/2,3/2-dy*33.2]) circle(d=3);
        translate([0,31/2+4.5,3.95+0.2]) rotate([0.8,0,0]) linear_extrude(2) square([15,31], center=true);
        translate([0,31/2+4.5,0.09-1.55]) rotate([-2,0,0]) linear_extrude(3) square([15,31], center=true);
        //if(!optimize_fdm) translate([0,2-20/2,-4-5/2+0.5]) rotate([3,0,0]) cube([7,20,5], center=true);
    } else {
        //translate([0,0,0]) rotate([0,90,0]) cylinder(d=2, h=5, center=true);
        translate([0,4.7,0]) linear_extrude(3.95-1.1, scale=[1,4.7]) translate([0,-1/2]) square([12.2,1], center=true);
        translate([0,4.7/2,3.95-1.1]) linear_extrude(1.1) square([12.2,4.7], center=true);
        translate([0,5/2+4.7,1]) linear_extrude(3.4) square([12.2,5], center=true);
        //translate([0,5/2+4.7,3.95-1.9]) linear_extrude(1.9) square([12.2,5], center=true);
    }
}

module battery_cover() {

    label_bbox = [42.3,22.5];
    top_prongs = [16.1,32.1,52.3,98.3,118.8,134.6];
    holder_clips = [22.65+3+12.2/2-bbox.x/2, -(22.35+3+12.2/2-bbox.x/2)];
    difference() {
        union() {
            translate([0,96.5/2-bbox.y/2+7.7,optimize_fdm?0:1])
                linear_extrude(3.4+(optimize_fdm?1:0))
                    square([145.2,96.5], center=true);
            translate([0,68.35/2-bbox.y/2+7.7+8.9,1])
                linear_extrude(4)
                    square([137.8,68.35], center=true);
            if (!optimize_fdm)
                translate([0,49.1+label_bbox.y/2-bbox.y/2,1]) rotate([180,0,0]) linear_extrude(.4) difference() {
                    offset(3) offset(-3) square(label_bbox, center=true);
                    offset(3-1.4) offset(-(3-1.4)) square(label_bbox-[1,1]*2*1.4, center=true);
                }
            // pongs
            for(dx=[4.2,45.2,95.1,127])
                translate([5/2-bbox.x/2+dx,7.7-bbox.y/2,1+3.4-2.4/2]) rotate([90,0,0]) prong();
            if (!optimize_fdm) translate([0,-51,4.5]) rotate([0,0,180]) text("815-1097-11", size=4, valign="center", halign="center");

            for(dx=[-1,1])
                translate([dx*(7.6-2-5/2-bbox.y/2),7.7-bbox.y/2-1+51.5,5]) spring_clip();

            // Vertical part is about 88°, not exactly 90.
            translate([0,96.5-bbox.y/2+7.7,0]) rotate([-2,0,0]) translate([0,-3.7/2,15.3/2+1]) cube([bbox.x,3.7,15.3], center=true);
            intersection() {
                translate([0,96.5-bbox.y/2+7.7+0.21,15.7+1-1.32]) rotate([0,90,0]) cylinder(r=3.5,h=bbox.x,center=true);
                translate([-bbox.x/2,96.5-bbox.y/2+7.7-5.36+2+0.23,15.7+1-0.4]) cube([bbox.x,10,10]);
            }
            translate([0,96.5-bbox.y/2+7.7+15.5/2+0,15.2+1]) linear_extrude(2.65) square([bbox.x,15.5],center=true);
            translate([54-bbox.x/2,96.5-bbox.y/2+7.7+15.5,18+1-0.2]) battery_spring();

            // Battery switch nub
            translate([22+3.5/2-bbox.x/2,96.5-bbox.y/2+7.7+15.5-20/2+5.6,15.2+1]) intersection() {
                linear_extrude(16.8, scale=[2.3/3.5,18/20]) square([3.5,20], center=true);
                translate([0,0,18.2/2-3.6]) rotate([23,0,0]) cube([5,30,18.2], center=true);
            }
            //#translate([22+3.5/2-bbox.x/2,96.5-bbox.y/2+7.7+15.5-20/2+5.6-3.3,15.2+1+2.65+8.8/2]) cube([10,12,8.8], center=true);

            for(dx=top_prongs)
                translate([-5.45/2-bbox.x/2+dx,-bbox.y/2+7.7+93.3,1+10.35-2.35/2]) rotate([90,0,0]) prong(base=[5.45,2.35],length=3.5);

            for (dx=holder_clips)
                translate([dx,-bbox.y/2,0]) holder_clip();
        }

        translate([bbox.x/2-58.25,0,1+10.3+.01]) linear_extrude(10) square([90,90]);

        for(dx=[-1,1])
            translate([dx*(7.6-2-5/2-bbox.y/2),7.7-bbox.y/2-1+51.5,5]) spring_clip(sub=true);

        translate([54-bbox.x/2,96.5-bbox.y/2+7.7+15.5,18+1-0.2]) battery_spring(sub=true);

        for(dx=top_prongs)
            translate([-5.45/2-bbox.x/2+dx,-bbox.y/2+7.7+93.3-5.8/2,(optimize_fdm?0:1)-0.1]) linear_extrude(8+(optimize_fdm?1:0), scale=[0.9,0.93]) square([9.85,5.8], center=true);

        for (dx=holder_clips)
            translate([dx,-bbox.y/2,0]) holder_clip(sub=true);

        if (optimize_fdm) {
            translate([0,49.1+label_bbox.y/2-bbox.y/2,1.39-1]) rotate([180,0,0]) linear_extrude(0.4) difference() {
                offset(3) offset(-3) square(label_bbox, center=true);
                offset(3-1.4) offset(-(3-1.4)) square(label_bbox-[1,1]*2*1.4, center=true);
            }
            translate([0,49.1+label_bbox.y/2-bbox.y/2,1.39-1]) rotate([180,0,0]) linear_extrude(0.4) {
                text("- +", halign="center", valign="center", size=8, font="monospace");
                difference() {
                    offset(1) scale([2,2]) battery_symbol_outline();
                    scale([2,2]) battery_symbol_outline();
                }
            }
        }
        // indents for fingers
        for (dx=[-1,1])
            translate([dx*120/2,57.7-bbox.y/2+7.7+12/2,(optimize_fdm?0:1)-0.01]) linear_extrude(optimize_fdm?0.4:0.2) hull() {
                circle(d=12);
                translate([0,12/2]) square([12,1], center=true);
            }
        //if ($preview) translate([60,0,-1]) cube(100);
    }

    for (dx=[-1,1],dy=optimize_fdm?[-6:6]:[-10:10])
        translate([dx*120/2,57.7-bbox.y/2+7.7+12/2+dy*(optimize_fdm?1.2:0.7),(optimize_fdm?0.2:1)+0.4/2]) rotate([0,90,0]) cylinder(d=optimize_fdm?0.8:0.4, h=15,center=true);

    //if ($preview) color("green", 0.2) translate([0,0,bbox.z/2]) cube(bbox, center=true);
}
//translate($preview?[0,0,0]:[0,0,optimize_fdm?0:-0.6])
battery_cover();








