/*
Title:          thruster.scad
Description:    Thruster desing
Authors:        Pau Roura (@proura)
Date:           20180610
Version:        0.1
Notes:

    Default values for module half_thruster_A, half_thruster_B or thruster

    module half_thruster_A | half_thruster_B | thruster(
        w_walls=2.7,    //width of the walls
        d_motor_t=9.6,    //motor diameter
        h_motor_sup=8,      //motor support height
        o_motor=0,      //motor support distance from ground
        d_thruster=34,  //thruster diameter
        h_thruster=30,  //thruster height
        d_screw_p=3.4,    //screw diameter
        h_support=8,    //screw support height
        w_support=8     //screw support width
    )
*/
include <config.scad>;

module half_thruster_A(w_walls=2.7, d_motor_t=9.6, h_motor_sup=8, o_motor=0, d_thruster=34,h_thruster=30, d_screw_p=3.4, h_support=8, w_support=8) { 
    difference() {  
        union() {
            
            //Body of the thruster
            difference() {
                cylinder(d=d_thruster,h=h_thruster-w_walls/2);
                translate ([0,0,-1]) cylinder(d=d_thruster-+w_walls*2,h=h_thruster+2-w_walls/2);
            }
            
            //Rounded top thruster
            translate ([0,0,h_thruster-w_walls/2]) rotate_extrude (convexity=10) translate ([d_thruster/2-w_walls/2,0,0]) circle (r=w_walls/2);

            //Engine support
            translate([0,0,o_motor]){  
                difference() {
                    cylinder (r=d_motor_t/2+w_walls,h=h_motor_sup);
                    translate ([0,0,-1]) cylinder (r=d_motor_t/2,h=h_motor_sup+2);
                }
                translate ([d_motor_t/2+w_walls/2,-w_walls,0]) cube([d_thruster/2-d_motor_t/2-w_walls,w_walls*2,h_motor_sup]);            
            }
            
            //Chassis thruster support
            difference() {
                translate ([d_thruster/2-w_walls/2,-w_walls,0]) cube([w_support+w_walls/2, w_walls*2, h_support]);
                translate ([d_thruster/2+w_support/2,(w_walls*2+2)/2,h_support/2]) rotate([90,0,0]) cylinder (r=d_screw_p/2,h=w_walls*2+2);
            }
        }
        
        //half thruster
        translate ([-d_thruster/2-1,0,-1]) cube ([d_thruster+w_support+2,d_thruster/2+1,h_thruster+2+h_motor_sup]);
    }
}

module half_thruster_B(w_walls=2.7, d_motor_t=9.6, h_motor_sup=8, o_motor=0, d_thruster=34,h_thruster=30, d_screw_p=3.4, h_support=8, w_support=8){
    union() {
        mirror ([0,1,0]) half_thruster_A(w_walls, d_motor_t, h_motor_sup, o_motor, d_thruster, h_thruster, d_screw_p, h_support, w_support);
        difference() {
            union() {
                translate([-d_thruster/2,0,0]) linear_extrude(height=h_thruster-w_walls/2) scale([1.2,2,1]) circle(d_thruster/30);
                translate([ d_thruster/2,0,h_support]) linear_extrude(height=h_thruster-w_walls/2-h_support) scale([1.2,2,1]) circle(d_thruster/30);
            }
            translate([-0,0,-1]) cylinder(d=d_thruster,h=h_thruster-w_walls/2+2);
        }
    }    
}
         
module thruster(w_walls=2.7, d_motor_t=9.6, h_motor_sup=8, o_motor=0, d_thruster=34,h_thruster=30, d_screw_p=3.4, h_support=8, w_support=8){
    half_thruster_A(w_walls, d_motor_t, h_motor_sup, o_motor, d_thruster, h_thruster, d_screw_p, h_support, w_support);
    half_thruster_B(w_walls, d_motor_t, h_motor_sup, o_motor, d_thruster, h_thruster, d_screw_p, h_support, w_support);
}

//$fn = 100;
translate([0,-2.5,0]) half_thruster_A(w_walls, d_motor_t, h_motor_sup, o_motor, d_thruster,h_thruster, d_screw_p, h_support, w_support);
translate([0,2.5,0]) half_thruster_B(w_walls, d_motor_t, h_motor_sup, o_motor, d_thruster,h_thruster, d_screw_p, h_support, w_support);
translate([50,0,0]) thruster(w_walls, d_motor_t, h_motor_sup, o_motor, d_thruster,h_thruster, d_screw_p, h_support, w_support);

