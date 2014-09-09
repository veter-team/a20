use <../MCAD/boxes.scad>
use <motor_holder.scad>
include <../main_dimensions.scad>


module wheel_holder_shaft_hole()
{
    translate([base_x_size / 2 - wheel_holder_y_dim / 2, 0, wheel_holder_z_dim / 2])
    rotate([90, 0, 0])
    color("Silver")
    cylinder(r = holder_shaft_r, h = front_pannel_h + 2, center = true, $fn = 32);
}


module mounting_pad()
{
    mounting_pad_y_size = 16;
    mounting_pad_z_size = 7;
    
    translate([60,
            -mounting_pad_y_size / 2 + front_pannel_h / 2,
            (wheel_holder_z_dim + (shaft_radius + 2) + 8)/2 - mounting_pad_z_size / 2])
    difference()
    {
        roundedBox([15, mounting_pad_y_size, mounting_pad_z_size],
            1, false, $fn = 16);
        translate([0,
                -mounting_pad_y_size / 2 + front_pannel_h / 2 + 3,
                -(mounting_pad_z_size + 0.1) / 2])
        mounting_hole(mounting_pad_z_size + 0.2, false, $fn = 32);
    }
}
    

module front_pannel()
{

    difference()
    {
        union()
        {
            // Base
            roundedBox([base_x_size,
                    front_pannel_h,
                    wheel_holder_z_dim + (shaft_radius + 2) + 8],
                1, false, $fn = 16);

            // Mounting pads
            mounting_pad();
            mirror([1, 0, 0])
            mounting_pad();
            mirror([0, 0, 1])
            {
                mounting_pad();
                mirror([1, 0, 0])
                mounting_pad();
            }
        }

        // Holes for wheel holder shafts
        wheel_holder_shaft_hole();
        mirror([1, 0, 0])
        wheel_holder_shaft_hole();
        mirror([0, 0, 1])
        {
            wheel_holder_shaft_hole();
            mirror([1, 0, 0])
            wheel_holder_shaft_hole();
        }
    }
}


if(ASSEMBLY == undef || ASSEMBLY == 0)
{
    //%cube([200, 1, 200], center = true);
    //rotate([0, 45, 0])
    rotate([-90, 0, 0])
    {
        translate([0, distance_betwee_wheels + shaft_shift, 0])
        {
            difference()
            {
                front_pannel();
                
                // Holes for motor holder
                translate([-(base_x_size / 2 - wheel_holder_y_dim - shaft_coupling_l - 10),
                        0,
                        -motor_holder_y_dim / 2,
                        ])
                rotate([90, 0, 0])
                motor_holder_mounting_holes(front_pannel_h * 2);
            }
        }
    }
}
