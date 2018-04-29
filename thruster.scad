$fn = 100;

/*
w_walls = 2.7;
d_motor = 7.6;
h_motor = 10;
d_thruster = 34;
h_thruster = 30-w_walls/2;
d_screw = 3.4;
*/

module half_thruster_A(w_walls=2.7, d_motor=7.6, h_motor=10, d_thruster=34,h_thruster=30, d_screw=3.4) { 
    difference(){  
        union() {
            difference() {
                cylinder(d=d_thruster,h=h_thruster-w_walls/2);
                translate ([0,0,-1]) cylinder(d=d_thruster-+w_walls*2,h=h_thruster+2-w_walls/2);
            }
            difference(){
                cylinder (r=d_motor/2+w_walls,h=h_motor);
                translate ([0,0,-1]) cylinder (r=d_motor/2,h=h_motor+2);
            }
            difference(){
                translate ([d_motor/2+w_walls/2,-w_walls,0]) cube([d_thruster/2-d_motor/2-w_walls/2+w_walls*2+d_screw,w_walls*2,h_motor]);
                translate ([d_thruster/2+w_walls+d_screw/2,(w_walls*2+2)/2,h_motor/2]) rotate([90,0,0]) cylinder (r=d_screw/2,h=w_walls*2+2);
            }

            translate ([0,0,h_thruster-w_walls/2]) rotate_extrude (convexity=10) translate ([d_thruster/2-w_walls/2,0,0]) circle (r=w_walls/2);
        }
        translate ([-d_thruster/2-1,0,-1]) cube ([d_thruster+2*w_walls+d_screw+2,d_thruster/2+1,h_thruster+2]);
    }
}

half_thruster_A();
mirror ([0,1,0]) half_thruster_A();
