// IDC port cover


//if (preview_IDC) {
include <NopSCADlib/core.scad>
include <NopSCADlib/vitamins/pin_headers.scad>
//}

//
variant_port =  -1; // [-1:Preview all ports,-2:Preview all cartridges,-3:All ORIC ports, -4:All Commodore C64 ports,0:Custom - see below,1:ORIC Expansion,2:ORIC Printer,3:Raspberry Pi 400 GPIO]

option_print_label = true;

/* [Custom: only for "Custom size" variant] */

// Number of contacts per PCB face
custom_contact_count = 20;

// PCB contact pitch
custom_rows = 2;

// Connector has a polarizing key
custom_key = true;

// Label
custom_label = "???";

// Rotate the label
custom_label_flipped = false;

// Material color (only for preview, X11 color name)
custom_preview_color = "Blue";
// [Black, White]


/* [Printing options] */

print_delta_y = 15;
//$preview ? 20 : 15;

print_count_x = 1;

// Only works for single variant!
print_count_y = 1;

// Print upside-down. The plate texture on top should help with reading the label
print_upsidedown = false;

// UNIMPLEMENTED - Make the roof smaller, should only be required if not printing top-down
optimize_fdm = true;


/* [Preview] */

preview_IDC = true;

/* [Hidden] */


definitions = [
    // [contact_count, rows, key, label, label_flipped, color]
    [custom_contact_count, custom_rows, custom_key, custom_label, custom_label_flipped, custom_preview_color],
    [34, 2, true, "EXPANSION", false, "DimGrey"], // ORIC Expansion
    [20, 2, true, "PRINTER", false, "DimGrey"], // ORIC Expansion
    [40, 2, true, "GPIO", true, "MediumVioletRed"] // Raspberry Pi 400
];

preview_variants = [ // -1 and down:
    [1:3], // All ports
    [], // All cartridges
    [1:2] // ORIC
];


module IDC_port_cover(pins = 20, rows = 2, key=true, label="", label_flipped=false) {
    bbox = [(pins/rows)*2.54+4.7,rows*2.54+0.9,7];

    translate([0,0,(!$preview && print_upsidedown)?(bbox.z+3):0])
    rotate([(!$preview && print_upsidedown)?180:0,0,0])
    difference() {
        union() {
            // main body
            linear_extrude(bbox.z) square([bbox.x,bbox.y], center=true);
            translate([0,0,bbox.z]) linear_extrude(3, scale=[0.9,0.8]) square([bbox.x,bbox.y], center=true);
            // make grip larger
            translate([0,0,bbox.z]) linear_extrude(3) square([6,bbox.y], center=true);
            // some clips to hold inside the IDC
            for(dy=[-1,1], dx=[-1,1])
                translate([dx*bbox.x/3,dy*bbox.y/2,1]) rotate([0,90,0]) cylinder(d=1,h=3.5, center=true);
            // polarizing key
            translate([0,-0.7-rows*2.54/2]) linear_extrude(6) square([3.8,2], center=true);
            // avoid supports when printing upside-down
            translate([0,-0.7-rows*2.54/2,6]) linear_extrude(1,scale=[0.7,0.25]) square([3.8,2], center=true);
        }
        // room for pins
        translate([0,0,-1]) linear_extrude(bbox.z) square([bbox.x-4,bbox.y-2.2], center=true);
        // roof
        translate([0,0,bbox.z-1.01]) linear_extrude(3, scale=[0.9,0.1]) square([bbox.x-4,bbox.y-2.2], center=true);
        // grip
        for(dy=[-1,1])
            translate([0,dy*bbox.y/2,bbox.z+1.5]) rotate([0,90,0]) cylinder(d=1.5,h=10, center=true);
        // ventilation holes
        translate([0,0,bbox.z+1]) rotate([0,90,0]) cylinder(d=1.3,h=bbox.x+8, center=true);
        // label
        if (option_print_label)
            translate([0,0,bbox.z+2.5]) rotate([0,0,label_flipped?180:0]) linear_extrude(1) text(label, size=4*rows/2, halign="center", valign="center", font="Liberation Sans:style=Bold");
        // preview cutout
        //if ($preview) cube(40);
    }
}


variants = variant_port < 0 ? preview_variants[-variant_port-1] : [variant_port:variant_port];

for (v = variants) {
    defs = definitions[v];
    contact_count = defs[0];
    rows = defs[1];
    key = defs[2];
    label = defs[3];
    label_flipped = defs[4];
    preview_color = defs[5];
    pitch = 2.54;

    for (iy = [0:print_count_y-1]) {
        for (ix = [0:print_count_x-1]) {
            translate([-ix * (10 + contact_count * pitch/2), print_delta_y*(iy+v-1), 0]) {
                if ($preview && preview_IDC) difference() {
                    translate([0,0,-2.3]) box_header(2p54header, contact_count/rows, rows);
                    //if ($preview) cube(40);
                }
                color(preview_color, 0.8)
                    IDC_port_cover(contact_count, rows, key, label, label_flipped);
            }
        }
    }
}

// ORIC
//translate([0,20,0])
//IDC_port_cover(20, label="PRINTER");
//IDC_port_cover(34, label="EXPANSION");