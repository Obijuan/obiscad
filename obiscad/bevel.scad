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


module bevel()
{
  
  //-------- Main object
  size=[30,30,30];
  *cube(size,center=true);  

  //-- edge connector
  eanchor2 = [size[0]/2, 0,size[2]/2];
  ec1 = [[-size[0]/2, 0,  size[2]/2],[0,1,0],0];
  ec2 = [eanchor2,                   [0,1,0],0];

  //-- edge orientation
  eo = [ eanchor2, [1,0,1], 0 ];


  //-- Corner connector
  cc =  [[0,0,0],[0,0,1],0];
  co = -[[0,0,0],[1,1,0],0];

  //-- Draw the edge connector
  connector(ec2);
  connector(eo);

  //-- Calculate the angle between the eo and co
  //-- First the transformation of co (tco) should be
  //-- calculated!
  //tco = 
  v = unitv(cc[1])*10;
  vector(v);

  //-- Calculate here the transformation!!!
  raxis = cross(v,ec2[1]);
  ang = anglev(v,ec2[1]);
  

  p = co[1];  //-- Vector to transform
  k=unitv(raxis);
  teta = ang;

  tv = p*cos(teta) + cross(k,p*sin(teta)) + k*dot(k,p)*(1-cos(teta));
  color("Red") vector(unitv(tv)*10);
  
  //-- Roll angle!
  final_angle =anglev(tv,eo[1]);
 
  ec2m = [ec2[0], ec2[1], final_angle];


  attach(ec2m, cc) 
  //color("Blue") 
    union() {
      connector(co);
      color("Blue",0.2)
      bccorner(cr=15, cres=10, l=10, th=1, ecorner=false);
    }



}

//-------------------------------------------------------------------
//--   TESTS
//-------------------------------------------------------------------

//-- example 1
//bccorner(cr=15, cres=10, l=10, th=3, ecorner=true);


bevel();


/*

difference() {

cube(size,center=true);

attach(ec2, cc) 
  #color("Blue") 
    bccorner(cr=15, cres=10, l=10, th=3, ecorner=false);
}


*render(convexity=4);

*/



