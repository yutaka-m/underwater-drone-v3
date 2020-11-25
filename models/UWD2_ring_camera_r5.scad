$fn=50;

module sketch() {
      circle(r=31);
}

module nat_m3() {
        linear_extrude(2.5) {
            square([6,6]);
        }
}

module camera_plate() {
    union() {
        linear_extrude(16) {
            square([26,28]);
        }
        translate([18,1.5,0]) {
            linear_extrude(4) {
                square([5.2,22.2]);
            }
        }
        translate([9,12.5]) {
            linear_extrude(16) {
                circle(r=7.7);
            }
        }
        translate([2,3,-10]) {
            linear_extrude(20) {
                circle (1.5);
            }
        }
        translate([2,24.2,-10]) {
            linear_extrude(20) {
                circle (1.5);
            }
        }
        translate([16,3,-10]) {
            linear_extrude(20) {
                circle (1.5);
            }
        }
        translate([16,24.2,-10]) {
            linear_extrude(20) {
                circle (1.5);
            }
        }
        translate([4,0,-3]) {
            linear_extrude(3) {
                square([10.1,28.2]);
            }
        }
    }
}

module screw_m3() {
        union() {
            linear_extrude(12) circle(r=1.7);
            translate([0,0,-24]) linear_extrude(24) circle(r=3.3);
        }
}

module nat_m3_frame() {
    linear_extrude(8) {
        difference(){
            square([8,4.5]);
            translate([1,1]) {
                square([6,2.5]);
            }
        }
    }
}


module ring() {
    difference(){
      union() {
        linear_extrude(15) {
            union() {
                difference(){
                  offset(0) offset(0){
                      sketch();
                  }
                  offset(0) offset(-1) sketch();
                }

            translate([-18,-23.5,0]) rotate([0,0,90]) square([9.5,2]);
            translate([-18,14,0]) rotate([0,0,90]) square([9.5,2]);
            }
        }
        linear_extrude(35) {
            translate([20,-23.5,0]) rotate([0,0,90]) square([9.5,2]);
            translate([20,14,0]) rotate([0,0,90]) square([9.5,2]);
        }
      }
        union() {
            translate([-20,17.5,10]) rotate([0,90,0]) screw_m3();
            translate([-20,-17.5,10]) rotate([0,90,0]) screw_m3();
            translate([20,17.5,10]) rotate([0,-90,0]) screw_m3();
            translate([20,-17.5,10]) rotate([0,-90,0]) screw_m3();
            translate([20,17.5,30]) rotate([0,-90,0]) screw_m3();
            translate([20,-17.5,30]) rotate([0,-90,0]) screw_m3();
        }
    }
    

    
}

module cambox() {
    difference(){
        union() {
            //cam
            translate([-12.1,-21,-4]) {
                linear_extrude(12) {
                    square([24.2,42]);
                }
            }
        }
        union() {
            //cam
            translate([-12.1,-14,-3]) {
                camera_plate();
            }
            translate([-12.1,-19,-2]) {
                linear_extrude(12) {
                    square([24.2,38]);
                }
            }            
        }
        translate([0,21,2]) rotate([90,0,0]) screw_m3();
        translate([0,-21,2]) rotate([-90,0,0]) screw_m3();
    }
}

translate([0,0,0]){
    rotate([0,0,0]){
        difference() {
            union() {
                ring();
                linear_extrude(15) translate([-19,23]) square([38,1.5]);
                rotate([0,4,0]) translate([27,-5,10]) rotate([0,90,0]) linear_extrude(2.8) square([10,10]);    
             
            }
            linear_extrude(16) translate([-30,24]) square([60,60]);
            
            translate([28,0,3]) rotate([0,-90,0]) screw_m3();
            translate([-4,10,13]) rotate([0,90,90]) linear_extrude(15) square([10,5]);
            
            translate([-10.8,23,8]) rotate([-90,0,0]) screw_m3();
            translate([9.8,23,8]) rotate([-90,0,0]) screw_m3();
        }
    }
    difference() {
        translate([-20,10,0]) linear_extrude(2) square([40,14]);

        translate([0,17,0]) rotate([0,0,0]) screw_m3();
        translate([0,19,0]) rotate([0,0,0]) screw_m3();
        translate([0,21,0]) rotate([0,0,0]) screw_m3();
    }
}

translate([0,0,-42]) linear_extrude(42){
    difference(){
      offset(0) offset(0) circle(r=31);
      offset(0) offset(-1) circle(r=31);
      translate([-32,0,0]) square([64,42]);
    }
}
//24.6 2.5 light hole
//2.8 8 3connector

translate([0,0,-42]){
    rotate([180,0,0]) {
        difference() {
            union() {
                ring();
                linear_extrude(15) translate([-19,-24.5]) square([38,1.5]);

            }
            linear_extrude(16) translate([-30,-84]) square([60,60]);
            translate([-4,-30,13]) rotate([0,90,90]) linear_extrude(15) square([10,5]);
            
            translate([-10.8,-24,8]) rotate([-90,0,0]) screw_m3();
            translate([9.8,-24,8]) rotate([-90,0,0]) screw_m3();
            
        }
    }
    translate([0,0,-2]) difference() {
        translate([-20,10,0]) linear_extrude(2) square([40,14]);

        translate([0,17,0]) rotate([0,0,0]) screw_m3();
        translate([0,19,0]) rotate([0,0,0]) screw_m3();
        translate([0,21,0]) rotate([0,0,0]) screw_m3();
    }
    
}

//translate([0,0,15]) cambox();
