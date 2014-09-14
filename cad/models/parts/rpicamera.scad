use <../MCAD/boxes.scad>
use <../MCAD/regular_shapes.scad>
include <../main_dimensions.scad>

/*
Technical Parameters

    Sensor type: OmniVision OV5647[4] Color CMOS QSXGA (5-megapixel)
    Sensor size: 3.67 x 2.74 mm
    Pixel Count: 2592 x 1944
    Pixel Size: 1.4 x 1.4 um
    Lens: f=3.6 mm, f/2.9
    Angle of View: 54 x 41 degrees
    Field of View: 2.0 x 1.33 m at 2 m
    Full-frame SLR lens equivalent: 35 mm
    Fixed Focus: 1 m to infinity
*/

// Field of view
module fov(distance)
{
    rotate([180, 0, 0])
    translate([0, 0, -distance + 2])
    scale([distance, distance, distance])
    square_pyramid(sin(54 / 2) * 2, sin(41 / 2) * 2, 1);
}
    

// Raspberry Pi camera revision 1.3
module rpicamera(fov_distance = 100)
{
    x_dim = 25;
    y_dim = 24;

    difference()
    {
        // Base board
        color("DarkGreen")
        cube([x_dim, y_dim, 1], center = true);

        // Mounting holes
        // top-left
        translate([-21 / 2, y_dim / 2 - 2, 0])
        cylinder(r = 1, h = 3, $fn = 32);
        // top-right
        translate([21 / 2, y_dim / 2 - 2, 0])
        cylinder(r = 1, h = 3, $fn = 32);
        // bottom-left
        translate([-21 / 2, y_dim / 2 - 2 - 12.5, 0])
        cylinder(r = 1, h = 3, $fn = 32);
        // bottom-right
        translate([21 / 2, y_dim / 2 - 2 - 12.5, 0])
        cylinder(r = 1, h = 3, $fn = 32);
    }

    translate([-x_dim/2 + 8.5 + 8 / 2, -y_dim/2 + 5.5 + 8 / 2, 1.5])
    color("DarkGray")
    roundedBox([8, 8, 2], 0.5, true, $fn = 32);

    // Lens
    translate([-x_dim/2 + 8.5 + 8 / 2, -y_dim/2 + 5.5 + 8 / 2, 2 + 0.5])
    {
        color("Black")
        cylinder(r = 3.5, h = 2, $fn = 32);
        %fov(fov_distance);
    }

    // Cable
    translate([0, -y_dim/2 - 3, 0])
    color("LightGray")
    cube([16, 6, 0.2], center = true);
}


if(ASSEMBLY == undef || ASSEMBLY == 0)
{
    rpicamera(100);
}
