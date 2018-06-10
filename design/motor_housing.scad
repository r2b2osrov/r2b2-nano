/*
Title:          motor_housing.scad
Description:    encapsulation for the motors
Authors:        Pau Roura (@proura)
Date:           20180610
Version:        0.1
Notes:

    Default values for module motor_housing

    module motor_housing(
        w_walls=1.5,        //with of the walls
        d_motor=7.2,        //motor diameter
        h_motor_body=26,    //motor housing height
        d_motor_shaft=1     //motor shaft diameter
    )
*/

module motor_housing(w_walls=1.5, d_motor=7.2, h_motor_body=26, d_motor_shaft=1){
    difference() {
                            cylinder(d=d_motor+w_walls*2, h=h_motor_body); 
        translate([0,0,-1]) cylinder(d=d_motor, h=h_motor_body-w_walls+1);
        translate([0,0,1])  cylinder(d=d_motor_shaft, h=h_motor_body);
    }     
}

motor_housing();