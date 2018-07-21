/*
Title:          chassis.scad for generate STL file
Description:    R2B2 nano Chassis
Authors:        Pau Roura (@proura)
Date:           20180621
Version:        0.1
Notes:

    Default values for module chassis

    module chassis(
        d_screw_h=3,        //screw hole diameter
        w_walls=2.7,        //wall with
        w_support=8,        //support with
        h_support=8,        //support depth
        w_chassis=56,       //chassis with
        d_chassis=71,       //chassis depth
        h_battery=9.5,
        h_control=10
    )
*/

include<../config.scad>;
use <../chassis.scad>;
$fn = 100;
chassis_b(d_screw_p, w_walls, w_support, h_support, w_chassis, d_chassis, h_battery, h_control);