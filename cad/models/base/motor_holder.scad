include <main_dimensions.scad>

// http://www.exp-tech.de/Zubehoer/Mechanisches-Bauteil/Pololu-37D-mm-Metall-Getriebemotor-Halterung-Paar.html

$fn = 64;

x_dim = 44;
y_dim = 38;
z_dim = 44;



module holder_mounting_holes(depth = 50)
{
    translate([0, 0, 0])
    cylinder(r = 5, h = depth, center = true);

    for(i = [0 : 360 / 4 : 360])
    {
        rotate([0, 0, i])
        translate([0, 10, 0])
        cylinder(r = 3 / 2, h = depth, center = true);
    }
}


module motor_holder()
{
    color("Black")
    translate([0, -y_dim / 2, 0])
    difference()
    {
        union()
        {
            cube([x_dim - y_dim / 2, y_dim, z_dim - y_dim / 2]);
            translate([x_dim - y_dim / 2, y_dim / 2, 0])
            cylinder(r = y_dim / 2, h = z_dim - y_dim / 2);

            translate([0, y_dim / 2, z_dim - y_dim / 2])
            rotate([0, 90, 0])
            cylinder(r = y_dim / 2, h = x_dim - x_dim / 2);
        }
        translate([motor_holder_h, -tolerance, motor_holder_h])
        cube([x_dim, y_dim + 2 * tolerance, z_dim]);

        // Shaft hole
        translate([motor_holder_h / 2, y_dim / 2, 25.0])
        union()
        {
            translate([-motor_holder_h, 0, -14.3 / 2])
            rotate([0, 90, 0])
            cylinder(r = 13 / 2, h = 2 * motor_holder_h);

            cube([2 * motor_holder_h, 13, 14.3], center = true);

            translate([-motor_holder_h, 0, 14.3 / 2])
            rotate([0, 90, 0])
            cylinder(r = 13 / 2, h = 2 * motor_holder_h);
        }

        // Motor mounting holes
        translate([motor_holder_h / 2, y_dim / 2, 25.0])
        for(i = [0 : 360 / 6 : 360])
        {
            rotate([i, 0, 0])
            translate([0, 31 / 2, 0])
            rotate([0, 90, 0])
            cylinder(r = 3.3 / 2, h = 50, center = true);
        }

        translate([x_dim - x_dim / 2, y_dim / 2, 0])
        holder_mounting_holes(3 * motor_holder_h);
    }
}

if(ASSEMBLY == undef || ASSEMBLY == 0)
{
  motor_holder();
}
