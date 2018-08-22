/*
Title:           buoy_top.scad for generate STL file
Description:    Buoy top part
Authors:        Pau Roura (@proura)
Date:           20180821
Version:        0.1
Notes:

Default values for module buoy_top

    module buoy_top(
        d_screw_h=3,            //screw hole diameter
        d_screw_head=6.5        //screw head diameter
    )
*/

include<../config.scad>;
use <../buoy.scad>;
$fn = 100;
buoy_top(d_screw_h);