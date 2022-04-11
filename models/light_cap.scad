$fn=50;

cap();

module cap() {
    union() {
        translate([0, 0, 25]) linear_extrude(4) circle(37);
        translate([0, 0, 9]) linear_extrude(15) difference() {
            circle(37);
            circle(32);
        }
        linear_extrude(25) difference() {
            circle(37);
            circle(34);
        }
        for(z = [0 : 1 : 2]) {
            rotate([0, 0, 120*z]) translate([0, 0, 5]) rotate_extrude(angle = 45, convexity = 2) translate([34.7, 0, 0]) circle(1);
        }
    }

}