$fn=40;

module frame() {
    linear_extrude(21) union() {
        translate([105 - 3.6, 0, 0]) square([3.6, 48.5]);
        square([105, 3.6]);
        square([3.6, 48.5]);
    }
}

module pole() {
    linear_extrude(20) difference() {
        circle(6);
        circle(4);
    }
}


translate([10, 20, -9]) rotate([0, 90, 0]) pole();
translate([75, 20, 29]) rotate([0, 90, 0]) pole();
translate([10, 20, 29]) rotate([0, 90, 0]) pole();
translate([75, 20, -9]) rotate([0, 90, 0]) pole();
difference() {
    translate([-5, 10, -5]) holder();
    frame();
    translate([-100, -100, 10]) linear_extrude(1) square([300,300]);
    translate([40, 20, -20]) linear_extrude(100) circle(1.7);
    translate([65, 20, -20]) linear_extrude(100) circle(1.7);
    translate([52.5, 0, 10]) rotate([-90, 0, 0]) linear_extrude(100) circle(6);
    translate([25, 0, 10]) rotate([-90, 0, 0]) linear_extrude(100) circle(6);
    translate([80, 0, 10]) rotate([-90, 0, 0]) linear_extrude(100) circle(6);

}

module holder() {
    linear_extrude(30) square([115, 20]);
}