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

//-------------------------------------------------------------------
//--   TESTS
//-------------------------------------------------------------------

//-- example 1
//bccorner(cr=15, cres=10, l=10, th=3, ecorner=true);

//-- corner connector
cc = [[0,0,0],[0,0,1],0];

size = [30,30,30];

//-- edge connector
ec1 = [[-size[0]/2, 0,size[2]/2],[0,1,0],0];
ec2 = [[size[0]/2, 0,size[2]/2],[0,1,0],0];



connector(ec2);

difference() {

cube(size,center=true);

attach(ec2, cc) 
  #color("Blue") 
    bccorner(cr=15, cres=10, l=10, th=3, ecorner=false);
}


*render(convexity=4);





