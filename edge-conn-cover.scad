// PCB Edge Connector Cover
// Copyright François Revol, 2023

// This model is based on the MO5 Expansion connector cover, generalized to other sizes.

// TODO: split the cartridge stand part out?

/* [Variants] */

// 
variant_port =  -1; // [-1:Preview all ports,-2:Preview all cartridges,-3:All Amstrad CPC ports, -4:All Commodore C64 ports,0:Custom - see below,1:Thomson MO5/… Extension,2:Amstrad CPC Expansion,3:Amstrad CPC Printer,4:Amstrad CPC Drive 2,5:Commodore C64 User,6:Commodore C64 Cassette,7:Matra Alice,8:TRS-80 MC-10,9:Philips VG 5000,10:Generic 2x17 - 5-1/4 Drive,11:Generic 2x20,12:C64 Cartridge]
// Matra Alice & TRS-80 MC-10 should have their own screwed port covers but added just in case
// Others:
// TRAN Jasmin 2 drive for ORIC: 2x20
// TODO: consolidate into a shorter list? Or add text labels


variant_options = 0; // [0:None - just cover the port,1:Add some grip for easy removal,11:Small foot - use as cartridge stand,12:Large foot - use as cartridge stand,13:Huge foot - use as cartridge stand,14:Mega foot - use as cartridge stand,15:Giga foot - use as cartridge stand]

// (Value clipped for small sized foot)
variant_foot_radius = 0; // [0:1:30]

// The $fn value for rounding
variant_foot_radius_faces = 0; // [0:Round,4:Octagon,8,10]

/* [Custom: only for "Custom size" variant] */

// Number of contacts per PCB face
custom_face_contact_count = 19;

// PCB contact pitch
custom_pcb_pitch = 2.54;

// PCB thickness
custom_pcb_thickness = 1.6;

// Total height
custom_total_height = 15.5;

// Material color (only for preview, X11 color name)
custom_preview_color = "Blue";
// [Black, White]


/* [Printing options] */

print_delta_y = 15;
//$preview ? 20 : 15;

print_count_x = 1;

// Only works for single variant!
print_count_y = 1;

// Rotate so the top is on the print-bed
print_top_down = false;

// Make the roof smaller, should only be required if not printing top-down
optimize_fdm = true;

// When printing with TPU, try around -0.5
thickness_adjust = 0.0; // [-1:0.1:1]

/* [Hidden] */

debug = true;

preview_all = true;

// we need more faces on such a small piece
$fa=6;
$fs=0.1;


definitions = [
    // [contact_count, pitch, thickness, height, color]
    [custom_face_contact_count, custom_pcb_pitch, custom_pcb_thickness, custom_total_height, custom_preview_color],
    [19, 2.54, 1.6, 15.5, "DimGrey"], // MO5
    [25, 2.54, 1.6, 15.5, "DarkGrey"], // Amstrad CPC Expansion
    [17, 2.54, 1.6, 15.5, "DarkGrey"], // Amstrad CPC Printer
    [17, 2.54, 1.6, 15.5, "DarkGrey"], // Amstrad CPC Drive 2 - same as printer
    [12, 3.96, 1.6, 15.5, "Wheat"], // C64 User
    [6, 3.96, 1.6, 15.5, "Wheat"], // C64 Cassette
// Matra Alice & TRS-80 MC-10 should have their own screwed port covers but added just in case
    [18, 2.54, 1.6, 15.5, "Red"], // Matra Alice
    [18, 2.54, 1.6, 15.5, "White"], // TRS-80 MC-10 = Matra Alice
    [25, 2.54, 1.6, 15.5, "DarkGrey"], // Philips VG 5000
    [17, 2.54, 1.6, 15.5, "DimGrey"], // Generic 2x17 - 5-1/4" Drive
    [20, 2.54, 1.6, 15.5, "DimGrey"], // Generic 2x20
    [22, 2.54, 1.6, 15.5, "Wheat"], // C64 Cartridge
];

preview_variants = [ // -1 and down:
    [1:11], // All ports
    [12:12], // All cartridges
    [2:4], // Amstrad
    [5:6] // C64
];

