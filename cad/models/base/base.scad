use <../MCAD/boxes.scad>
use <lead_battery.scad>
include <../main_dimensions.scad>


module base1()
{
  color("BurlyWood")
  roundedBox([base_x_size, base_y_size, base_z_size], 3, true);
  echo("** Base x-size: ", base_x_size);
  echo("** Base y-size: ", base_y_size);

// Allowed dimensions
%cube([allowed_x_size, allowed_y_size, 2], center = true);
}

module base2()
{
  difference()
  {
    base1();
    // battery pocket
    translate([0, 0, -(shaft_shift + belt_gear_15_r1 + 1 + wheel_holder_mount_h + base_z_size / 2)])
    scale([1.02, 1.04, 1.0])
    lead_battery();
  }
}


if(ASSEMBLY == undef || ASSEMBLY == 0)
{
  base2();
}
