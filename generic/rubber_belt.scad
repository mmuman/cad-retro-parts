

// values for the Citizen W1D

ID = 65;//69.9-0.9;
thickness = 0.5; // .45 actually
height = 1;

$fn = $preview ? $fn : 360*10;
echo($fn);

difference() {
    cylinder(d=ID+thickness,h=height);
    cylinder(d=ID,h=3*height,center=true);
}