
module screw_m3() {
        union() {
            linear_extrude(45) {
                circle(r=1.7);
            }
            linear_extrude(6) {
                circle(r=3.3);
            }
        }
}

difference() {
    linear_extrude(40) square([117,100]);
    translate([52,5,5]) linear_extrude(35.6) square([60,95]);
    translate([5,5,5]) linear_extrude(35.6) square([44,90]);
    translate([49,75,15]) linear_extrude(15) square([3,20]);
    translate([67,0,3]) linear_extrude(5) square([30,5]);
    translate([3.5,3.5,-2]) screw_m3();
    translate([3.5,96.5,-2]) screw_m3();
    translate([113.5,3.5,-2]) screw_m3();
    translate([113.5,96.5,-2]) screw_m3();
    translate([57,10,-2]) screw_m3();
    translate([107,10,-2]) screw_m3();
    translate([57,67.5,-2]) screw_m3();
    translate([107,67.5,-2]) screw_m3();
}