use <MCAD/boxes.scad>
include <main_dimensions.scad>


module wheel_holder_mounting_pad(mount_w, mount_h)
{
  difference()
  {
    translate([0, 0, wheel_holder_z_size / 2])
    roundedBox([mount_h, mount_w, wheel_holder_z_size], 1, true, $fn = 32);

    // mounting holes

    translate([-mount_h / 2 - 0.1, mount_w / 2 - 5, wheel_holder_z_size / 2])
    rotate([0, 90, 0])
    mounting_hole(mount_h + 0.2, false, $fn = 32);

    mirror([0, 1, 0])
    {
      translate([-mount_h / 2 - 0.1, mount_w / 2 - 5, wheel_holder_z_size / 2])
      rotate([0, 90, 0])
      mounting_hole(mount_h + 0.2, false, $fn = 32);
    }
  }
}


module wheel_holder_base()
{
  mount_w = (radial_bearing_r + wheel_holder_wall) * 2 + 20;

  difference()
  {
    union()
    {
      translate([-(belt_gear_15_r1 + 1) - wheel_holder_mount_h, 
                 -(radial_bearing_r + wheel_holder_wall), 
                 0])
      cube([shaft_shift + belt_gear_15_r1 + 1 + wheel_holder_mount_h, 
            (radial_bearing_r + wheel_holder_wall) * 2, 
            wheel_holder_z_size]);
  
      translate([-(belt_gear_15_r1 + 1) - wheel_holder_mount_h / 2, 0, 0])
      wheel_holder_mounting_pad(mount_w, wheel_holder_mount_h);

      translate([shaft_shift - wheel_holder_mount_h / 2, 0, 0])
      wheel_holder_mounting_pad(mount_w, wheel_holder_mount_h);
    }

    // shaft
    cylinder(r = shaft_radius + tolerance, h = wheel_holder_z_size + 0.1, $fn = 64);

    // bearing pocket
    translate([0, 0, wheel_holder_wall])
    cylinder(r = radial_bearing_r, h = radial_bearing_h, $fn = 128);
  }
}


module wheel_holder()
{
  difference()
  {
    wheel_holder_base();

    translate([radial_bearing_r + 10, 0, -0.05])
    mounting_hole(wheel_holder_z_size + 0.1, true);

    translate([-radial_bearing_r - 2.5, 0, -0.05])
    mounting_hole(wheel_holder_z_size + 0.1, true);
  }
}


if(ASSEMBLY == undef || ASSEMBLY == 0)
{
  difference()
  {
    wheel_holder();
    
    translate([-(belt_gear_15_r1 + 1), 
               -(radial_bearing_r + wheel_holder_wall) - 0.05, 
               wheel_holder_z_size - wheel_holder_wall - 0.1])
    cube([shaft_shift + belt_gear_15_r1 + 1 - wheel_holder_mount_h, 
          (radial_bearing_r + wheel_holder_wall) * 2 + 0.1, 
          wheel_holder_wall + 0.15]);
  }
}
