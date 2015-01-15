total_height=20;
motor_shaft_depth=10;
motor_shaft_diameter=6.350; //nema 23

m5_shaft_diameter=5;
//took actual measurements of a nut
m5_nut_flat_width=8; // references say 7.612;
m5_nut_corner_width=9; //refs 8.79;
m5_nut_thickness=4; //refs 4.7;

cross_shaft_placement=14;
cross_shaft_length=30; //arbitrary, but so we don't have magic numbers below

module knob_top() {
  max_radius=20;
  scallop_radius=8;
  thickness=8;

  difference() {
    //shallow cylinder
    cylinder(h=thickness,r=max_radius);

    //"scallops"
    for(n=[1:8]) {
      rotate( n * 360 / 8, [0, 0, 1])
        translate([max_radius+.6*scallop_radius, 0, 0])
          cylinder(h=thickness*2, r = scallop_radius, center=true,$fn=25);
    }
  }
}

//choose a slot type
module hexslot() {
  box_height=10; 
  union() {
    rotate([90,90,0])
      cylinder (h = m5_nut_thickness, r = m5_nut_corner_width / 2, center = true, $fn = 6);
    translate([0,0,box_height/2]) cube([m5_nut_flat_width,m5_nut_thickness,box_height], center=true);
  }
}
module squareslot() {
  cube([m5_nut_flat_width,m5_nut_thickness,15], center=true);
}

knob_top();

//shaft coupling
difference() {
  difference() {
    difference() {
      //11mm radius cylinder
      cylinder(h=total_height, r=11);
      //- 1/4 inch diamater cylinder, z+10, 20 height (could be infinite
      translate([0,0,(total_height-motor_shaft_depth)]) 
        cylinder(h=motor_shaft_depth, r=motor_shaft_diameter/2, $fn=20);
    }

    // hex nut side shaft
    translate([0,cross_shaft_length/2,cross_shaft_placement]) 
      rotate ([90,0,0]) 
        cylinder (h = cross_shaft_length, r=m5_shaft_diameter/2, center = true, $fn=20);
  }
  translate([0,6,cross_shaft_placement]) //6 is just a position between the shaft and outside
    hexslot();
    //squareslot();
}