include <config.scad>;
use <propeller.scad>;
use <thruster.scad>;
use <motor_housing.scad>;
use <chassis.scad>;

//$fn = 100;

module thruster_Complete() {
                         color("blue")    translate([0,0,0])        thruster(w_walls, d_motor_t, h_motor_sup, o_motor, d_thruster,h_thruster, d_screw_p, h_support, w_support);
    rotate([0,180,0])    color("red")     translate([0,0,-14.9])    motor_housing(w_walls_m, d_motor, h_motor_body, d_motor_shaft);
    rotate([0,0,$t*360]) color("orange")  translate([0,0,15])       propeller(w_walls, d_thruster, h_propeller, o_propeller, n_blade, s_blade, w_blade, rounded, d_motor_shaft, d_motor_grub);
}

translate([-w_chassis/2-d_thruster/2,15,0])   rotate([90,0,0])    thruster_Complete();
translate([w_chassis/2+d_thruster/2,15,0])    rotate([-90,0,180]) thruster_Complete();
translate([0,-d_chassis/2-d_thruster/2,-15])  rotate([0,0,90])    thruster_Complete();
translate([0,d_chassis/2+d_thruster/2,-15])   rotate([0,0,-90])   thruster_Complete();

translate([0,0,-15])    chassis(d_screw_h, w_walls, w_support, h_support, w_chassis, d_chassis, h_battery);
color("gray") translate([0,0,-15])    chassis_b(d_screw_p, w_walls, w_support, h_support, w_chassis, d_chassis, h_battery, h_control);
