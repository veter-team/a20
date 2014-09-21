// RPi B+ drawing:
// http://www.raspberrypi.org/wp-content/uploads/2014/07/mechanicalspecB+.png
// 4 x M2.5 mounting holes

use <../MCAD/boxes.scad>
include <../main_dimensions.scad>
use <../base/lead_battery.scad>


base_h = cover2_h;


module rpi_holder()
{
    mounting_hole_x_dist = 58;
    mounting_hole_y_dist = 49;
    rpi_x_dim = 85;
    rpi_y_dim = mounting_hole_y_dist + 2 * 3.5;
    mounting_hole_r = 3 / 2 + tolerance;
    wall_th = mounting_hole_r + 1.5;
    column_h = base_h + 0;

    difference()
    {
        translate([-rpi_x_dim + 3.5 - mounting_hole_r + (mounting_hole_x_dist + 2 * mounting_hole_r ) / 2,
                3.5 + mounting_hole_y_dist + mounting_hole_r - (mounting_hole_y_dist + 2 * mounting_hole_r ) / 2,
                base_h / 2])
        roundedBox([mounting_hole_x_dist + 2 * wall_th,
                mounting_hole_y_dist + 2 * wall_th,
                base_h],
            mounting_hole_r, true, $fn = 32);

        translate([-rpi_x_dim + 3.5 - mounting_hole_r + (mounting_hole_x_dist + 2 * mounting_hole_r ) / 2,
                3.5 + mounting_hole_y_dist + mounting_hole_r - (mounting_hole_y_dist + 2 * mounting_hole_r ) / 2,
                base_h / 2 - 0.1])
        roundedBox([mounting_hole_x_dist - wall_th,
                mounting_hole_y_dist - wall_th,
                base_h + 0.3],
            mounting_hole_r, true, $fn = 32);

        // Mounting holes
        // top-left
        translate([-rpi_x_dim + 3.5, 3.5 + mounting_hole_y_dist, -0.1])
        cylinder(r = mounting_hole_r, h = column_h + 0.2, $fn = 32);
        // bottom-left
        translate([-rpi_x_dim + 3.5, 3.5, -0.1])
        cylinder(r = mounting_hole_r, h = column_h + 0.2, $fn = 32);
        // top-right
        translate([-rpi_x_dim + 3.5 + mounting_hole_x_dist, 3.5 + mounting_hole_y_dist, -0.1])
        cylinder(r = mounting_hole_r, h = column_h + 0.2, $fn = 32);
        // bottom-left
        translate([-rpi_x_dim + 3.5 + mounting_hole_x_dist, 3.5, -0.1])
        cylinder(r = mounting_hole_r, h = column_h + 0.2, $fn = 32);

        // Bottom holes for screws
        translate([-rpi_x_dim + 3.5 + mounting_hole_x_dist / 2 + 12,
                3.5 + mounting_hole_y_dist + 0.7,
                -0.1])
        cylinder(r = 1, h = column_h + 0.2, $fn = 16);
        // bottom-left
        translate([-rpi_x_dim + 3.5 + mounting_hole_x_dist / 2 + 12,
                3.5 - 0.7,
                -0.1])
        cylinder(r = 1, h = column_h + 0.2, $fn = 16);
        /*
        // top-right
        translate([-rpi_x_dim + 3.5 + mounting_hole_x_dist + 0.6, 3.5 + mounting_hole_y_dist / 2, -0.1])
        cylinder(r = 1, h = 15, $fn = 16);
        // bottom-left
        translate([-rpi_x_dim + 3.5 - 0.6, 3.5 + mounting_hole_y_dist / 2, -0.1])
        cylinder(r = 1, h = 15, $fn = 16);
        */

        // Battery
        translate([0, 0,
                -wheel_holder_z_dim / 2 - shaft_radius - 2 + base_z_size / 2
                - (wheel_holder_z_dim / 2 + shaft_radius + 2 + base_z_size / 2 + 1)])
        rotate([0, 0, 90])
        scale([1.0, 1.04, 1.08])
        lead_battery();

        translate([-60, 0, 0])
        roundedBox([30, 3 * rpi_y_dim, base_h * 2 - 15], 5, false, $fn = 64);

        translate([0, rpi_y_dim / 2, 0])
        roundedBox([3 * rpi_x_dim, 40, base_h * 2 - 15], 5, false, $fn = 64);
    }
}


if(ASSEMBLY == undef || ASSEMBLY == 0)
{
    translate([0, 0, base_h])
    rotate([180, 0, 0])
    rpi_holder();
}
