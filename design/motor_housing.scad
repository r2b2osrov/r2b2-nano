/*
Title:          motor_housing.scad
Description:    encapsulation for the motors
Authors:        Pau Roura (@proura)
Date:           20180610
Version:        0.1
Notes:

    Default values for module motor_housing

    module motor_housing(
        w_walls_m=1,          //width of the walls
        d_motor=7.6,          //motor diameter
        h_motor_body=22.6,    //motor housing height
        d_motor_shaft=1.5     //motor shaft diameter
    )
*/

include <config.scad>;

module motor_housing(w_walls_m=1, d_motor=7.6, h_motor_body=22.6, d_motor_shaft=1.5){
    difference() {
                                    cylinder(d=d_motor+w_walls_m*2, h=h_motor_body); 
        translate([0,0,w_walls_m])  cylinder(d=d_motor, h=h_motor_body);
        translate([0,0,-2])         cylinder(d=d_motor_shaft, h=h_motor_body);
    }     
}

//$fn = 100;
motor_housing(w_walls_m, d_motor, h_motor_body, d_motor_shaft);