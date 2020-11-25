$fn=50;
module screw_m3() {
        union() {
            linear_extrude(12) {
                circle(r=1.7);
            }
            linear_extrude(6) {
                circle(r=3.3);
            }
        }
}
module bt() {
    linear_extrude(25) {
        square([130,45]);
    }
}
difference() {
    linear_extrude(2) {
        square([120,40]);
    }
    union() {
        translate([2.5,2.5,-6]){
            screw_m3();
        }
        translate([117.5,2.5,-6]){
            screw_m3();
        }
        translate([2.5,37.5,-6]){
            screw_m3();
        }
        translate([117.5,37.5,-6]){
            screw_m3();
        }
        
        for(i= [0:4]) {
            translate([22*i+15,20,-1]){
                cylinder(r=9,4);
            }
        }
    }
}
