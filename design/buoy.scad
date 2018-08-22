/*
Title:          buoy.scad
Description:    Communications Buoy
Authors:        Pau Roura (@proura)
Date:           20180817
Version:        0.1
Notes:

Default values for module buoy_base and buoy_top

    module buoy_base or buoy_top(
        d_screw_h=3,            //screw hole diameter
        d_screw_head=6.5        //screw head diameter
    )
*/

include <config.scad>;

module buoy_base(d_screw_h=3, d_screw_head=6.5){
    difference() {
        union(){
            difference() {
                translate([0,0,40])  rotate([0,0,0]) cylinder(10,25,25);
                translate([0,0,41])  rotate([0,0,0]) cylinder(10,23.5,23.5);
            }
            translate([0,0,0])  rotate([0,0,0]) cylinder(40,5,10);
            
            translate([0,15,40])  rotate([0,0,0]) cylinder(10,d_screw_h/2+4,d_screw_h/2+4);
            translate([0,-15,40])  rotate([0,0,0]) cylinder(10,d_screw_h/2+4,d_screw_h/2+4);
        }  
        translate([0,0,1])  rotate([0,0,0]) cylinder(41,4,9);
        translate([0,0,-1])  rotate([0,0,0]) cylinder(5,1,1);
        translate([0,-15,35])  rotate([0,0,0]) cylinder(20,d_screw_h/2+0.3,d_screw_h/2+0.3);
        translate([0,15,35])  rotate([0,0,0]) cylinder(20,d_screw_h/2+0.3,d_screw_h/2+0.3);
        translate([0,15,39])  rotate([0,0,0]) cylinder(4,d_screw_head/2,d_screw_head/2);
        translate([0,-15,39])  rotate([0,0,0]) cylinder(4,d_screw_head/2,d_screw_head/2);
    }
}

module buoy_top(d_screw_h=3){
    difference() {
        union(){
            difference() {
                translate([0,0,40])  rotate([0,0,0]) cylinder(40,25,25);
                translate([0,0,41])  rotate([0,0,0]) cylinder(40,23.5,23.5);
            }
            
            translate([0,15,40])  rotate([0,0,0]) cylinder(5,d_screw_h/2+2,d_screw_h/2+2);
            translate([0,-15,40])  rotate([0,0,0]) cylinder(5,d_screw_h/2+2,d_screw_h/2+2);
        }  
        translate([0,0,1])  rotate([0,0,0]) cylinder(41,4,9);
        translate([0,0,-1])  rotate([0,0,0]) cylinder(5,1,1);
        translate([0,-15,35])  rotate([0,0,0]) cylinder(20,d_screw_h/2,d_screw_h/2);
        translate([0,15,35])  rotate([0,0,0]) cylinder(20,d_screw_h/2,d_screw_h/2);
    }
}

translate([0,0,0])  rotate([0,0,0])     buoy_base(d_screw_h);
translate([0,0,30])  rotate([0,0,0])     buoy_top(d_screw_h,d_screw_head);
