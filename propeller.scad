/*
w_walls = 2.7;
d_thruster = 34;
h_propeller = 10;
o_propeller = 1;
n_blade = 3;
s_blade = 20;
w_blade = 4;
d_motor = 1;
*/

module blades(w_walls=2.7, d_thruster=34, h_propeller=10, o_propeller=1, n_blade=3, s_blade=20, w_blade=4){
    for (i=[0:n_blade]){
        rotate([0,0,i*(360/n_blade)])   
            linear_extrude(height = h_propeller, convexity = 10, twist = (-360/n_blade)+s_blade)
                translate([-o_propeller,-2,0]) polygon(points=[[0,0],[(d_thruster)/2-w_walls,0],[(d_thruster)/2-w_walls,w_blade/2],[0,w_blade]]);
    }
}

module propeller(w_walls=2.7, d_thruster=34, h_propeller=10, o_propeller=1, n_blade=3, s_blade=20, w_blade=4, rounded=false, d_motor=1){
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
        
        translate([0,0,-1]) cylinder(h=h_propeller,d=d_motor);
    }
}

//$fn=100;
propeller();
