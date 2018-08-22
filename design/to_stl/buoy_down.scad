/*
Title:          buoy_down.scad for generate STL file
Description:    buoy base
Authors:        Pau Roura (@proura)
Date:           20180821
Version:        0.1
Notes:

Default values for module buoy_base

    module buoy_base(
        d_screw_h=3,            //screw hole diameter
        d_screw_head=6.5        //screw head diameter
    )
*/

include<../config.scad>;
use <../buoy.scad>;
$fn = 100;
buoy_base(d_screw_h, d_screw_head);