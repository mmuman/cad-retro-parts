// PowerBook 5xx Rear feet
// Copyright François Revol, 2025

/* [Printing options] */

print_single_body = false;

print_plastic_parts = true;
print_rubber_parts = true;

print_washers = true;
print_stands = true;

// Leave holes in the washers to insert 6.8mm long wires cut from 0.9mm thick paperclips, which should be sturdier.
option_washer_paperclip_pin = false;

// Optimize for FDM printers (less supports, larger details) - UNIMPLEMENTED
optimize_fdm = true;

/* [Hidden] */
$fs = $preview ? 0.5 : 0.1;
$fa = $preview ? 12 : 6;


module rear_foot_washer_right(right=true) {
    bbox = [9.4,11.0,6.9];
    d1 = 5.9;
    axis = [bbox.x-2.5-d1/2,bbox.y-2.5-d1/2];
    a=95;
    paperclip_angles = [-1,13];

    module base_shape() {
        intersection() {
            union() {
                translate(axis) circle(r=5.5);
                square([bbox.x,axis.y]);
            }
            square([15,15]);
            rotate([0,0,5]) translate([0.82,-2,0]) square([15,15]);
        }
    }
    mirror([right?0:1,0,0]) difference() {
        union() {
            hull() {
                linear_extrude(0.1) offset(r=-0.1) base_shape();
                translate([0,0,4.3-.1]) linear_extrude(0.1) base_shape();
            }
            // some ridges
            for (d=[[0,0],[-105,0],[-90-55,4.5]]) {
                intersection() {
                    translate([axis.x,axis.y,4.8-1]) difference() {
                        cylinder(r=5.5-0.6+d[1], h=2);
                        cylinder(d=6,h=10, center=true);
                    }
                    translate([axis.x,axis.y,4.8-1.7/2]) rotate([-90,0,d[0]]) translate([0,0,d[1]]) cylinder(d=1.7, 5);
                    cube(12);
                }
            }
            // little nub
            if (!option_washer_paperclip_pin) translate([axis.x,axis.y,0]) intersection() {
                rotate([0,0,180+40]) translate([-0.2,-5,4.3+2.5/2]) cube([2.4,5,2.5], center=true);
                difference() {
                    cylinder(r=4.9, h=10);
                    cylinder(r=4.9-0.9, h=20, center=true);
                }
            }
        }
        // little nub
        if (option_washer_paperclip_pin) translate([axis.x,axis.y,0]) for(a=paperclip_angles) {
            rotate([0,0,40-a]) translate([0,4.4,0]) cylinder(d=0.9+0.2, h=20, center=true);
        }
        translate(axis+[0,0,-0.1]) cylinder(d=5.9, h=5);
        // 2 indents inside
        for (d=[[0,5.5-0.6],[90+45,5.5-1.1]]) {
            translate([axis.x,axis.y,0]) intersection() {
                rotate([0,0,d[0]]) translate([0,-5,4-0.1]) cube([1.8,5,8], center=true);
                cylinder(r=d[1], h=10, center=true);
            }
        }
        translate([7.5,1.5,-0.1]) linear_extrude(0.5) rotate([right?180:0,0,90]) text(right?"R":"L", size=1.8, halign="center", valign="center");
    }
    // DEBUG: bbox
    //if ($preview) color("green", 0.2) cube(bbox);
    // preview paperclip pins
    if ($preview && option_washer_paperclip_pin) color("silver", 0.6) mirror([right?0:1,0,0]) translate([axis.x,axis.y,0]) for(a=paperclip_angles) {
        rotate([0,0,40-a]) translate([0,4.4,0]) cylinder(d=0.9, h=6.8);
    }
}

module rear_foot_stand(right=true,plastic=true, rubber=true) {
    bbox=[15.2,35.6,10.4];

    module foot_shell(inside = true) {
        h = inside ? 7.5 : 10.3;
        difference() {
            union() {
                // a little extra thing to keep the TPU shell on
                if (inside)
                    translate([-2.5,7.9,0]) rotate([0,0,15])
                        cube([1.5,0.8,h], center=true);
                // the two main round parts
                translate([-0.965,2,0]) difference() {
                    intersection() {
                        cylinder(r=inside?6.5:8,h=h, center=true,$fa=1);
                        translate([-12/2-(inside?2:0),12/2,0]) cube(12, center=true);
                    }
                    translate([0,0,0]) cylinder(r=5,h=12, center=true);
                    //#translate([-(inside?2:0),6.5,5]) cube(3, center=true);
                    //#translate([-6.5,.5,5]) cube(3, center=true);
                }
                translate([-1,2,0]) difference() {
                    intersection() {
                        hull() {
                            translate([100-8.1,-5,0]) cylinder(r=inside?98.5:100,h=h, center=true,$fa=1);
                            if (!inside) translate([-5.35,-23,0]-[-1,2,0]) intersection() {
                                scale([1,1,2.4]) sphere(d=5.5);
                                cube(10.3, center=true);
                            }
                        }
                        translate([-25/2,-25/2+0.1,0]) cube(25.2, center=true);
                    }
                    //translate([100-7.65,-7,0]) cylinder(r=97,h=12, center=true,$fa=1);
                    translate([100-8.1,-5,0]) cylinder(r=97,h=12, center=true,$fa=1);
                }
            }
        }
    }

