//---------------------------------------------------------------
//-- Openscad Attachment library
//-- Attach easily parts. Make your designs more reusable
//---------------------------------------------------------------
//-- This is a component of the obiscad opescad tools by Obijuan
//-- (C) Juan Gonzalez-Gomez (Obijuan)
//-- Sep-2012
//---------------------------------------------------------------
//-- Released under the GPL license
//---------------------------------------------------------------

use <vector.scad>

module connector(c)
{
  p = c[0];
  v = c[1];
  ang = c[2];

  color("Gray") point(p);
  translate(p)
    color("Gray") vector(unitv(v)*6,l_arrow=2);
}


//-- a,b are connectors
module attach(a,b)
{
  //-- Get the data from the connectors
  vref = b[1];
  v = a[1];
  roll=a[2];
  pos1 = a[0];
  pos2 = b[0];

  //-------- Calculations for the "orientate operator"
  //-- Calculate the rotation axis
  raxis = cross(vref,v);
    
  //-- Calculate the angle between the vectors
  ang = anglev(vref,v);

  translate(pos1)
    //-- Orientate operator
    rotate(a=roll, v=v)  rotate(a=ang, v=raxis)
      translate(-pos2)
	child(0); 
}

module arm(debug=false)
{
  
  cube(asize,center=true);

  if (debug) {
    frame(l=10);
    connector(a);
  }
}

module Test()
{
  cube(size,center=true);
  attach(c1,a) arm(debug=true);
  attach(c2,a) arm();
}

//-- Main part
size = [10,10,10];
c1 = [ [0,0,size[2]/2], [0,0,1], 10];
c2 = [ [-size[0]/2,0,0], [-1,0,0], 90 ];

*connector(c1);
*connector(c2);
*cube(size,center=true);


//-- Attachable part
asize = [5,20,3];
a = [ [0,asize[1]/2-3,-asize[2]/2], [0,0,1], 0  ];

*translate([30,0,0])  arm(debug=true);

*attach(c1,a) arm();
*attach(c2,a) arm();
  

orientate([1,1,1])
Test();


