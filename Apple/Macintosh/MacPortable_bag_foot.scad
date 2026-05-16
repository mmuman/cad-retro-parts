// Macintosh Portable Bag foot
// Copyright 2025-2026, François Revol

// Other known models:
// https://www.thingiverse.com/thing:4594159 (not exact, and missing the internal side)

/*[Printing]*/

optimize_fdm = true;

print_bottom = true;

print_top = true;

/*[Preview]*/

preview_distance = 40;

preview_bbox = true;

/*[Model parameters (do not touch)]*/

bottom_bbox = [65.2, 18.1, 13.9];

top_bbox = [64.5, 18, 2.1];

hole_center_distance = 40.6;

hole_diameter = 5.8; // guestimated but feels a bit small

wall_thickness = 2;

top_radius = 2.5;
bottom_radius = 2;
side_radius = 3;

$fn = $preview ? 10 : 30;


module foot_bottom() {
    bbox = bottom_bbox;

    s = [64.2/bbox.x,17.3/bbox.y];
    difference() {
        minkowski() {
            translate([0,0,bottom_radius])
                linear_extrude(bbox.z-bottom_radius-0.5, scale=1/s)
                    offset(r=side_radius-bottom_radius)
                        square([bbox.x*s.x, bbox.y*s.y]-2*side_radius*[1,1], center=true);
            sphere(bottom_radius);
        }
        translate([0,0,bbox.z-0.5]) linear_extrude(5) square([bbox.x,bbox.y], center=true);
        difference() {
            translate([0,0,wall_thickness])
                linear_extrude(bbox.z-bottom_radius, scale=1/s)
                    offset(r=side_radius-wall_thickness)
                        square([bbox.x*s.x, bbox.y*s.y]-2*side_radius*[1,1], center=true);
            for (dx=[-1,1])
                translate([dx*hole_center_distance/2, 0, 0]) scale([1,5.7/5.8]) cylinder(d=hole_diameter+(optimize_fdm?3:2.3), h=20);
            linear_extrude(15) square([bbox.x, optimize_fdm ? 2 : 1.5], center=true);
            for (dx=[-hole_center_distance/2,-8.6,0,8.6,hole_center_distance/2])
                translate([dx,0,0]) linear_extrude(15) square([optimize_fdm ? 2 : 1.7, bbox.y], center=true);
        }
        for (dx=[-1,1])
            translate([dx*hole_center_distance/2, 0, bbox.z-12+0.3]) scale([1,5.7/5.8]) cylinder(d=hole_diameter, h=12);
        //if ($preview) cube(200);
    }
    minkowski() {
        translate([0,0,bbox.z-0.5])
            linear_extrude(0.01, scale=1) difference() {
                offset(r=side_radius-0.6) offset(-side_radius)
                    square([bbox.x, bbox.y], center=true);
                offset(r=side_radius-wall_thickness) offset(-0*wall_thickness-side_radius+0.7)
                    square([bbox.x*s.x, bbox.y*s.y]-0*(wall_thickness)*[1,1], center=true);
            }
        sphere(r=0.5);
    }

    if ($preview && preview_bbox)
        color("green", 0.2) translate([0,0,bbox.z/2])
            cube(bbox, center=true);
}

module foot_top() {
    bbox = top_bbox;

    module post() {
        linear_extrude(0.9) square(5.6*[1,1], center=true);
        intersection() {
            // not a perfect cylinder
            scale([1,5.7/5.8]) cylinder(d=hole_diameter, h=14.2);
            union() {
                linear_extrude(15)
                    offset(optimize_fdm?0.3:0)
                        square([2.7,2.5], center=true);
                translate([0,0,14.2-3.2]) linear_extrude(1.5, scale=[optimize_fdm?1.7:1,1]) square([optimize_fdm?2.7:4.7,2.5], center=true);
                translate([0,0,14.2-1.7]) linear_extrude(1.7, scale=[3/4.7,1]) square([4.7,2.5], center=true);
                for (i=[0:6],a=[0,1]) {
                    translate([0,0,2+(i-a/2)*1.3]) rotate([0,0,a*90]) linear_extrude(0.6, scale=[0.45,1]) square([7,2.5], center=true);
                    if (optimize_fdm)
                        translate([0,0,2+(i-a/2)*1.3-0.6]) rotate([0,0,a*90]) linear_extrude(0.6, scale=[1.6,1]) square([3,2.5], center=true);
                }
            }
        }
    }


    linear_extrude(bbox.z)
        offset(top_radius) offset(-top_radius)
            square([bbox.x,bbox.y], center=true);
    for (dx=[-1,1])
        translate([dx*hole_center_distance/2, 0, bbox.z]) post();
        //translate([dx*hole_center_distance/2, 0, -1]) cylinder(d=hole_diameter+1, h=10);
}

if (print_bottom)
    foot_bottom();

if (print_top)
    translate([0,$preview?0:20,$preview?preview_distance:0]) rotate([$preview?180:0,0,0]) foot_top();
