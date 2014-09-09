include <../main_dimensions.scad>
use <wheel.scad>
use <motor_holder.scad>
use <motor.scad>
use <shaft_hub.scad>
use <shaft_coupling.scad>
//use <belt_gear_15.scad>
use <belt_gear_10.scad>
use <wheel_holder.scad>


module wheel_shaft()
{
    // Shaft. Length:
    // half tire width
    // half rim width
    // 2mm distance between holder and wheel
    // 7 + 1 = 8mm distance to motor shaft coupling
    // 5mm tolerance
    shaft_len = wheel_width / 2 + 11 + wheel_holder_y_dim + 2 + 8 + 5;
    echo("** Wheel shaft length:", shaft_len);
    pad_h = 0.5; // height for shaft pads to prevent hubs from sliping

    difference()
    {
        rotate([-90, 0, 0])
        color("Silver")
        cylinder(r = shaft_radius, h = shaft_len, $fn = 32);

        // Shaft pads
        translate([-shaft_radius, 0, shaft_radius - pad_h])
        {
            // Shaft coupling
            cube([2 * shaft_radius, shaft_coupling_l / 2, pad_h * 2]);
            echo("** Wheel shaft pad 1:", 0, shaft_coupling_l / 2);

            // Belt gear
            translate([0, shaft_coupling_l / 2 + radial_bearing_h + 1 + 2, 0])
            cube([2 * shaft_radius, belt_gear_l - belt_gear_l1, pad_h * 2]);
            echo("** Wheel shaft pad 2:",
                shaft_coupling_l / 2 + radial_bearing_h + 1 + 2,
                belt_gear_l - belt_gear_l1);

            // Outer part
            translate([0, shaft_coupling_l / 2 + wheel_holder_y_dim + 1, 0])
            cube([2 * shaft_radius, shaft_len - (shaft_coupling_l / 2 + wheel_holder_y_dim + 1) + 0.1, pad_h * 2]);
            echo("** Wheel shaft pad 3:",
                shaft_coupling_l / 2 + wheel_holder_y_dim + 1,
                shaft_len - (shaft_coupling_l / 2 + wheel_holder_y_dim + 1));
        }
    }
}


module motor_with_holder()
{
  motor_holder();

  translate([1.5 * motor_holder_h, 0, 25.0]) 
  rotate([0, -90, 0]) 
  motor();
}


module wheel_block()
{
    difference()
    {
        union()
        {
            color("Snow")
            wheel_holder();
        
            translate([0, belt_gear_l / 2, 0])
            rotate([90, 0, 0])
            color("Gainsboro")
            belt_gear();
              
            translate([0, wheel_holder_y_dim / 2 + wheel_width / 2 + 2, 0]) 
            rotate([90, 0, 0])
            wheel();
        }
        translate([0, -10, 0])
        cube([100, 200, 100]);
    }

    translate([0, -wheel_holder_y_dim / 2 - 8, 0])
    wheel_shaft();
}


module wheel_motor_block()
{
    wheel_block();

    translate([0, -wheel_holder_y_dim / 2 - 1, 0])
    rotate([90, 0, 0])
    color("DarkGoldenrod")
    shaft_coupling();

    rotate([0, 0, -90])
    rotate([-90, 0, 0])
    translate([wheel_holder_y_dim / 2 + shaft_coupling_l + 10, 0, -shaft_shift])
    motor_with_holder();
}



if(ASSEMBLY == undef || ASSEMBLY == 0)
{
    //wheel_block();
    wheel_motor_block();
    //wheel_shaft();
    /*
    difference()
    {
        wheel_motor_block();
        translate([0, -10, 0])
        cube([100, 200, 100]);
    }
    */
}
