
optimize_fdm = false;

/* [Hidden] */

// we need more faces on such a small piece
$fa= $preview ? 6 : 2;
$fs=0.1;

module pb_1xx_hinge_cover() {
    d_out = 17.2;
    d_middle = 15.3;
    d_in = 13.2;
    h_total = 30.3;

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
            positions = [[6.3,3],[0,h_total-2.45],[-6.3,3]];
            translate(positions[i]) rotate([0,0,i*90]) {
                h_clip = 8.4;
                base = optimize_fdm ? [2.3,3.0] : [2.1,2.6];
                translate([0,0,-4.1])
                    difference() {
                        linear_extrude(h_clip, scale = optimize_fdm ? 0.77 : 0.9)
                            square(base, center=true);
                        if (!optimize_fdm)
                            translate([-0.8,0,0]) cylinder(d = 0.9, h = h_clip+1);
                        translate([0.8,0,h_clip]) rotate([0,55,0])
                            cube([4,4,1], center=true);
                        translate([1.3,0,h_clip-1.05-1.2])
                            cube([2,4,2.1], center=true);
                    }
                if (false&&$preview) // DEBUG
                    translate([0,0,3.1+0.5])
                        color("green", 0.3) cube([1.9,2.4,1],center=true);
            }
        }

        // mating for the pins on the other part
        for (sx = [-1,1]) {
            translate([sx*d_in/2,10.6-3.1/2,-0.5])
                cube([0.4,3.1,3], center=true);
        }
    }
    // reference
    translate([0,d_in/2+0.1,h_total/2-5.5]) rotate([0,90,-90])
        linear_extrude(0.4)
            text("815-1231>REV  8", size=1.6, valign="center", halign="center");
    translate([-3.3,d_in/2-0.8,h_total/2-5.0]) rotate([0,90,-60])
        linear_extrude(0.4)
            text("remake: mmu_man", size=1.2, valign="center", halign="center");
    // DEBUG: bbox
    if (false&&$preview) color("white", 0.2)
        translate([0,0,h_total/2])
            cube([d_out,d_out,h_total], center=true);
}

pb_1xx_hinge_cover();