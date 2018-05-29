/*
Default values for module half_thruster_A

module half_thruster_A(
    w_walls=2.7,    //width of the walls
    d_motor=7.6,    //motor diametre
    h_motor=8,      //motor support height
    o_motor=0,      //motor support distance from ground
    d_thruster=34,  //thruster diameter
    h_thruster=30,  //thruster height
    d_screw=3.4,    //screw diameter
    h_support=8,    //screw support height
    w_support=8)    //screw support width
*/

use <../thruster.scad>;
$fn = 100;
half_thruster_A();