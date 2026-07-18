// FieldWorks 8000 Series rubber foot
// Copyright François Revol, 2026


bbox = [19.5,32.6, 5];
$fn=60;

module FW8000_foot() {
    difference() {
        linear_extrude(bbox.z, scale=[17/bbox.x,30/bbox.y]) {
            square([bbox.x, bbox.y], center=true);
        }
        for (dy=[-5:2:5]) {
            d=2.35;
            translate([0,dy*22.5/5/2,bbox.z+d/2-1])
                rotate([0,90,0])
                cylinder(d=d, h=30, center=true);
        }
    }
}

FW8000_foot();