// DIY PowerDoor mod for PowerBook port door
// Copyright François Revol, 2023

powerbutton_hole = true;

modemport_hole = true;

powerdoor_marking = false;

/* [Hidden] */
// we need more faces on such a small piece
$fa=6;
$fs=0.1;

module marking() {
    // text approximation
    if (false)
        translate([85,15,1.1]) rotate([0,180,0])
        color("white") linear_extrude(0.2)
            text("PowerDoor™", font="Go Smallcaps", valign="center", halign="center");

    translate([123,13,1.1]) rotate([0,180,0])
        color("white") linear_extrude(0.2)
            scale(0.085) import("PowerDoor_Logo.svg");

}

rotate([0,0,180]) difference() {

// from https://www.thingiverse.com/thing:5662913
color("grey")
    import("PB180_ioDoor.stl");

    if (powerbutton_hole)
        translate([8.5,14.5,-2]) hull() {
            d = 16;
            cylinder(d = d, h = d);
            translate([-d/2,0,d/2]) cube(d, center = true);
        }

    if (modemport_hole)
        translate([154.5,20.55,-2]) cube([16.1,22,20], center = true);

    if (powerdoor_marking) marking();
}

//if ($preview && !powerdoor_marking) marking();
