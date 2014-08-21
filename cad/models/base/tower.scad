
module cap(cap_r)
{
    scale_z = 0.6;
    
    difference()
    {
        scale([1, 1, scale_z])
        sphere(r = cap_r, $fn = 128);

        scale([1, 1, 0.5])
        translate([0, 0, -5])
        sphere(r = 75, $fn = 128);

        rotate([180, 0, 0])
        cylinder(r = 81, h = cap_r * scale_z);
    }
}

module tower()
{
    cap_r = 80;
    cap_h = 40;

    translate([0, 0, cap_h])
    cap(cap_r);
    difference()
    {
        cylinder(r = cap_r, h = cap_h + 0.1, $fn = 128);
        translate([0, 0, -0.1])
        cylinder(r = 75, h = cap_h + 0.3, $fn = 128);
    }
}
