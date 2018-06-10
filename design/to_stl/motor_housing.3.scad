/*
Title:          motor_housing.scad for generate STL file
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

use <../motor_housing.scad>;
$fn = 100;
motor_housing(w_walls=1.5, d_motor=7.8, h_motor_body=26, d_motor_shaft=0);