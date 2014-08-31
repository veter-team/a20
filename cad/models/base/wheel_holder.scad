use <MCAD/boxes.scad>
include <main_dimensions.scad>


module wheel_holder()
{
    side_hole_len = wheel_holder_x_dim - radial_bearing_r - 3 - 5;

    difference()
    {
        // Base holder body
        union()
        {
            rotate([90, 0, 0])
            cylinder(r = wheel_holder_z_dim / 2, h = wheel_holder_y_dim, center = true, $fn = 128);

            translate([0, -wheel_holder_y_dim / 2, -wheel_holder_z_dim / 2])
            cube([wheel_holder_x_dim, wheel_holder_y_dim, wheel_holder_z_dim]);

            // Top holder
            translate([wheel_holder_x_dim, 0, wheel_holder_z_dim / 2])
            rotate([0, -90, 0])
            cylinder(r = holder_shaft_r + 2, h = wheel_holder_x_dim, $fn = 64);

            // Bottom holder
            translate([wheel_holder_x_dim, 0, -wheel_holder_z_dim / 2])
            rotate([0, -90, 0])
            cylinder(r = holder_shaft_r + 2, h = wheel_holder_x_dim, $fn = 64);
        }

        // Cut out upper and bottom part around belt gear
        translate([-wheel_holder_z_dim / 2, 0, 0])
        cube([wheel_holder_z_dim + 0.1,
                belt_gear_l + 1 * 2,
                wheel_holder_z_dim + 0.1], center = true);
        
        // Holder holes

        // Top
        translate([wheel_holder_x_dim + 0.1, 0, wheel_holder_z_dim / 2])
        rotate([0, -90, 0])
        cylinder(r = holder_shaft_r + tolerance / 2, h = wheel_holder_x_dim + 20, $fn = 64);

        // Bottom
        translate([wheel_holder_x_dim + 0.1, 0, -wheel_holder_z_dim / 2])
        rotate([0, -90, 0])
        cylinder(r = holder_shaft_r + tolerance / 2, h = wheel_holder_x_dim + 20, $fn = 64);

        // Belt hole
        roundedBox([2.5 * wheel_holder_x_dim,
                belt_gear_l + 1 * 2,
                belt_gear_r1 * 2 + 1 * 2],
            2, false, , $fn = 16);
        
        // Shaft hole
        rotate([90, 0, 0])
        cylinder(r = shaft_radius + tolerance, h = wheel_holder_y_dim * 1.5, center = true, $fn = 64);

        // Side hole
        translate([wheel_holder_x_dim - side_hole_len / 2 - 3, 0, 0])
        roundedBox([side_hole_len, wheel_holder_y_dim * 1.5, wheel_holder_z_dim - 20], 10, false, $fn = 64);

        // Bearing pockets
        translate([0, wheel_holder_y_dim / 2 + 0.1, 0])
        rotate([90, 0, 0])
        cylinder(r = radial_bearing_r, h = radial_bearing_h, $fn = 128);

        translate([0, -wheel_holder_y_dim / 2 - 0.1, 0])
        rotate([-90, 0, 0])
        cylinder(r = radial_bearing_r, h = radial_bearing_h, $fn = 128);

        // Flange
        translate([-wheel_holder_z_dim / 2, 0, 0])
        difference()
        {
            rotate([0, 90, 0])
            cylinder(r = 40, h = wheel_holder_x_dim + wheel_holder_z_dim / 2 + 10, $fn = 128);
            rotate([0, 90, 0])
            cylinder(r = 26.5, h = wheel_holder_x_dim + wheel_holder_z_dim / 2 + 10, $fn = 128);
        }
    }
}


if(ASSEMBLY == undef || ASSEMBLY == 0)
{
    translate([0, 0, wheel_holder_x_dim])
    rotate([0, 90, 0])
    wheel_holder();
}
