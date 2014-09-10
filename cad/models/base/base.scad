use <../MCAD/boxes.scad>
use <lead_battery.scad>
include <../main_dimensions.scad>


module base1(show_max_dimensions = true)
{
    color("BurlyWood")
    roundedBox([base_x_size, base_y_size, base_z_size], 3, true);
    echo("** Base x-size: ", base_x_size);
    echo("** Base y-size: ", base_y_size);

    if(show_max_dimensions)
    {
        // Allowed dimensions
        %cube([allowed_x_size, allowed_y_size, 2], center = true);
    }
}

module base2(show_max_dimensions = false)
{
    difference()
    {
        base1(show_max_dimensions);
        // battery pocket
        translate([0, 0, -(wheel_holder_z_dim + 2 + 2)])
        scale([1.02, 1.04, 1.0])
        lead_battery();
    }
}


if(ASSEMBLY == undef || ASSEMBLY == 0)
{
    base2();
}
