use <../MCAD/boxes.scad>
include <../main_dimensions.scad>


module lead_battery()
{
  translate([0, 0, akku_z_dim / 2])
  color("DimGray")
  roundedBox([akku_x_dim, akku_y_dim, akku_z_dim], 2, false, $fn = 16);

  // Contacts
  translate([-akku_x_dim / 2 + 10, akku_y_dim / 2 - 15, akku_z_dim])
  color("Gainsboro")
  cube([1, 3, 5]);

  translate([-akku_x_dim / 2 + 10, -(akku_y_dim / 2 - 15), akku_z_dim])
  color("Gainsboro")
  cube([1, 3, 5]);
}


if(ASSEMBLY == undef || ASSEMBLY == 0)
{
  lead_battery();
}
