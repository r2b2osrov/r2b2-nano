/*
Title:          propeller.scad for generate STL file
Description:    encapsulation for the motors
Authors:        Pau Roura (@proura)
Date:           20180610
Version:        0.1
Notes:

    Default values for module propeller

    module propeller(
        w_walls=2.7,        //with of the walls
        d_thruster=34,      //thruster diameter
        h_propeller=10,     //propeller height
        o_propeller=1,      //distance from propeller to walls of thruster
        n_blade=3,          //number of blades
        s_blade=20,         //angle separation between blades
        w_blade=4,          //with of the blades
        rounded=false,      //shape of the blades [round | trian | empty]
        d_motor_shaft=1     //motor shaft diameter
    )
*/

include<../config.scad>;
use <../propeller.scad>;
$fn = 100;
propeller(w_walls, d_thruster, h_propeller, o_propeller, n_blade, s_blade, w_blade, rounded, d_motor_shaft);
