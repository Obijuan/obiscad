//---------------------------------------------------------------
//-- Openscad Bevel library
//-- xxxxxxxx
//---------------------------------------------------------------
//-- This is a component of the obiscad opescad tools by Obijuan
//-- (C) Juan Gonzalez-Gomez (Obijuan)
//-- Sep-2012
//---------------------------------------------------------------
//-- Released under the GPL license
//---------------------------------------------------------------
use <vector.scad>
use <attach.scad>


//-----------------------------------------------------------------
//- Rotate a vector an angle teta around the axis given by the
//-- unit vector k
//-----------------------------------------------------------------
function Rot_axis_ang(p,k,teta) =
  p*cos(teta) + cross(k,p*sin(teta)) + k*dot(k,p)*(1-cos(teta));

//-- Transformation defined by rotating vfrom vector to vto
//-- It is applied to vector v
//-- It returns the transformed vector
function Tovector(vfrom, vto, v) = 
   Rot_axis_ang(v, unitv(cross(vfrom,vto)), anglev(vfrom,vto));

//-- Auxiliary function for extending a vector of 3 components to 4
function ev(v,c=0) = [v[0], v[1], v[2], c];

function det(a,b,c) = 
   a[0]*(b[1]*c[2]-b[2]*c[1])
 - a[1]*(b[0]*c[2]-b[2]*c[0])  
 + a[2]*(b[0]*c[1]-b[1]*c[0]);

function anglevs(u,v) =  sign(det(u,v,cross(u,v)))*anglev(u,v);


//--------------------------------------------------------------------
//-- Beveled concave corner
//-- NOT AN INTERFACE MODULE (The user should call bcorner instead)
//--
//-- Parameters:
//--   * cr: Corner radius
//--   * cres: Corner resolution
//--   * l: Length
//-    * th: Thickness
//--------------------------------------------------------------------
module bccorner2(cr,cres,l,th)
{
  
  //-- vector for translating the  main cube
  //-- so that the top rigth corner is on the origin
  v1 = -[(cr+th)/2, (cr+th)/2, 0];

  //-- The part frame of reference is on the
  //-- internal corner
  v2 = [cr,cr,0];

  //-- Locate the frame of ref. in the internal
  //-- corner
  translate(v2)
  difference() {

    //-- Main cube for doing the corner
    translate(v1)
        //color("yellow",0.5)
        cube([cr+th, cr+th, l],center=true);
 
    //-- Cylinder used for beveling...
    cylinder(r=cr, h=l+1, center=true, $fn=4*(cres+1));
  }
}

//--------------------------------------------------------------------
//-- Beveled concave corner
//--
//-- Parameters:
//--   * cr: Corner radius
//--   * cres: Corner resolution
//--   * l: Length
//-    * th: Thickness
//--   * ecorner: Where the origin is locate. By default it is located
//--       in the internal corner (concave zone). If true, 
//--       it will be in the external corner (convex zone)
//----------------------------------------------------------------------------
module bccorner(cr=1,cres=4,th=1,l=10,ecorner=false)
{
  /* -- Documentation
  //-- Connector
  c = [[0,0,0], [0,0,1], 0];
  connector(c);

  //-- Orientation vector
  v = -[cr,cr,0];
  vector(v);
  */

  if (ecorner)
    translate([th,th,0]) 
      bccorner2(cr,cres,l,th);
  else
     translate([0.01, 0.01,0])
       bccorner2(cr,cres,l,th);

  //frame(l=10); //-- Debug
}

//-- Edge connector: on the edge. Paralell to the edge
//-- Edge normal: Vector normal to the edge (45 deg)
module bevel(edge_c, normal_c, l, cr=4, cres=10,)
{
  
  //-- Get the vector paralell and normal to the edge
  edge_v = edge_c[1];      //-- Edge verctor
  enormal_v = normal_c[1]; //-- Edge normal vector

  //-- Corner vector
  cedge_v = unitv([0,0,1]);  //-- Corner edge vector
  cnormal_v = [-1,-1,0];     //-- Corner normal vector

  //-- The correct orientation of the corner (roll angle)
  //-- when it is attached to the edge is given by the angle
  //-- between the edge normal vector (enormal_v) and the transformated
  //-- corner normal vector (Tcnormal_v)

  //-- The tcn can be calculated easily by using transformation
  //-- Matrix... BUT... version 2012.02.22 of OpenScad lacks
  //-- the product of Matrix and matrix by vector operator!!!!

  //-- Calculate here the transformation without matrices!!!
  //-- Transformation ce --> edge
  //-- Apply to cn
  Tcnormal_v = Tovector(cedge_v, edge_v, cnormal_v);

  //-- Calculate the sign of the rotation
  s=sign(det(cnormal_v,enormal_v,edge_v));

  //-- Roll angle with sign!
  roll=s*anglev(Tcnormal_v, enormal_v);

  echo("Roll: ",roll);

  //-- Create the connectors for the attach operation!
  cto = [edge_c[0], edge_c[1], roll];
  cfrom = [[0,0,0],cedge_v,0];

  //-- This block represent an attach operation
  //-- It is equivalent to:  attach(cto,cfrom)
  translate(cto[0])
  rotate(a=cto[2], v=cto[1])
  rotate(a=anglev(cfrom[1],cto[1]), v=cross(cfrom[1],cto[1]))
  translate(-cfrom[0]) 

  union() {
    //color("Blue")
    //connector(cfrom);
    //connector([cfrom[0],cnormal_v,0]);
    bccorner(cr=cr, cres=cres, l=l, th=1, ecorner=false);
  }


}

//-------------------------------------------------------------------
//--   TESTS
//-------------------------------------------------------------------

//-- example 1
//bccorner(cr=15, cres=10, l=10, th=3, ecorner=true);

//-------- Main object
size=[30,30,30];


//-- edges connectors
ec1 = [[size[0]/2, 0,size[2]/2], [0,1,0], 0];
en1 = [ec1[0],                   [1,0,1], 0];

ec2 = [[-size[0]/2, 0,size[2]/2], [0,1,0], 0];
en2 = [ec2[0],                   [-1,0,1], 0];

ec3 = [[-size[0]/2, 0,-size[2]/2], [0,1,0], 0];
en3 = [ec3[0],                   [-1,0,-1], 0];

ec4 = [[size[0]/2, 0,-size[2]/2], [0,1,0], 0];
en4 = [ec4[0],                   [1,0,-1], 0];

*connector(ec4);
*connector(en4);

difference() {
  cube(size,center=true); 
  #bevel(ec1,en1,l=size[0]+2);
  #bevel(ec2,en2,l=size[0]+2);
  #bevel(ec3,en3,l=size[0]+2);
  #bevel(ec4,en4,l=size[0]+2);
}


/*
v1 = [1,1,0];
v2 = [-1,1,0];
v3 = cross(v1,v2);
s = sign(det(v1,v2,v3));

echo("Det: ",det(v1,v2,v3));

color("Blue") vector(v1*10);
vector(v2*10);

echo("Angle: ",anglevs(v2,v1));

*/

/*

difference() {

cube(size,center=true);

attach(ec2, cc) 
  #color("Blue") 
    bccorner(cr=15, cres=10, l=10, th=3, ecorner=false);
}


*render(convexity=4);

*/



