include <../../main_dimensions.scad>


module cone_gear()
{
    color("Silver")
    difference()
    {
        union()
        {
            cylinder(r = 6, h = 9, $fn = 64);
            translate([0, 0, 8])
            cylinder(r1 = 10, r2 = 6, h = 5);
        }

        translate([0, 0 , -1])
        cylinder(r = shaft_radius, h = 20, $fn = 64);
    }
}


if(ASSEMBLY == undef || ASSEMBLY == 0)
{
    cone_gear();
}
