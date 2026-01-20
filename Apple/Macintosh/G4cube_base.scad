// LED Lighting base for the G4 Cube
// Idea by Xodium
// Copyright François Revol, 2025

/*[Variant]*/

// Case model
variant = 0; // [0:G4 Cube,1:PowerLogix ClearCube]

/*[Parameters]*/

base_height = 10; // [4:20]

base_thickness = 5; // [4:10]

back_cutout = true;

insertion_margin = 0.2;

/*[Preview]*/

preview_base_color = "CadetBlue"; // ["Silver","CadetBlue"]

preview_cube = true;

preview_inside_cut = false;

/*[DEBUG]*/

export_svg = false;

// x, y, z, radius, thickness, back cut width, back cut height
G4_variants_bbox = [
    [ 196.85, 196.85, 249, 17.5, 4.3, 136, 60 ], // original G4 case
    [ 8.5*2.54*10, 8.5*2.54*10, 249, 17.5, 4.3, 136, 60 ] // aftermarket
];

G4_bbox = G4_variants_bbox[variant];

$fa = $preview ? $fa : 0.5;

module G4_outline(delta = 0) {
    hull() {
        for(dx=[-1,1], dy=[-1,1])
            translate([dx*(G4_bbox.x/2-G4_bbox[3]),dy*(G4_bbox.y/2-G4_bbox[3])])
                circle(r = G4_bbox[3] + delta);
    }
}

module G4_xy() {
    difference() {
        G4_outline();
        G4_outline(delta = -G4_bbox[4]);
    }
}

module G4_back_cutout(delta = 0) {
    rotate([-90,0,0]) linear_extrude(200) hull() {
        for(dx=[-1,1], dy=[-1,1])
            translate([dx*(G4_bbox[5]/2-G4_bbox[3]+delta),dy*(G4_bbox[6]-G4_bbox[3])])
                circle(r = G4_bbox[3]);
    }
}

module G4() {
    color(preview_base_color, 0.4) translate([0,-G4_bbox.y/2,G4_bbox.z*0.65])
        rotate([90,0,0]) linear_extrude(height=0.1)
            text("\U01F34E", font="ChicagoFLF,Symbola,Unifont Upper", valign="center", halign="center", size=50);

    color("white", 0.4) render() difference() {
        linear_extrude(G4_bbox.z)
            G4_xy();
        G4_back_cutout();
    }

}

module G4_base(h = 10, th = 5) {
    margin = insertion_margin;
    strip_w = 11;
    strip_s = [-0.04, 0.043];
    difference() {
        linear_extrude(h) difference() {
            G4_outline(delta = th);
            G4_outline(delta = -G4_bbox[4] - th);
        }
        // room for the Cube
        translate([0,0,h*0.75]) linear_extrude(h) difference() {
            G4_outline(delta = margin);
            G4_outline(delta = -G4_bbox[4] - margin);
        }
        // room for the LED strips
        translate([0,0,h/4]) {
            linear_extrude(h) difference() {
                G4_outline(delta = -0.5);
                G4_outline(delta = -G4_bbox[4] + 0.5);
            }
            intersection_for(ds=strip_s) {
                {
                    linear_extrude(h*0.45, scale=1.0+ds) difference() {
                        G4_outline(delta = (strip_w-G4_bbox[4])/2);
                        G4_outline(delta = -G4_bbox[4] - (strip_w-G4_bbox[4])/2);
                    }
                }
            }
        }
        // room to insert the LED strips from the bottom
        translate([0,0,-1]) {
            intersection() {
                union() {
                    linear_extrude(h*0.351) difference() {
                        G4_outline(delta = (strip_w-G4_bbox[4])/2);
                        G4_outline(delta = -G4_bbox[4] - (strip_w-G4_bbox[4])/2);
                    }
                    linear_extrude(h*1.2) difference() {
                        G4_outline(delta = margin);
                        G4_outline(delta = -G4_bbox[4] - margin);
                    }
                }
                for(dx=[-1,1], dy=[-1,1])
                    translate([dx*(G4_bbox.x-G4_bbox[3])/2,dy*(G4_bbox.y-G4_bbox[3])/2])
                        cylinder(r = G4_bbox[3]*0.9, h*1.5 );
            }
        }
        // the back cutout for cables
        if (back_cutout)
            G4_back_cutout(delta = -5);
    }
}

difference() {
    union() {

        if (export_svg)
            projection() G4_base(h = base_height, th = base_thickness);
        else
            color(preview_base_color) G4_base(h = base_height, th = base_thickness);
    }
    if ($preview && preview_inside_cut)
        translate([0,0,-1]) cube([G4_bbox.x,G4_bbox.y,G4_bbox.z]);
}
if ($preview && preview_cube)
    translate([0,0,base_height*0.75]) G4();
