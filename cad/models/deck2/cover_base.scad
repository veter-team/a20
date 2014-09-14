use <../MCAD/regular_shapes.scad>
include <../main_dimensions.scad>


module cover_base(cover_base_h, length)
{
    difference()
    {
        union()
        {
            difference()
            {
                square_pyramid(base_x_size, base_y_size, 400);

                translate([0, 0, -0.05])
                square_pyramid(base_x_size - 8, base_y_size - 8, 400 - 5);
            }

            intersection()
            {
                square_pyramid(base_x_size, base_y_size, 400);
        
                translate([0, 0, 5 / 2 + cover_base_h])
                cube([base_x_size, base_y_size, 5], center = true);
            }
        }
        
        translate([0, 0, 400 / 2 + cover_base_h + 5])
        cube([base_x_size, base_y_size, 400], center = true);

        translate([-base_x_size / 2 - 0.05, -base_y_size / 2 + length, -0.05])
        cube([base_x_size + 0.1, base_y_size, 400]);
    }
}
