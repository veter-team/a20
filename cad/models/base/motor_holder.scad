// MMT-03 motor holder
// http://www.lynxmotion.com/images/data/mmt-03.pdf

include <../main_dimensions.scad>

$fn = 64;


module motor_holder_mounting_holes(depth = 50)
{
    translate([24, motor_holder_y_dim / 2, 0])
    {
        cylinder(r = 3.9751, h = depth, center = true);

        for(i = [0 : 360 / 4 : 360])
        {
            rotate([0, 0, i])
            translate([0, 8.3312, 0])
            cylinder(r = 1.1938, h = depth, center = true);
        }
    }
}


module motor_holder()
{
    color("Black")
    translate([0, -motor_holder_y_dim / 2, 0])
    difference()
    {
        union()
        {
            cube([motor_holder_x_dim - motor_holder_y_dim / 2, motor_holder_y_dim, motor_holder_z_dim - motor_holder_y_dim / 2]);
            translate([motor_holder_x_dim - motor_holder_y_dim / 2, motor_holder_y_dim / 2, 0])
            cylinder(r = motor_holder_y_dim / 2, h = motor_holder_z_dim - motor_holder_y_dim / 2);

            translate([0, motor_holder_y_dim / 2, motor_holder_z_dim - motor_holder_y_dim / 2])
            rotate([0, 90, 0])
            cylinder(r = motor_holder_y_dim / 2, h = motor_holder_x_dim - motor_holder_x_dim / 2);
        }
        translate([motor_holder_h, -tolerance, motor_holder_h])
        cube([motor_holder_x_dim, motor_holder_y_dim + 2 * tolerance, motor_holder_z_dim]);

        // Shaft hole
        translate([motor_holder_h / 2, motor_holder_y_dim / 2, 25.0])
        union()
        {
            translate([-motor_holder_h, 0, -14.3 / 2])
            rotate([0, 90, 0])
            cylinder(r = 13 / 2, h = 2 * motor_holder_h);

            cube([2 * motor_holder_h, 13, 14.3], center = true);

            translate([-motor_holder_h, 0, 14.3 / 2])
            rotate([0, 90, 0])
            cylinder(r = 13 / 2, h = 2 * motor_holder_h);
        }

        // Motor mounting holes
        translate([motor_holder_h / 2, motor_holder_y_dim / 2, 25.0])
        for(i = [0 : 360 / 6 : 360])
        {
            rotate([i, 0, 0])
            translate([0, 31 / 2, 0])
            rotate([0, 90, 0])
            cylinder(r = 3.3 / 2, h = 50, center = true);
        }

        motor_holder_mounting_holes(3 * motor_holder_h);
    }
}

if(ASSEMBLY == undef || ASSEMBLY == 0)
{
  motor_holder();
}
