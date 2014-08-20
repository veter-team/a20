include <main_dimensions.scad>


module shaft_hub()
{
  difference()
  {
    union()
    {
      cylinder(r = hub_outer_radius, h = hub_height1, $fn = 64);
      translate([0, 0, hub_height1])
      cylinder(r = hub_inner_radius, h = hub_height2, $fn = 64);
    }

    // shaft hole
    cylinder(r = shaft_radius, h = hub_height1 + hub_height2 + 0.1, $fn = 64);

    // mounting holes
    // Hub mounting holes
    for(i = [0 : 360 / 6 : 360])
    {
      rotate([0, 0, i])
      translate([9.53, 0, -tolerance])
      cylinder(r = mount_hole_radius + tolerance / 2, 
               h = hub_height1 + 3 * tolerance, $fn = 16);
    }

  }
}


if(ASSEMBLY == undef || ASSEMBLY == 0)
{
  shaft_hub();
}
