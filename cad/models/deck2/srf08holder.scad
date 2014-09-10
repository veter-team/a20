// Dimensions in mm according to the following drawing:
// http://193.40.245.66/mhx/wwwroot/mhk/materjalid/mhk5300/juhendid/R145-SRF08.html

use <../MCAD/boxes.scad>
include <../main_dimensions.scad>


mount_hole_x_dist = 38.1;
mount_hole_y_dist = 14.478;
mount_hole_r = 3.302 / 2;

board_x_dim = 43.18;
board_y_dim = mount_hole_y_dist + 5.08;
board_z_dim = 1.524;

reflector_r = 16.256 / 2;
reflector_h = 14.224 - board_z_dim;

light_sensor_r = 4.572 / 2;

electronic_height = 2;


module srf08()
{
    // Base board
    cube([board_x_dim, board_y_dim, board_z_dim], center = true);

    // Reflectors
    translate([-12, 0, 0])
    cylinder(r = reflector_r, h = reflector_h, $fn = 128);
    translate([11, 0, 0])
    cylinder(r = reflector_r, h = reflector_h, $fn = 128);

    // Mounting holes
    translate([mount_hole_x_dist / 2, mount_hole_y_dist / 2, 0])
    cylinder(r = mount_hole_r, h = reflector_h * 2, center = true, $fn = 32);
    translate([-mount_hole_x_dist / 2, -mount_hole_y_dist / 2, 0])
    cylinder(r = mount_hole_r, h = reflector_h * 2, center = true, $fn = 32);

    // Light sensor
    translate([0, board_y_dim / 2 - 5.08 / 2 + mount_hole_r - light_sensor_r, 0])
    cylinder(r = light_sensor_r, h = reflector_h, $fn = 32);
    
}


module holder_base()
{
    rotate([0, 0, 90])
    {
        difference()
        {
            roundedBox([(board_y_dim / 2 + 15 + 3) * 2, board_x_dim + 3, 3], 5, true, $fn = 32);
            translate([-50, 0, 0])
            cube([100, 100, 5], center = true);
        }
        translate([0, -(board_x_dim + 3) / 2, 0])
        cube([3, board_x_dim + 3, 10]);
    }
}


module srf08holder(show_sonar = false)
{
    color("Snow")
    difference()
    {
        holder_base();
        
        translate([0, 15, board_z_dim / 2 + 3 / 2 + electronic_height])
        rotate([180, 0, 0])
        rotate([0, 0, 180])
        srf08();

        // Holder mounting holes
        translate([-10, 3.1, (10 - 3 / 2) / 2 + 3 / 2])
        rotate([90, 0, 0])
        mounting_hole(4, false, $fn = 32);

        translate([10, 3.1, (10 - 3 / 2) / 2 + 3 / 2])
        rotate([90, 0, 0])
        mounting_hole(4, false, $fn = 32);
        
    }
    
    if(show_sonar)
    {
        translate([0, 15, board_z_dim / 2 + 3 / 2 + electronic_height])
        rotate([180, 0, 0])
        rotate([0, 0, 180])
        color("Gainsboro")
        srf08();
    }
}


if(ASSEMBLY == undef || ASSEMBLY == 0)
{
    srf08holder();
    //srf08();
    //holder_base();
}
