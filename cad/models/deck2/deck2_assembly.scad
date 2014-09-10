// RPi B+ drawing:
// http://www.raspberrypi.org/wp-content/uploads/2014/07/mechanicalspecB+.png
// 4 x M2.5 mounting holes
// STL files are from here:
// http://www.thingiverse.com/thing:402498/#files

ASSEMBLY = 1;

include <../main_dimensions.scad>
use <../MCAD/boxes.scad>
use <../base/base.scad>
use <../parts/md22.scad>
use <../parts/srf08holder.scad>
use <../parts/rcreceiver.scad>

mounting_hole_x_dist = 58;
mounting_hole_y_dist = 49;
rpi_x_dim = 85;
rpi_y_dim = mounting_hole_y_dist + 2 * 3.5;
mounting_hole_r = 2.75 / 2;


module rpi()
{
    translate([54, -42.4, 0])
    import("../parts/B+_Model_v4.stl", convexity = 3);

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


module units_placement()
{
    rpi_pos = [100, 40, 2];
    rpi_rot = [0, 0, 0];
    srf08_pos = [0, -80, 3];
    srf08_rot = [90, 0, 180];
    md22_pos = [-100, 40, 3];
    md22_rot = [0, 0, 0];

    // RaspberryPi
    translate(rpi_pos)
    rotate(rpi_rot)
    color("SeaGreen")
    rpi();

    // Sonar with holder
    translate(srf08_pos)
    rotate(srf08_rot)
    srf08holder(true);

    // Motor controller
    translate(md22_pos)
    rotate(md22_rot)
    md22();
}


module deck2_assembly()
{
    rcv_pos = [-100, -100, 3];
    rcv_rot = [0, 0, 0];

    difference()
    {
        base2();
        // Cut mounting holes
        units_placement();
    }

    // Visualize units
    units_placement();

    // RC receiver
    translate(rcv_pos)
    rotate(rcv_rot)
    rcreceiver();
}


deck2_assembly();
