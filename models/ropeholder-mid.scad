$fn=40;

module edge() {
    linear_extrude(50) union() {
        translate([0,-50]) circle(10);
        square([20,100],true);
        translate([0,50]) circle(10);
    }
}

module dent() {
    linear_extrude(60) union() {
        translate([0,-30]) circle(20);
        square([40,60],true);
        translate([0,30]) circle(20);
    }
}

module pipe10() {
    linear_extrude(400) difference() {
        circle(5.1);
        circle(4.40);
    }
}

module bar10() {
    linear_extrude(400) difference() {
        circle(5.1);
    }
}

module ropeholder() {
    difference() {
        edge();
        for(x = [0 : 1 : 3]) {
            translate([0, -50 + 33 * x, 30]) pipe10();
        }
        translate([-20,0,0]) rotate([0,90,0]) dent();
    }
}

//ropeholder();

module middle() {
    linear_extrude(20) union() {
        translate([0,-50]) circle(10);
        square([20,100],true);
        translate([0,50]) circle(10);

        //stable1
        translate([8, 60, 0]) difference() {
            circle(5);
            circle(3);
            rotate([0, 0, -160]) translate([0, 5, 0]) square([3,10],true);
        }

        //stable2
        translate([-7, 59, 0]) difference() {
            circle(4);
            circle(2);
            rotate([0, 0, -120]) translate([5, 0, 0]) square([10,2],true);
        }
        
        //stable3
        translate([8, -60, 0]) difference() {
            circle(5);
            circle(3);
            rotate([0, 0, -20]) translate([0, 5, 0]) square([3,10],true);
        }

        //stable4
        translate([-7, -59, 0]) difference() {
            circle(4);
            circle(2);
            rotate([0, 0, -240]) translate([5, 0, 0]) square([10,2],true);
        }
    }
}

module m3() {
    linear_extrude(50) circle(1.8);
}

module ropeholder_middle() {

    difference() {
        middle();
        for(x = [0 : 1 : 3]) {
            translate([0, -50 + 33 * x, 0]) bar10();
        }
        rotate([0, 90, 0]) linear_extrude(1) square([40, 200], true);
        for(y = [0 : 1 : 2]) {
            
            translate([0, -33 + (33 * y), 0]) translate([-30,0,10]) rotate([0, 90, 0]) m3();
        }
    }
}

ropeholder_middle();
