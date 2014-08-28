use <MCAD/boxes.scad>
use <belt_gear_15.scad>
include <main_dimensions.scad>

holder_x_dim = 50;
// belt_gear_l + 1 * 2 -> 1mm distance from inner wals 
// 2 * 2 = two inner walls of 2mm
holder_y_dim = belt_gear_l + 1 * 2 + radial_bearing_h * 2 + 2 * 2;
holder_z_dim = 40;


module wheel_holder2()
{
    side_hole_len = holder_x_dim - radial_bearing_r - 3 - 5;

    difference()
    {
        // Base holder body
        union()
        {
            rotate([90, 0, 0])
            cylinder(r = holder_z_dim / 2, h = holder_y_dim, center = true, $fn = 64);

            translate([0, -holder_y_dim / 2, -holder_z_dim / 2])
            cube([holder_x_dim, holder_y_dim, holder_z_dim]);

            // Top holder
            translate([holder_x_dim, 0, holder_z_dim / 2])
            rotate([0, -90, 0])
            cylinder(r = shaft_radius + 2, h = holder_x_dim * 0.7, $fn = 32);

            // Bottom holder
            translate([holder_x_dim, 0, -holder_z_dim / 2])
            rotate([0, -90, 0])
            cylinder(r = shaft_radius + 2, h = holder_x_dim * 0.7, $fn = 32);
        }

        // Holder holes

        // Top
        translate([holder_x_dim + 0.1, 0, holder_z_dim / 2])
        rotate([0, -90, 0])
        cylinder(r = shaft_radius + tolerance / 2, h = holder_x_dim * 0.7 - 1, $fn = 64);

        // Bottom
        translate([holder_x_dim + 0.1, 0, -holder_z_dim / 2])
        rotate([0, -90, 0])
        cylinder(r = shaft_radius + tolerance / 2, h = holder_x_dim * 0.7 - 1, $fn = 64);

        // Belt hole
        roundedBox([2.5 * holder_x_dim, belt_gear_l + 1 * 2, belt_gear_r1 * 2 + 1 * 2], 2, false, , $fn = 16);

        // Shaft hole
        rotate([90, 0, 0])
        cylinder(r = shaft_radius + tolerance, h = holder_y_dim * 1.5, center = true, $fn = 64);

        // Side hole
        translate([holder_x_dim - side_hole_len / 2 - 3, 0, 0])
        roundedBox([side_hole_len, holder_y_dim * 1.5, holder_z_dim - 20], 10, false, $fn = 64);

        // Bearing pockets
        translate([0, holder_y_dim / 2 + 0.1, 0])
        rotate([90, 0, 0])
        cylinder(r = radial_bearing_r, h = radial_bearing_h, $fn = 64);

        translate([0, -holder_y_dim / 2 - 0.1, 0])
        rotate([-90, 0, 0])
        cylinder(r = radial_bearing_r, h = radial_bearing_h, $fn = 64);

        // Flange
        translate([-holder_z_dim / 2, 0, 0])
        difference()
        {
            rotate([0, 90, 0])
            cylinder(r = 40, h = holder_x_dim + holder_z_dim / 2 + 10, $fn = 128);
            rotate([0, 90, 0])
            cylinder(r = 27.5, h = holder_x_dim + holder_z_dim / 2 + 10, $fn = 128);
        }
    }
}


if(ASSEMBLY == undef || ASSEMBLY == 0)
{
    //translate([0, 0, holder_x_dim])
    //rotate([0, 90, 0])
    wheel_holder2();
}
