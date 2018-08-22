/*
Title:          chassis.scad for generate STL file
Description:    R2B2 nano Chassis
Authors:        Pau Roura (@proura)
Date:           20180822
Version:        0.2
Notes:

    Default values for chassis_b module

    module chassis_b(
        d_screw_h=3,        //screw hole diameter
        w_walls=2.7,        //wall width
        w_support=8,        //support width
        h_support=8,        //support depth
        w_chassis=70,       //chassis width
        d_chassis=100,      //chassis depth
        h_battery=12,       //chassis power height
        h_control=12        //chassis control height
    )
*/

include<../config.scad>;
use <../chassis.scad>;
$fn = 100;
chassis_b(d_screw_p, w_walls, w_support, h_support, w_chassis, d_chassis, h_battery, h_control);