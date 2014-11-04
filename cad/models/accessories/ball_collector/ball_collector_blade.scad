use <../../BezierScad.scad>
use <../../MCAD/regular_shapes.scad>
use <../../MCAD/boxes.scad>
use <../../base/shaft_coupling.scad>
use <motor_box.scad>
include <../../main_dimensions.scad>


side_wall_h = ball_r * 2;
side_wall_thickness = radial_bearing_h + 1;
blade_h = 3;
mount_pin_r = 5 / 2 + tolerance;
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


module ball_collector_blade_base()
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


module bearing_mounting()
{
    or = radial_bearing_r + 10;
    
    translate([blade_w / 2, 0, 0])
    rotate([0, -90, 0])
    cylinder(r = or, h = side_wall_thickness, $fn = 128);

    //translate([blade_w / 2 - side_wall_thickness, 0, -or])
    //cube([side_wall_thickness, 60, 2 * or]);
    translate([blade_w / 2, 0, 0])
    rotate([0, 0, -90])
    rotate([90, 0, 0])
    linear_extrude(height = side_wall_thickness)
    polygon(points=[
            [0,or],
            [-20, or + 10],
            [-60, or + 10],
            [-60, -30],
            [0, -30]
        ]);
    
    translate([blade_w / 2, 0, 0])
    rotate([0, 0, -90])
    rotate([90, 0, 0])
    linear_extrude(height = side_wall_thickness)
    polygon(points=[
            [-1,0],
            [or, 0],
            [or, -50],
            [-1,-80]
        ]);

}


module ball_collector_blade()
{
    difference()
    {
        union()
        {
            ball_collector_blade_base();

            bearing_mounting();
            mirror([1, 0, 0])
            bearing_mounting();
        }

        // Right bearing hole
        hull()
        {
            translate([blade_w / 2 - (side_wall_thickness - radial_bearing_h) - 0.05, 0, 0])
            rotate([0, -90, 0])
            cylinder(r = radial_bearing_r, h = radial_bearing_h, $fn = 128);

            translate([blade_w / 2 - (side_wall_thickness - radial_bearing_h) - 0.05, 0, -20])
            rotate([0, -90, 0])
            cylinder(r = radial_bearing_r, h = radial_bearing_h, $fn = 128);
        }
        
        // Left bearing hole
        hull()
        {
            translate([-blade_w / 2 + (side_wall_thickness - radial_bearing_h) + 0.05, 0, 0])
            rotate([0, 90, 0])
            cylinder(r = radial_bearing_r, h = radial_bearing_h, $fn = 128);

            translate([-blade_w / 2 + (side_wall_thickness - radial_bearing_h) + 0.05, 0, -20])
            rotate([0, 90, 0])
            cylinder(r = radial_bearing_r, h = radial_bearing_h, $fn = 128);
        }
        
        // Shaft hole
        hull()
        {
            rotate([0, 90, 0])
            cylinder(r = shaft_radius, h = blade_w + 10, center = true, $fn = 64);

            translate([0, 0, -20])
            rotate([0, 90, 0])
            cylinder(r = shaft_radius, h = blade_w + 10, center = true, $fn = 64);
        }

        // Material save hole
        translate([0, 30, -60])
        rotate([0, 90, 0])
        cylinder(r = 20, h = blade_w + 10, center = true, $fn = 64);
    }
}


if(ASSEMBLY == undef || ASSEMBLY == 0)
{
    //translate([27, 0, 0])
    //rotate([0, -90, 0])
    //shaft_coupling();

    ball_collector_blade();
}
