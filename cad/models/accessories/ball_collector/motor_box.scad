use <../../MCAD/boxes.scad>
use <../../base/motor.scad>
use <../../base/motor_holder.scad>
include <../../main_dimensions.scad>


tube_len = 80;


module mounting_foot(for_mounting_holes)
{
    middle_x = 30;
    foot_h = 3;

    translate([4, 0, 0])
    {
        difference()
        {
            hull()
            {
                // middle
                translate([middle_x, 0, 0])
                cylinder(r = 4, h = foot_h, $fn = 32);
                // close
                translate([0, -(motor_holder_y_dim + 0) / 2, 0])
                cylinder(r = 4, h = foot_h, $fn = 32);
                // far
                translate([0, (motor_holder_y_dim + 0) / 2, 0])
                cylinder(r = 4, h = foot_h, $fn = 32);
            }

            translate([0, 0, -1])
            {
                // close
                translate([0, -(motor_holder_y_dim + 0) / 2, 0])
                cylinder(r = mount_hole_radius, h = foot_h + 2, $fn = 32);
                // far
                translate([0, (motor_holder_y_dim + 0) / 2, 0])
                cylinder(r = mount_hole_radius, h = foot_h + 2, $fn = 32);
            }
        }
        if(for_mounting_holes == true)
        {
            // close
            translate([0, -(motor_holder_y_dim + 0) / 2, 0])
            cylinder(r = mount_hole_radius, h = foot_h + 50, center = true, $fn = 32);
            // far
            translate([0, (motor_holder_y_dim + 0) / 2, 0])
            cylinder(r = mount_hole_radius, h = foot_h + 50, center = true, $fn = 32);
        }
    }
}


module motor_box_base(for_mounting_holes)
{
    translate([0, 0, -25 - motor_shaft_shift])
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
            union()
            {
                translate([0, 0, motor_holder_z_dim -motor_holder_y_dim / 2])
                rotate([0, 90, 0])
                cylinder(r = motor_holder_y_dim / 2 + 3, h = tube_len, $fn = 128);

                translate([0, -motor_holder_y_dim / 2 - 3, 25])
                rotate([-90, 0, 0])
                {
                    mounting_foot(for_mounting_holes);
                
                    translate([tube_len, 0, 0])
                    rotate([0, 0, 180])
                    mounting_foot(for_mounting_holes);
                }
            }

            translate([-5, 0, motor_holder_z_dim - motor_holder_y_dim / 2])
            rotate([0, 90, 0])
            cylinder(r = motor_holder_y_dim / 2 - 0.1, h = tube_len + 10, $fn = 128);

            translate([(tube_len - 20) / 2 + 10, 0, motor_holder_z_dim - motor_holder_y_dim / 2])
            rotate([0, 0, 0])
            roundedBox([tube_len - 20, 10, 2 * motor_holder_y_dim], 4, true, $fn = 32);

            translate([(tube_len - 20) / 2 + 10, motor_holder_y_dim, motor_holder_z_dim - motor_holder_y_dim / 2])
            rotate([90, 0, 0])
            roundedBox([tube_len - 20, 10, 2 * motor_holder_y_dim], 4, true, $fn = 32);
            
        }
/*
        translate([1.5 * motor_holder_h, 0, 25.0])
        rotate([0, -90, 0])
        motor();
*/        
    }
}


module motor_box(for_mounting_holes, angle)
{
    if(for_mounting_holes == true)
    {
        difference()
        {
            motor_box_base(true, angle);
            cube([tube_len * 3, motor_holder_y_dim + 2 * 3 + 0.05, 100], center = true);
        }
    }
    else
    {
        motor_box_base(false, angle);
    }
}

if(ASSEMBLY == undef || ASSEMBLY == 0)
{
    rotate([0, -90, 0])
    motor_box(false);
}
