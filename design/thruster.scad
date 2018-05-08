/*
w_walls = 2.7
d_motor = 7.6
h_motor = 5
o_motor = 5
d_thruster = 34
h_thruster = 30
d_screw = 3.4
h_support=8
w_support=8
*/

module half_thruster_A(w_walls=2.7, d_motor=7.6, h_motor=8, o_motor=0, d_thruster=34,h_thruster=30, d_screw=3.4, h_support=8, w_support=8) { 
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
                    cylinder (r=d_motor/2+w_walls,h=h_motor);
                    translate ([0,0,-1]) cylinder (r=d_motor/2,h=h_motor+2);
                }
                translate ([d_motor/2+w_walls/2,-w_walls,0]) cube([d_thruster/2-d_motor/2-w_walls,w_walls*2,h_motor]);            
            }
            
            //Chassis thruster support
            difference() {
                translate ([d_thruster/2-w_walls/2,-w_walls,0]) cube([w_support+w_walls/2, w_walls*2, h_support]);
                translate ([d_thruster/2+w_support/2,(w_walls*2+2)/2,h_support/2]) rotate([90,0,0]) cylinder (r=d_screw/2,h=w_walls*2+2);
            }
        }
        
        //half thruster
        translate ([-d_thruster/2-1,0,-1]) cube ([d_thruster+w_support+2,d_thruster/2+1,h_thruster+2+h_motor]);
    }
}

module half_thruster_B(w_walls=2.7, d_motor=7.6, h_motor=8, o_motor=0, d_thruster=34,h_thruster=30, d_screw=3.4, h_support=8, w_support=8){
    union() {
        mirror ([0,1,0]) half_thruster_A(w_walls, d_motor, h_motor, o_motor, d_thruster, h_thruster, d_screw, h_support, w_support);
        difference() {
            union() {
                translate([-d_thruster/2,0,0]) linear_extrude(height=h_thruster-w_walls/2) scale([1.2,2,1]) circle(d_thruster/30);
                translate([ d_thruster/2,0,h_support]) linear_extrude(height=h_thruster-w_walls/2-h_support) scale([1.2,2,1]) circle(d_thruster/30);
            }
            translate([-0,0,-1]) cylinder(d=d_thruster,h=h_thruster-w_walls/2+2);
        }
    }    
}
         
module thruster(w_walls=2.7, d_motor=7.6, h_motor=8, o_motor=0, d_thruster=34,h_thruster=30, d_screw=3.4, h_support=8, w_support=8){
    half_thruster_A(w_walls, d_motor, h_motor, o_motor, d_thruster, h_thruster, d_screw, h_support, w_support);
    half_thruster_B(w_walls, d_motor, h_motor, o_motor, d_thruster, h_thruster, d_screw, h_support, w_support);
}

//$fn = 100;

translate([0,-2.5,0]) half_thruster_A();
translate([0,2.5,0]) half_thruster_B();
translate([50,0,0]) thruster();

