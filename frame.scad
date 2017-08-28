/**
 * CoreXY v2
 * Frame modules
 *
 *   -- noah@hack.se, 2016-2017
 */

// Sizes for bearing, screw holes/taps, ..
include <defs.scad>
// Printer configuration
include <config.scad>

// Modules
use <helpers.scad>
use <yAxis.scad>


// Print statements
*!printTopCorners();
*!printOutsideYBrackets();
*!mirror([1,1,0]) spoolHolderBracket();
*!spoolHolderNut();

// Print helpers
module printTopCorners() {
    translate([-3*thickness,-3*thickness,0]) rotate([0,0,180]) frameCornerBracketRegular([2,3,2]);
    translate([-3*thickness,3*thickness,0]) rotate([0,0,90]) frameCornerBracketRegular([3,2,2]);
    translate([3*thickness,-3*thickness,0]) rotate([0,0,270]) frameCornerBracketRegular([2,2,2]);
    translate([3*thickness,3*thickness,0]) rotate([0,0,0]) frameCornerBracketRegular([2,2,2]);
}

module printOutsideYBrackets() {
    translate([0,0,thickness]) rotate([90,0,270]) yRodOutsideBracket([3,0,2]);
    translate([14,0,thickness]) rotate([90,0,0]) yRodOutsideBracket([2,0,3]);
}

// Spool holder arm mounted on the side of the printer
// Reenforced with a 80-100mm M8 rod
module spoolHolderBracket() {
    thickness=5;
    length=120;
    factor=1.5;

    difference() {
        union() {
            hull() {
            translate([0,beamSize-beamSize,0]) cube([beamSize, beamSize*factor, thickness]);
            #translate([length-beamSize,length-beamSize,0]) cube([beamSize*factor, beamSize, thickness]);
            }

            translate([length/2, length/2, 0]) cylinder(d=35, h=12);
            hull() {
                translate([length/2, length/2, 12]) cylinder(d=35, h=1);
                translate([length/2, length/2, 12]) cylinder(d=21.5, h=thickness);
            }
            translate([length/2, length/2, 12+thickness]) cylinder(d=21.5, h=thickness-1);
            translate([length/2, length/2, 12+2*thickness-1]) cylinder(d=12, h=1);

            translate([80,80,0])cube([20,20,thickness]);

//            translate([100-beamSize, beamSize])
        }
        translate([beamSize/2, beamSize*factor-beamSize/2, -.5]) polyhole(d=M4hole,h=thickness+1);
        translate([length-beamSize/2, length-beamSize/2, -.5]) polyhole(d=M4hole,h=thickness+1);
        translate([length/2, length/2, -.5]) nuttrap(d=14.3, h=15);
        translate([length/2, length/2, 15+1]) polyhole(d=8.6, h=20+1);
    }
}

module spoolHolderNut() {
    difference() {
        union() {
            hull() {
                cylinder(d=35, h=1);
                translate([0,0,1]) cylinder(d=22, h=5);
            }
            translate([0,0,6]) cylinder(d=22, h=20);
            translate([0,0,6+20]) cylinder(d=12, h=1);
        }

        translate([0,0,-.5]) nuttrap(d=14.4, h=1+5+15);
        translate([0,0,1+5+15+1])polyhole(d=8.6, h=6+20+1+1);
    }

}

module frameCornerBracketRegular(size=[3,0,3]) {
    // X, Y and Z size in multiples of beamSize
    radius=15;
    difference() {
        union() {
            // Bottom X and Y
            translate([-thickness, -thickness, -thickness]) {
                cube([thickness+size[0]*beamSize, thickness+beamSize, thickness]);
                cube([thickness+beamSize, thickness+size[1]*beamSize, thickness]);
            }
            // Reinforcement bottom XY
            if(size[0] > 1 && size[1] > 1)
                translate([beamSize,beamSize,-thickness]) rotate([0,0,0]) convexCorner(h=thickness, r=radius);

            // Front X and Y
            translate([-thickness, -thickness, -thickness]) {
                cube([thickness+size[0]*beamSize, thickness, thickness+beamSize]);
                cube([thickness+beamSize, thickness, thickness+size[2]*beamSize]);
            }
            // Reinforcement front XZ
            if(size[0] > 1 && size[2] > 1)
                translate([beamSize,0,beamSize]) rotate([90,0,0]) convexCorner(h=thickness, r=radius);

            // Left Y and Z
            translate([-thickness, -thickness, -thickness]) {
                cube([thickness, thickness+size[1]*beamSize, thickness+beamSize]);
                cube([thickness, thickness+beamSize, thickness+size[2]*beamSize]);
            }
            // Reinforcement left YZ
            if(size[1] > 1 && size[2] > 1)
                translate([0,beamSize,beamSize]) rotate([0,270,0]) convexCorner(h=thickness, r=radius);
        }

        // Hole front X and Y
        for(i=[1:2:2*size[0]]) translate([i*beamSize/2, -thickness, beamSize/2]) rotate([-90, 0, 0]) cylinder(d=M4hole, h=thickness);
        for(i=[1:2:2*size[2]]) translate([beamSize/2, -thickness, i*beamSize/2]) rotate([-90, 0, 0]) cylinder(d=M4hole, h=thickness);
        // Bottom X and Y
        for(i=[1:2:2*size[0]]) translate([i*beamSize/2, beamSize/2, 0]) rotate([180, 0, 0]) cylinder(d=M4hole, h=thickness);
        for(i=[1:2:2*size[1]]) translate([beamSize/2,i*beamSize/2,0]) rotate([180, 0, 0]) cylinder(d=M4hole, h=thickness);
        // Left Y and Z
        for(i=[1:2:2*size[1]]) translate([0,i*beamSize/2,beamSize/2]) rotate([0, -90, 0]) cylinder(d=M4hole, h=thickness);
        for(i=[1:2:2*size[2]]) translate([0,beamSize/2,i*beamSize/2]) rotate([0, -90, 0]) cylinder(d=M4hole, h=thickness);
    }
}
