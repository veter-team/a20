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
use <../parts/rpicamera.scad>
use <../parts/picoups.scad>
use <../base/lead_battery.scad>
use <cover1.scad>
use <cover2.scad>
use <rpi_holder.scad>


mounting_hole_x_dist = 58;
mounting_hole_y_dist = 49;
rpi_x_dim = 85;
rpi_y_dim = mounting_hole_y_dist + 2 * 3.5;
mounting_hole_r = 2.75 / 2;


module rpi(parts_dir)
{
    translate([54, -42.4, 0])
    import(str(parts_dir, "/B+_Model_v4.stl"), convexity = 3);

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


module units_placement(parts_dir)
{
    rpi_pos = [rpi_y_dim - 8, 0, cover2_h + 5];
    rpi_rot = [0, 0, 90];
    rpi_holder_pos = [rpi_pos[0], rpi_pos[1], 0];
    rpi_holder_rot = rpi_rot;
    srf08_pos = [-50, 0, cover1_h + 5];
    srf08_rot = [90, 0, 180];
    md22_pos = [90, 90, 3];
    md22_rot = [0, 0, 180];
    picoups_pos = [-90, -90, 4];
    picoups_rot = [0, 0, 0];

    // RaspberryPi
    translate(rpi_pos)
    rotate(rpi_rot)
    color("SeaGreen")
    rpi(parts_dir);

    // RaspberryPi holder
    translate(rpi_holder_pos)
    rotate(rpi_holder_rot)
    color("Snow")
    rpi_holder();
    
    // Sonar with holder
    translate(srf08_pos)
    rotate(srf08_rot)
    srf08holder(true);

    // Motor controller
    translate(md22_pos)
    rotate(md22_rot)
    md22();

    // PicoUPS module
    translate(picoups_pos)
    rotate(picoups_rot)
    picoups();
}
    

module deck2_assembly(parts_dir)
{
    rcv_pos = [-90, 50, 3];
    rcv_rot = [0, 0, 0];
    cam_pos = [0, -100, 30];
    cam_rot = [90 + 19, 0, 0];
    
    difference()
    {
        base2();
        // Cut mounting holes
        units_placement(parts_dir);
    }

    // Visualize units
    units_placement(parts_dir);

    // RC receiver
    translate(rcv_pos)
    rotate(rcv_rot)
    rcreceiver();

    // RPi camera
    translate(cam_pos)
    rotate(cam_rot)
    rpicamera(200);
/*
    color("Gray")
    {
        %cover1();
        %cover2();
    }
*/

    // Battery
    translate([0, 0,
            -wheel_holder_z_dim / 2 - shaft_radius - 2 + base_z_size / 2
            - (wheel_holder_z_dim / 2 + shaft_radius + 2 + base_z_size / 2 + 1)])
    lead_battery();
}


deck2_assembly("../parts");

