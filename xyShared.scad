/**
 * CoreXY v2
 * Shared X/Y modules
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
*!printXyBearingBrackets();
*!printXyMotorMounts();
*!xyCornerBearingDistance();
*!printXyBracketV2s();
*!xyBracketV2();
*!xyGuideBracketV1();
*!xyBeltGuide();  // Extra

// Print helpers
module printXyBracketV2s() {
    translate([0,0,(2*3+yBearing[1])/2]) xyBracketV2Top();
    translate([70,0,-(2*3+yBearing[1])/2]) xyBracketV2Bottom();

    translate([0,-70,(2*3+yBearing[1])/2]) xyBracketV2Top(mirrored=true);
    translate([70,-70,-(2*3+yBearing[1])/2]) xyBracketV2Bottom(mirrored=true);
}
module printXyBearingBrackets() {
    translate([0,-30,0]) xyBearingBracket(false);
    translate([0,60,0]) xyBearingBracket(true);
}
module printXyMotorMounts() {
    translate([0,0,-20]) xyMotorMount();
    translate([-10,0,-20]) rotate([0,0,180]) mirror([0,1,0]) xyMotorMount();
}


// X/Y guide bracket for a vertical X axis
// Note: Y axis shell touches zero X and Y
// Note: print with a brim
module xyBracketV2Top(mirrored=false) {
    difference() {
        xyBracketV2(mirrored);
        translate([-.25,-.25,-100-3-yBearing[1]/2])
            cube([100,100,100]);
    }
}
module xyBracketV2Bottom(mirrored=false) {
    mirror([0,0,1])
    difference() {
        xyBracketV2(!mirrored);
        translate([-.25,-.25,-3-yBearing[1]/2])
            cube([100,100,100]);
    }
}
module xyBracketV2(mirrored=false) {
    xyBracketWidth = 65;
    towerWidth = (xyBearing[1]+3+1)*2; // xyBearing + belt + extra
    towerWidth = xyBearing[1]*2+thickness; // xyBearing + belt + extra
    towerDepth = (xyBearing[1]+3+1)+thickness*2;
    towerXDistance = xyStepper[0]/2+xyPulleySizeWithBelt/2+xyBearing[1]/2;
    // Experimental
    towerInnerDiameter = xyBearing[1]*2+1.5*2;
    towerInnerDiameter = (xyBearing[1]+1.5+thickness)*2;
    towerInnerHeight = thickness*2+(xyBearing[2]+1)*2;
    tmpThickness = 3;
    xRodShellLength = 47; // was 65
    towerY=8*(mirrored? -1: 1);
    difference() {
        union() {
            // Top X shell and reinforcement
            rx=40;
            translate([towerXDistance, towerY+xyBracketWidth/2-xBearing[0]/2-thickness, xRodDistance/2-xBearing[0]/2-thickness+xRodZShift])
                cube([xRodShellLength-towerXDistance, xBearing[0]+2*thickness, xBearing[0]+2*thickness]);
            translate([xRodShellLength-rx/2, towerY+xyBracketWidth/2-xBearing[0]/2-thickness, xRodDistance/2-xBearing[0]/2-thickness+xRodZShift])
                rotate([270,0,0])
                    convexCorner(h=xBearing[0]+2*thickness,r=rx);

            // Bottom X shell and reinforcement
            translate([towerXDistance, towerY+xyBracketWidth/2-xBearing[0]/2-thickness, -xRodDistance/2-xBearing[0]/2-thickness+xRodZShift])
                cube([xRodShellLength-towerXDistance, xBearing[0]+2*thickness, xBearing[0]+2*thickness]);
            // Tower connecting X axis shells with the base
            hull() for(z=[-1,1]) {
                translate([towerXDistance-1, towerY+xyBracketWidth/2-((z > 0? towerWidth: xBearing[0]+2*thickness))/2, z*((xRodDistance+xBearing[0]+2*thickness-towerDepth-2)/2)+xRodZShift])
                    rotate([270,0,0])
                        polyhole(d=towerDepth+2, h=(z > 0? towerWidth: xBearing[0]+2*thickness));
            }

            // Y bearing shell
            translate([tmpThickness+yBearing[1]/2,0,-tmpThickness-yBearing[1]/2])
                rotate([270,0,0])
                    cylinder(d=yBearing[1]+2*tmpThickness, h=xyBracketWidth);

            // Extend with rectangular tube
            translate([tmpThickness+yBearing[1]/2, 0, -tmpThickness*2-yBearing[1]])
                cube([tmpThickness+yBearing[1]/2+5, xyBracketWidth, tmpThickness*2+yBearing[1]]);
            // Rounded corners (TODO: make ry match with tower depth)
            ry=25;
            hull() {
                for(y=[1,-1])
                    translate([towerXDistance, xyBracketWidth/2-y*(xyBracketWidth/2-ry/2),-tmpThickness*2-yBearing[1]])
                        polyhole(d=ry, h=2*tmpThickness+yBearing[1]);
            }
        }

        // X rod holes
        for(z=[1, -1])
            translate([/*48*/0,towerY+xyBracketWidth/2,z*xRodDistance/2+xRodZShift])
                rotate([0,90,0])
                    polyhole(d=xBearing[0]+.3, h=xRodShellLength+1);
        // X rod grub screw
        for(z=[1, -1])
            translate([xRodShellLength-6,towerY+xyBracketWidth/2-20,z*xRodDistance/2+xRodZShift])
                rotate([270,0,0])
                    polyhole(d=M3tap, h=xyBracketWidth/2+2*thickness);

        for(y=[-1,1]) {
            // M5 tap for xyBearings
            translate([towerXDistance, towerY+xyBracketWidth/2+y*(xyBearing[1]+3)/2, -yBearing[1]/2-tmpThickness-10])
                polyhole(d=M5tap, h=35);
            // Screw hole through tower
            translate([towerXDistance, towerY+xyBracketWidth/2+y*(xyBearing[1]+3)/2, beamClearance+3+xyBearing[2]*4])
                polyhole(d=9.3, h=xRodDistance/2+xRodZShift);
        }

        // Right belt slot (closest to origin) with rounded roof
        translate([towerXDistance-(xyBearing[1]+3+1)/2, towerY, beamClearance+3])
            cube([xyBearing[1]+3+1, xyBracketWidth/2, xyBearing[2]*2+2*2]);
        // Left belt slot
        translate([towerXDistance-(xyBearing[1]+3+1)/2, towerY-.5, beamClearance+3+xyBearing[2]*2])
            cube([xyBearing[1]+3+1, xyBracketWidth+1, xyBearing[2]*2+2*2]);
        translate([towerXDistance, towerY, beamClearance+3+2+xyBearing[2]*4])
            rotate([270,0,0])
                polyhole(d=xyBearing[1]+3+1, h=xyBracketWidth+1);
        // Center belt slot for X carriage
        translate([towerXDistance-(xyBearing[1]+3+1)/2, towerY+xyBracketWidth/2-3, beamClearance+3])
            cube([towerInnerDiameter+30, 3*2, 2+xyBearing[2]*4+3]);

        // Y bearing cut-out
        translate([tmpThickness+yBearing[1]/2, xyBracketWidth/2-(yBearing[2]+1.2)/2, -yBearing[1]/2-tmpThickness])
            rotate([270,0,0])
                polyhole(d=yBearing[1]+0.75, h=yBearing[2]+1.1/*slightly longer*/);
        // Y rod through hole (XXX: the round one disabled because rigid.ink PLA)