module edge_conn_cover(contacts = 19, pitch = 2.54, thickness = 1.6, height = 15.5) {
    extra_x = pitch == 2.54 ? 6.34 : 6.34 + 2;
    base_sz = [extra_x + contacts * pitch, 6.2 + thickness];
    top_sz = base_sz - [0.8, 0.8];
    cavity_sz = base_sz - [2*1, 2*1.9];
    h_scale = [top_sz.x / base_sz.x, top_sz.y / base_sz.y];
    // For small ones, we want more grip to compensate
    grip_dx = (base_sz.x < 40) ? 8 : 14.8;
    grip_diam = 1.8;
    difference() {
        linear_extrude(height, scale = h_scale)
            square(base_sz, center = true);
        difference() {
            union() {
                translate([0,0,-0.1])
                    linear_extrude(height - 1.4 - (optimize_fdm ? 1 : 0))
                        square(cavity_sz, center = true);
                if (optimize_fdm)
                    translate([0,0,height-2.51])
                        linear_extrude(1.2, scale = [0.95, 0.2])
                            square(cavity_sz, center = true);
            }
            grip_c = round(base_sz.x/(2*grip_dx)+.2/*5*/);
            //echo(base_sz.x);
            //echo(grip_c);
            for (dy = [-1,1])
                for (dx = [0:grip_c-1])
                    for (sx = [-1,1])
                        // avoid double volume at 0
                        if (dx > 0 || sx > 0) {
                            translate([sx * dx *
                             grip_dx, dy * (grip_diam + thickness - 0.1)/2, 0])
                                difference() {
                                    cylinder(d = 1.8 - thickness_adjust, h = height-1);
                                    translate([0,0,-1.4])
                                        rotate([-dy * 60, 0, 0])
                                            cube([4,10,2], center = true);
                                }
                        }
        }
        if (variant_options == 1) {
            for (dy = [-1,1])
                for (dz = [0:6])
                    translate([0,dy*(base_sz.y/2-0.1+dz*0.02),height-2.5-dz*1])
                        rotate([-dy * 45, 0, 0])
                            cube([base_sz.x - 10,1,1], center = true);
        }
    }
    // Foot options
    if (variant_options > 9) {
        echo(variant_options % 10);
        foot_sz = top_sz + ((variant_options % 10) + 1) * 10 * [1,1];
        foot_scale = [top_sz.x / foot_sz.x, top_sz.y / foot_sz.y];
        foot_h = 3;
        foot_r = min(variant_foot_radius, 7 * ((variant_options % 10) + 0));
        foot_fn = variant_foot_radius_faces > 0 ? variant_foot_radius_faces : $fn;
        translate([0,0,height+foot_h-2])
            rotate([180,0,0])
                linear_extrude(foot_h-1, scale = foot_scale)
                    offset(r = foot_r, $fn = foot_fn)
                        square(foot_sz - foot_r*[2,2], center = true);
        translate([0,0,height+foot_h-1])
            rotate([180,0,0])
                linear_extrude(1)
                    offset(r = foot_r, $fn = foot_fn)
                        square(foot_sz - foot_r*[2,2], center = true);
    }
}


module preview_pcb_edge_conn(defs) {
    face_contact_count = defs[0];
    pcb_pitch = defs[1];
    pcb_thickness = defs[2];
    total_height = defs[3];
    preview_color = defs[4];
    extra_x = pcb_pitch == 2.54 ? 1.74 : 3 /*max:4.12*/;
    pcb_sz = [pcb_pitch * face_contact_count + extra_x, pcb_thickness];
    //echo("Total Width:", pcb_sz.x);
    pcb_h = custom_total_height - 3;
    color("Green") {
        translate([0,0,-pcb_h])
            linear_extrude(pcb_h)
                square(pcb_sz + [10,0], center = true);
    }
    color("Tan") {
        linear_extrude(pcb_h-1)
            square(pcb_sz, center = true);
        translate([0,0,pcb_h-1])
            linear_extrude(1, scale = [0.99, 0.5])
                square(pcb_sz, center = true);
    }
    color("Gold")
        for (dy = [-1,1])
            for (dx = [0:face_contact_count-1])
                translate([(extra_x + pcb_pitch)/2-pcb_sz.x/2 + pcb_pitch * dx, dy * pcb_thickness/2, pcb_h/3])
                    cube([pcb_pitch/2, 0.1, pcb_h], center = true);
}


variants = variant_port < 0 ? preview_variants[-variant_port-1] : [variant_port:variant_port];

for (v = variants) {
    defs = definitions[v];
    face_contact_count = defs[0];
    pcb_pitch = defs[1];
    pcb_thickness = defs[2];
    total_height = defs[3];
    preview_color = defs[4];
    do_rotate = print_top_down || (variant_options > 9);
    echo(do_rotate);
    
    // Preview with PCB edge connector
    if ($preview) {
        translate([0, print_delta_y*(v-1), do_rotate ? total_height : 0])
            rotate([do_rotate ? 180 : 0,0,0])
                preview_pcb_edge_conn(definitions[v]);
    }

    for (iy = [0:print_count_y-1]) {
        for (ix = [0:print_count_x-1]) {
            translate([-ix * (10 + face_contact_count * pcb_pitch), print_delta_y*(iy+v-1), do_rotate ? total_height : 0])
                rotate([do_rotate ? 180 : 0,0,0])
                    difference() {
                        color(preview_color, 0.8) edge_conn_cover(face_contact_count, pcb_pitch, pcb_thickness, total_height);
                        if (debug && $preview && iy == 0 && ix == 0) translate([10,0,0]) rotate([0,0,-90]) cube([100,100,100]);
                    }
        }
    }
}
