use <../BezierScad.scad>
use <../MCAD/regular_shapes.scad>
use <../MCAD/boxes.scad>
use <../base/motor.scad>
use <../base/motor_holder.scad>
use <../base/shaft_coupling.scad>
include <../main_dimensions.scad>


tolerance = 0.2;

ball_r = 70 / 2;

side_wall_h = ball_r * 2;
side_wall_thickness = 5;

blade_h = 3;
//blade_w = ball_r * 2;

mount_pin_r = 5 / 2 + tolerance;

rotor_r = 60 / 2;


blade_w = base_x_size + 2 * wheel_width;
first_curve_r = rotor_r + 2 * ball_r;
shoot_angle = 75;
cut_angle = 90 - shoot_angle;


module sidewall()
{
    linear_extrude(height = blade_h)
    BezLine([
            [0, 0],
            [7, 30],
            [50, 50]
        ], width = [-side_wall_h, -side_wall_h], resolution = 6,
        centered = false);
}


module first_curve(inc_angle)
{
    ang = inc_angle ? cut_angle - 0.1 : cut_angle;
    x_shift = inc_angle ?  0.1 : 0;

    intersection()
    {
        rotate([0, 90, 0])
        rotate([0, 0, 90])
        translate([0, 0, -blade_w / 2])
        linear_extrude(height = blade_w + 0.3)
        polygon(points=[
                [-x_shift, x_shift],
                [-x_shift, -first_curve_r - 0.1],
                [first_curve_r + 0.1, -first_curve_r - 0.1],
                [(first_curve_r + 0.1) * cos(ang), -first_curve_r * sin(ang)]
            ]);
     
        rotate([0, 90, 0])
        cylinder(r = first_curve_r, h = blade_w, center = true, $fn = 128);
    }
}

module rib(radius)
{
    difference()
    {
        // Cut the sharp edge out
        scale([3, 1, 1])
        triangle_prism(40, radius + 1);
        
        translate([-5, radius - 1, -0.1])
        cube([10, 3, 40 + 0.3]);
    }
}


module ball_collector()
{
    k = (first_curve_r - blade_h) / first_curve_r;
    cyl_r = holder_shaft_r + 2;
    second_holder_angle = 60;

