include <../../main_dimensions.scad>


module cone_gear()
{
    color("Silver")
    difference()
    {
        union()
        {
            cylinder(r = 15 / 2, h = 7, $fn = 64);
            translate([0, 0, 6.5])
            cylinder(r1 = 16.8 / 2, r2 = 12.7 / 2, h = 5.3);
        }

        translate([0, 0 , -1])
        cylinder(r = shaft_radius, h = 20, $fn = 64);
    }
}


if(ASSEMBLY == undef || ASSEMBLY == 0)
{
    cone_gear();
}
