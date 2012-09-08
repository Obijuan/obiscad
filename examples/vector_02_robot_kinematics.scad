//---------------------------------------------
//-- Example of use of the vector library
//---------------------------------------------
use <obiscad/vector.scad>

//-- Robot parameters
show_robot = true;     //-- Show the whole robot or just the kinematics
ls = 3;                //-- link section side
r = 3;                 //-- link sphere radius
robot_color="Yellow";  //--- Color

//-- Define the 2 link vectors and calculate their lengths
v1 = [20,20,20]; l1 = mod(v1);
v2 = [30,0,10]; l2 = mod(v2);

//-- Projections of the link vector on the z=0 plane
v1p = [v1[0], v1[1], 0];
v2p = [v2[0], v2[1], 0];

//-- Robot origin
frame(l=20);

//-- Draw link vector 1
vector(v1);

if (show_robot) {
  //-- Origin robot sphere
  color(robot_color) sphere(r=r, $fn=20);

  //-- Link 1
  orientate(v=v1, roll=0)
    translate([0,0,l1/2])
      color(robot_color) cube([ls,ls,l1],center=true);
}

//-- Draw link2
translate(v1) {
  frame(l=20);
  vector(v2);

  if (show_robot) {
    color(robot_color) sphere(r=r, $fn=20);

    orientate(v=v2, roll=0)
    translate([0,0,l2/2])
      color(robot_color) cube([ls,ls,l2],center=true);
  }
}

//-- Frame in the robot end
translate(v1+v2) {
  frame(l=20);
}

//-- Draw the proyections (to see the robot better)
 color("Gray")  vector(v1p);

 translate(v1p)
   color("Gray") vector(v2p);


