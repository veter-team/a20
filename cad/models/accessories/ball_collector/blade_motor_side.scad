use <ball_collector_blade.scad>
include <../../main_dimensions.scad>

rotate([0, -90, 0])
translate([blade_w / 2, 0, 0])
difference()
{
    ball_collector_blade();

    translate([-blade_w / 4, -200, -200])
    cube([blade_w, 400, 400]);
}
