use <MCAD/boxes.scad>
include <main_dimensions.scad>
use <wheel_holder.scad>


module bearing_pad()
{
  translate([0, 0, -wheel_holder_z_size + wheel_holder_wall])
  intersection()
  {
    wheel_holder();
    
    translate([-(belt_gear_15_r1 + 1 - tolerance / 4), 
               -(radial_bearing_r + wheel_holder_wall), 
               wheel_holder_z_size - wheel_holder_wall + 0.05])
    cube([shaft_shift + belt_gear_15_r1 + 1 - tolerance / 2 - wheel_holder_mount_h, 
          (radial_bearing_r + wheel_holder_wall) * 2, 
          wheel_holder_wall]);
  }
}


if(ASSEMBLY == undef || ASSEMBLY == 0)
{
  bearing_pad();
}
