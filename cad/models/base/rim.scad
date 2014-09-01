include <main_dimensions.scad>


/*
There are always different requirements or wishes regarding spokes
and the ways to mount the shaft. However, tires are standard. So
first we define the base for standard tire and than modify the middle
part of the rim. Such approach makes it easier to modify spokes and
mounting surface later.  
Set shaft_r to 0 if no shaft hole needed.
*/
module half_rim_base(shaft_r)
{
    rotate_extrude(convexity = 10, $fn = 128)
    polygon(points=[[shaft_r, 0],
                   [shaft_r, half_rim_width],
                   [31.50, half_rim_width],
                   [31.50, 21.6],
                   [29, 19.5],
                   [29, 17.6782],
                   [31, 16],
                   [31, 14],
                   [26, 9.8],
                   [26, 0] ]);

    // Tier anti-sliding pads
    for(i = [0 : 360 / 4 : 360])
    {
        rotate([0, 0, i])
        translate([23, -5 / 2, 0])
        cube([7, 5, 14]);
    }
}


module spoke(l, w, h1 = 5, h2 = 10)
{
    linear_extrude(height = l)
    polygon(points=[[-h1/2, 0],
                   [h1/2, 0],
                   [h2/2, w],
                   [0, w * 1.2],
                   [-h2/2, w]]);
}    


module half_rim(shaft_r)
{
    mnt_surface_z = 34 / 2;
    rr = 22;
    h1 = 11;
    
    difference()
    {
        half_rim_base(shaft_r);

        cylinder(r = rr, h = h1, $fn = 128);
        translate([0, 0, h1])
        cylinder(r1 = rr, r2 = 28, h = half_rim_width - h1 + 0.1, $fn = 128);
    }

    // Shaft holder
    difference()
    {
        cylinder(r = hub_outer_radius + 1, h = h1, $fn = 128);

        // Hole for mounting hub
        translate([0, 0, h1 - hub_height2])
        cylinder(r = hub_inner_radius, h = hub_height2 + 0.1, $fn = 64);

        // Shaft hole
        cylinder(r = shaft_r, h = mnt_surface_z + 0.1, $fn = 64);

        // Hub mounting holes
        for(i = [0 : 360 / 6 : 360])
        {
            rotate([0, 0, i])
            translate([9.53, 0, h1 + 1])
            rotate([0, 180, 0])
            mounting_hole(h1 + 2, true);
        }
    }

    // Spokes
    for(i = [0 : 360 / 3 : 360])
    {
        rotate([0, 0, i])
        translate([0, hub_outer_radius-1, 0])
        spoke(h1, rr - (hub_outer_radius + 1) + 2, 8, 12);
    }
}


module rim()
{
  half_rim(shaft_radius + tolerance / 2);
  mirror([0, 0, 1]) half_rim(shaft_radius + tolerance / 2);
}


if(ASSEMBLY == undef || ASSEMBLY == 0)
{
  //rim();
  half_rim(shaft_radius + tolerance / 2);
}