*        translate([tmpThickness+yBearing[1]/2, -.5, -yBearing[1]/2-tmpThickness])
            rotate([270,0,0])
                polyhole(d=yBearing[0]+2, h=xyBracketWidth+1);
        translate([tmpThickness+yBearing[1]/2-(yBearing[0]+2)/2, -.5, -yBearing[1]/2-tmpThickness-(yBearing[0]+2)/2])
            cube([yBearing[0]+2, xyBracketWidth+1, yBearing[0]+2]);

        // Y clamping holes
        for(y=[-1,1]) {
            translate([towerXDistance, xyBracketWidth/2-y*(xyBracketWidth/2-8), -.5-2*tmpThickness-yBearing[1]]) {
                polyhole(d=M5hole, h=2*tmpThickness+yBearing[1]+1);
            // Nut inset
            translate([0,0,yBearing[1]+1])
                nuttrap(d=8 /*M5*/, h=8);
            // Washer dent
            translate([0,0,-1])
                polyhole(d=14, h=1.5);
            }
        }
    }
}

// Mounting bracket for X/Y motors in the top front corners
module xyMotorMount() {
    difference() {
        union() {

            hull() {
                // Stepper plate
                translate([beamSize+beamClearance, beamSize+beamClearance, beamSize])
                    cube([xyStepper[0], xyStepper[1], thickness]);
                // Y axis shell foundation
                translate([beamSize+yRodBeamOffset-yBearing[0]/2-thickness, beamSize+beamClearance+xyStepper[1], beamSize])
                    cube([thickness+yBearing[0]+thickness, 2*thickness, thickness]);
                // Mount along Y axis
                translate([0, beamSize+beamClearance, beamSize])
                    cube([beamSize+beamClearance+xyStepper[0], xyStepper[1], thickness]);
            }
            // Mount along X axis
            translate([beamSize+beamClearance, 0, beamSize])
                cube([xyStepper[0], beamSize+beamClearance+xyStepper[1], thickness]);

            hull() {
                 // Y axis shell foundation
                translate([beamSize+yRodBeamOffset-yBearing[0]/2-thickness, beamSize+beamClearance+xyStepper[1], beamSize])
                    cube([thickness+yBearing[0]+thickness, 2*thickness, thickness]);
                // Y axis shell
                translate([beamSize+yRodBeamOffset, beamSize+beamClearance+xyStepper[1], beamSize+yRodBeamOffset])
                    rotate([-90,0,0])
                        cylinder(d=yBearing[0]+2*thickness, h=2*thickness);
            }
        }

        // NEMA mounting holes
        translate([beamSize+beamClearance+xyStepper[0]/2, beamSize+beamClearance+xyStepper[1]/2, beamSize-1]) {
            polyhole(d=xyStepper[5]+.5, h=thickness+2);
            for(x=[-1,1]) for(y=[-1,1])
                translate([x*xyStepper[4], y*xyStepper[4], 0])
                    polyhole(d=M3hole, h=thickness+2);

            for(x=[-1,1]) for(y=[-1,1])
                translate([x*xyStepper[4], y*xyStepper[4], 1+thickness])
                    polyhole(d=M3hole+3, h=4);
        }

        // Y rod mount
        translate([beamSize+yRodBeamOffset, beamSize+beamClearance+xyStepper[1]-1, beamSize+yRodBeamOffset])
            rotate([-90,0,0])
                polyhole(d=yBearing[0]+0.35, h=2*thickness+2);

        // Hole along the X beam
        translate([beamSize+2*beamSize/3, beamSize/2, beamSize-1]) polyhole(d=M4hole, h=thickness+2);
        translate([beamSize+5*beamSize/3, beamSize/2, beamSize-1]) polyhole(d=M4hole, h=thickness+2);

        // Hole along the Y beam
        translate([beamSize/2, beamSize+2*beamSize/3, beamSize-1]) polyhole(d=M4hole, h=thickness+2);
        translate([beamSize/2, beamSize+5*beamSize/3, beamSize-1]) polyhole(d=M4hole, h=thickness+2);


        // Hole X side
        translate([5*beamSize/3, beamSize, beamSize+beamSize/2]) rotate([-90, 0, 0]) cylinder(d=M4hole, h=thickness);
        translate([8*beamSize/3, beamSize, beamSize+beamSize/2]) rotate([-90, 0, 0]) cylinder(d=M4hole, h=thickness);

        // Hole Y side
        translate([beamSize+thickness,5*beamSize/3,beamSize+beamSize/2]) rotate([0, -90, 0]) cylinder(d=M4hole, h=thickness);
        translate([beamSize+thickness,8*beamSize/3,beamSize+beamSize/2]) rotate([0, -90, 0]) cylinder(d=M4hole, h=thickness);
    }
}

