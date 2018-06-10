/*
Title:          chassis.scad for generate STL file
Description:    R2B2 nano Chassis
Authors:        Pau Roura (@proura)
Date:           20180610
Version:        0.1
Notes:

    Default values for module chassis

    module chassis(
        d_screw=3        //screw diameter
    )
*/

use <../chassis.scad>;
$fn = 100;
chassis();