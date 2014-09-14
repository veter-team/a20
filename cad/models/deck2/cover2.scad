use <cover_base.scad>
include <../main_dimensions.scad>


module cover2()
{
    difference()
    {
        mirror([0, 1, 0])
        cover_base(cover2_h, base_y_size / 2 - 20);

        // Hole for RC antenna
        translate([-95, 70, cover2_h])
        cylinder(r = 2, h = 20, center = true);
    }
}


if(ASSEMBLY == undef || ASSEMBLY == 0)
{
    translate([0, -20 - (base_y_size / 2 - 20) / 2, cover2_h + 5])
    rotate([0, 180, 0])
    cover2();
}
