ASSEMBLY = 1;
//$fn=64;

use <wheel_motor_block.scad>
use <base.scad>
use <lead_battery.scad>
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
//base2();

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
