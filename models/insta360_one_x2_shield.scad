$fn=40;

module ring() {
    translate([0,0,-5]) {    
        difference() {
            union() {
                linear_extrude(10) circle(4);
                rotate([90,0,0]) translate([0,5,-5]) linear_extrude(10) circle(4);
            }
            {
                linear_extrude(10) circle(2);
                rotate([90,0,0]) translate([0,5,-6]) linear_extrude(12) circle(2);
            }
//            translate([-1.5,0,0]) square([3,10]);
        }
    }
}


module screw_m3() {
    union() {
        linear_extrude(40) {
            circle(r=1.7);
        }
        translate([0,0,-10]) linear_extrude(20) {
            circle(r=3.3);
        }
    }
}

module body() {
    
    difference() {
        union() {
            // side
            translate([27,0,-20]) rotate([0,0,-5]) linear_extrude(40) union() { 
                square([10,48],0);
            }
            translate([-37,0,-20]) rotate([0,0,5]) linear_extrude(40) union() { 
                square([10,48],0);
            }

            //under
            translate([-29,0,-20]) linear_extrude(40) translate([-8,-2,0]) square([16,4],0);
            translate([29,0,-20]) linear_extrude(40) translate([-8,-2,0]) square([16,4],0);

            //front
            translate([0,20,21]) rotate([0,90,0]) translate([0,0,-37]) linear_extrude(74) translate([-2,-22,0]) square([4,47],0);
            translate([0,20,-21]) rotate([0,90,0]) translate([0,0,-37]) linear_extrude(74) translate([-2,-22,0]) square([4,47],0);
        }
        translate([0,29,0]) switch_hole();
        translate([32.4,27,0]) rotate([0,0,-5]) translate([-4,-17,-11]) linear_extrude(22) square([8,34],0);
        translate([-32.4,27,0]) rotate([0,0,5]) translate([-4,-17,-11]) linear_extrude(22) square([8,34],0);
    }
    
    translate([39,6,10]) rotate([0,0,0]) ring();
    translate([39,6,-10]) rotate([0,0,0]) ring();
    translate([42,39,10]) rotate([0,0,0]) ring();
    translate([42,39,-10]) rotate([0,0,0]) ring();
    translate([-39,6,10]) rotate([0,0,0]) ring();
    translate([-39,6,-10]) rotate([0,0,0]) ring();
    translate([-42,39,10]) rotate([0,0,0]) ring();
    translate([-42,39,-10]) rotate([0,0,0]) ring();

    translate([26,6,24]) rotate([0,90,0]) ring();
    translate([-26,6,24]) rotate([0,90,0]) ring();
    translate([26,39,24]) rotate([0,90,0]) ring();
    translate([-26,39,24]) rotate([0,90,0]) ring();
    translate([26,6,-24]) rotate([0,90,0]) ring();
    translate([-26,6,-24]) rotate([0,90,0]) ring();
    translate([26,39,-24]) rotate([0,90,0]) ring();
    translate([-26,39,-24]) rotate([0,90,0]) ring();
    
    translate([35,55.5,0]) rotate([-90,90,0]) switch_holder();
}

module switch_holder() {
    difference() {
        union() {
            translate([-12,-2,-10]) linear_extrude(10) square([24,5]);
            translate([0,3,0]) rotate([90,0,0]) linear_extrude(5) circle(12);
        }
        rotate([90,0,0]) translate([0,0,-4]) linear_extrude(40) {
            circle(r=7);
        }
    }
}

module switch_hole() {
    union() {
        linear_extrude(40) {
            circle(r=7);
        }
    }
}
 
translate([-34.5,1.5,-2.5]) cube(5);
translate([29.5,1.5,-2.5]) cube(5);

difference() {
    body();
    union() {
        translate([-75,-75,-0.5]) linear_extrude(0.7) square([150,150],0); 
        difference() { 
            translate([-35,1,-3]) cube(6);
            translate([-35,1,0]) cube(6);   
        }           
        difference() { 
            translate([29,1,-3]) cube(6);
            translate([29,1,0]) cube(6);   
        }           
    }
    //x=30;
    //translate([0,-5,0]) rotate([-90,0,0]) linear_extrude(150) polygon([[150,0],[x-1,0],[x-1,4],[-x+1,4],[-x+1,0],[-150,0],[-150,1],[-x,1],[-x,5],[x,5],[x,1],[150,1]]);
    
}