    difference()
    {
        union()
        {
            difference()
            {
                union()
                {
                    for(x = [-blade_w / 2 : blade_w / 4 : blade_w / 2])
                    {
                        translate([x,
                                (first_curve_r - (blade_h - cyl_r)) * cos(second_holder_angle),
                                -(first_curve_r - (blade_h - cyl_r)) * sin(second_holder_angle) - 1])
                        rotate([0, 0, 180])
                        rotate([-99, 0, 0])
                        rib(cyl_r);
                    }
                    first_curve(false);
                }

                // Cut out half of the side rib
                translate([-blade_w / 2,
                        (first_curve_r - (blade_h - cyl_r)) * cos(second_holder_angle) + 1,
                        -(first_curve_r - (blade_h - cyl_r)) * sin(second_holder_angle) - 15])
                rotate([0, 0, 180])
                cube([20, 50, 30]);

                // Cut out half of the other side rib
                translate([blade_w / 2 + 20,
                        (first_curve_r - (blade_h - cyl_r)) * cos(second_holder_angle) + 1,
                        -(first_curve_r - (blade_h - cyl_r)) * sin(second_holder_angle) - 15])
                rotate([0, 0, 180])
                cube([20, 50, 30]);
                
                scale([(blade_w - 2 * side_wall_thickness) / blade_w, k, k])
                first_curve(true);
            }
        
            rotate([0, 90, 0])
            rotate([0, 0, 90])
            translate([(first_curve_r - blade_h) * cos(cut_angle) - 0.08,
                    -(first_curve_r - blade_h) * sin(cut_angle) - 0.2,
                    -blade_w / 2])
            BezWall( [
                    [0, 0],
                    [7, 30],
                    [50, 50]
                    
                ] , width = blade_h, height = blade_w, steps = 128,
                centered = false );    

            // Mounting cylinders on the bottom side
            translate([0,
                    (first_curve_r - (blade_h - cyl_r)) * cos(cut_angle),
                    -(first_curve_r - (blade_h - cyl_r)) * sin(cut_angle)])
            rotate([0, 90, 0])
            cylinder(r = cyl_r, h = blade_w, center = true, $fn = 64);
            
            translate([0,
                    (first_curve_r - (blade_h - cyl_r)) * cos(second_holder_angle),
                    -(first_curve_r - (blade_h - cyl_r)) * sin(second_holder_angle)])
            rotate([0, 90, 0])
            cylinder(r = cyl_r, h = blade_w, center = true, $fn = 64);

            // Front rounding cylinder
            translate([0, 0, -(first_curve_r - blade_h / 2)])
            rotate([0, 90, 0])
            cylinder(r = blade_h / 2, h = blade_w, center = true, $fn = 32);
        }

        // Holes in the mounting cylinder on bottom side
        translate([0,
                (first_curve_r - (blade_h - cyl_r)) * cos(cut_angle),
                -(first_curve_r - (blade_h - cyl_r)) * sin(cut_angle)])
        rotate([0, 90, 0])
        cylinder(r = holder_shaft_r, h = blade_w + 0.2,
            center = true, $fn = 64);
    
        translate([0,
                (first_curve_r - (blade_h - cyl_r)) * cos(second_holder_angle),
                -(first_curve_r - (blade_h - cyl_r)) * sin(second_holder_angle)])
        rotate([0, 90, 0])
        cylinder(r = holder_shaft_r, h = blade_w + 0.2,
            center = true, $fn = 64);
    }

    // Side wall upper parts
    rotate([0, 90, 0])
    rotate([0, 0, 90])
    translate([(first_curve_r - blade_h) * cos(cut_angle) - 0.08,
            -(first_curve_r - blade_h) * sin(cut_angle) - 0.2,
            -blade_w / 2])
    sidewall();
    
    rotate([0, 90, 0])
    rotate([0, 0, 90])
    translate([(first_curve_r - blade_h) * cos(cut_angle) - 0.08,
            -(first_curve_r - blade_h) * sin(cut_angle) - 0.2,
            blade_w / 2 - blade_h])
    sidewall();
}


module motor_box()
{
    tube_len = 80;

    translate([0, 0, -25 - motor_shaft_shift])
    {
        difference()
        {
            union()
            {
                difference()
                {
                    motor_holder();

                    difference()
                    {
                        translate([-5, 0, motor_holder_z_dim - motor_holder_y_dim / 2])
                        rotate([0, 90, 0])
                        cylinder(r = motor_holder_y_dim / 2 + 30, h = 100, $fn = 128);

                        translate([-7, 0, motor_holder_z_dim - motor_holder_y_dim / 2])
                        rotate([0, 90, 0])
                        cylinder(r = motor_holder_y_dim / 2, h = 110, $fn = 128);
                    }
                }

                difference()
                {
                    translate([0, 0, motor_holder_z_dim -motor_holder_y_dim / 2])
                    rotate([0, 90, 0])
                    cylinder(r = motor_holder_y_dim / 2 + 3, h = tube_len, $fn = 128);

                    translate([-5, 0, motor_holder_z_dim - motor_holder_y_dim / 2])
                    rotate([0, 90, 0])
                    cylinder(r = motor_holder_y_dim / 2 - 0.1, h = tube_len + 10, $fn = 128);

                    for(a = [0 : 180 / 2 : 180])
                    {
                        translate([(tube_len - 20) / 2 + 10, 0, motor_holder_z_dim - motor_holder_y_dim / 2])
                        rotate([a, 0, 0])
                        roundedBox([tube_len - 20, 10, 3 * motor_holder_y_dim], 4, true, $fn = 32);
                    }
                }

                translate([0, 0, motor_holder_z_dim - motor_holder_y_dim / 2])
                for(a = [0 : 360 / 4 : 360])
                {
                    rotate([a + 45, 0, 0])
                    translate([0, motor_holder_y_dim / 2 + 4, 0])
                    rotate([0, 90, 0])
                    cylinder(r = 3.5, h = tube_len, $fn = 32);
                }
            }

            translate([0, 0, motor_holder_z_dim - motor_holder_y_dim / 2])
            for(a = [0 : 360 / 4 : 360])
            {
                difference()
                {
                    rotate([a + 45, 0, 0])
                    translate([-0.1, motor_holder_y_dim / 2 + 4, 0])
                    rotate([0, 90, 0])
                    cylinder(r = 1.5 + tolerance, h = tube_len + 0.3, $fn = 32);
                }
            }
        }

        translate([1.5 * motor_holder_h, 0, 25.0])
        rotate([0, -90, 0])
        %motor();
    }
}


