/*
Title:          base.scad for generate STL file
Description:    charger base
Authors:        Pau Roura (@proura)
Date:           20180801
Version:        0.1
Notes:

Default values for module base and base_b

    module base or base_b(
        d_screw_h=3,            //screw hole diameter
        d_screw_p=d_screw_h+0.4 //screw pass trhougth diameter
        d_screw_head=6.5        //screw head diameter
    )
*/

include<../config.scad>;
use <../base.scad>;
$fn = 100;
base_b(d_screw_p,d_screw_head);