// Hinge cover for the Macintosh Portable
// Copyright François Revol, 2025

// [Printing]

optimize_fdm = true;

builtin_supports = false;

preview_color = true;

preview_modifier = false;

// [Hidden]
$fn=$preview ? 30 : 50;

RENDER_MODIFIER = false;

support_color = "blue";

module hinge_cover() {
    r = 3;

    difference() {
        translate([0,0,r]) minkowski() {
            cylinder(d = 28-2*r, h = 49.4/*, $fn=2*$fn*/);
            sphere(r=r);
        }
        // crop the top
        translate([0,0,49.4]) cylinder(d=30, h=2*r);

        // outside features

        // little ridge
        translate([0,0,5]) difference() {
            cylinder(d=30, h = 2);
            translate([0,0,-1]) cylinder(d=28-3, h = 4);
            if (builtin_supports) color(support_color) translate([0,0,1]) {
                for (i=[0:3]) difference() {
                    cylinder(d=27+i/5, h=2-i/4, center=true);
                    cylinder(d=26.7-i/5, h=4, center=true);
                    translate([0,-10,0]) cube([1.5,20,5], center=true);
                }
                //translate([-1.0,-13.8,0]) rotate([0,90,-10]) scale([1,0.5]) cylinder(d=1.8,h=2, center=true);
            }
        }
        // retention clips
        translate([0,-14,16.8]) difference() {
            union() {
                linear_extrude(24) square([17.3,15], center=true);
                linear_extrude(35) square([9,10], center=true);
            }
            for(a=[-1,1])
                rotate([0,0,a*4]) linear_extrude(3.1) square([3.1,10], center=true);
            for(dx=[-1,1], a=[0,1])
                translate([dx*5.5,0,2.9]) rotate([0,0,-dx*a*5]) linear_extrude(22) square([2,10], center=true);
            // roundish thing (not just a cylinder though)
            for(dx=[-1,1]) translate([dx*5.5,0,6.3]) rotate([-90,0,0]) {
                intersection() {
                    cylinder(r=2.5,h=10);
                    translate([-dx*3,-1.6,3]) cube(6, center=true);
                }
            }
            if (optimize_fdm) for (dx=[-1,1]) {
                translate([dx*7.7,4.0,21]) rotate([0,0,dx*0]) difference() {
                    cube([7,1.5,7], center=true);
                    translate([0,0,-4]) scale([1,1,6]) rotate([90,0,0]) cylinder(d=1.8,h=10, center=true);
                }
            }
            if (builtin_supports) color(support_color) for (dx=[-1,1])
                translate([dx*5.5,2.4,-0.1]) scale([0.4,1]) cylinder(d=2.3,h=5);
            if (builtin_supports) color(support_color) for (dx=[-1,1], dz=[1/*,2*/])
                translate([dx*9.0,4.5,dz*7-0.1]) rotate([0,-dx*40,dx*35]) scale([0.4,1]) cylinder(d=1.8,h=5.5);
        }

        // inside
        difference() {
            union() {
                translate([0,0,9.1]) cylinder(d=23.7, h=50);
                translate([0,0,3.4]) cylinder(d=21/*?*/, h=50);
                translate([0,0,8.2]) cylinder(d1=21/*?*/,d2=23.7, h=1);
            }
            for(a=[-120:120:120])
                rotate([0,0,a])
                    translate([0,23.7/2,50/2+8]) {
                        cube([0.8,0.2,50], center=true);
                        cube([0.2,0.4,50], center=true);
                    }
            translate([0,0,3.4-0.1]) rotate([0,0,90]) linear_extrude(0.5) text("815-1098", size=1.5, halign="center", valign="center");
        }
    }
    // sturdiness
    if (optimize_fdm) for (a=[-1,1]) {
        rotate([0,0,a*23.5]) difference() {
            hull() {
                for(dz=[0,1])
                    translate([0,-14,22+dz*25]) sphere(d=2);
            }
            translate([0,-14,22]) cylinder(d=1,h=30);
        }
    }
    if (builtin_supports)
        color(support_color) translate([-1.0,-13.4,5+1]) rotate([0,0,-35])
            scale([3,0.8,1.8]) sphere(d=1, $fn=20); 
    // DEBUG: bbox
    //if ($preview) color("green", 0.2) cylinder(d = 28, h = 49.4);
}

module hinge_cover_fuzzy_skin_mod() {
    r = 3;

    difference() {
        translate([0,0,0.2]) cylinder(d = 30.5, h = 50);
        translate([0,0,1]) cylinder(d = 28-1, h = 50);
        translate([0,0,5]) cylinder(d = 31, h = 2);
        translate([0,-14,16.8]) linear_extrude(24) square([17.0,10], center=true);
        
    }
}

if (RENDER_MODIFIER) {
    //TODO: modifier for fuzzy skin
    hinge_cover_fuzzy_skin_mod();
} else {
//intersection() {
    color(preview_color ? "#bfbcb1" : 0) hinge_cover();
    if ($preview && preview_modifier) color("yellow", 0.2) hinge_cover_fuzzy_skin_mod();
//rotate([0,0,190]) cube(30);}
}
