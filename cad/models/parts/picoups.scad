// Pico UPS
// http://www.mini-box.com/picoUPS-120-12V-DC-micro-UPS-battery-backup

include <../main_dimensions.scad>


module connector()
{
    color("Silver")
    {
        translate([2, 0, 0])
        cube([3, 1, 5]);

        translate([-5, 0, 3])
        cube([10, 1, 3]);
    }
}


module picoups()
{
    // Mounting holes
    picoups_mh_r = 3.175 / 2;
    picoups_mh_center = 3.91;
    // Board dimensions
    picoups_dim = [54 + picoups_mh_r, 32.92 + picoups_mh_r, 1];

    difference()
    {
        // Base board
        color("DarkGreen")
        cube(picoups_dim);

        // Mounting holes
        // top-left
        translate([picoups_mh_center, picoups_dim[1] - picoups_mh_center, -1])
        cylinder(r = picoups_mh_r, h = 3, $fn = 32);
        // top-right
        translate([picoups_dim[0] - picoups_mh_center, picoups_dim[1] - picoups_mh_center, -1])
        cylinder(r = picoups_mh_r, h = 3, $fn = 32);
        // bottom-left
        translate([picoups_mh_center, picoups_mh_center, -1])
        cylinder(r = picoups_mh_r, h = 3, $fn = 32);
        // bottom-right
        translate([picoups_dim[0] - picoups_mh_center, picoups_mh_center, -1])
        cylinder(r = picoups_mh_r, h = 3, $fn = 32);
    }

    // Connectors
    // Bat
    translate([0, 7, 0])
    connector();
    translate([0, 12, 0])
    connector();
    // Vin
    translate([0, 21, 0])
    connector();
    translate([0, 26, 0])
    connector();
    // Vout
    translate([picoups_dim[0], 8, 0])
    mirror([1, 0, 0])
    connector();
    translate([picoups_dim[0], 15, 0])
    mirror([1, 0, 0])
    connector();

    // Capacitors
    for(x = [25 : 10 : 25 + 2 * 10])
    {
        translate([x, picoups_dim[1] - 8, 0.5])
        color("DarkGray")
        cylinder(r = 4, h = 10, $fn = 32);
    }

    // Fuse
    translate([10, picoups_dim[1] - 15, 0.5])
    color("Red")
    cube([3, 10, 10]);
}


if(ASSEMBLY == undef || ASSEMBLY == 0)
{
    picoups();
}
