use <cover_base.scad>
include <../main_dimensions.scad>


module cover1()
{
    cover_base(40, base_y_size / 2 + 20);
}


if(ASSEMBLY == undef || ASSEMBLY == 0)
{
    translate([0, -20 + (base_y_size / 2 + 20) / 2, 40 + 5])
    rotate([0, 180, 0])
    cover1();
}
