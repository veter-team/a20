//**************************************************************
// Parameterized Threaded Rod
// Author: psync
// Version: Where we're going, we don't need versions...
//			... but if anyone asks, this is 0.1
// Date: 12/01/2010
//**************************************************************
fn_value = 50;	// $fn value for torus, makes it look 
				// nicer the higher the value

// Test input values, values are in mm. Comment out these lines if
// you plan on using this module externally
t_d1 = 4;  // Diameter of coils in the helix
t_d2 = 25; // Diameter of central thread (add d1 for max diameter )
t_h1 = 3; // Height between coils (0 means coils have no separation)
t_h2 = 30; // Height of total coil (should be non-zero)

module half_torus( d1, w )
{
	rotate_extrude(convexity = 10)
		translate([w/2,0,0])
			circle(r=d1/2,$fn=fn_value);
} // half_torus module //

module basic_helix( d1, w, h1 )
{
	// This piece forms the bottom half of the helix
	rotate( a = -asin((d1+h1)/(2*w)), v=[0,1,0] )
	{	
		union()
		{
		translate([w/2,0,0])
			difference() 
			{
				half_torus(d1,w);
				// Translate -0.1 extra for manifold 
				// intersection
				translate([0,-(w+d1)/4-0.1,0])
					cube( size = [w+d1,(w+d1)/2,d1], 
						center = true );
			} // end of difference()
		} // end of union()
	} // end of rotate()
} // basic_helix module //

//basic_helix( t_d1, t_d2, t_h1 ); // Debug output checking

module basic_unit( d1, w, h1 )
{
	union()
	{
		// Lay down the first half-torus
		basic_helix( d1, w, h1 );
		// Now mirror it and place a copy above
		translate([0,0,h1+d1])
			mirror([0,1,0])
				mirror([0,0,1])
				basic_helix( d1, w , h1);	
	} // end of union()
} // basic_unit module //

//basic_unit( t_d1, t_d2, t_h1 ); // Debug output checking

module main_helix( d1, w, h1, h2 )
{
	union()
	{
		for ( i = [0:(h1+d1):h2] )
		{
		translate([0,0,i])
			basic_unit( d1, w, h1 );
		} // end of for()
	} // end of union()
} // main_helix module //

//main_helix( t_d1, t_d2, t_h1, t_h2 ); // Debug output checking

module spring( d1, d2, h1, h2 )
{
	// Calcuate w (internal torus width) from d2
	w = sqrt( pow(d2,2) + pow((h1+d1)/2,2) );
	
	difference()
		{
		// Center the helix
		translate([-d2/2,0,-d1/2])
			main_helix( d1, d2, h1, h2 );

		// Subtract a box to slice off the bottom
		translate([0,0,-d1/2])
			cube(size = [d2+2*d1,d2+2*d1,d1],
				center = true);
		}
} // spring module //

// spring( t_d1, t_d2, t_h1, t_h2 ); // Debug output checking

module screw_thread( d1, d2, h1, h2 )
{
	// Calculate the base diameter, edge to edge
	//w = sqrt( pow(d2,2) + pow((h1+d1)/2,2) );
	
	difference() // Subtract the top slice
	{
		union() 
		{
			// Main helical springamajig
			spring( d1, d2, h1, h2 );

			// Central thread cylinder
			translate( [0,0,h2/2] )
				cylinder( h = h2, r = d2/2, center = true );
		} // end of union()

		// Top slicing box
		translate([0,0,h2+(h2+h1)/2])
			cube( size = [ d2+2*d1, d2+2*d1, h2+h1], 
				center = true );
	} // end of difference()
} // screw_thread module //

screw_thread( t_d1, t_d2, t_h1, t_h2 ); // Comment this out if you want to 
									// call this module externally