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


difference() {
    edge();
    for(x = [0 : 1 : 3]) {
        translate([0, -50 + 33 * x, 30]) pipe10();
    }
    translate([-20,0,0]) rotate([0,90,0]) dent();
}