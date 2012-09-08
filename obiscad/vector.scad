//---------------------------------------------------------------
//-- Openscad vector library
//-- This is a component of the obiscad opescad tools by Obijuan
//-- (C) Juan Gonzalez-Gomez (Obijuan)
//-- Sep-2012
//---------------------------------------------------------------
//-- Released under the GPL license
//---------------------------------------------------------------

//---------------------------------------------------------------
//-- Draw a vector poiting to the z axis
//-- Parameters:
//--  l: total vector length (line + arrow)
//--  l_arrow: Vector arrow length
//---------------------------------------------------------
module vectorz(l=10, l_arrow=4)
{
  //-- vector body length (not including the arrow)
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
//-- ORIENTATE OPERATOR
//-- Orientate the child to the direction given by the vector
//-- The z axis of the child is rotate so that it points in the
//-- direction given by v
//-- 
//-- Parameters:
//--   v : Orientation vector
//--  roll: Angle to rotate the child around the v axis
//---------------------------------------------------------------
module orientate(v=[1,1,1],roll=0)
{
  //-- Get the vector coordinales and rotating angle
  x=v[0]; y=v[1]; z=v[2];
  phi_z1 = roll;
  
  //-- Perform the needed calculations
  phi_x = atan2(y,z);  //-- for case 1 (x=0)
  phi_y2 = atan2(x,z); //-- For case 2 (y=0)
  phi_z3 = atan2(y,x); //-- For case 3 (z=0)

  //-- General case
  l=sqrt(x*x+y*y);
  phi_y4 = atan2(l,z);
  phi_z4 = atan2(y,x);

  //-- Orientate the Child acording to region where 
  //-- the orientation vector is located

  //-- Case 1:  The vector is on the plane x=0
  if (x==0) { 
     //echo("Case 1");      //-- For debugging 
     
     rotate([-phi_x,0,0])
       rotate([0,0,phi_z1])
         child(0);
  }

  //-- Case 2: Plane y=0
  else if (y==0) {
    //echo("Case 2");      //-- Debugging

    rotate([0,phi_y2,0])
       rotate([0,0,phi_z1])
         child(0);
  }
  //-- Case 3: Plane z=0
  else if (z==0) {
    //echo("Case 3");      //-- Debugging

    rotate([0,0,phi_z3])
    rotate([0,90,0])
       rotate([0,0,phi_z1])
         child(0);
  }
  //-- General case
  else {
    //echo("General case ");    //-- Debugging
    //echo("Phi_z4: ", phi_z4);
    //echo("Phi_y4: ",phi_y4);

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

//------------------------------------
//-- Tests and examples
//-----------------------------------


//-- Testing that the vector library is working ok
//-- 22 vectors in total are drawn, poiting to different directions
a = 20;
k = 1;

//--  Add a frame of reference (in the origin)
frame(l=a);

//-- Negative vectors, pointing towards the three axis: -x, -y, -z
color("Red")   vector([-a, 0,  0]);
color("Green") vector([0, -a,  0]);
color("Blue")  vector([0,  0, -a]);

//-- It is *not* has been implemented using a for loop on purpose
//-- This way, individual vectors can be commented out or highlighted

//-- vectors with positive z
vector([a,   a, a*k]);
vector([0,   a, a*k]);
vector([-a,  a, a*k]);
vector([-a,  0, a*k]);

vector([-a, -a, a*k]);
vector([0,  -a, a*k]);
vector([a,  -a, a*k]);
vector([a,   0, a*k]);


//-- Vectors with negative z
vector([a,   a, -a*k]);
vector([0,   a, -a*k]);
vector([-a,  a, -a*k]);
vector([-a,  0, -a*k]);

vector([-a, -a, -a*k]);
vector([0,  -a, -a*k]);
vector([a,  -a, -a*k]);
vector([a,   0, -a*k]);




