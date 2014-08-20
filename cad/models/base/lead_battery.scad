use <MCAD/boxes.scad>
include <main_dimensions.scad>


module lead_battery()
{
  x_dim = 134;
  y_dim = 67;
  z_dim = 61;

  translate([0, 0, z_dim / 2])
  color("DimGray")
  roundedBox([x_dim, y_dim, z_dim], 2, false, $fn = 16);

  // Contacts
  translate([-x_dim / 2 + 10, y_dim / 2 - 15, z_dim])
  color("Gainsboro")
  cube([1, 3, 5]);

  translate([-x_dim / 2 + 10, -(y_dim / 2 - 15), z_dim])
  color("Gainsboro")
  cube([1, 3, 5]);
}


if(ASSEMBLY == undef || ASSEMBLY == 0)
{
  lead_battery();
}
