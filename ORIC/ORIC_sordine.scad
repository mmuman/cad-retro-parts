// Sordine for the ORIC
//
// Copyright François Revol, 2025
// Licenced under CC-BY-NC-SA


variant_slim = true;

$fa = 0.5;
//$fs = 10;


ORIC_case_bottom_angle = 10;
b1_bbox = [214, 145.5, 33];


preview_ORIC = true;

module ORIC_logo_O() {
    difference() {
        circle(d=69);
        circle(d=43);
    }
    translate([-7,-7.5]) intersection() {
        rotate([0,0,53]) square([112, 12], center=true);
        square([80, 81], center=true);
    }
    translate([0,-42]) square([68, 12], center=true);
        
}

module ORIC_case_bottom() {
    difference() {
        union() {
            rotate([ORIC_case_bottom_angle,0,0]) difference() {
                cube(b1_bbox);
                translate(2*[1,1,-1]) cube(b1_bbox - 4*[1,1,2]);
            }
            translate([140,90,33+10]) cylinder(d=64.8, h=2);
        }
        translate([140,90,33+10+2]) {
            cylinder(d=64.8, h=11);
            for (dx = [-1, 1], dy = [0:5])
                translate([dx*(3+14.8)/2, (dy-2.5)*(3+2.95), 0]) cube([14.8, 2.8, 10], center=true);
            //#cube([32.8,32.8,10], center=true);
        }
    }
    
}


module ORIC_sordine() {
    od = 64.8-0.2-0.05;
//#cylinder(d=65, h= 10);
    difference() {
        render() intersection() {
            union() {
                cylinder(d=od, h=11);
                for (dx = [-1, 1], dy = [0:5]) {
                    translate([dx*(3+14.8)/2, (dy-2.5)*(3+2.95), 0]) difference() {
                        cube([14.8, 2.8, 4], center=true);
                        cube([14.8-2, 2.8-2, 6], center=true);
                    }
                    hull() for(ddx = [0,0.5])
                        translate([dx*(3/2+14.8-0.1-ddx), (dy-2.5)*(3+2.95), -4*0.52]) rotate([90,0,0]) cylinder(d=0.5, h=2.8, center=true, $fn=16);
                }
            }
            translate([-140,-90,-33-12-.2]) rotate([ORIC_case_bottom_angle,0,0]) cube(b1_bbox);
            //translate([-140,-90,-33-12+6.5]) rotate([ORIC_case_bottom_angle/2,0,0]) cube(b1_bbox);
            if (variant_slim) 
                translate([-140,-90,-33+1.5]) rotate([0,0,0]) cube(b1_bbox);
            if (variant_slim) 
                translate([-140,0,-33-25]) rotate([45,0,0]) cube(b1_bbox+[0,0,20]);
        }
        
        // ease insertion in the middle
        for (dx=[-1,1])
            translate([dx,0,-4.5]) rotate([0,45,0]) cube([5,50,5], center=true);
        /*translate([0,2,.5]) intersection() {
            rotate([ORIC_case_bottom_angle*0.5,0,0]) linear_extrude(10)
                scale([0.5,0.5]) ORIC_logo_O();
            translate([0,0,100/2]) cube(100, center=true);

        }*/
        // handle
        hull() for(dx=[-1,1])
            translate([dx*8,0,0]+(variant_slim?[0,23,0]:[0,20,6])) rotate([-20,0,0]) scale([0.5,1.2,0.8]) sphere(d=10);
        /*
        for (dx = [-1,1]) {
            scale([1.8,1,0.8]) hull() {
                for (dy=[-1,1])
                    translate([dx*7,dy*17+0,7]) sphere(d=10);
            }
        }
        */

        translate([0,0,0.8]) rotate_extrude() {
            //translate([od/2,0,0]) circle(d=1, $fn=16);
            hull() {
                translate([od/2,0,0]) circle(d=1, $fn=16);
                translate([od/2,10,0]) circle(d=0.05);
            }
        }
        translate([0,2,variant_slim?1:3.8]) rotate([variant_slim?0:ORIC_case_bottom_angle,0,0]) linear_extrude(1)
            for (dy=[0,1]){
                texts=["ORIC", "Sordine"];
                translate([0,-10*dy,0]) text(texts[dy], font="Liberation Mono", size=6.5, halign="center", valign="center");
            }
        //#translate([0,0,6]) scale([6,6,1]) sphere(d=10);
        //if ($preview) rotate([0,0,0*-90]) cube(80);
    }

}
rotate($preview ? [0,0,0] : [180-(variant_slim?0:ORIC_case_bottom_angle),0,0]) translate($preview ? [0,0,0.5] : [0,0,variant_slim?-1.5:-4.4]) color("DimGrey", 0.8) ORIC_sordine();

if ($preview && preview_ORIC) color("red", 0.6) {
    translate([-140,-90,-33-12]) ORIC_case_bottom();
}
