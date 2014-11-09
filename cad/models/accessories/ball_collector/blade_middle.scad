use <ball_collector_blade.scad>
include <../../main_dimensions.scad>

rotate([0, -90, 0])
translate([blade_w / 6, 0, 0])
intersection()
{
    ball_collector_blade();

    cube([blade_w / 3, 400, 400], center = true);
}
