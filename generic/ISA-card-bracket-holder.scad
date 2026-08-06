

//cf.
// https://patentimages.storage.googleapis.com/60/f1/db/b4e09dc452baed/US4745524.pdf

bracket_plate_bbox = [18.3,12.1,1.6];

bracket_plate_offset = [0,0,0];

board_clip_plate_bbox = [7,12,1.6];

board_clip_bbox = [4.5,12,10];

board_clip_offset = [0,0,0];

card_offset = [-.25,-2.5,5.1];

card_thickness = 1.65;

$fn = 60;

module holder() {
    difference() {
        union() {
            linear_extrude(bracket_plate_bbox.z) {
                offset(1) offset(-1-1) offset(1) {
                    translate(bracket_plate_offset) square([bracket_plate_bbox.x,bracket_plate_bbox.y]);
                    translate([0,-board_clip_plate_bbox.y/2-.5]) square([board_clip_plate_bbox.x,board_clip_plate_bbox.y], center=true);
                }
            }
            // reinforcement
            translate([0,-0.5,bracket_plate_bbox.z]) linear_extrude(board_clip_bbox.z-3.1-bracket_plate_bbox.z, scale=[1,0]) square([1,bracket_plate_bbox.y]);
            translate(board_clip_offset-[board_clip_plate_bbox.x/2,board_clip_plate_bbox.y+0.5,3.1]) linear_extrude(board_clip_bbox.z) square([board_clip_bbox.x,board_clip_bbox.y]);
        }
        hull() for(dx=[-1,1])
            translate([bracket_plate_bbox.x+dx*6.6,bracket_plate_bbox.y/2,0])
                cylinder(d=4.5,h=10, center=true);
        // space for the card
        difference() {
            translate(card_offset+[-card_thickness,-20,-20]) cube([card_thickness,20,20]);
            for(dx=[-1,1]) {
                bulge_r = 10;
                translate([-card_thickness/2+dx*(bulge_r+card_thickness/4),1-board_clip_bbox.y/2,-(board_clip_bbox.z-3.1)/2]+card_offset) sphere(r=bulge_r);
            }
        }
        translate(card_offset+[board_clip_bbox.x/2-1.98
       *card_thickness+0.2,-.5-board_clip_bbox.y+2.4,-10+card_offset.z-0.1]) rotate([-90,0,0]) linear_extrude(card_thickness, scale=[1/2,1]) square([card_thickness*2,10], center=true);
        //if ($preview) rotate([180,180,0]) cube(100);
    }
}

module card() {
    translate(card_offset+[-card_thickness,-20,-20]) cube([card_thickness,20,20]);
}

module bracket() {
}



if ($preview) {
    //color("green", 0.2) card();
    color("silver", 0.2) bracket();
}
translate([0,0,3.1]) holder();
