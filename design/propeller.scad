/*
Title:          propeller.scad
Description:    encapsulation for the motors
Authors:        Pau Roura (@proura)
Date:           20180610
Version:        0.1
Notes:

    Default values for module propeller

    module propeller(
        w_walls=2.7,        //with of the walls
        d_thruster=34,      //thruster diameter
        h_propeller=10,     //propeller height
        o_propeller=1,      //distance from propeller to walls of thruster
        n_blade=3,          //number of blades
        s_blade=20,         //angle separation between blades
        w_blade=4,          //with of the blades
        rounded=false,      //shape of the blades [round | trian | empty]
        d_motor_shaft=1     //motor shaft diameter
    )
*/
include <config.scad>;

module blades(w_walls=2.7, d_thruster=34, h_propeller=10, o_propeller=1, n_blade=3, s_blade=20, w_blade=4){
    for (i=[0:n_blade]){
        rotate([0,0,i*(360/n_blade)])   
            linear_extrude(height = h_propeller, convexity = 10, twist = (-360/n_blade)+s_blade)
                translate([-o_propeller,-2,0]) polygon(points=[[0,0],[(d_thruster)/2-w_walls,0],[(d_thruster)/2-w_walls,w_blade/2],[0,w_blade]]);
    }
}

module propeller(w_walls=2.7, d_thruster=34, h_propeller=10, o_propeller=1, n_blade=3, s_blade=20, w_blade=4, rounded=false, d_motor_shaft=1, d_motor_grub=2){
    difference(){ 
        union(){        
            if  (rounded=="round") {
                intersection() {
                    translate([0,0,h_propeller/2]) 
                        rotate_extrude() 
                            translate([(d_thruster/2-w_walls-o_propeller)/2,0,0]) 
                                scale([1,h_propeller/((d_thruster/2-w_walls-o_propeller)/2)/2,1]) 
                                    circle((d_thruster/2-w_walls-o_propeller)/2);
                    blades(w_walls, d_thruster, h_propeller, o_propeller, n_blade, s_blade, w_blade); 
                }   
            }
            else if  (rounded=="trian") {
                intersection() {
                    rotate_extrude()
                        polygon(points=[[0,0],[(d_thruster)/2-w_walls,0],[(d_thruster)/2-w_walls,h_propeller*0.8],[0,h_propeller]]);
                    blades(w_walls, d_thruster, h_propeller, o_propeller, n_blade, s_blade, w_blade);
                }
            }
            else {
                blades(w_walls, d_thruster, h_propeller, o_propeller, n_blade, s_blade, w_blade);
            }
            
            //Body of the propeller
            cylinder(h=h_propeller,r1=d_thruster/10, r2=d_thruster/20);
            translate([0,0,h_propeller]) scale([1,1,0.6]) sphere(d_thruster/20);
        }
        
        translate([0,0,-1]) cylinder(h=h_propeller,d=d_motor_shaft);
        translate([0,0,2+d_motor_grub/2]) rotate([360/n_blade*0.6/2,90,0]) cylinder(h=h_propeller,d=d_motor_grub);
    }
}

//$fn=100;
propeller(w_walls, d_thruster, h_propeller, o_propeller, n_blade, s_blade, w_blade, rounded, d_motor_shaft, d_motor_grub);
