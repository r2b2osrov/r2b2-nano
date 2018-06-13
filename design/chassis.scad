/*
Title:          chassis.scad
Description:    R2B2 nano Chassis
Authors:        Pau Roura (@proura)
Date:           20180611
Version:        0.2
Notes:

    Default values for module chassis

    module chassis(
        d_screw_h=3,        //screw hole diameter
        w_walls=2.7,        //wall with
        w_support=8,        //support with
        h_support=8,        //support depth
        w_chassis=56,       //chassis with
        d_chassis=71,       //chassis depth
        h_battery=9.5
    )
*/
include <config.scad>;

module chassis(d_screw_h=3, w_walls=2.7, w_support=8, h_support=8, w_chassis=56, d_chassis=71, h_battery=9.5){
    difference() {
        union(){
            translate([0,0,-w_walls/2]) cube([w_chassis,d_chassis,w_walls], center=true);

            //Rigth and Left Thrusters supports
            difference(){
                union(){
                    translate([w_chassis/2-w_support,15-h_support,0])          cube([w_support,h_support,12.3]);
                    translate([w_chassis/2-w_support,15-h_support-w_walls,0])  cube([w_support-2,h_support+w_walls*2,12.3+w_walls*2]);
                }
                translate([w_chassis/2-1-w_support,15-h_support,12.3]) cube([w_support+2,h_support,12.3]);
            }

            difference(){
                union(){
                    translate([-w_chassis/2,15-h_support,0])            cube([w_support,h_support,12.3]);
                    translate([-w_chassis/2+2,15-h_support-w_walls,0])  cube([w_support-2,h_support+w_walls*2,12.3+w_walls*2]);
                }
                translate([-w_chassis/2+1,15-h_support,12.3]) cube([w_support+2,h_support,12.3]);
            }

            //Up and Down Thrusters supports
            translate([w_walls,d_chassis/2-w_support,0])     cube([w_walls,w_support,h_support]);
            translate([-w_walls*2,d_chassis/2-w_support,0])  cube([w_walls,w_support,h_support]);
            translate([w_walls,-d_chassis/2,0])              cube([w_walls,w_support,h_support]);
            translate([-w_walls*2,-d_chassis/2,0])           cube([w_walls,w_support,h_support]);

            //battery and power compartments
            translate([-w_chassis/2,-d_chassis/2+w_support,0])          cube ([w_chassis,w_walls,h_battery]);
            translate([-w_chassis/2,15-h_support-w_walls*2,0])          cube ([w_chassis,w_walls,h_battery]);
            translate([-w_chassis/2,d_chassis/2-w_support-w_walls,0])   cube ([w_chassis,w_walls,h_battery]);
            translate([-w_chassis/2,-d_chassis/2+w_support,0])          cube ([w_walls,d_chassis/2+7-h_support,h_battery]);
            translate([w_chassis/2-w_walls,-d_chassis/2+w_support,0])   cube ([w_walls,d_chassis/2+7-h_support,h_battery]);
            translate([-w_chassis/2,15,0])                              cube ([w_walls,d_chassis/2-15-w_support-w_walls,h_battery]);
            translate([w_chassis/2-w_walls,15,0])                       cube ([w_walls,d_chassis/2-15-w_support-w_walls,h_battery]);
        }

        translate([w_chassis/2-w_support/2,15-h_support/2,-w_walls-1])               cylinder(h=30,d=d_screw_h);
        translate([-w_chassis/2+w_support/2,15-h_support/2,-w_walls-1])              cylinder(h=30,d=d_screw_h);
        translate([-14,d_chassis/2-w_support/2,h_support/2])     rotate([0,90,0])    cylinder(h=30,d=d_screw_h);
        translate([-14,-d_chassis/2+w_support/2,h_support/2])    rotate([0,90,0])    cylinder(h=30,d=d_screw_h);

        translate([-w_chassis/2+w_support,15-h_support-w_walls*2-1,0])  cube ([w_walls,w_walls+2,h_battery+1]);
        translate([w_chassis/2-w_support-w_walls*2,13,-w_walls-1])      cube ([w_walls,w_walls+2,w_walls+2]);
    }
}

/*%translate([0,0,h_battery+w_walls/2])
difference(){
    cube ([w_chassis-4,d_chassis-w_support*2,w_walls], center=true);
    difference(){
        union(){
            translate([w_chassis/2-w_support,15-h_support,0])          cube([w_support,h_support,12.3]);
            translate([w_chassis/2-w_support,15-h_support-w_walls,0])  cube([w_support-2,h_support+w_walls*2,12.3+w_walls*2]);
        }
        translate([w_chassis/2-1-w_support,15-h_support,12.3]) cube([w_support+2,h_support,12.3]);
    }
    difference(){
        union(){
            translate([-w_chassis/2,15-h_support,0])            cube([w_support,h_support,12.3]);
            translate([-w_chassis/2+2,15-h_support-w_walls,0])  cube([w_support-2,h_support+w_walls*2,12.3+w_walls*2]);
        }
        translate([-w_chassis/2+1,15-h_support,12.3]) cube([w_support+2,h_support,12.3]);
    }
}*/

//$fn=100;
chassis(d_screw_h, w_walls, w_support, h_support, w_chassis, d_chassis, h_battery);