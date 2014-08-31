include <main_dimensions.scad>
use <wheel.scad>
use <motor_holder.scad>
use <motor.scad>
use <shaft_hub.scad>
use <shaft_coupling.scad>
//use <belt_gear_15.scad>
use <belt_gear_10.scad>
use <wheel_holder.scad>


module motor_with_holder()
{
  motor_holder();

  translate([1.5 * motor_holder_h, 0, 25.0]) 
  rotate([0, -90, 0]) 
  motor();
}


module wheel_block()
{
    color("Snow")
    wheel_holder();

    translate([0, belt_gear_l / 2, 0])
    rotate([90, 0, 0])
    color("Gainsboro")
    belt_gear();
      
    translate([0, wheel_holder_y_dim / 2 + wheel_width / 2 + 2, 0]) 
    rotate([90, 0, 0])
    wheel();
}


module wheel_motor_block()
{
    wheel_block();

    translate([0, -wheel_holder_y_dim / 2 - 1, 0])
    rotate([90, 0, 0])
    color("DarkGoldenrod")
    shaft_coupling();

    rotate([0, 0, -90])
    rotate([-90, 0, 0])
    translate([wheel_holder_y_dim / 2 + shaft_coupling_l + 10, 0, -shaft_shift])
    motor_with_holder();
}



if(ASSEMBLY == undef || ASSEMBLY == 0)
{
    //wheel_block();
    wheel_motor_block();
}
