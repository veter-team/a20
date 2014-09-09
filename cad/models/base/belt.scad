include <../main_dimensions.scad>


module belt(total_length, gear_r)
{
    x = (total_length - 2 * 3.1415 * gear_r) / 2;
    // belt thickness is 3mm, width is 9.6mm

    translate([-9.6 / 2, 0, 0])
    rotate([0, 0, 90])
    rotate([90, 0, 0])
    color("DimGray")
    difference()
    {
        union()
        {
            cylinder(r = gear_r + 3, h = 9.6);
            
            translate([0, -gear_r - 3, 0])
            cube([x, (gear_r + 3) * 2, 9.6]);
            
            translate([x, 0, 0])
            cylinder(r = gear_r + 3, h = 9.6);
        }

        translate([0, 0, -0.1]) // this translate/scale
        scale([1, 1, 1.1]) // is to remove viewing artefacts
        union()
        {
            cylinder(r = gear_r, h = 9.6);
            
            translate([0, -gear_r, 0])
            cube([x, gear_r * 2, 9.6]);
            
            translate([x, 0, 0])
            cylinder(r = gear_r, h = 9.6);
        }
    }
}


if(ASSEMBLY == undef || ASSEMBLY == 0)
{
    //belt(330.5, belt_gear_10_r2);
    belt(330.5, belt_gear_15_r2);
}
