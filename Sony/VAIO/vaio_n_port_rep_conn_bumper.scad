// VAIO N Series port replicator connector bumpers
// Copyright François Revol, 2025

module VAIO_N_port_rep_conn_bumper() {
    h = 8.5;
    points = [
        [0, 0],
        [0, 13.5],
        [0.8, 13.5],
        [0.8, 13.5-7],
        [2, 5.5],
        [2, 2],
        [16, 2],
        [16.5, 2.3],
        [22.5, 1],
        [22.5, 0],
        [22.5-3, 0],
        [22.5-3, -1],
        [22.5-2, -1],
        [22.5-2, -2],
        [22.5-2-4, -2],
        [22.5-2-4, -1],
        [22.5-1-4, -1],
        [22.5-1-4, 0],
        [22.5-1-4, 0],
        [22.5-6.5, 0],
        [22.5-7.5, 1],
        [9, 1],
        [8, 0],
        [5, 0],
        [8-3, -1],
        [8-2, -1],
        [8-2, -2],
        [8-2-4, -2],
        [8-2-4, -1],
        [8-1-4, -1],
        [8-1-4, 0],
        [8-1-4, 0],
        [0, 0],
    
    ];
    difference() {
        linear_extrude(h)
            polygon(points);
        for (dh = [0,1])
            translate([22.5, 0, dh*h])
                rotate([0,-(2*dh-1)*20,0])
                    cube([1,5,10], center=true);
    };
}


VAIO_N_port_rep_conn_bumper();
// the other side
translate([8, -5, 0]) mirror([0,1,0]) VAIO_N_port_rep_conn_bumper();

