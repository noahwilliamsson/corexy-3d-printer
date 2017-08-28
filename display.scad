/**
 * CoreXY v2
 * Modules to render misc elements
 *
 *   -- noah@hack.se, 2016-2017
 */

// Sizes for bearing, screw holes/taps, ..
include <defs.scad>
// Printer configuration
include <config.scad>

// Modules
use <helpers.scad>
use <bed.scad>
use <electronics.scad>
use <frame.scad>
use <xyShared.scad>
use <xAxis.scad>
use <yAxis.scad>
use <zAxis.scad>


// Print statements
*!showCoreXyV1();
*!testXYAndCarriage();
*!showVirtualFrame();
*!showVirtualZFrame();
*!showXyStepper();
*!omronSS5GLF();

// Print helpers
module testXYAndCarriage() {
    towerY=8;
    translate([0,0,3+yBearing[1]/2] /* center Z around Y axis */) {
        translate([0, towerY-thickness-xBearing[1]/2, thickness+xBearing[1]/2-xRodDistance/2+xRodZShift]) xCarriageV2();
        translate([-65,-65/2,0/*3+yBearing[1]/2*/]) xyBracketV3();
    }
}


// X and Y centered around the mounting holes
module omronSS5GLF() {
    w=19.8;
    h=10.2;
    z=6.4;
    difference() {
        union() {
            // Body
            translate([-w/2, -2.9, 0]) cube([w, h, z]);
            translate([-w/2+7, -2.9+h, 1]) cylinder(d=2, h=6.4-2);
            // Legs
            for(x=[1.6,1.6+8.8,1.6+8.8+7.3])
                translate([-w/2+x,-6.4, 6.4/2-3.2/2]) cube([1,6.4,3.2]);
        }
        for(x=[-1,1]) translate([x*9.5/2,0,-.5]) polyhole(d=2.5, h=6.4+1);
    }
}

// Show design (not all parts shown)
module showCoreXyV1() {
    // Display frame bars
    showVirtualFrame();

    // Display Z frame
    showVirtualZFrame();

    // Front bottom left (origin)
    translate([0,0,0])
        rotate([0,0,0])
            frameCornerBracketRegular();
    // Front bottom right
    translate([beamSize+xBeamLength+beamSize,0,0])
        rotate([0,0,90])
            frameCornerBracketRegular();
    // Front top left
    translate([0,0,zBeamLength])
        rotate([0,90,0])
            frameCornerBracketRegular();
    // Front top right
    translate([beamSize+xBeamLength+beamSize,0,zBeamLength])
        rotate([0,180,0])
            frameCornerBracketRegular();
    // Back bottom left
    translate([0, beamSize+yBeamLength+beamSize,0])
        rotate([0,0,-90])
                frameCornerBracketRegular();
    // Back bottom right
    translate([beamSize+xBeamLength+beamSize, beamSize+yBeamLength+beamSize,0])
        rotate([0,0,180])
                frameCornerBracketRegular();

    // Back top left
    translate([0,beamSize+yBeamLength+beamSize,zBeamLength])
        mirror([0,1,0])
            xyBearingBracket();

    // Back top left
    translate([0, beamSize+yBeamLength+beamSize, zBeamLength])
        rotate([180,0,0])
            mirror([0,0,0]) {
                frameCornerBracketForYRod();
                xyGuideBracketV1();

               // Virtual X carriage
                xPosition=2*($t < .5? xTravel*$t: xTravel-xTravel*$t);
                %translate([xRodMinimumXOffset+xGuideLengths+xPosition, beamSize+(xyGuideBracketWidth-xRodDistance)/2, beamSize+thickness+xBearing[1]/2]) {
                    xCarriageV1();
                    translate([10,xCarriageWidth/2,-xBearing[1]/2-thickness])
                        rotate([180,0,180])
                            xCarriageV1Fastener();

                    translate([xCarriageWidth-10,xCarriageWidth/2,-xBearing[1]/2-thickness])
                        rotate([180,0,0])
                            xCarriageV1Fastener();
                }
            }

    translate([beamSize+xBeamLength+beamSize, beamSize+yBeamLength+beamSize, zBeamLength])
        rotate([180,0,0])
            mirror([1,0,0]) {
                frameCornerBracketForYRod();
                mirror([0,0,0]) xyGuideBracketV1();
            }

    // Left stepper bracket
    translate([0,0,zBeamLength]) mirror([0,1,0]) rotate([180,0,0])  xyMotorMount();
    // Left stepper
    %translate([0,0,zBeamLength-xyStepper[2]-beamSize-thickness])
        rotate([0,180,270])
            mirror([0,0,1])
                showXyStepper();
    // Left Y endstop
    translate([beamSize+beamClearance+xyStepper[1]+beamSize, 0, zBeamLength])
        rotate([0,180,0])
            yEndstopBracket();


    // Right Y endstop
    translate([beamSize+xBeamLength-xyStepper[1]-beamClearance-beamSize, 0, zBeamLength])
        rotate([0,180,0])
            yEndstopBracket();

