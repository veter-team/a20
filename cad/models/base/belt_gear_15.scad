include <main_dimensions.scad>


module belt_gear_15()
{
  difference()
  {
    union()
    {
      cylinder(r = belt_gear_15_r1, h = 1, $fn = 128);

      translate([0, 0, 1])
      cylinder(r = 12, h = 12);

      translate([0, 0, 13])
      cylinder(r = belt_gear_15_r1, h = 1, $fn = 128);

      translate([0, 0, 14])
      cylinder(r = 7.5, h = 6, $fn = 128);
    }

    translate([0, 0, -0.05])
    cylinder(r = 3, h = 20 + 0.15, $fn = 64);
  }
}


if(ASSEMBLY == undef || ASSEMBLY == 0)
{
    belt_gear_15();
}
