use <../MCAD/boxes.scad>
include <../main_dimensions.scad>


// Raspberry Pi camera revision 1.3
module rpicamera()
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
    color("Black")
    cylinder(r = 3.5, h = 2, $fn = 32);

    // Cable
    translate([0, -y_dim/2 - 3, 0])
    color("LightGray")
    cube([16, 6, 0.2], center = true);
}


if(ASSEMBLY == undef || ASSEMBLY == 0)
{
    rpicamera();
}
