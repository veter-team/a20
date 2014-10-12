ASSEMBLY = 1;

use <base/base_assembly.scad>
use <deck2/deck2_assembly.scad>
use <accessories/ball_collector3.scad>
include <main_dimensions.scad>


// Chassis and deck1
base_assembly();

// Deck 2 with electronic
translate([0, 0, wheel_holder_z_dim / 2 + shaft_radius + 2 + base_z_size / 2 + 1])
deck2_assembly("parts");

translate([0, -230, 40])
ball_collector();