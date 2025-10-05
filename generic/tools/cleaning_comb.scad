// Cleaning comb template
// Copyright 2025, François Revol
// Idea by Paul Rickards


// Pitch of the comb
pitch = 10.0; // [1:0.1:50]

// count
teeth = 3; // [1:40]

// width of the teeth
width = 1; // [0.1:0.1:10]

// depth of the teeth
depth = 3; // [0.1:0.1:10]

thickness = 1;

handle_height = 20;

label = "Cleaning comb";

$fn = 20;

module comb() {
    difference() {
        linear_extrude(thickness) {
            square([(teeth-1)*pitch+width, handle_height]);
            for(i = [0:teeth-1])
                translate([i*pitch,-depth]) difference() {
                    square([width,depth]);
                    translate([width/2,-0.1]) scale([0.8,0.3]) circle(d=width);
                    for(dx=[0,1])
                        translate([width*dx,depth/2]) scale([0.05,1]) circle(d=depth);
                }
        }

        translate([-1,-depth-1,0.2]) rotate([10,0,0]) cube([teeth*pitch+width,depth+handle_height+10,10]);
        // label
        translate([((teeth-1)*pitch+width)/2,handle_height/2,thickness-0.5]) linear_extrude(1) text(label, valign="center", halign="center", size=handle_height/8);
    }
}

comb();