    // Right stepper bracket
    translate([beamSize+xBeamLength+beamSize,0,zBeamLength]) mirror([0,0,0]) rotate([0,180,0])  xyMotorMount();
    // Right stepper
    %translate([xBeamLength-xyStepper[0],0,zBeamLength-xyStepper[2]-beamSize-thickness])
        rotate([0,180,270])
            mirror([0,0,1])
                showXyStepper();
    // Right stepper Up-side down
    *translate([xBeamLength-xyStepper[0],0,zBeamLength])
        rotate([0,180,270])
                showXyStepper();

    translate([beamSize+xBeamLength/2,0])
        zBottomBracket();

}

module showVirtualZFrame() {
    translate([beamSize+xBeamLength/2,0,beamSize+4/*screw heads*/+thickness]) {
        %translate([-bedXBeamLength/2,0,0]) cube([bedXBeamLength, beamSize, beamSize]);
        %translate([-100,0,0]) cube([beamSize, beamSize+bedYBeamLength, beamSize]);
        %translate([100,0,0]) cube([beamSize, beamSize+bedYBeamLength, beamSize]);
        %translate([-bedXBeamLength/2,beamSize+bedYBeamLength,0]) cube([bedXBeamLength, beamSize, beamSize]);
        zGantryBracket();
    }
    translate([beamSize+xBeamLength/2,0,zBeamLength-beamSize-thickness]) {
        mirror([0,0,0])
        zMotorBracket();
    }
}

module showVirtualFrame() {
    // Z beams in corners
    %color("blue", .4) translate([0, 0, 0]) cube([beamSize,beamSize, zBeamLength]);
    %color("blue", .4) translate([beamSize+xBeamLength, 0, 0]) cube([beamSize,beamSize, zBeamLength]);
    %color("blue", .4) translate([0, beamSize+yBeamLength, 0]) cube([beamSize, beamSize, zBeamLength]);
    %color("blue", .4) translate([beamSize+xBeamLength, beamSize+yBeamLength, 0]) cube([beamSize, beamSize, zBeamLength]);

    // X beams
    %color("red", .4) translate([beamSize, 0, 0]) cube([xBeamLength, beamSize, beamSize]);
    %color("red", .4) translate([beamSize, 0, zBeamLength-beamSize]) cube([xBeamLength, beamSize, beamSize]);
    %color("red", .4) translate([beamSize, beamSize+yBeamLength, 0]) cube([xBeamLength, beamSize, beamSize]);
    %color("red", .4) translate([beamSize, beamSize+yBeamLength, zBeamLength-beamSize]) cube([xBeamLength, beamSize, beamSize]);

    // Y beams
    %color("green", .4) translate([0, beamSize, 0]) cube([beamSize, yBeamLength, beamSize]);
    %color("green", .4) translate([0, beamSize, zBeamLength-beamSize]) cube([beamSize, yBeamLength, beamSize]);
    %color("green", .4) translate([beamSize+xBeamLength, beamSize, 0]) cube([beamSize, yBeamLength, beamSize]);
    %color("green", .4) translate([beamSize+xBeamLength, beamSize, zBeamLength-beamSize]) cube([beamSize, yBeamLength, beamSize]);
}


// Render a NEMA17 stepper motor
// TODO: Center around some axle
module showXyStepper() {
    // X, Y, Z, hole radius, axle diameter
    difference() {
        union() {
            translate([beamSize+beamClearance, beamSize+beamClearance, 0])
                cube([xyStepper[0], xyStepper[1], xyStepper[2]]);

            translate([beamSize+beamClearance+xyStepper[0]/2, beamSize+beamClearance+xyStepper[1]/2, xyStepper[2]])
                cylinder(d=xyStepper[3], h=20);

            // Pulley
            translate([beamSize+beamClearance+xyStepper[0]/2, beamSize+beamClearance+xyStepper[1]/2, xyStepper[2]])
                cylinder(d=xyPulleySize, h=20);
            translate([beamSize+beamClearance+xyStepper[0]/2, beamSize+beamClearance+xyStepper[1]/2, xyStepper[2]+20-1])
                cylinder(d=xyPulleySize+3.5, h=1);
            translate([beamSize+beamClearance+xyStepper[0]/2, beamSize+beamClearance+xyStepper[1]/2, xyStepper[2]+thickness+4/*compensate for corner bracket */-1])
                cylinder(d=xyPulleySize+3.5, h=1);

            // Belt
            %color("red", 0.5) translate([beamSize+beamClearance+xyStepper[0]/2, beamSize+beamClearance+xyStepper[1]/2+xyPulleySizeWithBelt/2-xyBeltThickness, xyStepper[2]+thickness+4/*compensate for corner bracket */])
                cube([xRodLength,xyBeltThickness,6]);

            %color("black", 0.5) translate([beamSize+beamClearance+xyStepper[0]/2, beamSize+beamClearance+xyStepper[1]/2-xyPulleySizeWithBelt/2, xyStepper[2]+12])
                cube([xRodLength,xyBeltThickness,6]);
        }

        // NEMA holes
        translate([beamSize+beamClearance+xyStepper[0]/2, beamSize+beamClearance+xyStepper[1]/2, xyStepper[2]]) {
            for(x=[-1,1]) for(y=[-1,1])
            translate([x*xyStepper[4], y*xyStepper[4], -5]) polyhole(d=M3hole, h=5+1);
        }
    }
}