module coupling_cover_whole()
{
    cover_len = 37;

    difference()
    {
        union()
        {
            difference()
            {
                translate([motor_shaft_shift, 0, 0])
                difference()
                {
                    cylinder(r = motor_holder_y_dim / 2 + 3, h = cover_len, $fn = 128);
        
                    translate([0, 0, radial_bearing_h + 2])
                    cylinder(r = motor_holder_y_dim / 2, h = cover_len, $fn = 128);
                }
                
                translate([0, 0, 1])
                cylinder(r = radial_bearing_r, h = radial_bearing_h, $fn = 128);
        
                cylinder(r = radial_bearing_r - 2, h = 40, $fn = 128);
        
                for(a = [0 : 180 / 2 : 180])
                {
                    translate([motor_shaft_shift, 0, (cover_len - 18) / 2 + 9])
                    rotate([0, 0, a])
                    rotate([0, 90, 0])
                    roundedBox([cover_len - 18, 10, 3 * motor_holder_y_dim], 4, true, $fn = 32);
                }
            }
        
            translate([motor_shaft_shift, 0, 0])
            for(a = [0 : 360 / 4 : 360])
            {
                rotate([0, 0, a + 45])
                translate([0, motor_holder_y_dim / 2 + 4, 0])
                cylinder(r = 3.5, h = cover_len, $fn = 32);
            }
        }
        
        translate([motor_shaft_shift, 0, 0])
        for(a = [0 : 360 / 4 : 360])
        {
            rotate([0, 0, a + 45])
            translate([0, motor_holder_y_dim / 2 + 4, -0.1])
            cylinder(r = 1.5 + tolerance, h = cover_len + 0.3, $fn = 32);
        }
    }
}


module coupling_cover_main()
{
    translate([0, 0, -(radial_bearing_h + 1)])
    difference()
    {
        coupling_cover_whole();

        translate([motor_shaft_shift, 0, -0.1])
        cylinder(r = motor_holder_y_dim / 2 + 20, h = radial_bearing_h + 1.1, $fn = 128);
    }
}


module coupling_cover_bearing_pocket()
{
    difference()
    {
        coupling_cover_whole();

        translate([motor_shaft_shift, 0, radial_bearing_h + 0.9])
        cylinder(r = motor_holder_y_dim / 2 + 20, h = 50, $fn = 128);
    }
}


if(ASSEMBLY == undef || ASSEMBLY == 0)
{
    // Tennis ball
    //translate([0, 0, -rotor_r - ball_r])
    //%sphere(r = ball_r);

    // Rotor
    //rotate([0, 90, 0])
    //%cylinder(r = rotor_r, h = blade_w, center = true);

    //translate([37, 0, 0])
    //motor_box();

    //translate([27, 0, 0])
    //rotate([0, -90, 0])
    //shaft_coupling();

    coupling_cover_main();
    //coupling_cover_bearing_pocket();
    

    //ball_collector();    
}
