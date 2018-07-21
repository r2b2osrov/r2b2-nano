/*
Title:          config.scad for R2B2 Nano
Description:    All configuration parameters for R2B2-Nano
Authors:        Pau Roura (@proura)
Date:           20180721
Version:        0.2
Notes:
*/

//General Config
$fn = 100;
w_walls=2.7;                //width of the walls
d_screw_h=3;                //screw thread hole
d_screw_p=d_screw_h+0.4;    //screw pass trhougth
h_support=8;                //screw support height
w_support=8;                //screw support width
w_chassis=60;               //chassis with
d_chassis=80;               //chassis depth
h_battery=9.5;              //hight battery
h_control=10;               //hight electronics

//motor
d_motor=7.6;        //motor diameter
d_motor_shaft=1;    //motor shaft diameter
d_motor_grub=2;     //motor grub screw diameter
h_motor=16.60;      //motor height

//motor_housing
w_walls_m=1;                           //with of the walls
gap_housing=3;                         //extra height of the encapsulation
h_motor_body=h_motor+(gap_housing*2);  //motor housing height

//Thrusters
d_motor_t=d_motor+(w_walls_m*2);    //motor support diameter
h_motor_sup=8;                      //motor support height
o_motor=0;                          //motor support distance from ground
d_thruster=34;                      //thruster diameter
h_thruster=30;                      //thruster height

//module propeller
h_propeller=10;     //propeller height
o_propeller=1;      //offset of the blades to shaft
n_blade=3;          //number of blades
s_blade=20;         //angle separation between blades
w_blade=4;          //with of the blades
rounded="empty";      //shape of the blades [round | trian | empty]
