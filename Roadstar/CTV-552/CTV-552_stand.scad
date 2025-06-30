// Swivel stand for the Roadstar CTV-552
// Copyright François Revol, 2025



optimize_fdm = false;

ball_radius = 80;

//$fs=0.5;
$fa = $preview ? $fa : $fa/4;
$fs = $preview ? $fs : $fs/4;
echo($fa);
echo($fs);
echo($fn);

module base() {
    thickness = 3;
    feet = [[57.5,76],[65,-66.9]]; // 5.5

    module trapezoid(outer=true) {
        b1 = [75.3-10, -10+93];
        b2 = [168/2-10, -83+10];
        base_layers = [
            // TODO: front and back are large circles, about 1.5m radius
            // max y 178.5
            //y @x=55 =177
            [b1, b2, 10, [0,-0.1]],
            [b1+[-2, -2], b2+[-2,2], 9, [6,3.5]],
            [b1+[-18, -18], b2+[-18,18], 8, [13,9.4]]
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
                if (!optimize_fdm)
                    trapezoid(false);
            }
            for (f = feet) {
                for (dx = [-1,1]) {
                    intersection() {
                        trapezoid();
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
        if ($preview) cube(80);
    }
}


module ball() {
    //120
    //113
    //#cylinder(d=120, h=5);
    difference() {
        union() {
            intersection() {
                cylinder(d=120, h=40, $fs=$fs/10);
                translate([0,0,32.5-ball_radius]) sphere(r=ball_radius, $fs=$fs/10);
            }
            translate([0,-64/2,0]) linear_extrude(3) square([120,64], center=true);
            // positive volumes for the locks
            for (dx=[-1,1]) translate([dx*56,-64,0]) {
                 translate([0,2.4/2,0]) linear_extrude(8) offset(0.2) offset(-0.2) square([8,2.4], center=true);
                 translate([0,0.3,4.5]) linear_extrude(3.5, scale=[1,0.42]) translate([0,5/2,0]) square([8,5], center=true);
                 translate([0,14/2,0]) linear_extrude(4.5) square([8,14], center=true);
                 translate([0,14,3]) linear_extrude(1.5, scale=[1,0]) square([8,12], center=true);
            }
        }
        intersection() {
            intersection() {
                //cylinder(d=113, h=4.5*2, center=true);
                cylinder(d=113, h=80, center=true, $fs=$fs/10);
                translate([0,0,32.5-ball_radius]) sphere(r=ball_radius-3, $fs=$fs/10);
            }
            union() {
                cube([53.5,optimize_fdm?65:120,80], center=true);
                translate([0,120/2-7.7/2-3.0,0]) cube([11.7,6,80], center=true);
                if (!optimize_fdm) for(dx=[-1,1],dy=[-1,1])
                    translate([dx*(53.5+1.2+40)/2,dy*(60+1.1)/2,0]) cube([40,60,80], center=true);
            }
        }
        if (!optimize_fdm) translate([0,120/2-7.7/2-2.8,0]) cube([11.7,6,80], center=true);
        if ($preview) cube(100);
        minkowski() {
            r1 = 3;
            cube([23.5, 57, 80]-2*3*[1,1,0], center=true);
            cylinder(r=r1);
        }
        if (!optimize_fdm) for (dx=[-1,1])
            translate([dx*30,-54.5,0]) cylinder(d = 4.3, h = 20, center=true);
        // separation to the locks
        for (dx=[-1,1])
            hull()
                for (dy=[-1,1])
                    translate([dx*51,dy*10-54,0])
                        cylinder(d = 2.1, h = 20, center=true);
        // negative volumes for the locks
        for (dx=[-1,1]) translate([dx*56,-64,0]) {
             translate([0,0,-0.1]) linear_extrude(5.1, scale=[1,0.35]) square([10,13], center=true);
             translate([0,8+5/2,-0.1]) linear_extrude(1.4) square([10,5], center=true);
             translate([0,8+10/2,-0.1]) linear_extrude(1.4, scale=[1,0]) square([10,10], center=true);
             //#translate([0,0,0]) linear_extrude(1) square([10,13], center=true);
             //#translate([0,2.4/2,0]) linear_extrude(5) square([10,2.2], center=true);
            /*
             translate([0,0.3,4.5]) linear_extrude(3.5, scale=[1,0.42]) translate([0,5/2,0]) square([8,5], center=true);
             translate([0,14/2,0]) linear_extrude(4.5) square([8,14], center=true);
             translate([0,14,3]) linear_extrude(1.5, scale=[1,0]) square([8,12], center=true);
        */}
    }
    // back clip
    translate([0,120/2-7.7/2-0.4,-6.6]) {
        linear_extrude(1.3) square([9.9,7.7], center=true);
        translate([0,0,1.3]) linear_extrude(1.3, scale=[1,0.7]) square([9.9,7.7], center=true);
        translate([0,(7.7-3)/2,0]) linear_extrude(7) square([9.9,3], center=true);
    }
    // front clips
    for (dx=[-1,1]) translate([dx*40,-60.6,-6.3]) {
        linear_extrude(2.0) translate([0,-10/2]) square([10,10], center=true);
        translate([0,0,2]) linear_extrude(0.4, scale=[1,0.95]) translate([0,-10/2,2.4]) square([10,10], center=true);
        translate([0,0,2.4]) linear_extrude(1, scale=[1,0.1]) translate([0,-(10-0.5)/2,2.4]) square([10,10-0.5], center=true);
        linear_extrude(7) translate([0,-3.4/2]) square([10,3.4], center=true);
    }

    // bounding boxes
    //if ($preview) %cylinder(d=100,h=31.1);
    //if ($preview) translate([0,-4.4/2,37.4/2-6.3]) %cube([120,123.6,37.4], center=true);
    //if ($preview) translate([0,-5.5,37.4/2-6.3]) %cube([120,130,37.4], center=true);
}

module bracket() {
    ad1 = 26;
    ad2 = 38.8;
    r1 = 0.2;
    difference() {
        union() {
            // base
            hull() {
                for (dy=[-1,1])
                    translate([0,dy*ad1/2,0]) cylinder(r=4, h=3);
                for (dx=[-1,1])
                    translate([dx*ad2/2,0,0]) cylinder(r=4.4, h=3);
            }
            // main tube
            cylinder(d = 18.5, h = 5);
            translate([0,0,5]) cylinder(d1 = 18.5, d2 = 17, h = 1);
            // two prongs
            for (dx=[-1,1])
                minkowski() {
                    intersection() {
                        hull() {
                            translate([dx*ad2/2,0,r1]) cylinder(r=4.4-r1, h=9);
                            for(dy=[-1,1])
                                translate([dx*(28.8/2+1),dy*(4.4-1),r1]) cylinder(r=1-r1, h=9);
                        }
                        translate([0,0,10.5-ball_radius+3-r1]) sphere(r=ball_radius-3, $fs=$fs/10);
                    }
                    sphere(r=r1);
                }
        }
        for (dy=[-1,1])
            translate([0,dy*ad1/2,-1]) cylinder(d=3.1+0.3, h=20);
        if (!optimize_fdm) for (dx=[-1,1])
            translate([dx*ad2/2,0,-0.1]) cylinder(d=3.8, h=5.7);
        translate([0,0,-1]) cylinder(d=14.6,h=20);
        //if ($preview) cube(100);
    }
    // bbox
    if ($preview) color("yellow", 0.2) translate([0,0,8.8/2]) cube([48,34,8.8], center=true);
}

base();

translate($preview ? [0,0,80] : [-150,0,6.3]) rotate($preview?[0,180,0]:[0,0,0])
    ball();

//translate($preview ? [0,0,80] : [110,0,0]) rotate($preview?[180,0,0]:[0,0,0]) bracket();

/*
translate([0,0,50]) {
    cylinder(d=113,h=4);
    cylinder(d=53.5,h=24);
    %cylinder(d=23.6,h=30);
    r=75;
    translate([0,0,30-r]) %sphere(r=r, $fs=0.05);
}*/
/*
difference() {
    cylinder(d=200,h=50);
    translate([0,0,-1]) cylinder(d=100,h=60);
}*/