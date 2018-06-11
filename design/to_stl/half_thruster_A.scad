/*
Title:          halt_thruster_A.scad for generate STL file
Description:    Thruster desing
Authors:        Pau Roura (@proura)
Date:           20180610
Version:        0.1
Notes:

    Default values for module half_thruster_A

    module half_thruster_A(
        w_walls=2.7,    //width of the walls
        d_motor=7.6,    //motor diameter
        h_motor_sup=8,      //motor support height
        o_motor=0,      //motor support distance from ground
        d_thruster=34,  //thruster diameter
        h_thruster=30,  //thruster height
        d_screw_p=3.4,    //screw diameter
        h_support=8,    //screw support height
        w_support=8     //screw support width
    )
*/

include<../config.scad>;
use <../thruster.scad>;
$fn = 100;
half_thruster_A(w_walls, d_motor_t, h_motor_sup, o_motor, d_thruster,h_thruster, d_screw_p, h_support, w_support);