/*
Title:          base.scad
Description:    charger base
Authors:        Pau Roura (@proura)
Date:           20180801
Version:        0.1
Notes:

Default values for module base and base_b

    module base or base_b(
        d_screw_h=3,            //screw hole diameter
        d_screw_p=d_screw_h+0.4 //screw pass trhougth diameter
        d_screw_head=6.5        //screw head diameter
    )
*/

include <config.scad>;

module base(d_screw_h=3){
    difference(){
        union(){
            translate([30,0,0])cube([41,60,10]);
            translate([30,30,0])cylinder(10,30,30);
            translate([71,30,0])cylinder(10,30,30);
        }
        union(){
            translate([30,2,2])cube([41,56,10]);
            translate([30,30,2])cylinder(10,28,28);
            translate([71,30,2])cylinder(10,28,28);
        }
        translate([26.5,-1,4]) cube([8,6,3.5]);
        translate([66.5,-1,4]) cube([8,6,3.5]);
        translate([85,20,0]) linear_extrude(height = 2, center = true, convexity = 10, twist = 0) rotate([0,180,0]) text("R2B2", size=20);

    }

     difference(){
        union(){
            translate([50.5,10,0] )cylinder(6,d_screw_h/2+2,d_screw_h/2+2);
            translate([50.5,50,0]) cylinder(6,d_screw_h/2+2,d_screw_h/2+2);
        }   

        translate([50.5,10,1]) cylinder(8,d_screw_h/2,d_screw_h/2);
        translate([50.5,50,1]) cylinder(8,d_screw_h/2,d_screw_h/2);
    }
}

module base_b(d_screw_p=d_screw_h+0.4,d_screw_head=6.5){
    difference(){
        union(){
            translate([30,2,2])cube([41,56,2]);
            translate([30,30,2])cylinder(2,28,28);
            translate([71,30,2])cylinder(2,28,28);
            translate([50.5,10,0])cylinder(2,d_screw_head/2+1,d_screw_head/2+1);
            translate([50.5,50,0])cylinder(2,d_screw_head/2+1,d_screw_head/2+1);
        }
        translate([50.5,10,-2])cylinder(20,d_screw_p/2,d_screw_p/2);
        translate([50.5,50,-2])cylinder(20,d_screw_p/2,d_screw_p/2);
        translate([50.5,10,2])cylinder(3,d_screw_head/2,d_screw_head/2);
        translate([50.5,50,2])cylinder(3,d_screw_head/2,d_screw_head/2);
    }
}


color("yellow") translate([0,0,0])  base(d_screw_h);
color("blue")   translate([0,0,16]) base_b(d_screw_p,d_screw_head);