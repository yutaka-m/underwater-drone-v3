$fn=40;

cap();

module cap() {
    difference() {
        union() {
            linear_extrude(10) circle(5.5);
            linear_extrude(1) circle(6.5);
            translate([0,0,9]) linear_extrude(1) circle(6.5);
        }
        linear_extrude(10) circle(0.9);
        translate([-25,0,0]) rotate([90,0,0]) linear_extrude(0.2) square(50,50);
    }
}