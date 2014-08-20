include <main_dimensions.scad>


module md22()
{
  color("DarkGreen")
  cube([110, 51, 1.5]);
}


if(ASSEMBLY == undef || ASSEMBLY == 0)
{
  md22();
}
