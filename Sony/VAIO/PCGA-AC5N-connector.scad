variant = 1; // [0:Official - UNSUPPORTED,1:TO220 leads,2:PCB]

$fn = 60;

module TO220_lead() {
    translate([0,0,-5.2]) linear_extrude(5.2) square([1.42,0.5], center=true);
    translate([0,0,-13]) linear_extrude(13) square([0.8,0.5], center=true);
}

module connector(burried = 3, variant = variant) {
    pcb = (variant == 2);

    //translate([0,0.1,0]) %linear_extrude(4.45) square([6.9,2.55], center=true);
    difference() {
        union() {
            linear_extrude(burried-1) square([8.3,3.7]+[1,1], center=true);
            linear_extrude(burried+1) square([8.3,3.7], center=true);

            translate([0,0,burried+1]) intersection() {
                linear_extrude(4.45) square([6.9,2.7], center=true);
                for (a=[-1,1])
                    translate([0,.6,0]) rotate([0,0,a*45]) cube([6,6,10], center=true);
                translate([0,0.1,0]) union() {
                    cube([10,2.55,10], center=true);
                }
            }
                    translate([0,0.1-2.55/2,burried+1+4.45-0.8]) linear_extrude(0.2, scale=[1,20]) square([3,0.3/10], center=true);
                    translate([0,0.1-2.55/2,burried+1+4.45-0.8+0.2]) linear_extrude(0.6, scale=[1,0.3]) square([3,0.3*2], center=true);
                    //linear_extrude(0.8)
                        // 3,0.3*2,.8
        }
        translate([0,0,burried+1]) {
            linear_extrude(5) square([5.1,1.2], center=true);
            translate([0,0,4.15]) linear_extrude(1, scale=[6/5,2/1]) square([5.1,1.2], center=true);
        }
        if (variant == 2) {
            translate([0,0.95,0]) cube([6,.9,(5+burried)*3], center=true);
            translate([0,0,burried-2]) rotate([90,0,0]) cylinder(d=1.75+0.2, h=30, center=true);
        }
        if (variant == 1) {
            for (dx=[-1,1])
                translate([dx*(1+1.3)/2,1.2/2+.5/2,burried+1+4.45-0.3]) minkowski() {
                    TO220_lead();
                    cube(.1, center=true);
                }
        }
            // contact 1.4 with .8 in between
            // pitch ~= 2.2
        if ($preview) cube(100);
    }
    if ($preview) {
        if (variant == 2)
            color("green", 0.5) translate([0,0.95,(5+burried)/2]) cube([6,.8,(5+1+burried)], center=true);
        if (variant == 1)
            for (dx=[-1,1])
                translate([dx*(1+1.3)/2,1.2/2+.5/2,burried+1+4.45-0.3]) color("gold") TO220_lead();
    }
}

connector();