use <../MCAD/regular_shapes.scad>
include <../main_dimensions.scad>


wheel_clutch_r = 13.4 / 2;

module stopper_pocket(depth)
{
    stopper_r = 2 / 2 + tolerance / 2;
    stopper_h = 10.5;

    translate([0, 0, stopper_r])
    {
        rotate([90, 0, 0])
        cylinder(r = stopper_r, h = stopper_h, center = true, $fn = 32);

        translate([-stopper_r, -stopper_h / 2, 0])
        cube([stopper_r * 2, stopper_h, depth - stopper_r]);
    }
}


module wheel_clutch()
{
    wheel_clutch_h = 5;
    stopper_pocket_depth = wheel_clutch_h / 3 * 2;

    difference()
    {
        // Base
        hexagon_prism(wheel_clutch_h, wheel_clutch_r);
        // Shaft hole
        cylinder(r = shaft_radius, h = wheel_clutch_h * 3, center = true, $fn = 64);
        // Stopper pockets
        translate([0, 0, wheel_clutch_h - stopper_pocket_depth + 0.1])
        rotate([0, 0, 90])
        stopper_pocket(stopper_pocket_depth);
    }
}


if(ASSEMBLY == undef || ASSEMBLY == 0)
{
  wheel_clutch();
}
