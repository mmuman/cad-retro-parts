// LED Lighting base for the G4 Cube
// Idea by Xodium
// Copyright François Revol, 2025

include <NopSCADlib/core.scad>
include <NopSCADlib/vitamins/fans.scad>

/*[Variant]*/

// Case model
cube_model = 0; // [0:G4 Cube,1:PowerLogix ClearCube]

enable_LED_base = true;

enable_cable_base = true;

enable_fan_base = true;


/*[Parameters]*/

base_height = 10; // [4:20]

base_thickness = 5; // [4:10]

back_cutout = true;

insertion_margin = 0.2;

cable_base_height = 20; // [40:60]

fan_base_height = 40; // [40:60]

// Put vents on the visible sides too, not just the back
front_vents = true;

/*[Preview]*/

preview_base_color = "CadetBlue"; // ["Silver","CadetBlue"]

preview_cube = true;

preview_inside_cut = false;

preview_distance = 0; // [0:100]

/*[DEBUG]*/

export_svg = false;

fan_size = 140;

// x, y, z, radius, thickness, back cut width, back cut height
G4_cube_models_bbox = [
    [ 196.85, 196.85, 249, 17.5, 4.3, 136, 60 ], // original G4 case
    [ 8.5*2.54*10, 8.5*2.54*10, 249, 17.5, 4.3, 136, 60 ] // aftermarket
];

G4_bbox = G4_cube_models_bbox[cube_model];

$fa = $preview ? $fa : 0.5;


module honeycomb_grill(rect, hpitch, wall=1) {
    r = hpitch/2;
    difference() {
        square(rect);
        for (dx=[0:r*4*cos(30):rect.x+hpitch],dy=[0:2*r:rect.y]) {
            translate([dx,dy]) rotate([0,0,0]) circle(d=hpitch - wall, $fn=6);
            translate([dx,dy]+[2*r*cos(30),2*r*sin(30),]) rotate([0,0,0]) circle(d=hpitch - wall, $fn=6);
        }
    }
}

//honeycomb_grill([100,200],10, 1);


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

module G4_LED_base(h = 10, th = 5) {
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

module G4_cable_base(h = cable_base_height, th = 5) {
    margin = insertion_margin;
    strip_w = 11;
    strip_s = [-0.04, 0.043];

    // nubs to align and hold the LED base
    module nubs(height=3, o = 0) {
        intersection() {
            linear_extrude(height) difference() {
                G4_outline(delta = (strip_w-G4_bbox[4])/2 - o);
                G4_outline(delta = -G4_bbox[4] - (strip_w-G4_bbox[4])/2 + o);
            }
            for(dx=[-1,1], dy=[-1,1])
                translate([dx*(G4_bbox.x-G4_bbox[3])/2,dy*(G4_bbox.y-G4_bbox[3])/2])
                    cylinder(r = G4_bbox[3]*0.9 - o, h*1.5 );
        }
    }

    difference() {
        linear_extrude(h) difference() {
            G4_outline(delta = th);
            G4_outline(delta = -G4_bbox[4] - th);
        }
        translate([0,0,-0.1]) nubs(4);
        // the back cutout for cables
        difference() {
            G4_back_cutout(delta = -5);
            cube([G4_bbox.x*2,G4_bbox.y*2,4], center=true);
        }

        if ($preview) cube(500);
    }
    translate([0,0,h]) {
        nubs(3, 0.2);
    }
}

module G4_fan_base_vents(h = fan_base_height, th = 5) {
    margin = insertion_margin;
    strip_w = 11;
    strip_s = [-0.04, 0.043];
    vents_z_scale = 0.4;
    difference() {
        linear_extrude(h) difference() {
            G4_outline(delta = th);
            G4_outline(delta = -G4_bbox[4] - th);
        }
        // front/side vents
        for (a=(front_vents?[-90:90:90]:[])) {
            for (dx=[-8:8])
                rotate([0,0,a]) translate([G4_bbox.x*dx/20,-G4_bbox.y/2-th-0.5,h*0.1]) 
                    rotate([-90]) linear_extrude(G4_bbox[4]+2*th+1, scale=[4,vents_z_scale])
                        translate([0,-h*0.8/2]) square([2,h*0.8], center=true);
        }
        // back holes
        for (dx=[-3:3])
            rotate([0,0,180]) translate([G4_bbox.x*dx*0.12,-G4_bbox.y/2-th-0.5,h*0.1]) 
                rotate([-90]) linear_extrude(G4_bbox[4]+2*th+1, scale=[1.4,vents_z_scale])
                    translate([0,-h*0.8/2]) square([15,h*0.8], center=true);
        if ($preview) cube(500);
    }
    module pillars(inward=10) {
        for (a=[0:90:3*90]) hull()
            for(d=[0,inward])
                rotate([0,0,a]) translate([G4_bbox.x/2,G4_bbox.y/2]-(G4_bbox[4]+th+d)*[1,1]) circle(r=5);
    }

