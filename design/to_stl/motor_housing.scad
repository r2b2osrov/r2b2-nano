/*
Title:          motor_housing.scad for generate STL file
Description:    encapsulation for the motors
Authors:        Pau Roura (@proura)
Date:           20180610
Version:        0.1
Notes:

    Default values for module motor_housing

    module motor_housing(
        w_walls=1,        //with of the walls
        d_motor=7.6,        //motor diameter
        h_motor_body=22.6,    //motor housing height
        d_motor_shaft=1     //motor shaft diameter
    )
*/

include<../config.scad>;
use <../motor_housing.scad>;
$fn = 100;
motor_housing(w_walls_m, d_motor, h_motor_body, d_motor_shaft);
