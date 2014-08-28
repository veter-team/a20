use <MCAD/metric_fastners.scad>


tolerance = 0.4;

// Maximal robot footprint is DIN A3 - 210 * 2 x 297 = 420 x 297
// http://piwars.org/?page_id=16
// So let us make the robot large enough but not on the limit
base_z_size = 3;

base_x_size = 420 - 10;
//base_x_size = 297 - 17;
base_y_size = 297 - 10;

shaft_radius = 6 / 2 + tolerance / 2;

//wheel_radius = 128 / 2;
//wheel_width = 58;
//wheel_radius = 100 / 2;
//wheel_width = 42;
wheel_radius = 125 / 2;
wheel_width = 65;

hub_outer_radius = 25.4 / 2 + tolerance / 2;
hub_inner_radius = 12 / 2 + tolerance / 2;
hub_height1 = 5;
hub_height2 = 4.5;

motor_holder_h = 3;

motor_shaft_shift = 7;

radial_bearing_r = 19 / 2 + tolerance / 2;
radial_bearing_h = 6 + tolerance * 2;

wheel_holder_mount_h = 4;
wheel_holder_wall = 3;
wheel_holder_z_size = radial_bearing_h + 2 * wheel_holder_wall;

//shaft_shift = 20.3 + motor_shaft_shift;
shaft_shift = 25 + motor_shaft_shift;

shaft_coupling_l = 16;

belt_gear_15_r1 = 14;
belt_gear_15_r2 = 24 / 2;
belt_gear_15_l1 = 14;
belt_gear_15_l = 20;

belt_gear_10_r1 = 23 / 2;
belt_gear_10_r2 = 16 / 2;
belt_gear_10_l1 = 14;
belt_gear_10_l = 20;

// To simplify switching between two gear types
//belt_gear_r1 = belt_gear_10_r1;
//belt_gear_r2 = belt_gear_10_r2;
//belt_gear_l1 = belt_gear_10_l1;
//belt_gear_l = belt_gear_10_l;

belt_gear_r1 = belt_gear_15_r1;
belt_gear_r2 = belt_gear_15_r2;
belt_gear_l1 = belt_gear_15_l1;
belt_gear_l = belt_gear_15_l;


mount_hole_radius = 3 / 2 + tolerance / 2;


module mounting_hole(thickness, use_bolt)
{
    d = 3 + tolerance;
    l = thickness;
    
    if(use_bolt)
    {
        csk_bolt(d, l + 0.6 * d);
    }
    else
    {
        cylinder(h = l, r = d / 2);
    }
    rotate([180, 0, 0]) cylinder(h = l, r = 1.0 * d);
    translate([0, 0, thickness]) cylinder(h = l, r = 1.0 * d);
}