// For use in the belt corners (together with xyBearingBracket())
// Note: scrapped
module xyCornerBearingDistance() {
    difference() {
        union() {
            cylinder(d=9, h=cornerBearing[2]*2);
        }
        translate([0,0,-.5])
            polyhole(d=cornerBearing[0]+.4, h=cornerBearing[2]*2+1);
    }
}

// Top corner brackets to hold belt bearings
module xyBearingBracket(mirrored=false) {
    size=[3,2,0];
    mirror([0,mirrored? 1: 0, 0]) difference() {
        union() {
            hull() {
                // Top X and Y
                translate([-thickness, -thickness, thickness]) {
                    cube([thickness+size[0]*beamSize, thickness+beamSize, thickness]);
                    cube([thickness+beamSize, thickness+size[1]*beamSize, thickness]);
                }

                // For outer bearing screw
                translate([beamSize+beamClearance+xyStepper[0]/2+xyPulleySizeWithBelt/2+cornerBearing[1]/2,
                    beamSize+7+cornerBearing[1]/2+xyBeltThickness, thickness])
                    cylinder(d=M5tap+2*thickness, h=thickness);
            }

            // Extra screw material
            translate([beamSize+7/*screw in corner bracket*/+cornerBearing[1]/2+xyBeltThickness,
                        beamSize+7+cornerBearing[1]/2+xyBeltThickness, thickness*2])
                    cylinder(d=M5tap+2*thickness, h=thickness+(mirrored? 0: 8));
            translate([beamSize+beamClearance+xyStepper[0]/2+xyPulleySizeWithBelt/2+cornerBearing[1]/2,
                        beamSize+7+cornerBearing[1]/2+xyBeltThickness, thickness*2])
                    cylinder(d=M5tap+2*thickness, h=thickness+(mirrored? 8: 0));
        }

        // Top X and Y mounting holes
        for(i=[1:2:2*size[0]]) translate([i*beamSize/2, beamSize/2, 2*thickness+.1]) rotate([180, 0, 0]) cylinder(d=M4hole, h=thickness+.2);
#        for(i=[1:2:2*size[1]]) translate([beamSize/2,i*beamSize/2, 2*thickness+.1]) rotate([180, 0, 0]) cylinder(d=M4hole, h=thickness+.2);

    // Inner corner bearing, for belt from stepper; can be as close to the beam as possible
    translate([beamSize+7/*screw in corner bracket*/+cornerBearing[1]/2+xyBeltThickness,
                beamSize+7+cornerBearing[1]/2+xyBeltThickness,
                -.5]) {
        polyhole(d=M5tap, h=20+thickness+1);
        // Virtual bearings
        *%polyhole(d=cornerBearing[1], h=cornerBearing[2]*4);
        // Virtual belt
        *%color("black", 0.5) translate([-cornerBearing[1]/2 -xyBeltThickness, -cornerBearing[1]/2 -xyBeltThickness, 0]) cube([yBeamLength-100, xyBeltThickness, 6]);
    }


    // Outer corner bearing, for belt from stepper; can be as close to the beam as possible
    translate([beamSize+beamClearance+xyStepper[0]/2+xyPulleySizeWithBelt/2+cornerBearing[1]/2,
                beamSize+7+cornerBearing[1]/2+xyBeltThickness,
                -.5]) {
        polyhole(d=M5tap, h=20+thickness+1);
        // Virtual bearings
        *%polyhole(d=cornerBearing[1], h=cornerBearing[2]*4);
        // Virtual belt
        *%color("black", 0.5) translate([-cornerBearing[1]/2 -xyBeltThickness, -cornerBearing[1]/2 -xyBeltThickness, 0]) cube([yBeamLength-100, xyBeltThickness, 6]);
    }


        // Bearing screw tap
*        translate([beamSize+beamClearance+xyStepper[0]/2+xyPulleySize/2+xyBeltThickness+xyBearing[1]/2,beamSize+beamClearance+xyBearing[1]/2+xyBeltThickness,thickness-.1])
            polyhole(d=M8tap, h=2*thickness+.2);

*        translate([beamSize+beamClearance+xyStepper[0]/2+xyPulleySize/2+xyBeltThickness,beamSize+beamClearance+B625[1]/2+xyBeltThickness,thickness-.1])
            polyhole(d=M5tap, h=2*thickness+.2);

*        translate([beamSize+beamClearance+xyStepper[0]/2-2+xyBeltThickness,beamSize+beamClearance+B624[1]/2+xyBeltThickness,thickness-.1])
            polyhole(d=M4tap, h=2*thickness+.2);

*        translate([beamSize+beamClearance+B625[0]+xyBeltThickness,beamSize+beamClearance+B625[1]/2+xyBeltThickness,thickness-.1])
            polyhole(d=M4tap, h=2*thickness+.2);

    }
}

