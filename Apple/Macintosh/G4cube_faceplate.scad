// Front plate for the G4 Cube
// Copyright François Revol, 2026

// FIXME: take proper measurements!


face_bbox = [180,180,4];

corner_radius = 20;

screw_hole_diam = 5;
screw_hole_center_distance = 150;

center_vent_bbox = [100,50];

slot_bbox = [130,6];

slot_pos = [0,-70];

grill_diameter = 4;
grill_pitch = 4.5;
grill_pos = [0,70];

grill_hull = false;

module G4Cube_faceplate() {
    module grill() {
        // grill: 31+32+31
        for (dy=[-1,0,1])
            for (dx=[0:31-abs(dy)])
                translate(grill_pos+[grill_pitch*(-(32-1)/2+dx+abs(dy)/2),dy*grill_pitch]) circle(d=grill_diameter);
    }

    difference() {
        hull() {
            r = corner_radius;
            for (dx=[-1,1],dy=[-1,1])
                translate([dx*(face_bbox.x/2-r),dy*(face_bbox.y/2-r)]) circle(r=corner_radius);
        }

        for (dx=[-1,1])
            translate([dx*screw_hole_center_distance/2,0])
                circle(d=screw_hole_diam);
        hull() {
            d = center_vent_bbox.y;
            for (dx=[-1,1])
                translate([dx*(center_vent_bbox.x-d)/2,0])
                    circle(d=center_vent_bbox.y);
        }

        // optical disc slot
        hull() {
            d = slot_bbox.y;
            for (dx=[-1,1])
                translate([dx*(slot_bbox.x-d)/2,0]+slot_pos)
                    circle(d=slot_bbox.y);
        }

        if (grill_hull)
            hull() grill();
        else
            grill();
    }
}

G4Cube_faceplate();