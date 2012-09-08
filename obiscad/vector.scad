//--------------------------------------------------------
//-- Draw a vector poiting to the z axis
//-- Parameters:
//--  l: total vector length (line + arrow)
//--  l_arrow: Vector arrow length
//---------------------------------------------------------
module vectorz(l=10, l_arrow=4)
{
  lb = l - l_arrow;

  //-- The vector is locatead at 0,0,0
  translate([0,0,lb/2])
  union() {

    //-- Draw the arrow
    translate([0,0,lb/2])
      cylinder(r1=2/2, r2=0.2, h=l_arrow, $fn=20);

    //-- Draw the body
    cylinder(r=1/2, h=lb, center=true, $fn=20);
  }

  //-- Draw a sphere in the vector base
  sphere(r=1/2, $fn=20);
}

//---------------------------------------------------------------
//-- Orientate the child to the direction given
//-- by a vector. 
//-- The z axis of the child is rotate so that it
//-- points in the direction given by v
//-- Parameters:
//--   v : Orientation vector
//--  roll: Angle to rotate the along the v axis
//---------------------------------------------------------------
module orientate(v=[1,1,1],roll=0)
{
  x=v[0]; y=v[1]; z=v[2];
  phi_z1 = roll;

  //-- Case 1
  phi_x = atan2(y,z);
  
  //-- Case 2
  phi_y2 = atan2(x,z);

  //-- Case 3
  phi_z3 = atan2(y,x);

  //-- General case
  l=sqrt(x*x+y*y);
  phi_y4 = atan2(l,z);
  phi_z4 = atan(y/x);

  //-- Case 1:  plane x=0
  if (x==0) { 
     echo("Case 1"); 
     rotate([-phi_x,0,0])
       rotate([0,0,phi_z1])
         child(0);
  }
  //-- Case 2: Plane y=0
  else if (y==0) {
    echo("Case 2");
    rotate([0,phi_y2,0])
       rotate([0,0,phi_z1])
         child(0);
  }
  //-- Case 3: Plane z=0
  else if (z==0) {
    echo("Case 3");
    rotate([0,0,phi_z3])
    rotate([0,90,0])
       rotate([0,0,phi_z1])
         child(0);
  }
  //-- General case
  else {
    echo("General case ");
    echo("Phi_z4: ", phi_z4);
    echo("Phi_y4: ",phi_y4);
    rotate([0,0,phi_z4])
      rotate([0,phi_y4,0])
        rotate([0,0,phi_z1])
          child(0);
  }
}

//--------------------------------------------------------
//-- Draw a vector poiting to the z axis
//-- Parameters:
//--  l: total vector length (line + arrow)
//--  l_arrow: Vector arrow length
//---------------------------------------------------------
module vector(v,l_arrow=4)
{
  mod = sqrt(v[0]*v[0]+v[1]*v[1]+v[2]*v[2]);
  orientate(v) vectorz(l=mod, l_arrow=l_arrow);
}

//----------------------------------------------------
//-- Draw a Frame of reference
//-- Parameters:
//-- l: length of the Unit vectors
//-----------------------------------------------------
module frame(l=10, l_arrow=4)
{

  //-- Z unit vector
  color("Blue")
    vector([0,0,l], l_arrow=l_arrow);

  //-- X unit vector
  color("Red")
    vector([l,0,0], l_arrow=l_arrow );

  //-- Y unit vector
  color("Green")
    vector([0,l,0],l_arrow=l_arrow);

  //-- Origin
  color("Gray")
    sphere(r=1, $fn=20);
}


//-- Examples

//--  Add a frame of reference
frame(l=10);

//-- Orientate a cube
*orientate(v=[1,1,1],roll=0) 
  translate([0,0,10]) 
    cube([1,1,20],center=true);

a = 20;

//-- Show a vector
vector([a,a,a]);

color("Gray") vector([a,a,0]);
color("Gray")
  translate([a,a,0])
  vector([0,0,a]);

//-- Add a transparent cube
color("Gray",0.2)
  cube(a);




