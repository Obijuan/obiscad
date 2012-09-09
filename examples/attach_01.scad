use <obiscad/vector.scad>
use <obiscad/attach.scad>

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