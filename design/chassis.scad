/*
Title:          chassis.scad
Description:    R2B2 nano Chassis
Authors:        Pau Roura (@proura)
Date:           20180621
Version:        0.3
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

module supportR(w_walls=2.7, w_support=8, h_support=8, w_chassis=56, h_battery=9.5){
    union(){
        translate([w_chassis/2-w_support,15-h_support-1,0])        cube([w_support,h_support+2,h_battery+w_walls]);
        translate([w_chassis/2-w_support,15-h_support-w_walls,0])  cube([w_support-2,w_walls,h_battery+w_walls*3]);
        translate([w_chassis/2-w_support,15,0])                    cube([w_support-2,w_walls,h_battery+w_walls*3]);
    }
}

module supportL(w_walls=2.7, w_support=8, h_support=8, w_chassis=56, h_battery=9.5){
    union(){
        translate([-w_chassis/2,15-h_support-1,0])          cube([w_support,h_support+2,h_battery+w_walls]);
        translate([-w_chassis/2+2,15-h_support-w_walls,0])  cube([w_support-2,w_walls,h_battery+w_walls*3]);
        translate([-w_chassis/2+2,15,0])                    cube([w_support-2,w_walls,h_battery+w_walls*3]);
    }
}

module supportB(w_walls=2.7, w_support=8, h_support=8, d_chassis=71){
    translate([w_walls,d_chassis/2-w_support,0])     cube([w_walls,w_support,h_support]);
    translate([-w_walls*2,d_chassis/2-w_support,0])  cube([w_walls,w_support,h_support]);
}

module supportF(w_walls=2.7, w_support=8, h_support=8, d_chassis=71){
    translate([w_walls,-d_chassis/2,0])              cube([w_walls,w_support,h_support]);
    translate([-w_walls*2,-d_chassis/2,0])           cube([w_walls,w_support,h_support]);

}

module chassis(d_screw_h=3, w_walls=2.7, w_support=8, h_support=8, w_chassis=56, d_chassis=71, h_battery=9.5){
    difference() {
        union(){
            translate([0,0,-w_walls/2]) cube([w_chassis,d_chassis,w_walls], center=true);

            //Thrusters supports
            supportR(w_walls, w_support, h_support, w_chassis, h_battery);
            supportL(w_walls, w_support, h_support, w_chassis, h_battery);
            supportB(w_walls, w_support, h_support, d_chassis);
            supportF(w_walls, w_support, h_support, d_chassis);

            //battery and power compartments
            translate([-w_chassis/2,-d_chassis/2+w_support,0])          cube ([w_chassis,w_walls,h_battery]);
            //translate([-w_chassis/2,15-h_support-w_walls*2,0])          cube ([w_chassis,w_walls,h_battery]);
            translate([-w_chassis/2,d_chassis/2-w_support-w_walls,0])   cube ([w_chassis,w_walls,h_battery]);
            translate([-w_chassis/2,-d_chassis/2+w_support,0])          cube ([w_walls,d_chassis/2+7-h_support,h_battery]);
            translate([w_chassis/2-w_walls,-d_chassis/2+w_support,0])   cube ([w_walls,d_chassis/2+7-h_support,h_battery]);
            translate([-w_chassis/2,15,0])                              cube ([w_walls,d_chassis/2-15-w_support-w_walls,h_battery]);
            translate([w_chassis/2-w_walls,15,0])                       cube ([w_walls,d_chassis/2-15-w_support-w_walls,h_battery]);
        }

        //Screw holes
        translate([w_chassis/2-w_support/2,15-h_support/2,-w_walls-1])                      cylinder(h_battery+w_walls*3,d=d_screw_h);
        translate([-w_chassis/2+w_support/2,15-h_support/2,-w_walls-1])                     cylinder(h_battery+w_walls*3,d=d_screw_h);
        translate([-w_walls*3,d_chassis/2-w_support/2,h_support/2])     rotate([0,90,0])    cylinder(w_walls*6,d=d_screw_h);
        translate([-w_walls*3,-d_chassis/2+w_support/2,h_support/2])    rotate([0,90,0])    cylinder(w_walls*6,d=d_screw_h);

        //Cable holes
        //translate([-w_chassis/2+w_support,15-h_support-w_walls*2-1,0])  cube ([w_walls,w_walls+2,h_battery+1]);
        //translate([w_chassis/2-w_support-w_walls*2,13,-w_walls-1])      cube ([w_walls,w_walls+2,w_walls+2]);
    }
}

module chassis_b(d_screw_h=3, w_walls=2.7, w_support=8, h_support=8, w_chassis=56, d_chassis=71, h_battery=9.5, h_control=10){
    difference() {
        union() {
            
            //Electronic Chassis Base
            translate([0,0,h_battery+w_walls/2])
            difference(){
                cube ([w_chassis-w_walls*2,d_chassis-w_support*2,w_walls], center=true);
                translate([0,0,-h_battery]) supportR(w_walls, w_support, h_support, w_chassis, h_battery);
                translate([0,0,-h_battery]) supportL(w_walls, w_support, h_support, w_chassis, h_battery);
                translate([0,-d_chassis/2+w_support+w_walls+2,0]) cube ([8,4,w_walls+2], center=true);
                
            };

            //Electronic compartment
            translate([-w_chassis/2+w_support,-d_chassis/2+w_support+w_walls+6,h_battery+w_walls]) cube ([w_chassis-w_support*2,w_walls,h_control]);
            translate([-w_chassis/2+w_support,d_chassis/2-w_support-w_walls-8,h_battery+w_walls]) cube ([w_chassis-w_support*2,w_walls,h_control]);
            translate([-w_chassis/2+w_support,d_chassis/2-w_support-w_walls,h_battery+w_walls]) cube ([w_chassis-w_support*2,w_walls,h_control]);
            translate([-w_chassis/2+w_support,-d_chassis/2+w_support,h_battery+w_walls])        cube ([w_chassis-w_support*2,w_walls,h_control]);
            translate([-w_chassis/2+w_support,-d_chassis/2+w_support,h_battery+w_walls])        cube ([w_walls,d_chassis-w_support*2,h_control]);
            translate([w_chassis/2-w_support-w_walls,-d_chassis/2+w_support,h_battery+w_walls]) cube ([w_walls,d_chassis-w_support*2,h_control]);

            //Supports
            translate([w_chassis/2-w_support,15-h_support,h_battery+w_walls*3]) cube ([w_support,h_support,w_walls]);
            translate([-w_chassis/2,15-h_support,h_battery+w_walls*3])          cube ([w_support,h_support,w_walls]);
        }
        
        //Screw holes
        translate([w_chassis/2-w_support/2,15-h_support/2,h_battery])   cylinder(h_control+h_battery,d=d_screw_h);
        translate([-w_chassis/2+w_support/2,15-h_support/2,h_battery])  cylinder(h_control+h_battery,d=d_screw_h);
    }
}

//$fn=100;
translate([0,0,-5]) chassis(d_screw_h, w_walls, w_support, h_support, w_chassis, d_chassis, h_battery);
translate([0,0,10]) chassis_b(d_screw_h, w_walls, w_support, h_support, w_chassis, d_chassis, h_battery, h_control);
