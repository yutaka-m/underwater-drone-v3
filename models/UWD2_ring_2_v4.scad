$fn=50;

module sketch() {
      circle(r=31);
}

module screw_m3() {
        union() {
            linear_extrude(12) {
                circle(r=1.7);
            }
            linear_extrude(6) {
                circle(r=2.8);
            }
        }
}

difference(){
    linear_extrude(10) {
        union() {
            difference(){
              offset(0) offset(0){
                  sketch();
              }
              offset(0) offset(-1) sketch();
            }

            translate([-18,-23.5,0]) rotate([0,0,90]) square([9.5,2]);
            translate([20,-23.5,0]) rotate([0,0,90]) square([9.5,2]);
            translate([-18,14,0]) rotate([0,0,90]) square([9.5,2]);
            translate([20,14,0]) rotate([0,0,90]) square([9.5,2]);
        }
    }

    union() {
        translate([-27,17.5,4]) {
            rotate([0,90,0]) {
                screw_m3();
            }
        }
        translate([-27,-17.5,4]) {
            rotate([0,90,0]) {
                screw_m3();
            }
        }
        translate([27,17.5,4]) {
            rotate([0,-90,0]) {
                screw_m3();
            }
        }
        translate([27,-17.5,4]) {
            rotate([0,-90,0]) {
                screw_m3();
            }
        }
    }
}