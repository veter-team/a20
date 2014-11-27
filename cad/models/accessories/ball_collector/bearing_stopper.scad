include <../../main_dimensions.scad>


module bearing_stopper(length)
{
    tolerated_length = length - tolerance;
    r1 = radial_bearing_r - tolerance / 2;
    
    difference()
    {
        union()
        {
            cylinder(r = r1, h = radial_bearing_h, $fn = 128);

            translate([4, -r1, 0])
            cube([tolerated_length - 4, 2 * r1, radial_bearing_h]);

            translate([tolerated_length, 0, 0])
            cylinder(r = r1, h = radial_bearing_h, $fn = 128);
        }

        translate([0, 0, -0.1])
        cylinder(r = radial_bearing_r + 0.1, h = radial_bearing_h + 0.3, $fn = 128);
    }
}


if(ASSEMBLY == undef || ASSEMBLY == 0)
{
    bearing_stopper(20);
}
