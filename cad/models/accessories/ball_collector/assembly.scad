ASSEMBLY = 1;

use <rotor_shaft.scad>
use <ball_collector_blade.scad>
use <motor_box.scad>
use <cone_gear.scad>
include <../../main_dimensions.scad>

motor_shift_x = 22;
motor_shift_y = 28;


module motor_positioned(for_mounting_holes)
{
    angle = 20;
    rotate([angle, 0, 0])
    translate([-blade_w / 2 - motor_shift_x-1, motor_shift_y, 0])
    rotate([0, 0, 90])
    motor_box(for_mounting_holes, angle);
}

difference()
{
    ball_collector_blade();

    translate([0, 0, 0])
    motor_positioned(true);
}
motor_positioned(false);

translate([-blade_w / 2 - 4, 0, 0])
rotate([0, -90, 0])
cone_gear();

rotate([20, 0, 0])
translate([-blade_w / 2 - motor_shift_x, motor_shift_y - 10, 0])
rotate([90, 0, 0])
%cone_gear();


// Tennis ball
translate([0, 0, -rotor_r - ball_r])
%sphere(r = ball_r);

// Shaft
rotate([0, 90, 0])
color("Gray")
cylinder(r = shaft_radius, h = blade_w + 2 * 10, center = true);

// Rotor
rotate([0, 90, 0])
%cylinder(r = rotor_r, h = blade_w - 2 * 10, center = true);
