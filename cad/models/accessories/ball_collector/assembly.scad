ASSEMBLY = 1;

use <rotor_shaft.scad>
use <ball_collector_blade.scad>
use <motor_box.scad>
include <../../main_dimensions.scad>


ball_collector_blade();

rotate([30, 0, 0])
translate([-blade_w / 2 - 20, 20, 0])
rotate([0, 0, 90])
motor_box();

// Tennis ball
translate([0, 0, -rotor_r - ball_r])
%sphere(r = ball_r);

// Rotor
rotate([0, 90, 0])
%cylinder(r = rotor_r, h = blade_w - 2 * 10, center = true);
