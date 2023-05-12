// Atari Mega ST backplate remake
// Copyright François Revol, 2023

// Some models have been published but none without holes,
// so let's just removel the plain one.


/* [Variants] */

variant = 0; // [0:plain]

/* [Printing options] */

optimize_fdm = false;

// we need more faces on such a small piece
$fa=6;
$fs=0.1;


module mega_st_backplate(optimize_fdm=false) {
    bounds = [72.8, 21.5];
    layers = [1.2, 1.7, optimize_fdm ? 1 : 0.6];
    inside = [66, 16];
    h_inside = 2.5 - 1.6;

    // sum vector members up to index
    function vadd(v, i = -1, r = 0) = i >= 0 ? vadd(v, i - 1, r + v[i]) : r;

    module border(inner=false) {
        inset = 1.6;
        radius = inner ? 0.5 : 1;
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
            for (i = [0:2]) {
                h = vadd(layers, i - 1);
                echo(i, h, layers[i]);
                translate([0,0,h])
                    linear_extrude(layers[i]) border(i == 1);
            }
        }
        // remove matter for the inside plate
        translate([0, -inside.y/2-1.9 , h_inside])
            difference() {
                linear_extrude(4)
                    square(inside, center=true);
                linear_extrude(0.2)
                    text("C1000 30", valign="center", halign="center", size=5, font="Clear Sans Thin:style=Regular,Arial");
                /*translate([0, -6])
                    linear_extrude(0.2)
                        text("remake: mmu_man", valign="center", halign="center", size=1);*/
            }
        //if ($preview) rotate([0,0,-90]) cube(40); // DEBUG
    }
}

mega_st_backplate(optimize_fdm);

