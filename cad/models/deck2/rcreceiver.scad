// Dimensions in mm according to the following drawing:
// http://193.40.245.66/mhx/wwwroot/mhk/materjalid/mhk5300/juhendid/R145-SRF08.html

use <../MCAD/boxes.scad>
include <../main_dimensions.scad>


rcv_dim = [40, 60, 15];


module rcreceiver()
{
    difference()
    {
        // Base
        translate(rcv_dim / 2)
        color("Gray")
        roundedBox(rcv_dim, 2, false, $fn = 16);
        
        // Connector pocket
        translate([rcv_dim[0] - 13, 5, rcv_dim[2] / 2])
        cube([10, rcv_dim[1] - 20, rcv_dim[2]]);
    }

    // Connector pins
    for(y = [10 : 5 : 10 + 6 * 5])
    {
        for(x = [rcv_dim[0] - 11 : 3 : rcv_dim[0] - 13 + 3 * 3])
        {
            translate([x, y, rcv_dim[2] / 2])
            color("Gold")
            cylinder(r = 0.5, h = rcv_dim[2] / 2 - 1);
        }
    }

    // Button
    translate([rcv_dim[0] / 2, rcv_dim[1] - 10, rcv_dim[2] - 3])
    color("Gray")
    sphere(r = 5);
}


if(ASSEMBLY == undef || ASSEMBLY == 0)
{
    rcreceiver();
}
