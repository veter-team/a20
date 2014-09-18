ASSEMBLY = 1;
//$fn=64;

use <wheel_motor_block.scad>
use <base.scad>
use <lead_battery.scad>
use <bottom_battery_holder.scad>
use <bottom_battery_stopper.scad>
use <tower.scad>
use <belt.scad>
use <front_pannel.scad>
use <screw_thread.scad>
use <motor_holder.scad>
include <../main_dimensions.scad>


explosion_distance = 3;
distance_betwee_wheels = (330.5 - 2 * 3.1415 * belt_gear_r2) / 2 / 2;


module wheel_motor_placement()
{
    
  translate([base_x_size / 2 - wheel_holder_y_dim / 2,
          -distance_betwee_wheels,
          0])
  rotate([0, 0, -90])
  rotate([0, 180, 0])
  wheel_motor_block();

  translate([base_x_size / 2 - wheel_holder_y_dim / 2 + (belt_gear_l - belt_gear_l1) / 2,
          -distance_betwee_wheels,
          0])
  rotate([0, 0, 0])
  belt(330.5, belt_gear_r2);
}


module wheel_placement()
{
  translate([base_x_size / 2 - wheel_holder_y_dim / 2,
          distance_betwee_wheels,
          0])
  rotate([0, 0, -90])
  wheel_block();
}


module wheel_holder_mount_shaft()
{
    spring_length = 45;
    holder_shaft_length = base_y_size + 25 * 2;
    
    translate([base_x_size / 2 - wheel_holder_y_dim / 2, 0, wheel_holder_z_dim / 2])
    rotate([90, 0, 0])
    {
        color("Silver")
        cylinder(r = shaft_radius, h = holder_shaft_length, center = true, $fn = 32);
        echo("** Wheel holder mount shaft length:", holder_shaft_length);

        // Springs for belt tension
        translate([0, 0, -spring_length / 2])
        color("Silver")
        spring(2, shaft_radius * 2 + 2, 1, spring_length, $fn = 32);
    }
}


module front_pannel_with_motor_holes()
{
    color("Snow")
    {
        translate([0, distance_betwee_wheels + shaft_shift + front_pannel_h / 2, 0])
        {
            difference()
            {
                front_pannel();
                
                // Holes for motor holder
                translate([-(base_x_size / 2 - wheel_holder_y_dim - shaft_coupling_l - 10),
                        0,
                        -motor_holder_y_dim / 2,
                        ])
                rotate([90, 0, 0])
                motor_holder_mounting_holes(front_pannel_h * 2);
            }
        }
    }
}

module base_assembly()
{
    // Marker to visually check wheel holder position
    //translate([-82 + 15, 79.5, -55]) cube([1, 10, 10]);
    
    // Base platform
    translate([0, 0, -wheel_holder_z_dim / 2 - shaft_radius - 2 - base_z_size / 2 - 1])
    base1();
    
    // Battery
    translate([0, 0, -wheel_holder_z_dim / 2 - shaft_radius - 2 + base_z_size / 2])
    lead_battery();

    // Battery holders on the deck1
    color("Snow")
    {
        translate([0, akku_y_dim / 2 + 5 + 3, -wheel_holder_z_dim / 2 - shaft_radius - 2 + base_z_size / 2])
        bottom_battery_holder();

        translate([0, -akku_y_dim / 2 - 5 - 3, -wheel_holder_z_dim / 2 - shaft_radius - 2 + base_z_size / 2])
        bottom_battery_holder();

        translate([akku_x_dim / 2 + 5 + 1, 0, -wheel_holder_z_dim / 2 - shaft_radius - 2 + base_z_size / 2])
        bottom_battery_stopper();
        
        translate([-akku_x_dim / 2 - 5 - 1, 0, -wheel_holder_z_dim / 2 - shaft_radius - 2 + base_z_size / 2])
        bottom_battery_stopper();
    }
    
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
    
    // Wheel holder mounting shafts
    wheel_holder_mount_shaft();
    mirror([1, 0, 0])
    wheel_holder_mount_shaft();
    
    mirror([0, 0, 1])
    {
        wheel_holder_mount_shaft();
        mirror([1, 0, 0])
        wheel_holder_mount_shaft();
    }
    
    // Front and rear pannels
    front_pannel_with_motor_holes();
    mirror([0, 1, 0])
    mirror([1, 0, 0])
    front_pannel_with_motor_holes();
    
    
    // ********************************************************
    // This is just a very first idea(s) regarding robot cover.
    /*
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
    */
}

base_assembly();
