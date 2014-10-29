use <../../MCAD/regular_shapes.scad>
use <../../base/shaft_hub.scad>
include <../../main_dimensions.scad>


wall_w = 2;
tube_r = hub_outer_radius + wall_w;
tube_h = (15 - hub_height1) + 15;


module rotor_shaft_base()
{
    
    cylinder_tube(tube_h, tube_r, wall_w, $fn = 128);
    cylinder(r = tube_r - 1, 3);
}


module rotor_shaft()
{
    difference()
    {
        rotor_shaft_base();

        // mounting holes
        // Hub mounting holes
        for(i = [0 : 360 / 6 : 360])
        {
            rotate([0, 0, i])
            rotate([180, 0, 0])
            translate([9.53, 0, -tolerance - 3])
            //cylinder(r = mount_hole_radius + tolerance / 2, h = 30, $fn = 32);
            mounting_hole(4, true, $fn = 32);
        }

        // Hole for shaft
        translate([0, 0, -1])
        cylinder(r = shaft_radius, h = tube_h, $fn = 64);

        translate([0, 0, 15 - hub_height1])
        for(i = [0 : 360 / 4 : 360])
        {
            rotate([0, 0, i])
            rotate([0, 90, 0])
            cylinder(r = 4 / 2 + tolerance, h = 30, $fn = 32);
        }
    }
}


if(ASSEMBLY == undef || ASSEMBLY == 0)
{
    rotor_shaft();
    //translate([0, 0, -2]) rotate([180, 0, 0]) shaft_hub();
}