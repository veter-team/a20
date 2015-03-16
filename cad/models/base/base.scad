use <../MCAD/boxes.scad>
use <lead_battery.scad>
use <front_pannel.scad>
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

        // holes for wires
        translate([base_x_size / 2 - 20, 0, 0])
        cube([4, 17, 10], center = true);
        
        translate([-(base_x_size / 2 - 20), 0, 0])
        cube([4, 17, 10], center = true);

        // Akku holder belt pockets
        translate([base_bottom_battery_holder_dim[0] / 4, akku_y_dim / 2, 0])
        cube([akku_belt_hole_w, 10, 10], center = true);

        translate([-base_bottom_battery_holder_dim[0] / 4, akku_y_dim / 2, 0])
        cube([akku_belt_hole_w, 10, 10], center = true);

        translate([base_bottom_battery_holder_dim[0] / 4, -akku_y_dim / 2, 0])
        cube([akku_belt_hole_w, 10, 10], center = true);

        translate([-base_bottom_battery_holder_dim[0] / 4, -akku_y_dim / 2, 0])
        cube([akku_belt_hole_w, 10, 10], center = true);
    }
}


if(ASSEMBLY == undef || ASSEMBLY == 0)
{
    // Uncomment for 2D projection.
    // Useful for DXF export.
    //projection(cut = false)
    difference()
    {
        base2();
        translate([0,
                base_y_size / 2 - front_pannel_h / 2,
                -front_pannel_z_dim / 2 - base_z_size / 2])
        front_pannel(true);

        mirror([0, 1, 0])
        {
            translate([0,
                    base_y_size / 2 - front_pannel_h / 2,
                    -front_pannel_z_dim / 2 - base_z_size / 2])
            front_pannel(true);
        }
    }
}
