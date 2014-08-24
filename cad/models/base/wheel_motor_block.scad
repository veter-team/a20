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
  rotate([180, 0, 0])
  {
      translate([0, 0, shaft_shift])
      rotate([0, 90, 0])
      color("LightGrey")
      wheel_holder();

      translate([wheel_holder_z_size + 1, 0, shaft_shift])
      rotate([0, 90, 0])
      color("Gainsboro")
      belt_gear_10();

      translate([wheel_holder_z_size + belt_gear_10_l + 2, 0, shaft_shift])
      rotate([0, 90, 0])
      color("LightGrey")
      wheel_holder();
      
      translate([-30, 0, 25.0 + motor_shaft_shift]) 
      rotate([0, -90, 0])
      wheel();
  }
}


module wheel_motor_block()
{

    wheel_block();
    rotate([180, 0, 0])
    {
        translate([2 * wheel_holder_z_size + belt_gear_15_l + 2 + 1, 0, shaft_shift])
        rotate([0, 90, 0])
        color("DarkGoldenrod")
        shaft_coupling();

        translate([2 * wheel_holder_z_size + belt_gear_15_l + 2 + shaft_coupling_l + 10, 0, 0])
        motor_with_holder();
    }
}



if(ASSEMBLY == undef || ASSEMBLY == 0)
{
    //wheel_block();
    wheel_motor_block();
}
