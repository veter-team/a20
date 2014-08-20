include <main_dimensions.scad>
use <wheel.scad>
use <motor_holder.scad>
use <motor.scad>
use <shaft_hub.scad>
use <shaft_coupling.scad>
use <belt_gear_15.scad>
use <wheel_holder.scad>


module motor_with_holder()
{
  motor_holder();
    
  translate([1.5 * motor_holder_h, 0, 25.0]) 
  rotate([0, -90, 0]) 
  motor();
}


module wheel_motor_block()
{
  rotate([180, 0, 0])
  {
    translate([shaft_coupling_l + wheel_holder_z_size + shaft_coupling_l + 13, 0, 0])
    motor_with_holder();

    translate([shaft_coupling_l + wheel_holder_z_size - shaft_coupling_l * 0.75 + 13, 0, shaft_shift])
    rotate([0, 90, 0])
    color("DarkGoldenrod")
    shaft_coupling();

    translate([16, 0, shaft_shift])
    rotate([0, 90, 0])
    color("LightGrey")
    wheel_holder();

    translate([15, 0, shaft_shift])
    rotate([0, -90, 0])
    color("Gainsboro")
    belt_gear_15();

    translate([-30, 0, 25.0 + motor_shaft_shift]) 
    rotate([0, -90, 0])
    wheel();
  }
}

module wheel_block()
{
  rotate([180, 0, 0])
  {
      translate([16, 0, shaft_shift])
      rotate([0, 90, 0])
      color("LightGrey")
      wheel_holder();

      translate([15, 0, shaft_shift])
      rotate([0, -90, 0])
      color("Gainsboro")
      belt_gear_15();

      translate([-30, 0, 25.0 + motor_shaft_shift]) 
      rotate([0, -90, 0])
      wheel();
  }
}


if(ASSEMBLY == undef || ASSEMBLY == 0)
{
    wheel_block();
    //wheel_motor_block();
}
