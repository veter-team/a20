use <../MCAD/boxes.scad>
include <../main_dimensions.scad>


module oled_display()
{
    pcb_x_dim = 28;
    pcb_y_dim = 29;

    scr_x_dim = 25;
    scr_y_dim = 14;
    thickness = 4;

    difference()
    {
        // Base board
        color("Blue")
        roundedBox([pcb_x_dim, pcb_y_dim, thickness / 2], 2, true, $fn = 32);
    }

    translate([0, 0, thickness / 2])
    color("Black")
    cube([scr_x_dim, scr_y_dim, thickness / 2], center = true);
}


if(ASSEMBLY == undef || ASSEMBLY == 0)
{
    oled_display();
}

