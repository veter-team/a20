include <../main_dimensions.scad>

md22_dim = [110, 51, 1.5];


module md22_base()
{
    // Base board
    color("DarkGreen")
    cube(md22_dim);

    // Capacitor
    translate([20 + 10, 5, md22_dim[2] + 10 + 2])
    rotate([-90, 0, 0])
    color("Gray")
    cylinder(r = 10, h = md22_dim[1] - 2 * 5, $fn = 64);
    // Mounting wires (near)
    color("Gainsboro")
    translate([20 + 10, 4, md22_dim[2]])
    cylinder(r = 1, h = 10 + 2, $fn = 32);
    // Mounting wires (far)
    color("Gainsboro")
    translate([20 + 10, md22_dim[1] - 4, md22_dim[2]])
    cylinder(r = 1, h = 10 + 2, $fn = 32);

    // Output terminal
    translate([5, 10, md22_dim[2]])
    color("SpringGreen")
    cube([10, md22_dim[1] - 2 * 10, 10]);

    // Input terminal
    translate([md22_dim[0] - 5 - 10, 15, md22_dim[2]])
    color("SpringGreen")
    cube([10, md22_dim[1] - 2 * 15, 10]);

    // Heat sinks
    for(x = [42, 47])
    {
        for(y = [2 : (md22_dim[1] - 2 * 2) / 4 : md22_dim[1] - 2 * 2])
        {
            translate([x, y, md22_dim[2] + 1])
            color("DimGray")
            cube([2, (md22_dim[1] - 2 * 2) / 4 - 1, 15]);
        }
    }

    // Mode switches
    // box
    translate([md22_dim[0] - 17 - 12, 1, md22_dim[2]])
    color("DodgerBlue")
    cube([11, 10, 8]);
    // switches
    for(x = [md22_dim[0] - 17 - 12 + 1 : 2.5 : md22_dim[0] - 17 - 12 + 1 + 3 * 2.5])
    {
        translate([x, -1, md22_dim[2] + 6])
        color("Snow")
        cube([1.5, 3, 1]);
    }
}

module md22_mounting_holes()
{
    m_h_r = 1.7;

    // Mounting holes
    for(x = [m_h_r + 2, md22_dim[0] - m_h_r - 2])
    {
        for(y = [m_h_r + 2, md22_dim[1] - m_h_r - 2])
        {
            translate([x, y, -20])
            cylinder(r = m_h_r, h = 40, $fn = 32);
        }
    }
}


module md22()
{
    difference()
    {
        md22_base();
        md22_mounting_holes();
    }

    color("DarkGreen")
    md22_mounting_holes();
}


if(ASSEMBLY == undef || ASSEMBLY == 0)
{
    md22();
}
