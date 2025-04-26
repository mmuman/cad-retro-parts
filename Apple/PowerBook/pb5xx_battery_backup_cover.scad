// PowerBook 5xx Battery backup cover
// Copyright François Revol, 2025

/* [Printing options] */

// Optimize for FDM printers (less supports, larger details) - UNIMPLEMENTED
optimize_fdm = true;

/* [Preview] */

/* [Hidden] */
$fs=0.1;


module pb5xx_battery_backup_cover(optimize_fdm=false) {
    r=7.5;
    bbox = [50.3,23.4,1.9] - (optimize_fdm?[0.4,0.4,0]:[0.45,0.3,0.6]);
    difference() {
        translate([0,0,optimize_fdm?0:0.6])
            linear_extrude(optimize_fdm?1.9:1.3, scale=[1.01,1.01]) hull()
                for(dx=[-1,1],dy=[-1,1]) {
                    translate([dx*(bbox.x/2-r),dy*(bbox.y/2-r)]) circle(r);
                }
        // text
        if (!optimize_fdm) translate([0,7.5,1.9]) difference() {
            cube([25.5,3.2,0.4], center=true);
            translate([0,0,-0.3]) linear_extrude(0.2) text("815-1537    REV.", size=2.2, halign="center", valign="center");
        }
        if (!optimize_fdm) translate([6.4,1,1.9]) difference() {
            cube([12.8,1.8,0.4], center=true);
            translate([0,0,-0.3]) linear_extrude(0.2) text("              CAV.1", size=1.2, halign="center", valign="center");
        }
    }
    /*if ($preview) color("green", 0.2) translate([0,0,0]) linear_extrude(1.9) hull() for(dx=[-1,1],dy=[-1,1]) {
        translate([dx*(50.3/2-r),dy*(23.4/2-r)]) circle(r);
    }*/
    for(dy=[-1,1])
        translate([0,dy*3.5,0]) linear_extrude(0.31, scale=[1.02,1.05]) square([48,0.6], center=true);

    // clips
    for(dx=[-1,1])
        translate([dx*25.4,0,1.9]) difference() {
            linear_extrude(4.5, scale=[0.5,1.05]) square([2.8,5.9], center=true);
            translate([dx*0.97,0,-0.1]) linear_extrude(2.7, scale=[0.7,1]) square([2.4,8], center=true);
        }
}

pb5xx_battery_backup_cover(optimize_fdm=optimize_fdm);
