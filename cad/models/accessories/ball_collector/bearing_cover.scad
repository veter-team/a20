use <ball_collector_blade.scad>


if(ASSEMBLY == undef || ASSEMBLY == 0)
{
    rotate([0, 90, 0])
    bearing_cover();
}
