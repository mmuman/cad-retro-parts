// Swivel stand for the Roadstar CTV-552
// Copyright François Revol, 2025



module base() {
    thickness = 3;
    feet = [[57.5,-76],[65,66.9]]; // 5.5

    module trapezoid(outer=true) {
        base_layers = [
            // TODO: front and back are large circles
            // max y 178.5
            //y @x=55 =177
            [[75.3-10, 10-93], , [168/2-10,83-10], 10, [0,-0.1]],
            [[75.3-10-2, 10+2-93], , [168/2-10-2,83-10-2], 9, [6,6]],
            [[75.3-10-18, 10+18-93], , [132/2-10,83-10-18], 8, [13,9.4]]
        ];
        heights = outer ? [0,2,4] : [-0.1,2,3];
        difference() {
            union() {
                hull() {
                    for (l = base_layers) {
                        echo (l);
                        translate([0,0,l[3][outer?0:1]]) linear_extrude(0.01) {
                            for (dx=[-1,1], py=[0,1]) {
                                echo (l[py]);
                                translate([dx*l[py].x,l[py].y]) circle(r = l[2] - (outer?0:3));
                            }
                        }
                    }
                }
            }
        }
    }
    // DEBUG
    translate([0,-5,0]) #cube([1,178.5,40], center=true);
    translate([55,-5,0]) #cube([1,177,40], center=true);

    difference() {
        union() {
            difference() {
                trapezoid();
                trapezoid(false);
            }
            for (f = feet) {
                for (dx = [-1,1]) {
                    intersection() {
                        //trapezoid();
                        translate([f.x*dx,f.y,0]) cylinder(d = 22, h = 20);
                        //8
                    }
                }
            }
        }
        union() {
            for (f = feet) {
                for (dx = [-1,1]) {
                    translate([f.x*dx,f.y,-1]) cylinder(d = 19.8, h = 5.5+1);
                    translate([f.x*dx,f.y,-1]) cylinder(d = 4.8, h = 10);
                }
            }
        }
    }
}

base();