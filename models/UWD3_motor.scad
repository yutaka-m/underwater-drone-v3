$fn=40;

//motor_screw_ccr();
//motor_screw_cr();
//body();
foot();
module foot() {
            scale([1,1,0.25])
            difference() {
                sphere(45);
                translate([-50,-50,0]) cube(100,0);
                for(i = [0:1:36]) {
    rotate([0,0,10 * i]) translate([0,0,-50]) rotate_extrude(angle=7) translate([10,0,0]) square([32,50],0);
                }
            }
            //linear_extrude(5) circle(45);
}

module wide_screw_m3() {
    union() {
        linear_extrude(50) circle(r=1.7);
        linear_extrude(30) circle(r=4.0);
        translate([-4,-20,0]) cube([8,20,30]);
    }
}

module wide_nat_m3() {
    union() {
        linear_extrude(3) circle(r=4.0);
        translate([-4,-20,0]) cube([8,20,3]);
    }
}

module screw_m3() {
    union() {
        linear_extrude(40) circle(r=1.7);
        linear_extrude(20) circle(r=3.3);
    }
}
module body_union() {
    difference() {
        union() {
            translate([0,0,85]) sphere(45);
            linear_extrude(85) circle(45);
            //translate([-50,0,85]) rotate([0,90,0]) linear_extrude(100) circle(38);
        }
        for(i = [0: 1: 24]) {
            rotate([-10, 0, 15 * i]) translate([0,0,35]) rotate([90,0,0]) linear_extrude(100) circle(4);
            rotate([-10, 0, 7 + 15 * i]) translate([0,0,25]) rotate([90,0,0]) linear_extrude(100) circle(4);
        }
    }
}

module body_diff() {
    translate([0,0,49]) linear_extrude(30) circle(30);
    linear_extrude(45) circle(42);
    translate([-50,0,85]) rotate([0,90,0]) linear_extrude(100) circle(36);
    translate([9.25,0,68]) rotate([0,180,0]) screw_m3();
    translate([-9.25,0,68]) rotate([0,180,0]) screw_m3();
    translate([0,8,68]) rotate([0,180,0]) screw_m3();
    translate([0,-8,68]) rotate([0,180,0]) screw_m3();
    translate([9.25,8,45]) linear_extrude(10) circle(3);
    translate([-9.25,8,45]) linear_extrude(10) circle(3);
    translate([0,0,45]) linear_extrude(2) circle(4);
    //18.5
    //16
    
    translate([10,-40,95]) rotate([180,0,180]) wide_screw_m3();
    translate([-10,-40,95]) rotate([180,0,180]) wide_screw_m3();
    translate([10,-40,55]) rotate([180,0,180]) wide_nat_m3();
    translate([-10,-40,55]) rotate([180,0,180]) wide_nat_m3();
    
    //wire
    translate([-50,32,64]) rotate([0,90,0]) linear_extrude(100) circle(4);
    //cut
    translate([-50,-100,60]) cube([100,100,0.2]);
}

module body() {
    difference() {
        union() {
            translate([0,85,85]) rotate([90,0,0]) body_union();
            body_union();
        }
        body_diff();
        translate([0,85,85]) rotate([90,180,0]) body_diff();
    }
}

module motor_screw_ccr() {
    translate([0,0,23]) linear_extrude(7) difference() {
        circle(15);
        circle(1.6);
    }
    linear_extrude(23) difference() {
        circle(15);
        circle(14);
    }

    translate([0,0,28]) linear_extrude(2) difference() {
        circle(30);
        circle(28);
    }
    linear_extrude(2) difference() {
        circle(30);
        circle(28);
    }

    for(i = [0:1:3]) {
        rotate([0,0,90 * i]) linear_extrude(30, twist=60,convexity=10) translate([15,0,0]) square([15,2],0);
    }
}

module motor_screw_cr() {
    translate([0,0,23]) linear_extrude(7) difference() {
        circle(15);
        circle(1.6);
    }
    linear_extrude(23) difference() {
        circle(15);
        circle(14);
    }

    translate([0,0,28]) linear_extrude(2) difference() {
        circle(30);
        circle(28);
    }
    linear_extrude(2) difference() {
        circle(30);
        circle(28);
    }

    for(i = [0:1:3]) {
        rotate([0,0,90 * i]) linear_extrude(30, twist=-60,convexity=10) translate([15,0,0]) square([15,2],0);
    }
}


