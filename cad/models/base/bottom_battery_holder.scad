use <../MCAD/boxes.scad>
use <lead_battery.scad>
include <../main_dimensions.scad>


module ring(inner_r, outer_r, height)
{
    difference()
    {
        cylinder(r = outer_r, h = height, center = true);
        cylinder(r = inner_r, h = height + 0.1, center = true);
    }
}


module bottom_battery_holder()
{
    ring_inner_r = 7;
    
    difference()
    {
        // Base
        translate([0, 0, base_bottom_battery_holder_dim[2] / 2])
        roundedBox(base_bottom_battery_holder_dim, 1, false, $fn = 32);

        // Right belt pocket
        translate([base_bottom_battery_holder_dim[0] / 4, 0, ring_inner_r + 3])
        rotate([0, 90, 0])
        #ring(ring_inner_r, ring_inner_r + 10, akku_belt_hole_w, $fn = 128);

        // Left belt pocket
        translate([-base_bottom_battery_holder_dim[0] / 4, 0, ring_inner_r + 3])
        rotate([0, 90, 0])
        ring(ring_inner_r, ring_inner_r + 10, akku_belt_hole_w, $fn = 128);

        // Right mounting hole
        translate([base_bottom_battery_holder_dim[0] / 2 - 5, 0, -0.1])
        cylinder(r = 0.7, h = base_bottom_battery_holder_dim[2] - 3, $fn = 32);

        // Middle mounting hole
        translate([0, 0, -0.1])
        cylinder(r = 0.7, h = base_bottom_battery_holder_dim[2] - 3, $fn = 32);
        
        // Left mounting hole
        translate([-base_bottom_battery_holder_dim[0] / 2 + 5, 0, -0.1])
        cylinder(r = 0.7, h = base_bottom_battery_holder_dim[2] - 3, $fn = 32);
    }   
}


if(ASSEMBLY == undef || ASSEMBLY == 0)
{
    translate([0, 0, base_bottom_battery_holder_dim[2]])
    rotate([180, 0, 0])
    bottom_battery_holder();
}