// To reduce belt slack on the X and Y axises
module xBeltGuide() {
    xBeltGuideLength=100;
    xBeltGuideRampLength=xBeltGuideLength/7;
    difference() {
        union() {
            cube([xBeltGuideLength,beamSize+9+thickness,thickness]);
            color("green") hull() {
                // Inner wall
                translate([xBeltGuideRampLength, beamSize+6-thickness, 0]) {
                    cube([xBeltGuideLength-xBeltGuideRampLength*2, thickness, beamSize]);
                }
                for(x=[1,xBeltGuideLength-1])
                    translate([x, beamSize+6-thickness, 0])
                        cylinder(d=2, h=beamSize);
            }
            color("green") hull() {
                // Outer wall
                translate([xBeltGuideRampLength, beamSize+9, 0])
                    cube([xBeltGuideLength-xBeltGuideRampLength*2, thickness, beamSize]);
                for(x=[1,xBeltGuideLength-1])
                    translate([x, beamSize+9+thickness-1, 0])
                        cylinder(d=2, h=beamSize);
            }
        }
        for(x=[10,xBeltGuideLength-10])
            translate([x, beamSize/2, -.5])
                polyhole(d=M4hole, h=thickness+1);
    }
}


/*** CoreXY v1 only ***/

// X/Y Guide rail bracket (CoreXY v1) for a horizontal X axis
// TODO: Remove dependency on beamSize (move origin) so it lays flat on the origin+beamClearance
module xyGuideBracketV1() {
    difference() {
        union() {
            hull() {

                // Left bearing foundation
                translate([beamSize+beamClearance, beamSize, beamSize+beamClearance])
                    cube([thickness+yBearing[1]+thickness, yBearing[2], thickness]);
                // Left bearing shell
                translate([beamSize+yRodBeamOffset, beamSize, beamSize+yRodBeamOffset])
                    rotate([-90,0,0])
                        polyhole(d=yBearingShellDiameter, h=yBearing[2]);

                // X rod shell
                hull() {
                    // Foundation
                    translate([xRodMinimumXOffset, beamSize+(xyGuideBracketWidth-xRodDistance)/2 -xBearing[1]/2, beamSize+beamClearance])
                        cube([xGuideLengths, xBearing[1], thickness]);
                    translate([xRodMinimumXOffset, beamSize+(xyGuideBracketWidth-xRodDistance)/2, beamSize+thickness+xBearing[1]/2])
                        rotate([-90,0,-90])
                            cylinder(d=xBearing[1], h=xGuideLengths);
                    // Roof
                    translate([xRodMinimumXOffset, beamSize+(xyGuideBracketWidth-xRodDistance)/2 -xBearing[1]/2, beamSize+beamClearance+yBearingShellDiameter-thickness])
                        cube([xGuideLengths, xBearing[1], thickness]);
                }
            }

            // Virtual X rod
            %translate([xRodCalculatedXOffset, beamSize+(xyGuideBracketWidth-xRodDistance)/2, beamSize+thickness+xBearing[1]/2])
                rotate([-90,0,-90])
                    cylinder(d=xBearing[0], h=xRodLength);


            // Wall connecting X rods with Y bearings
            translate([beamSize+yRodBeamOffset+thickness+yBearing[1]/2, beamSize+(xyGuideBracketWidth-xRodDistance)/2-xBearing[0]/2, beamSize+beamClearance])
                cube([thickness*4, xRodDistance+xBearing[0], /*2*max(yBearing[1]+2*thickness, 2*yRodBeamOffset)/3*/ yBearing[1]+thickness-beamClearance]);

            // Reinforcements
            translate([beamSize+yRodBeamOffset+thickness+yBearing[1]/2, beamSize+yBearing[2]-1, beamSize+beamClearance])
                rotate([0,0,90])
                    convexCorner(h=yBearing[1]+thickness-beamClearance, r=30);
            translate([beamSize+yRodBeamOffset+thickness+yBearing[1]/2, beamSize+xyGuideBracketWidth-yBearing[2]+1, beamSize+beamClearance])
                rotate([0,0,180])
                    convexCorner(h=yBearing[1]+thickness-beamClearance, r=30);
            translate([beamSize+yRodBeamOffset+thickness+yBearing[1]/2+4*thickness, beamSize+(xyGuideBracketWidth-xRodDistance)/2+xBearing[1]/2-1, beamSize+beamClearance])
                rotate([0,0,0])
                    convexCorner(h=yBearing[1]+thickness-beamClearance, r=30);
            translate([beamSize+yRodBeamOffset+thickness+yBearing[1]/2+4*thickness, beamSize+xyGuideBracketWidth-(xyGuideBracketWidth-xRodDistance)/2-xBearing[1]/2+1, beamSize+beamClearance])
                rotate([0,0,270])
                    convexCorner(h=yBearing[1]+thickness-beamClearance, r=30);


            hull() {
                // Right bearing foundation
                translate([beamSize+beamClearance, beamSize+xyGuideBracketWidth-yBearing[2], beamSize+beamClearance])
                    cube([thickness+yBearing[1]+thickness, yBearing[2], thickness]);
                // Right bearing shell
                translate([beamSize+yRodBeamOffset, beamSize+xyGuideBracketWidth-yBearing[2], beamSize+yRodBeamOffset])
                    rotate([-90,0,0])
                        cylinder(d=yBearingShellDiameter, h=yBearing[2]);
                // X rod shell
                hull() {
                    // Foundation
                    translate([xRodMinimumXOffset, beamSize+xyGuideBracketWidth-(xyGuideBracketWidth-xRodDistance)/2- xBearing[1]/2, beamSize+beamClearance])
                        cube([xGuideLengths, xBearing[1], thickness]);
*                   translate([xRodMinimumXOffset, beamSize+xyGuideBracketWidth-(xyGuideBracketWidth-xRodDistance)/2, beamSize+thickness+xBearing[1]/2])
                        rotate([-90,0,-90])
                            cylinder(d=xBearing[1], h=xGuideLengths);
                    // Roof
                    translate([xRodMinimumXOffset, beamSize+xyGuideBracketWidth-(xyGuideBracketWidth-xRodDistance)/2 -xBearing[1]/2, beamSize+beamClearance+yBearingShellDiameter-thickness])
                        cube([xGuideLengths, xBearing[1], thickness]);
                }
            }
            // Virtual X rod
            %translate([xRodCalculatedXOffset, beamSize+xyGuideBracketWidth-(xyGuideBracketWidth-xRodDistance)/2, beamSize+thickness+xBearing[1]/2])
                rotate([-90,0,-90])
                    cylinder(d=xBearing[0], h=xRodLength);

       }

        // Linear bearing holes
        translate([beamSize+yRodBeamOffset, beamSize-1, beamSize+yRodBeamOffset])
            rotate([-90,0,0])
                cylinder(d=yBearing[1]+0.35, h=xyGuideBracketWidth+2);

        // First X rod hole
        translate([xRodCalculatedXOffset-2*thickness, beamSize+(xyGuideBracketWidth-xRodDistance)/2, beamSize+thickness+xBearing[1]/2])
            rotate([-90,0,-90])
                cylinder(d=xBearing[0]+0.25, h=xGuideLengths);
        // First X top M3 tap
        translate([beamSize+yRodBeamOffset+yBearing[1]/2+1, beamSize+(xyGuideBracketWidth-xRodDistance)/2, beamSize-1])
            #cylinder(d=M3tap, h=yBearing[1]+2*thickness+2);

        // Belt bearing hole
        *translate([beamSize+beamClearance+xyStepper[0]/2+xyPulleySizeWithBelt/2+B608[1]/2, beamSize+xyGuideBracketWidth/2+25, beamSize-1]) {
            #cylinder(d=M8tap, h=yBearing[1]+2*thickness+2);
            // Virtual bearing for belt guide
            %translate([0,0,1+beamClearance-1-B608[2]]) cylinder(d=B608[1], h=B608[2]);
        }


        // First X top M4 tap
        translate([beamSize+yRodBeamOffset+yBearing[1]/2+18, beamSize+(xyGuideBracketWidth-xRodDistance)/2, beamSize-1])
            #cylinder(d=M4tap, h=yBearing[1]+2*thickness+2);

        // Y bearing bottom M4 tap
        translate([beamSize+yRodBeamOffset, beamSize+(xyGuideBracketWidth-xRodDistance)/2, beamSize-1])
            #cylinder(d=M4tap, h=yRodBeamOffset);


        // Middle belt bearing hole
        translate([beamSize+beamClearance+xyStepper[0]/2+xyPulleySizeWithBelt/2+xyBearing[1]/2, beamSize+xyGuideBracketWidth/2, beamSize-1]) {
            #cylinder(d=M5tap, h=yBearing[1]+2*thickness+2);
            // Virtual bearing for belt guide
            %translate([0,0,-4/*corner bracket compensation*/-xyBearing[2]*2-1]) cylinder(d=xyBearing[1], h=xyBearing[2]*2+2);

            // Virtual belt
            %color("red", 0.5) translate([-xyBearing[1]/2, -xyBearing[1]/2-xyBeltThickness, -4/*corner bracket compensation*/ -xyBearing[2]])
                cube([40, xyBeltThickness, 6]);
            %color("blue", 0.5) translate([-xyBearing[1]/2, xyBearing[1]/2, -4/*corner bracket compensation*/ -xyBearing[2]*2-2])
                cube([40, xyBeltThickness, 6]);

            %color("blue", 0.5) translate([-xyBearing[1]/2-xyBeltThickness, xyBearing[1]/2-xyGuideBracketWidth/2, -4/*corner bracket compensation*/ -xyBearing[2]*2-2])
                cube([xyBeltThickness, xyGuideBracketWidth/2, 6]);

        }


        // Second X rod
        translate([xRodCalculatedXOffset-2*thickness, beamSize+xyGuideBracketWidth-(xyGuideBracketWidth-xRodDistance)/2, beamSize+thickness+xBearing[1]/2])
            rotate([-90,0,-90])
                cylinder(d=xBearing[0]+0.25, h=xGuideLengths);
        // Second X top M3 tap
       translate([beamSize+yRodBeamOffset+yBearing[1]/2+1, beamSize+xyGuideBracketWidth-(xyGuideBracketWidth-xRodDistance)/2, beamSize-1])
            #cylinder(d=M3tap, h=yBearing[1]+2*thickness+2);

        // Belt bearing hole
*        translate([beamSize+beamClearance+xyStepper[0]/2+xyPulleySizeWithBelt/2+B608[1]/2, beamSize+xyGuideBracketWidth/2-25, beamSize-1]) {
            #cylinder(d=M8tap, h=yBearing[1]+2*thickness+2);
            // Virtual bearing for belt guide
            %translate([0,0,1+beamClearance-1-B608[2]]) cylinder(d=B608[1], h=B608[2]);
        }

        // Second X top M4 tap
       translate([beamSize+yRodBeamOffset+yBearing[1]/2+18, beamSize+xyGuideBracketWidth-(xyGuideBracketWidth-xRodDistance)/2, beamSize-1])
            #cylinder(d=M4tap, h=yBearing[1]+2*thickness+2);
        // Y bearing bottom M4 tap
       translate([beamSize+yRodBeamOffset, beamSize+xyGuideBracketWidth-(xyGuideBracketWidth-xRodDistance)/2, beamSize-1])
            #cylinder(d=M4tap, h=yRodBeamOffset);
    }
}
