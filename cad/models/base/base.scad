use <MCAD/boxes.scad>
use <lead_battery.scad>
include <main_dimensions.scad>


module base1()
{
  color("BurlyWood")
  roundedBox([base_x_size - wheel_width * 2, base_y_size, base_z_size], 10, true);
  echo("** Base x-size: ", base_x_size - wheel_width * 2);
  echo("** Base y-size: ", base_y_size);

  // Allowed dimensions
  //%cube([297, 420, 2], center = true);
  %cube([420, 297, 2], center = true);
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
