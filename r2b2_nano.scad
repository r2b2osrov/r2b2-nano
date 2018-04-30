use <propeller.scad>;
use <thruster.scad>;
use <chassis.scad>;

$fn = 50;

module thruster_Complete() {
                            color("blue")   translate([0,0,0]) thruster();
    rotate([0,0,$t*360])    color("orange") translate([0,0,15]) propeller();
}

translate([-45,15,0])   rotate([90,0,0])    thruster_Complete();
translate([45,15,0])    rotate([-90,0,180]) thruster_Complete();
translate([0,-50,-15])  rotate([0,0,90])    thruster_Complete();
translate([0,50,-15])   rotate([0,0,-90])   thruster_Complete();

chassis();
