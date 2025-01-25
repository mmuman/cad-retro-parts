// PowerBook 5xx Hard Disk Drive Caddy
// Copyright François Revol, 2025

/* [Printing options] */

// Variant
variant = 0; // [0:Original Metal Bracket,1:HDD 3D-printable, 2:PB BlueSCSI v2 3D-printable]

// Optimize for FDM printers (less supports, larger details)
optimize_fdm = true;

/* [Preview] */

preview_parts = true;

/* [Hidden] */
$fs=0.1;

module pb5xx_hdd_caddy(variant=variant) {
    // metal thickness
    th = 1.0;
    slim = (variant == 2);

    module hdd_screws(c=0) {
        for (dx=[0,1],dy=[0,1]) {
            translate([4+3.5/2+dx*62,33.5+3.5/2+dy*38,-0.1]) {
                cylinder(d=7,h=3.5+0.1);
                cylinder(d=3.5,h=10);
            }
        }
    }

    module caddy_screws(c=0) {
        for (dx=[0,1]) {
            translate([12.6-3.5-3/2+dx*60,1.8+3/2,-0.1]) {
                cylinder(d=7,h=3.5+0.1);
                // one is thicker for some reason
                cylinder(d=3+dx*0.5,h=10);
            }
        }
    }

    module BS_screws(c=0,post=true) {
        for (d=[[35,0],[4.7,14],[48.8,48.6]])
            translate([8.3+d.x,27.5+d.y,4.5]) difference() {
                cylinder(d=4.9, h=4.7);
                cylinder(d=2.85, h=5);
            }
    }

    color(variant?"DodgerBlue":"silver") translate([0,0,(slim && !$preview)?-2:0])
        difference() {
            union() {
                if (variant) {
                    // base
                    translate([0,0,0]) cube([72, 113, 4.5]);
                    // vertical plates
                    if (variant < 2)
                        translate([0,17.6,3.5]) cube([th, 91, 3]);
                    if (variant == 1) {
                        translate([0,17.6,3.5]) cube([th, 7.6, 21.4]);
                    }
                    if (variant == 2) {
                        BS_screws(post=true);
                        for (d=[[3.6,44.2],[43.6,44.2]])
                            translate([8.3+d.x,27.5+d.y,4.5]) cylinder(d = 4, h = 4.7);
                     }
                    // the 3 prongs
                    for (dx=[0:2]) {
                        translate([8+10/2+0.5+dx*14, 112.8, 3.5+0.5]) rotate([-90-20,0,0]) linear_extrude(3.5, scale=[0.6,1]) square([10, th], center=true);
                        if (optimize_fdm && variant)
                            translate([8+10/2+0.5+dx*14, 115.9, 0]) linear_extrude(2.4, scale=[0.6,0.05]) square([10, 5], center=true);
                    }
                } else {
                    // metal frame :

                    // base plate
                    translate([0,0,3.5]) cube([72, 113, th]);
                    // vertical plates
                    translate([71,17.6,0]) cube([th, 88, 3.5]);
                    for (dy=[0,1])
                        translate([18.9,29.5+dy*61,0.3]) cube([36, th, 3.2]);
                    // these serve both for mecanical rigidity and grounding
                    translate([0,17.6,3.5]) cube([th, 91, 9.3]);
                    translate([0,17.6,3.5]) cube([th, 7.6, 21.4]);
                    translate([0,17.6,3.5+20.4]) cube([3.8, 7.6, th]);

                    // the 3 prongs
                    for (dx=[0:2]) {
                        translate([8+10/2+0.5+dx*14, 112.8, 3.5+0.5]) rotate([-90-20,0,0]) linear_extrude(3.5, scale=[0.6,1]) square([10, th], center=true);
                    }
                }
            }
            // room for connector
            for (i=[0,variant ? 1 : 0]) {
                translate([12.6,-1,i*2-0.1]) hull() {
                    cube([48,10+1,20]);
                    for (dx=[0,1])
                        translate([5+dx*38,10+1,0]) cylinder(d=10+i*6, h=20);
                }
            }
            // large hole in the middle
            translate([17,30.6,-0.1]) {
                if (variant < 1)
                    cube([40.3,60.1,20]);
                else {
                    cube([40.3,37,20]);
                    translate([0,48,0]) cube([40.3,20,20]);
                }
                if (!variant) for (dx = [0,1]) hull() {
                    for (dy = [0,1])
                        translate([0.8+dx*38.5,-1.5+dy*63,0]) cylinder(d=2,h=20);
                }
            }
            // minor cutouts
            translate([1.2,-3,-0.1]) rotate([0,0,30]) cube([4,12,20]);
            translate([-0.1,108.5,-0.1]) cube([8.4,10,20]);
            translate([46.5,105.5,-0.1]) cube([30,10,20]);
            for (dx=[0,1])
                hull() for(dy=[0,1]) {
                    translate([20.4+dx*14,110.4+dy*10,-0.1]) cylinder(d=4.0,h=20);
                }
            // 3D printed version removed volumes
            //translate([0,108.5,-0.1]) cube([50,4.6,3.5+0.1]);
            translate([0,112,0]) rotate([0,90,0]) cylinder(d=7,h=50,$fs=0.2);

            if (slim)
                translate([-1, -1, -1]) cube([75, 120, 2+1]);

            // 4 HDD screws
            if (variant < 2)
                hdd_screws();
            // 2 screws for the caddy itself
            caddy_screws();
        }

    if ($preview && preview_parts) {
        if (variant < 2)
            color("black", 0.5) hdd_screws();
        color("black", 0.5) caddy_screws();
        /*
        if (variant == 2)
            translate([4,-2,4.5]) color("White", 0.3) import("PBMountingBracket.stl");
        */
        // bbox
        //color("green", 0.2) cube([72, 115.6, 21.4+3.5]);
    }
}

pb5xx_hdd_caddy();
