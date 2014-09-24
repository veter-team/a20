use <../MCAD/boxes.scad>
include <../main_dimensions.scad>
use <../base/lead_battery.scad>

pad_x_dim = 85;
pad_y_dim = 55;
base_box_dim = [akku_x_dim + 30, akku_y_dim / 3, 20];


module m_hole()
{
    translate([pad_x_dim / 2 - 5, pad_y_dim / 2 - 5, base_box_dim[2] - 4.1])
    mounting_hole(5, false, $fn = 64);
}


module screw_hole()
{
    translate([base_box_dim[0] / 2 - 4, 0, -0.1])
    cylinder(r = 1, h = base_box_dim[2] + 0.3, $fn = 64);
}


module iface_board_holder()
{
    difference()
    {
        union()
        {
            translate([0, 0, 20 / 2])
            roundedBox(base_box_dim, 1, false, $fn = 64);
            
            translate([0, 0, 20 / 2])
            roundedBox([pad_x_dim, pad_y_dim, 20], 1, false, $fn = 64);
        }
        
        // Battery
        translate([0, 0,
                -wheel_holder_z_dim / 2 - shaft_radius - 2 + base_z_size / 2
                - (wheel_holder_z_dim / 2 + shaft_radius + 2 + base_z_size / 2 + 1)])
        scale([1.1, 1.04, 1.08])
        lead_battery();

        m_hole();
        mirror([0, 1, 0])
        m_hole();
        mirror([1, 0, 0])
        {
            m_hole();
            mirror([0, 1, 0])
            m_hole();
        }

        screw_hole();
        mirror([1, 0, 0])
        screw_hole();
    }
    
}


if(ASSEMBLY == undef || ASSEMBLY == 0)
{
    translate([0, 0, base_box_dim[2]])
    rotate([180, 0, 0])
    iface_board_holder();
}
