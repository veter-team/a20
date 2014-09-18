use <../MCAD/boxes.scad>
use <lead_battery.scad>
include <../main_dimensions.scad>


base_dim = [10, 25, 15];


module bottom_battery_stopper()
{
    difference()
    {
        // Base
        translate([0, 0, base_dim[2] / 2])
        roundedBox(base_dim, 1, false, $fn = 32);

        // Right mounting hole
        translate([0, base_dim[1] / 2 - 5,-0.1])
        cylinder(r = 0.7, h = base_dim[2] - 3, $fn = 32);

        // Left mounting hole
        translate([0, -base_dim[1] / 2 + 5, -0.1])
        cylinder(r = 0.7, h = base_dim[2] - 3, $fn = 32);
    }   
}


if(ASSEMBLY == undef || ASSEMBLY == 0)
{
    translate([0, 0, base_dim[2]])
    rotate([180, 0, 0])
    bottom_battery_stopper();
}
