include <main_dimensions.scad>
use <tire.scad>
use <rim.scad>


module wheel()
{
    tire();
    color("Gainsboro")
    rim();
}


if(ASSEMBLY == undef || ASSEMBLY == 0)
{
  wheel();
}
