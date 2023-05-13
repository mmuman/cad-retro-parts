// Atari Mega ST backplate remake
// Copyright François Revol, 2023

// Some models have been published but none without holes,
// so let's just removel the plain one.


/* [Variants] */

variant = 0; // [0:plain - no hole]

/* [Printing options] */

// Optimize for FDM printing (less supports, thicker planes…)
optimize_fdm = false;

// (optimize_fdm only) height of the chamfered part of the last layer, to avoid supports for face-down prints, you may need to adjust depending on your slicer parameters
face_down_fdm_chamfer = 0.3; // [0.0:0.05:0.5]

print_orientation = 0; // [0:Face down - may still need supports,1:Vertically]

// we need more faces on such a small piece
$fa=6;
$fs=0.1;


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
    h_inside = 2.5 - 1.6 + (optimize_fdm ? 0.1 : 0);


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
                linear_extrude(0.3)
                    text("C1000 30", valign="center", halign="center", size=5, font="Clear Sans Thin:style=Regular,Arial");
                /*translate([0, -6])
                    linear_extrude(0.2)
                        text("remake: mmu_man", valign="center", halign="center", size=1);*/
            }
        //if ($preview) rotate([0,0,-90]) cube(40); // DEBUG
    }
}

rotate([print_orientation == 1 ? -90 : 0, 0, 0])
    mega_st_backplate(optimize_fdm, print_orientation);