    if (plastic) {
        difference() {
            union() {
                intersection() {
                    translate([-1,2,0]) cylinder(r=5.5,h=3, center=true);
                    translate([-12/2-3,12/2,0]) cube(12, center=true);
                }
                translate([-1,2,0]) cylinder(r=5.0,h=3, center=true);
                cylinder(d=13.8, h=3, center=true);
                difference() {
                    translate([-6.2/2,-7,0]) cube([6.2,18,3], center=true);
                    translate([10/2,-16,0]) cylinder(d=21,h=10,center=true);
                    // Identify which side this goes on.
                    // The part is symmetrical but since we have supports on one side,
                    // we want to use the other side in contact with the washer.
                    translate([-4.5,-7.5,(right?-1:1)*(3/2-0.3)]) rotate([0,right?180:0,0]) linear_extrude(0.6) text(right?"R":"L", size=2.8, halign="center", valign="center");
                }
                // not exact but well…
                translate([10/2,-16,0]) rotate([0,0,110]) rotate_extrude(angle=70/*,scale=[10,1]*/) translate([10.5,0,0]) scale([0.2,1])circle(d=3);
                foot_shell(true);
            }

            // central hole
            cylinder(d=4.3, h=8, center=true);
            // slant
            rotate([0,0,90+12]) translate([0,-10/2-5,0]) cube([20,10,10], center=true);

            // positionning features
            difference() {
                cylinder(r=5.15, h=10, center=true);
                cylinder(r=3.9, h=12, center=true);
                for (a=[40,-40])
                    rotate([0,0,90+a]) translate([0,-10/2-1.5,0]) cube([20,10,10], center=true);
            }
            // force render here, for some reason it makes preview slow
            render() for (d=[[0,0],[100,0],[-105,0],[-145,1],[-45,1]],side=[0,1]) {
                intersection() {
                    rotate([side*180,0,90+d[0]]) translate([5,0,1.5-0.6]) linear_extrude(0.7, scale=[1,1.8/0.8]) square([10,0.8], center=true);
                    difference() {
                        cylinder(r=d[1]?10:5, h=10, center=true);
                        if (d[1])
                            cylinder(r=4.4, h=12, center=true);
                    }
                }
            }
        }
    }
    if (rubber) difference() {
        union() {
            translate([-5.35,-23,0]) intersection() {
                scale([1,1,2.4]) sphere(d=5.5);
                cube(10.3, center=true);
            }
            foot_shell(false);
        }
        if (!plastic) minkowski() {
            //rear_foot_stand(plastic=true, rubber=false);
            foot_shell(true);
            // some margin for assembly
            cube(0.1,center=true);
            //sphere(0.1);
        }
        //if ($preview) rotate([0,0,90]) cube(30);
    }
    // DEBUG: bbox
    //if ($preview) color("green", 0.2) translate([-9.4+bbox.x/2,-bbox.y/2+7.9+4.1/2,0]) cube(bbox, center=true);
}

//#for(d=[0,1])
  //  translate([0,10*d,20]) mirror([d,0,0]) rear_foot_washer_right();



//translate([-10,30,0]) mirror([1,0,0]) rear_foot_washer_right(false);
//rear_foot_stand(plastic=true, rubber=true);
for (r = [0,1]) {
    if ((print_plastic_parts || print_single_body) && print_washers)
        translate([12+r*2,-23,0])
            rear_foot_washer_right(right=r!=0);
    if ((print_plastic_parts || print_single_body) && print_stands)
        translate([r?26:0,0,print_single_body?10.3/2:7.5/2]) rotate([0,r*180,0])
            rear_foot_stand(right=r!=0, plastic=true, rubber=print_single_body);
    if ((print_rubber_parts && !print_single_body) && print_stands)
        translate([r?-15:-30,0,10.3/2+0*9.1]) rotate([0,0*-90,0])
            rear_foot_stand(right=r!=0, plastic=false, rubber=true);
}
