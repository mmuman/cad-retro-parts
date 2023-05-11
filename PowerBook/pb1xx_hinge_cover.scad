
optimize_fdm = false;

/* [Hidden] */

// we need more faces on such a small piece
$fa= $preview ? 6 : 2;
$fs=0.1;

module pb_1xx_hinge_cover() {
    d_out = 17;
    d_middle = 15;
    d_in = 13;
    h_total = 30;

    module base_shape(d) {
        h = h_total - (d_out-d)/2;
        translate([0,d/2]) hull() {
            square([d,d], center=true);
            translate([0,h - d]) circle(d=d);
        }
    }

    // the shell
    rotate_extrude(angle = 180, convexity = 2)
        intersection() {
            difference() {
                base_shape(d_out);
                base_shape(d_in);
            }
            // clip the x>0 part else it won't extrude
            square(30);
        }
    // the bevel
    rotate([90,0,0]) {
        linear_extrude(1)
            difference() {
                base_shape(d_middle);
                base_shape(d_in);
            }

        // clips
        for (i = [0:2]) {
            positions = [[6.2,3],[0,h_total-2.45],[-6.2,3]];
            translate(positions[i]) rotate([0,0,i*90]) {
                h_clip = 8.6;
                base = optimize_fdm ? [2.3,3.5] : [2,3];
                translate([0,0,-4.1])
                    difference() {
                        linear_extrude(h_clip, scale = optimize_fdm ? 0.7 : 0.8)
                            square(base, center=true);
                        if (!optimize_fdm)
                            translate([-0.8,0,0]) cylinder(d = 0.8, h = h_clip+1);
                        translate([0.8,0,h_clip]) rotate([0,60,0])
                            cube([4,4,1], center=true);
                        translate([1.3,0,h_clip-1-1.5])
                            cube([2,4,2], center=true);
                    }
                if (false&&$preview)
                    translate([0,0,3+0.5])
                        color("green", 0.3) cube([1.8,2.5,1],center=true);
            }
        }

    }
    // bbox
    if (false&&$preview) color("white", 0.2)
        translate([0,0,h_total/2])
            cube([d_out,d_out,h_total], center=true);
}

pb_1xx_hinge_cover();