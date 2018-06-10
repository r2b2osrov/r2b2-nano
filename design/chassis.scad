/*
Title:          chassis.scad
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

module chassis(d_screw=3){
    difference() {
        union(){
            translate([0,0,-16.5]) cube([56,66,3], center=true);

            difference(){
                union(){
                    translate([24,11,-8.85]) cube([8,8,12.3], center=true);
                    translate([23,11,-6.15]) cube([6,12,17.6], center=true);
                }
                color("green") translate([23,11,3.45]) cube([10,8,12.3], center=true);
            }

            difference(){
                union(){
                    translate([-24,11,-8.85]) cube([8,8,12.3], center=true);
                    translate([-23,11,-6.15]) cube([6,12,17.6], center=true);
                }
                color("green") translate([-23,11,3.45]) cube([10,8,12.3], center=true);
            }

            translate([4.2,29,-11])     cube([3,8,8], center=true);
            translate([-4.2,29,-11])    cube([3,8,8], center=true);
            translate([4.2,-29,-11])    cube([3,8,8], center=true);
            translate([-4.2,-29,-11])   cube([3,8,8], center=true);
        }

        translate([24,11,-23])                       cylinder(h=30,d=d_screw);
        translate([-24,11,-23])                      cylinder(h=30,d=d_screw);
        translate([-14,29,-11])     rotate([0,90,0]) cylinder(h=30,d=d_screw);
        translate([-14,-29,-11])    rotate([0,90,0]) cylinder(h=30,d=d_screw);
    }
}