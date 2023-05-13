// Atari Mega ST backplate remake
// Copyright François Revol, 2023

// Some models have been published but none without holes,
// so let's just remodel the plain one.


/* [Variants] */

variant = 0; // [0:plain - no hole,1:Switches]

/* [Variant:Switches ONLY] */

// " " (space) to enable without label
switch_label_1 = "";
// " " to enable without label
switch_label_2 = "";
// " " to enable without label
switch_label_3 = "";
// " " to enable without label
switch_label_4 = "";

/* [Printing options] */

// Optimize for FDM printing (less supports, thicker planes…). Otherwise you get the exact model of the original part.
optimize_fdm = false;

// (optimize_fdm only) height of the chamfered part of the last layer, to avoid supports for face-down prints, you may need to adjust depending on your slicer parameters
face_down_fdm_chamfer = 0.3; // [0.0:0.05:0.5]

print_orientation = 0; // [0:Face down - may still need supports,1:Vertically]

face_labels_relief = 0; // [0:high-relief,1:bas-relief - suggested for face-down FDM prints]

// Make face 1mm thicker for strength
face_thicker = false;

/* [Hidden] */

// we need more faces on such a small piece
$fa=6;
$fs=0.1;


switch_labels = [
    switch_label_1, switch_label_2,
    switch_label_3, switch_label_4
];

module mega_st_backplate(optimize_fdm=false, print_orientation=0) {

    // sum vector members up to index
    function vadd(v, i = -1, r = 0) = i >= 0 ? vadd(v, i - 1, r + v[i]) : r;

    bounds = [72.8, 21.5];
    h_layers = [
        1.2,
        1.7,
        // extra layer only for face-down FDM
        (optimize_fdm && print_orientation == 0) ? face_down_fdm_chamfer : 0,
        0.6
    ];
    h_total = vadd(h_layers, len(h_layers) - 1);
    echo(h_total);
    inside = [66, 16];
    h_inside = 2.5 - 1.6 + (face_thicker ? 1.1 : 0);


    module border(l=0) {
        inset = 1.6;
        inner = l > 0 && l < 3;
        radius = l == 1 ? 0.5 : 1;
        b = bounds - (inner ? [2*inset,inset+radius] : [0,radius]);
        hull() {
            translate([0,(radius-b.y)/2])
                square(b - [0,radius], center = true);
            for (sx = [-1,1])
                translate([sx*(b.x/2-radius),-b.y]) circle(r = radius);
        }
    }

    module face_label(relief, label) {
        if (relief == face_labels_relief)
            rotate([0,180,0]) linear_extrude(0.6)
                text(label, size=3, valign="center", halign="center");
    }

    function switch_pos(i) = [(i % 2 ? -1 : 1)*15,-23+(i > 1 ? 1 : 2)*9];

    difference() {
        // main volume
        union() {
            for (i = [0:len(h_layers)-1]) {
                h = vadd(h_layers, i - 1);
                echo(i, h, h_layers[i]);
                l_scale = i == 2 ? [1.046, 1.08] : 1;
                translate([0,0,h])
                    linear_extrude(h_layers[i], scale = l_scale)
                        border(i);
            }
        }
        // remove matter for the inside plate
        translate([0, -inside.y/2-1.9 , h_inside])
            difference() {
                base = optimize_fdm ? inside - [2,2] : inside;
                sc = [inside.x/base.x,inside.y/base.y];
                echo(sc);
                linear_extrude(h_total-h_inside+0.1, scale = sc)
                    square(base, center=true);
                if (variant == 0)
                    linear_extrude(0.3)
                        text("C1000 30", valign="center", halign="center", size=5, font="Clear Sans Thin:style=Regular,Arial");
                translate([0, -6])
                    linear_extrude(0.2)
                        text("remake: mmu_man", valign="center", halign="center", size=1);
            }

        //if ($preview) rotate([0,0,-90]) cube(40); // DEBUG

        // A generalized version of this:
        // https://www.thingiverse.com/thing:3104433
        if (variant == 1) {
            for (i = [0:3]) {
                if (switch_labels[i]) {
                    translate(switch_pos(i)) {
                        cube([8.6,4.1,10], center=true);
                        for (sx = [-1,1])
                            translate([sx*9.5,0,0])
                                cylinder(d=2, h=10, center=true);
                        translate([0,-4.5, 0.3])
                            face_label(1, switch_labels[i]);
                    }
                }
            }
        }
        // TODO: 2 USB ports like:
        // https://www.thingiverse.com/thing:3410569
        // https://www.printables.com/fr/model/233717
        if (variant == 2) {
        }
    }

    // added matter
    union() {
        if (variant == 1) {
            for (i = [0:3]) {
                if (switch_labels[i]) {
                    translate(switch_pos(i)) {
                        translate([0,-4.5, 0.3])
                            face_label(0, switch_labels[i]);
                    }
                }
            }
        }
    }

}

// Used to compare the switch backplate from
// https://www.thingiverse.com/thing:3104433
/*
translate([-11,5,3.8]) rotate([-90,0,180])
    import("Mega_ST_back_plate_v6.stl");
#translate([19.7,8.95,-1]) {
    cube([8.6,4.1,10],center=true);
    for (dx=[-1,1]) translate([dx*9.5,0,0]) cylinder(d=2, h=10, center=true);
}
*/

rotate([print_orientation == 1 ? -90 : 0, 0, 0])
    mega_st_backplate(optimize_fdm, print_orientation);