    // nubs to align and hold the LED base
    translate([0,0,h]) {
        intersection() {
            difference() {
                linear_extrude(3) difference() {
                    G4_outline(delta = (strip_w-G4_bbox[4])/2 - 0.2);
                    G4_outline(delta = -G4_bbox[4] - (strip_w-G4_bbox[4])/2 + 0.2);
                }
                // room for the Cube
                linear_extrude(10, center=true) difference() {
                    G4_outline(delta = margin);
                    G4_outline(delta = -G4_bbox[4] - margin);
                }

            }
            for(dx=[-1,1], dy=[-1,1])
                translate([dx*(G4_bbox.x-G4_bbox[3])/2,dy*(G4_bbox.y-G4_bbox[3])/2])
                    cylinder(r = G4_bbox[3]*0.9 - 0.2, h*1.5 );
        }
    }


    linear_extrude(3) pillars(G4_bbox.x/2);
    linear_extrude(10) pillars(10);
    linear_extrude(10) circle(d=10);
}

module G4_fan_base_filter(h = fan_base_height, th = 5) {
    f_size = fan_size + 2;
    module filter_border(s=f_size) {
        difference() {
            offset(5) square(s*[1,1], center=true);
            square(s*[1,1], center=true);
        }
    }
    module pillars(inward=10) {
        for (a=[0:90:3*90]) hull()
            for(d=[0,inward])
                rotate([0,0,a]) translate([G4_bbox.x/2,G4_bbox.y/2]-(G4_bbox[3]+0*th+d)*[1,1]) circle(r=5);
    }

    linear_extrude(2) {
        filter_border();
        translate([1,1]*-f_size/2) honeycomb_grill(f_size*[1,1], 10, wall=1);
        circle(d=10);
        pillars(inward=5);
    }
    linear_extrude(5) {
        filter_border();
        pillars(inward=5);
    }
    translate([0,0,2]) linear_extrude(10-2) {
        filter_border(fan_size+7);
    }
    intersection() {
        linear_extrude(10, scale=[(G4_bbox.x-2*G4_bbox[4]-2*th)/(f_size+5*2),(G4_bbox.y-2*G4_bbox[4]-2*th)/(f_size+5*2)]) {
            filter_border();
        }
        linear_extrude(30, center=true) G4_outline(delta = -G4_bbox[4] - th - 0.2);
    }
}

module G4_fan_base_grill(h = fan_base_height, th = 5) {
    f_size = fan_size + 2;
    screw_pitch = 62.25; // XXX: depends on 140
    module grill_border(s=f_size) {
        difference() {
            offset(delta=2) square(s*[1,1], center=true);
            square(s*[1,1], center=true);
        }
    }
    difference() {
        linear_extrude(2) {
            difference() {
                union() {
                    difference() {
                        square(f_size*[1,1], center=true);
                        offset(-4) square(f_size*[1,1], center=true);
                        circle(d=fan_size);
                    }
                    translate([1,1]*-f_size/2) honeycomb_grill(f_size*[1,1], 10, wall=1);
                    for (a=[0:90:3*90]) rotate([0,0,a]) translate(screw_pitch*[1,1]) circle(d=15);
                }
                for (a=[0:90:3*90]) rotate([0,0,a]) translate(screw_pitch*[1,1]) circle(d=4.5);
            }
        }
        for (a=[0:90:3*90]) rotate([0,0,a]) translate(screw_pitch*[1,1,0]+[0,0,-0.1]) cylinder(d=7,$fn=6,h=1);
    }
    linear_extrude(6) {
        grill_border();
    }
    
}


module G4_fan_base(h = fan_base_height, th = 5) {

    color(preview_base_color) G4_fan_base_vents();

    color("red"/*preview_base_color*/) translate($preview?[0,0,10+preview_distance*1.5/4]:[220,0,0]) G4_fan_base_filter();

    // the filter
    if ($preview) color("Ivory", 0.5) translate([0,0,10+2+preview_distance*2/4]) linear_extrude(3) square(fan_size*[1,1], center=true);

    color("blue"/*preview_base_color*/) translate($preview?[0,0,10+5+preview_distance*2.5/4]:[400,0,0]) G4_fan_base_grill();
    
    if ($preview) translate([0,0,25/2 + 10 + 5 + 2 + preview_distance*3.3/4]) fan(fan140x25);

    color("darkblue"/*preview_base_color*/) translate($preview?[0,0,10+5+2+25+2+preview_distance*3.8/4]:[600,0,0]) rotate([180,0,0]) G4_fan_base_grill();
}

difference() {
    union() {

        if (export_svg)
            projection() G4_LED_base(h = base_height, th = base_thickness);
        else {

            if (enable_LED_base) color(preview_base_color, 0.2)
                translate($preview?[0,0,(enable_fan_base?fan_base_height:0)+(enable_cable_base?cable_base_height:0)+preview_distance*2]:[0,0,0])
                    G4_LED_base(h = base_height, th = base_thickness);

            if (enable_cable_base) color(preview_base_color, 0.4)
                translate($preview?[0,0,(enable_fan_base?fan_base_height:0)+preview_distance]:[0,250,0])
                    G4_cable_base(h = cable_base_height, th = base_thickness);

            if (enable_fan_base) translate($preview?[0,0,0]:[0,500,0]) G4_fan_base(h = fan_base_height, th = base_thickness);
        }
    }
    if ($preview && preview_inside_cut)
        translate([0,0,-1]) cube([G4_bbox.x,G4_bbox.y,G4_bbox.z]);
}
if ($preview && preview_cube)
    translate([0,0,(enable_fan_base?fan_base_height:0)+(enable_cable_base?cable_base_height:0)+(enable_LED_base?base_height*0.75:0)+preview_distance*3]) G4();


