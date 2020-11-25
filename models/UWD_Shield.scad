$fn=40;

module ring() {
    translate([0,0,2]) linear_extrude(6) {
        difference() {
            circle(7);
            circle(5);
            translate([-1.5,0,0]) square([3,10]);
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
    linear_extrude(10) {
        difference() {
            union() {
                circle(90,$fn=3);
                circle(d=100,$fn=100);
            }
            circle(d=72);
        }
    }
}
module edge_diff() {
    linear_extrude(10) {
        difference() {
            translate([80,0,0]) circle(10,$fn=3);
            translate([70,0,0]) circle(d=20);
        }
    }
}
module edge() {
    difference() {
        linear_extrude(40) {
            translate([70,0,0]) circle(d=20);
        }
        
        for(i = [0:1:5]) {
             translate([70,0,2 * i]) rotate([0,0,30 + 60 * i]) translate([0,18,15]) rotate([90,0,0]) screw_m3();
        }
    }
}


difference() {
    union() {
        difference() {
            body();
            edge_diff();
            rotate([0,0,120]) edge_diff();
            rotate([0,0,240]) edge_diff();
        }
        edge();
        rotate([0,0,120]) edge();
        rotate([0,0,240]) edge();
    }

    for (i = [0: 1: 35]) {
        rotate([90,0,10 * i + 5]) linear_extrude(200) circle(2);
    }
    for (i = [0: 1: 35]) {
        translate([0,0,10]) rotate([90,0,10 * i]) linear_extrude(200) circle(2);
    }
    for(i = [0: 1: 2]) {
        rotate([0,0,120 * i]) {
            translate([60,0,5]) rotate([90,0,0]) {
                translate([0,0,-19]) screw_m3();
                rotate([180,0,0]) translate([0,0,-19]) screw_m3();
            }
            translate([68,0,5]) rotate([90,0,0]) {
                translate([0,0,-15]) screw_m3();
                rotate([180,0,0]) translate([0,0,-15]) screw_m3();
            }
        }
    }
    for(i = [0: 1: 2]) {
        rotate([0,0,30 + 120 * i]) linear_extrude(50) square([0.5,100]);
    }
}


for(i = [0: 1: 2]) {
    rotate([0,0,120 * i]) {
        translate([-48,30,0]) ring();
        translate([-51,0,0]) ring();
        translate([-48,-30,0]) ring();
    }    
}


//weight();
//translate([-45,-92,0]) rotate([90,0,0]) weight_hook();
//translate([-45,-92,0]) rotate([0,0,90]) weight_holder();
//weight_hook();
module weight() {
    linear_extrude(4) square([176, 16]);
}

module weight_holder() {
    linear_extrude(35) square([184, 24]);
}

module weight_hook() {
    difference() {
        union() {
            linear_extrude(20) difference() {
                square([41, 23]);
                translate([3,3,0]) square([35, 17]);
            }
            translate([0,23,20]) rotate([90,0,0]) linear_extrude(23) polygon([[0,0],[0,20],[2,30],[4,32],[8,34],[16,36],[32,38],[32,34],[16,32],[8,30],[5,28],[3,20],[3,10],[3,0]]);
        }
        translate([29,8,10]) rotate([0,90,0]) screw_m3();
        translate([29,14,10]) rotate([0,90,0]) screw_m3();
    }
}

