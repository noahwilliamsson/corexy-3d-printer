/**
 * CoreXY v2
 * Modules for the bed
 *
 *   -- noah@hack.se, 2016-2017
 */

// Sizes for bearing, screw holes/taps, ..
include <defs.scad>
// Printer configuration
include <config.scad>

// Modules
use <helpers.scad>


// Print statements
*!bedGripThing();
*!printBedCorners();
*!printBedDistances();

// Print helpers
module printBedCorners() {
    translate([0,0,0]) bedCorner();
    translate([42,0,0]) bedCorner();
    translate([0,42,0]) bedCorner();
    translate([42,42,0]) bedCorner();
}
module printBedDistances() {
    translate([0,0,0]) bedDistance();
    translate([42,0,0]) bedDistance();
    translate([0,42,0]) bedDistance();
    translate([42,42,0]) bedDistance();
}

// To squeeze a plate of 4mm float glass and 4mm cork against a 2020 alu beam
module bedGripThing() {
    distance=28;
    thickness=4;
    difference() {
        union() {
            hull() for(x=[-1,1],y=[-1,1],z=[-1,1])
                translate([(thickness)/2+x*(distance)/2,
                            (2*thickness+distance/2)+y*(2*thickness+distance)/2,
                            5+5*z])
                    sphere(d=1,$fn=6);
        }
        translate([-2*thickness,2*thickness,-.5]) hull() for(x=[-1,1],y=[-1,1],z=[-1,1])
            translate([distance/2+x*distance/2, distance/2+y*distance/2, 5+(5+1)*z])
                sphere(d=1,$fn=6);
    }
}

// Bed leveling screw bracket for Z gantry
module bedCorner() {
    difference() {
        union() {
            cube([beamSize, 6*beamSize/7, thickness]);
            translate([0,5*beamSize/7,0]) cube([beamSize, 4*beamSize/7, thickness]);
            translate([beamSize/4,5*beamSize/7,0]) cube([beamSize/2, 4*beamSize/7, thickness*2]);
            translate([3*beamSize/4, 3*beamSize/3,8]) rotate([0,-90,0]) cylinder(d=12, h=beamSize/2);
        }
        // Mounting holes
        translate([beamSize/2, 2*beamSize/5, -.5]) polyhole(d=M4hole,h=thickness*2+1);
        translate([beamSize+.5, 3*beamSize/3,8]) rotate([0,-90,0]) cylinder(d=M3tap, h=beamSize+1);
    }
}

// Thing for the angled corners on the borosillicate glass
module bedDistance() {
    difference() {
        union() {
            cylinder(d=8,h=thickness);
            rotate(45) translate([-4,-6,0]) cube([8,12,thickness]);
        }
        translate([0,0,-.5]) cylinder(d=M3hole, h=thickness+1);
    }
}
