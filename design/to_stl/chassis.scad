/*
Title:          chassis.scad for generate STL file
Description:    R2B2 nano Chassis
Authors:        Pau Roura (@proura)
Date:           20180822
Version:        0.2
Notes:

    Default values for chassis module 

    module chassis(
        d_screw_h=3,        //screw hole diameter
        w_walls=2.7,        //wall width
        w_support=8,        //support width
        h_support=8,        //support depth
        w_chassis=70,       //chassis width
        d_chassis=100,       //chassis depth
        h_battery=12       //power chassis height
    )
*/

include<../config.scad>;
use <../chassis.scad>;
$fn = 100;
chassis(d_screw_h, w_walls, w_support, h_support, w_chassis, d_chassis, h_battery);