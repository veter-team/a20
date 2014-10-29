use <../../base/motor.scad>
use <../../base/motor_holder.scad>
include <../../main_dimensions.scad>


module motor_box()
{
    tube_len = 80;

    translate([0, 0, -25 - motor_shaft_shift])
    {
        difference()
        {
            union()
            {
                difference()
                {
                    motor_holder();

                    difference()
                    {
                        translate([-5, 0, motor_holder_z_dim - motor_holder_y_dim / 2])
                        rotate([0, 90, 0])
                        cylinder(r = motor_holder_y_dim / 2 + 30, h = 100, $fn = 128);

                        translate([-7, 0, motor_holder_z_dim - motor_holder_y_dim / 2])
                        rotate([0, 90, 0])
                        cylinder(r = motor_holder_y_dim / 2, h = 110, $fn = 128);
                    }
                }

                difference()
                {
                    translate([0, 0, motor_holder_z_dim -motor_holder_y_dim / 2])
                    rotate([0, 90, 0])
                    cylinder(r = motor_holder_y_dim / 2 + 3, h = tube_len, $fn = 128);

                    translate([-5, 0, motor_holder_z_dim - motor_holder_y_dim / 2])
                    rotate([0, 90, 0])
                    cylinder(r = motor_holder_y_dim / 2 - 0.1, h = tube_len + 10, $fn = 128);

                    for(a = [0 : 180 / 2 : 180])
                    {
                        translate([(tube_len - 20) / 2 + 10, 0, motor_holder_z_dim - motor_holder_y_dim / 2])
                        rotate([a, 0, 0])
                        #roundedBox([tube_len - 20, 10, 3 * motor_holder_y_dim], 4, true, $fn = 32);
                    }
                }

                translate([0, 0, motor_holder_z_dim - motor_holder_y_dim / 2])
                for(a = [0 : 360 / 4 : 360])
                {
                    rotate([a + 45, 0, 0])
                    translate([0, motor_holder_y_dim / 2 + 4, 0])
                    rotate([0, 90, 0])
                    cylinder(r = 3.5, h = tube_len, $fn = 32);
                }
            }

            translate([0, 0, motor_holder_z_dim - motor_holder_y_dim / 2])
            for(a = [0 : 360 / 4 : 360])
            {
                difference()
                {
                    rotate([a + 45, 0, 0])
                    translate([-0.1, motor_holder_y_dim / 2 + 4, 0])
                    rotate([0, 90, 0])
                    cylinder(r = 1.5 + tolerance, h = tube_len + 0.3, $fn = 32);
                }
            }
        }

        translate([1.5 * motor_holder_h, 0, 25.0])
        rotate([0, -90, 0])
        %motor();
    }
}


if(ASSEMBLY == undef || ASSEMBLY == 0)
{
    motor_box();
}
