ASSEMBLY = 1;
//$fn=64;

use <wheel_motor_block.scad>
use <base.scad>
use <lead_battery.scad>
use <tower.scad>
include <main_dimensions.scad>

explosion_distance = 3;

module wheel_motor_placement()
{
  translate([-base_x_size / 2 + wheel_width, -base_y_size / 2 + wheel_radius, -base_z_size / 2])
  wheel_motor_block();
}


module wheel_placement()
{
  translate([-base_x_size / 2 + wheel_width, base_y_size / 2 - wheel_radius, -base_z_size / 2])
  wheel_block();
}


// Base platform
base2();

translate([0, 0, -(shaft_shift + belt_gear_15_r1 + 1 + wheel_holder_mount_h + base_z_size)])
base1();

// Battery
translate([0, 0, -(shaft_shift + belt_gear_15_r1 + 1 + wheel_holder_mount_h + base_z_size / 2)])
lead_battery();

// Passive wheels
wheel_placement();
mirror([1, 0, 0])
mirror([0, 1, 0])
wheel_placement();

// Active wheels
wheel_motor_placement();
mirror([1, 0, 0])
mirror([0, 1, 0])
wheel_motor_placement();



// ********************************************************
// This is just a very first idea(s) regarding robot cover.

module front_cover()
{
    color("DimGray")
    rotate([0, 90, 0])
    scale([2, 1, 1])
    difference()
    {
        cylinder(r = 20, h = 164, center = true, $fn = 128);
        cylinder(r = 17, h = 164 + 0.1, center = true, $fn = 128);
        translate([0, 20, 0])
        cube([40, 40, 164 + 0.1], center = true);
    }
}

translate([0, -144, -15])
front_cover();

mirror([0, 1, 0])
translate([0, -144, -15])
front_cover();


translate([0, 60, 35])
color("DimGray")
tower();

color("DimGray")
translate([0, 80, 35])
cylinder(r1 = 5, r2 = 2, h = 200);

color("Gray")
translate([30, 80, 50])
cube([15, 5, 90]);

color("DimGray")
difference()
{
    translate([0, 0, 35])
    cube([164, 287, 3], center = true);

    translate([0, 60, 35])
    cylinder(r = 70, h = 10, center = true);
}

translate([15, -15, 60])
rotate([90, 0, 0])
color("Black")
cylinder(r = 10, h = 20, center = true);

translate([-15, -15, 60])
rotate([90, 0, 0])
color("Black")
cylinder(r = 10, h = 20, center = true);


translate([12, -155, 5])
rotate([90, 0, 0])
color("Silver")
cylinder(r = 10, h = 20, center = true);

translate([-12, -155, 5])
rotate([90, 0, 0])
color("Silver")
cylinder(r = 10, h = 20, center = true);
