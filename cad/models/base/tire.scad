use <../MCAD/regular_shapes.scad>
include <../main_dimensions.scad>


module tire()
{
  rim_r = 23;

  // Tire
  color("Gray")
  oval_torus(rim_r, [wheel_radius - rim_r, wheel_width], $fn = 64);
}


if(ASSEMBLY == undef || ASSEMBLY == 0)
{
  tire();
}
