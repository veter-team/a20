include <main_dimensions.scad>

// http://www.pololu.com/product/1442

module motor()
{
    motor_r1 = 36.8 / 2;
    motor_l1 = 22;
    motor_r2 = 33 / 2;
    motor_l2 = 30;

    // back shaft
    color("Silver")
    translate([0, 0, -motor_l1 - motor_l2 - 3 - 10]) cylinder(h = 12, r = 2 / 2);
    // back shaft holder
    color("LightGray")
    translate([0, 0, -motor_l1 - motor_l2 - 3]) cylinder(h = 3, r = 9 / 2);
    // thin back part
    color("LightGray")
    translate([0, 0, -motor_l1 - motor_l2])
    cylinder(h = motor_l2, r = motor_r2);
    // thick front part
    color("Gray")
    translate([0, 0, -motor_l1])
    cylinder(h = motor_l1, r = motor_r1);
    translate([motor_shaft_shift, 0, 0])
    {
        // front shaft holder
        color("Gray")
        cylinder(h = 6.5, r = 6);
        // front shaft
        color("Silver")
        cylinder(h = 22, r = 3);
    }
}

if(ASSEMBLY == undef || ASSEMBLY == 0)
{
    motor();
}
