// Macintosh Portable Bag foot
// Copyright 2025, François Revol

// UNTESTED


/*[Printing]*/

print_bottom = true;
print_top = true;

// UNIMPLEMENTED
optimize_fdm = true;

/*[Model parameters (do not touch)]*/

bottom_bbox = [65.2, 18.1, 13.7];

top_bbox = [66.3, 18.3, 3];

hole_center_distance = 42; // guestimated from a photo

hole_diameter = 2; // guestimated but feels a bit small

bottom_radius = 2;
side_radius = 3;


$fn = 30;


module foot_bottom() {
    bbox = bottom_bbox;

    s = [64.2/bbox.x,17.3/bbox.y];
    difference() {
        minkowski() {
            translate([0,0,bottom_radius])
                linear_extrude(bbox.z-bottom_radius, scale=1/s)
                    offset(r=side_radius-bottom_radius)
                        square([bbox.x*s.x, bbox.y*s.y]-2*side_radius*[1,1], center=true);
            sphere(bottom_radius);
        }
        translate([0,0,bbox.z]) linear_extrude(5) square([bbox.x,bbox.y], center=true);
        for (dx=[-1,1])
            #translate([dx*hole_center_distance/2, 0, 4]) cylinder(d=hole_diameter, h=10);
    }

    if ($preview)
        color("green", 0.2) translate([0,0,bbox.z/2])
            cube(bbox, center=true);
}

module foot_top() {
    bbox = top_bbox;

    difference() {
        linear_extrude(bbox.z) square([bbox.x,bbox.y], center=true);
        for (dx=[-1,1])
            translate([dx*hole_center_distance/2, 0, -1]) cylinder(d=hole_diameter+1, h=10);
    }
}

if (print_bottom)
    foot_bottom();

if (print_top)
    translate([0,$preview?0:20,$preview?20:0]) foot_top();
