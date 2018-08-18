/*
Title:          buoy.scad
Description:    Communications Buoy
Authors:        Pau Roura (@proura)
Date:           20180817
Version:        0.1
Notes:
*/

include <config.scad>;

module buoy_base(d_screw_h=3){
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
        translate([0,15,39])  rotate([0,0,0]) cylinder(4,d_screw_h/2+3,d_screw_h/2+3);
        translate([0,-15,39])  rotate([0,0,0]) cylinder(4,d_screw_h/2+3,d_screw_h/2+3);
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
        translate([0,-15,35])  rotate([0,0,0]) cylinder(20,d_screw_h/2+0.3,d_screw_h/2+0.3);
        translate([0,15,35])  rotate([0,0,0]) cylinder(20,d_screw_h/2+0.3,d_screw_h/2+0.3);
    }
}

translate([0,0,0])  rotate([0,0,0])     buoy_base(d_screw_h);
translate([0,0,30])  rotate([0,0,0])     buoy_top(d_screw_h);
//translate([26,0,6]) rotate([0,180,0])   port_prot(d_screw_h);