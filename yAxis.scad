/**
 * CoreXY v2
 * Y axis modules
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
*!yEndstopBracket();
*!printYRodOutsideBrackets();
*!frameCornerBracketForYRod(size=[2,0,0]); // Scrapped

// Print helpers
module printYRodOutsideBrackets() {
    translate([0,10,0]) rotate([-90,0,90]) mirror([0,1,0]) yRodOutsideBracket();
    translate([0,-10,0]) rotate([90,0,270]) yRodOutsideBracket();
}


// Centered around X axis
module yEndstopBracket(length = beamSize+beamClearance+xyStepper[1]+10/*extra*/) {
    echo("Endstop length",length);
    difference() {
        union() {
            translate([-beamSize/2, 0, beamSize]) cube([beamSize, length, thickness]);
            // Virtual Omron SS-5GL-F switch
            %color("black",0.5) translate([-beamSize/2, length-5-2.9, beamSize+thickness]) cube([19.8, 10.2, 6.4]);
        }
        // Slot hole
        translate([0,beamSize/4, beamSize-.5]) polyhole(d=M4hole, h=thickness+1);
        translate([-M4hole/2,beamSize/4, beamSize-.5]) cube([M4hole, length/2, thickness+1]);
        translate([0,beamSize/4+length/2, beamSize-.5]) polyhole(d=M4hole, h=thickness+1);
        // https://www.omron.com/ecb/products/sw/12/ss.html
        translate([-19.8/2+5.1, length-5, beamSize-.5]) polyhole(d=1.9, h=thickness+1);
        translate([-19.8/2+5.1+9.5, length-5, beamSize-.5]) polyhole(d=1.9, h=thickness+1);
    }
}

// Size: X, Y and Z size in multiples of beamSize
module yRodOutsideBracket(size=[2,0,3]) {
    difference() {
        union() {
            hull() {
                // Front X and Z
                translate([-thickness, -thickness, -thickness]) {
                    cube([thickness+size[0]*beamSize, thickness, thickness+beamSize]);
                    cube([thickness+beamSize, thickness, thickness+size[2]*beamSize]);
                }
                // Rod holder wall
                translate([beamSize+yRodBeamOffset, -thickness, beamSize+yRodBeamOffset])
                    rotate([-90,0,0])
                        polyhole(d=yBearing[1], h=thickness);
            }
            // Rod holder shell
            translate([beamSize+yRodBeamOffset, -thickness, beamSize+yRodBeamOffset])
                rotate([-90,0,0])
                    polyhole(d=yBearing[1], h=2*thickness+beamSize+8);

            // Virtual Y rod
            %translate([beamSize+yRodBeamOffset, -thickness, beamSize+yRodBeamOffset])
                rotate([-90,0,0])
                    cylinder(d=yBearing[0], h=yRodLength);

        }

        // Hole front X and Y
        for(i=[1:2:2*size[0]]) translate([i*beamSize/2, -thickness-.5, beamSize/2]) rotate([-90, 0, 0]) polyhole(d=M4hole, h=thickness+1);
        for(i=[1:2:2*size[2]]) translate([beamSize/2, -thickness-.5, i*beamSize/2]) rotate([-90, 0, 0]) polyhole(d=M4hole, h=thickness+1);
        // Bottom X and Y
        for(i=[1:2:2*size[0]]) translate([i*beamSize/2, beamSize/2, 0]) rotate([180, 0, 0]) polyhole(d=M4hole, h=thickness+1);
        for(i=[1:2:2*size[1]]) translate([beamSize/2,i*beamSize/2, 0]) rotate([180, 0, 0]) polyhole(d=M4hole, h=thickness);
        // Left Y and Z
        for(i=[1:2:2*size[1]]) translate([0,i*beamSize/2,beamSize/2]) rotate([0, -90, 0]) polyhole(d=M4hole, h=thickness);
        for(i=[1:2:2*size[2]]) translate([0,beamSize/2,i*beamSize/2]) rotate([0, -90, 0]) polyhole(d=M4hole, h=thickness);

        // Y endstop (Omron microswitch) test
        //translate([beamSize, 0, beamSize]) cube([6.8, beamSize, 28]);

        // Y rod mounting hole
        #translate([beamSize+yRodBeamOffset, -thickness-.5, beamSize+yRodBeamOffset])
            rotate([-90,0,0])
                polyhole(d=yBearing[0]+0.3, h=thickness*2+beamSize+8+1);
        for(angle=[0,90])
            translate([beamSize+yRodBeamOffset, -thickness+2*thickness+beamSize+8-5, beamSize+yRodBeamOffset])
                rotate([0,angle,0])
                    cylinder(d=M3tap, h=thickness*3+beamSize+1);
    }
}


// Similar to above, but modified with an Y rod bracket
// Size: X, Y and Z size in multiples of beamSize
// Scrapped
module frameCornerBracketForYRod(size=[3,2,3]) {
    difference() {
        union() {
            // Bottom X and Y
            translate([-thickness, -thickness, -thickness]) {
                cube([thickness+size[0]*beamSize, thickness+beamSize, thickness]);
                cube([thickness+beamSize, thickness+size[1]*beamSize, thickness]);
            }
            // Reinforcement bottom XY
            if(size[0] > 1 && size[1] > 1)
                translate([beamSize,beamSize,-thickness]) rotate([0,0,0]) convexCorner(h=thickness, r=20);

            hull() {
                // Front X and Z
                translate([-thickness, -thickness, -thickness]) {
                    cube([thickness+size[0]*beamSize, thickness, thickness+beamSize]);
                    cube([thickness+beamSize, thickness, thickness+size[2]*beamSize]);
                }
                // Rod holder wall
                translate([beamSize+yRodBeamOffset, -thickness, beamSize+yRodBeamOffset])
                    rotate([-90,0,0])
                        cylinder(d=28, h=thickness);
            }
            // Rod holder shell
            translate([beamSize+yRodBeamOffset, 0, beamSize+yRodBeamOffset])
                rotate([-90,0,0])
                    cylinder(d=28, h=10);

            // Virtual Y rod
            %translate([beamSize+yRodBeamOffset, -thickness, beamSize+yRodBeamOffset])
                rotate([-90,0,0])
                    cylinder(d=yBearing[0], h=yRodLength);

            // Left Y and X
            translate([-thickness, -thickness, -thickness]) {
                cube([thickness, thickness+size[1]*beamSize, thickness+beamSize]);
                cube([thickness, thickness+beamSize, thickness+size[2]*beamSize]);
            }
            // Reinforcement left YZ
            if(size[1] > 1 && size[2] > 1)
                translate([0,beamSize,beamSize]) rotate([0,270,0]) convexCorner(h=thickness, r=20);
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

        // Y endstop (Omron microswitch)
        translate([beamSize, 0, beamSize]) cube([6.8, beamSize, 28]);

        // Y rod mounting hole
        translate([beamSize+yRodBeamOffset, -thickness, beamSize+yRodBeamOffset])
            rotate([-90,0,0])
                cylinder(d=yBearing[0]+0.2, h=thickness+10+1);
        }
}
