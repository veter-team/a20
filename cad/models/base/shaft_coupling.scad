include <main_dimensions.scad>


module shaft_coupling()
{
  r1 = 6;
  r2 = 2;

  difference()
  {
    cylinder(r = 6, h = shaft_coupling_l, $fn = 128);
    
    // shaft hole
    translate([0, 0, -0.05])
    cylinder(r = 3, h = shaft_coupling_l + 0.15, $fn = 64);

    // screw bottom hole
    translate([0, 0, r2 + 1])
    rotate([0, 90, 0])
    cylinder(r = r2, h = r1, $fn = 32);

    // screw top hole
    translate([0, 0, shaft_coupling_l - r2 - 1])
    rotate([0, 90, 0])
    cylinder(r = r2, h = r1, $fn = 32);

    // opening to see shaft position
    translate([-r1, -r1, -0.05])
    cube([r1, r1, shaft_coupling_l + 0.15]);
  }
}


if(ASSEMBLY == undef || ASSEMBLY == 0)
{
    shaft_coupling();
}
