use <../BezierScad.scad>
include <../main_dimensions.scad>


tolerance = 0.2;

ball_r = 70 / 2;

side_wall_h = ball_r * 2;

blade_h = 3;
//blade_w = ball_r * 2;

mount_pin_r = 5 / 2 + tolerance;

rotor_r = 60 / 2;


module sidewall()
{
    linear_extrude(height = 3)
    BezLine([
            [0,3],
            [40,3],
            [100,30],
            [110,100],
            [140,100]
        ], width = [-side_wall_h, -side_wall_h], resolution = 6,
        centered = false);
}


module blade_base()
{
    hole_r = 10;

    difference()
    {
        BezWall( [
                [0,3],
                [40,3],
                [100,30],
                [110,100],
                [140,100]
            ] , width = blade_h, height = blade_w, steps = 128,
            centered = false );

        translate([0, 30, blade_w / 2])
        rotate([0, 90, 0])
        cylinder(r = hole_r, h = 200, $fn = 128);

        translate([0, 60, blade_w / 2])
        rotate([0, 90, 0])
        cylinder(r = hole_r, h = 200, $fn = 128);
    }

    // Blade front side
    translate([0, blade_h / 2, 0])
    cylinder(r = blade_h / 2, h = blade_w, $fn = 32);
    // Blade back side
    translate([140, 100 - blade_h / 2, 0])
    cylinder(r = blade_h / 2, h = blade_w, $fn = 32);
}


module blade()
{
    difference()
    {
        union()
        {
            blade_base();

            // Mounting cylinders
            translate([50, 11, 0])
            cylinder(r = mount_pin_r + 2, h = blade_w, $fn = 32);

            translate([120, 80, 0])
            cylinder(r = mount_pin_r + 2, h = blade_w, $fn = 32);
        }

        // Mounting pin holes
        translate([50, 11, -0.1])
        cylinder(r = mount_pin_r, h = blade_w + 0.3, $fn = 32);

        translate([120, 80, -0.1])
        cylinder(r = mount_pin_r, h = blade_w + 0.3, $fn = 32);
    }
}


// Tennis ball
//translate([0, ball_r, blade_w])
//%sphere(r = ball_r);

//blade();
//sidewall();

blade_w = base_x_size + 2 * wheel_width;
first_curve_r = rotor_r + 2 * ball_r;
shoot_angle = 75;
cut_angle = 90 - shoot_angle;

module first_curve()
{
    intersection()
    {
        rotate([0, 90, 0])
        rotate([0, 0, 90])
        translate([0, 0, -blade_w / 2])
        linear_extrude(height = blade_w + 0.3)
        polygon(points=[
                [0, 0],
                [0, -first_curve_r - 0.1],
                [first_curve_r + 0.1, -first_curve_r - 0.1],
                [(first_curve_r + 0.1) * cos(cut_angle), -first_curve_r * sin(cut_angle)]
            ]);
     
        rotate([0, 90, 0])
        cylinder(r = first_curve_r, h = blade_w, center = true, $fn = 128);
    }
}


module ball_collector()
{
    cca = cos(cut_angle);
    sca = sin(cut_angle);
    shift_x = blade_h * cca;
    shift_y = blade_h * sca + 0.05;
    
    difference()
    {
        first_curve();

        translate([0, -shift_x, shift_y])
        scale([1.1, 1, 1])
        first_curve();
    }

    rotate([0, 90, 0])
    rotate([0, 0, 90])
    translate([(first_curve_r - blade_h) * cca, -(first_curve_r - blade_h) * sca, -blade_w / 2])
    BezWall( [
            [0, 0],
            [7, 30],
            [50, 50]
            
        ] , width = blade_h, height = blade_w, steps = 128,
        centered = false );    
}


if(ASSEMBLY == undef || ASSEMBLY == 0)
{
    ball_collector();
}
