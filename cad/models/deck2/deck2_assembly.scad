// RPi B+ drawing:
// http://www.raspberrypi.org/wp-content/uploads/2014/07/mechanicalspecB+.png
// 4 x M2.5 mounting holes
// STL files are from here:
// http://www.thingiverse.com/thing:402498/#files

use <../MCAD/boxes.scad>
include <../main_dimensions.scad>

mounting_hole_x_dist = 58;
mounting_hole_y_dist = 49;
rpi_x_dim = 85;
rpi_y_dim = mounting_hole_y_dist + 2 * 3.5;
mounting_hole_r = 2.75 / 2;


module rpi()
{
    translate([54, -42.4, 0])
    import("B+_Model_v4.stl", convexity = 3);

    // Mounting holes
    // top-left
    translate([-rpi_x_dim + 3.5, 3.5 + mounting_hole_y_dist, 0])
    cylinder(r = mounting_hole_r, h = 20 * 2, center = true, $fn = 32);
    // bottom-left
    translate([-rpi_x_dim + 3.5, 3.5, 0])
    cylinder(r = mounting_hole_r, h = 20 * 2, center = true, $fn = 32);
    // top-right
    translate([-rpi_x_dim + 3.5 + mounting_hole_x_dist, 3.5 + mounting_hole_y_dist, 0])
    cylinder(r = mounting_hole_r, h = 20 * 2, center = true, $fn = 32);
    // bottom-left
    translate([-rpi_x_dim + 3.5 + mounting_hole_x_dist, 3.5, 0])
    cylinder(r = mounting_hole_r, h = 20 * 2, center = true, $fn = 32);
}


module base()
{
    difference()
    {
        roundedBox([base_x_size, base_y_size, base_z_size], 3, true);
        translate([0, 0, 2])
        %rpi();
    }
}


base();
