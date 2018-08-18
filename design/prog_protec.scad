/*
Title:          prog_protect.scad
Description:    Protection for Programing Port
Authors:        Pau Roura (@proura)
Date:           20180816
Version:        0.1
Notes:
*/

include <config.scad>;

module port_prot(d_screw_h=3){
    difference() {
        cube([26,10,2]);
        translate([5,2,1.25]) cube([16,6,3]);

        translate([8,5,2])rotate([90,0,0])cylinder(8,0.75,0.75);
        translate([10.5,5,2])rotate([90,0,0])cylinder(8,0.75,0.75);
        translate([13,5,2])rotate([90,0,0])cylinder(8,0.75,0.75);
        translate([15.5,5,2])rotate([90,0,0])cylinder(8,0.75,0.75);
        translate([18,5,2])rotate([90,0,0])cylinder(8,0.75,0.75);

        translate([3,5,-2])cylinder(8,d_screw_h/2,d_screw_h/2);
        translate([23,5,-2])cylinder(8,d_screw_h/2,d_screw_h/2);
    }
}

translate([0,0,0])  rotate([0,0,0])     port_prot(d_screw_h);
translate([26,0,6]) rotate([0,180,0])   port_prot(d_screw_h);