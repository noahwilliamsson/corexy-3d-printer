/**
 * CoreXY v2
 * Arduino Mega 2560 or Re-Arm for RAMPS + RAMPS brackets
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
*!arduinoBracket();
*!rearmForRampsEnclosure();
*!zeroviewBracket();


// Simple bracket to mount Arduino Mega2560+RAMPS to a top frame corner
module arduinoBracket() {
    difference() {
        earWidth=12;
        earHeight=11;
        earYBeamClearance = 52;
        boardXBeamClearance = 9;
        boardYBeamClearance = 9;
        union() {
            // Bottom bar and bottom left mounting ear
            hull() {
                translate([0,-thickness,0]) cube([board[0], thickness*3, thickness]);
                translate([-boardXBeamClearance-thickness, board[1]+boardYBeamClearance-earYBeamClearance -earWidth, 0])
                    cube([thickness, earWidth, thickness]);
            }
            translate([-boardXBeamClearance-thickness, board[1]+boardYBeamClearance-earYBeamClearance -earWidth, 0])
                cube([thickness, earWidth, thickness+earHeight]);

            // Left (bottom) bar
            translate([0,0,0]) cube([thickness*3, board[1], thickness]);
            // Top bar and wall
            translate([0,board[1]-thickness*3,0]) cube([board[0], thickness*3, thickness]);
            // Right bar and top right mounting ear
            hull() {
                translate([board[0]-thickness*3,0,0]) cube([thickness*3, board[1], thickness]);
                translate([board[0]-earWidth, board[1]+boardYBeamClearance-thickness, 0])
                    cube([earWidth, thickness, thickness]);
            }
            translate([board[0]-earWidth, board[1]+boardYBeamClearance-thickness, 0])
                cube([earWidth, thickness, thickness+earHeight]);

            // Extra mounting ear
            translate([board[0]-earWidth, -thickness, 0])
                cube([earWidth, thickness, thickness+earHeight]);

            // Fan ears
            for(fan=[0,1]) {
                translate([6+fan*40, -thickness, 0])
                    cube([earWidth, thickness, thickness+earHeight]);
                translate([6+fan*40+32, -thickness, 0])
                    cube([earWidth, thickness, thickness+earHeight]);
            }

            // Arduino standoffs
            for(hole = holes) {
                translate([hole[0], hole[1], thickness]) cylinder(d=M3tap+thickness, h=standoffHeight);
            }

            // Virtual Arduino (PCB, USB, barrel connector)
            %translate([0,0,thickness+standoffHeight]) cube([board[0], board[1], 2]);
            // For regular holes
            *%translate([6.35, 32.38, 2]) cube([15.87, 12.7, 13]);
            *%translate([1.90, 3.17, 2]) cube([13.33, 8.89, 13]);
            // For reverse holes
            %translate([92.08, 9.53, thickness+standoffHeight]) cube([15.87, 12.7, 13]);
            %translate([90.17, 41.28, thickness+standoffHeight]) cube([13.33, 8.89, 13]);
            // Virtual RAMPS board
            %translate([0,0,thickness+standoffHeight+13]) cube([board[0], board[1]+7, 2]);
        }

        for(hole = holes) {
            translate([hole[0], hole[1], -.5]) polyhole(d=M3tap, h=standoffHeight+1+40);
        }

        // Bottom left mounting ear hole
        translate([-boardXBeamClearance-thickness-.5, board[1]+boardYBeamClearance-earYBeamClearance -earWidth/2, thickness+earHeight/2])
            rotate([0,90,0])
                polyhole(d=M4hole, h=thickness+1);

        // Top right mounting ear hole
        translate([board[0]-earWidth/2, board[1]+boardYBeamClearance-thickness-.5, thickness+earHeight/2])
            rotate([-90,0,0])
                polyhole(d=M4hole, h=thickness+1);

        // Extra ear screw tap
        translate([board[0]-earWidth/2, +.5, thickness+earHeight/2])
            rotate([90,0,0])
                polyhole(d=M3tap, h=thickness+1);

        // Fan screw taps
        for(fan=[0,1]) {
            translate([6+earWidth/2 +fan*40, +.5, thickness+earHeight/2])
                rotate([90,0,0])
                    polyhole(d=M3tap, h=thickness+1);
            translate([6+earWidth/2 +fan*40+32, +.5, thickness+earHeight/2])
                rotate([90,0,0])
                    polyhole(d=M3tap, h=thickness+1);
            echo("Pos",x1=board[0]-earWidth/2 -fan*40,x2=board[0]-earWidth/2 -fan*40-32);
        }
    }
}

// WIP: enclosure for Re-ARM for Ramps+RAMPS 1.4
module rearmForRampsEnclosure() {
    width=78;
    depth=120;
    height=60;
    roofRounding=30;
    wallThickness=2;
    difference() {
        union() {
            %translate([-65+4+4,-45,-52+6]) import("Re-ARM_3D_assembly.stl");

            // Base plate
            cube([78, depth, 2]);
            // Roof
            *difference() {
                hull() {
                    for(x=[roofRounding/2,width-roofRounding/2])
                        translate([x,0,height-roofRounding/2])
                            rotate([0,90,90])
                                cylinder(d=roofRounding, h=depth);
                }

                hull() {
                    for(z=[0, -roofRounding/2])
                        for(x=[roofRounding/2+wallThickness,width-roofRounding/2-wallThickness])
                            translate([x,-.5,height-roofRounding/2-wallThickness+z])
                                rotate([0,90,90])
                                    cylinder(d=roofRounding, h=depth-wallThickness+.5);
                }
            }

            *translate([0,0,height-roofRounding/2]) difference() {
                translate([width/2, 0, 2+39]) rotate([0,90,90]) cylinder(d=78, h=depth);
                translate([width/2, -.5, 2+39]) rotate([0,90,90]) cylinder(d=78-4, h=depth+1);
                translate([2, -.5, 2]) cube([width-4, depth+1, 39]);
            }

            // Clips
            for(x=[0, 64]) for(y=[0, 68]) hull() {
                translate([2+x+4,7+y,2]) cube([2,30,6]);
                translate([3+x+4,7+y,2+4]) rotate([270,0,0]) cylinder(d=4, h=30);
                translate([3+x+4,7+y,2+4+3]) rotate([270,0,0]) cylinder(d=3, h=30);
            }

            // Bottom wall
            *cube([78, wallThickness, height-roofRounding/2]);
            // Top wall
            *translate([0, depth-wallThickness, 0]) cube([78, 2, height-roofRounding/2]);
            // Left wall
            difference() {
                union() {
                    // Top wall again
                    translate([0, depth-wallThickness, 0]) cube([78, 2, height-roofRounding/2]);
                    // Left wall and reinforcement
                    cube([wallThickness, depth, height-roofRounding/2]);
                    translate([5/2,0,height-roofRounding/2-6/2-0.5]) rotate([270,0,0]) polyhole(d=6, h=depth);
                    // Right wall and reinforcement
                    translate([width-wallThickness,0,0])cube([2,depth,height-roofRounding/2]);
                    translate([width-5/2+1,0,height-roofRounding/2-5/2-0.5]) rotate([270,0,0]) polyhole(d=5, h=depth);
                }
                // Kill 1x4mm on the left side and right side
                translate([-2,-.5,height-roofRounding/2-4]) cube([2+wallThickness, depth+1, 4+0.5]);
                translate([width-wallThickness,-.5,height-roofRounding/2-4]) cube([wallThickness+2, depth+1, 4+0.5]);
                // Make round cut-in on left and right side
                #translate([1, -.1, height-roofRounding/2-4.5/2-1]) rotate([270,0,0]) cylinder(d=4, h=depth+1, $fn=12);
                #translate([width-1, -.1, height-roofRounding/2-4.5/2-1]) rotate([270,0,0]) cylinder(d=4, h=depth+1, $fn=12);
            }
            // Right wall
            *translate([width-wallThickness,0,0])cube([2,depth,height-roofRounding/2]);
            *translate([width-wallThickness,0,height-roofRounding/2]) rotate([270,0,0]) cylinder(d=4, h=depth);

            // Standoff
            translate([59.5+5, 100, -1]) cylinder(d=6, h=5);
        }

        // Cut-out bottom to save material
        translate([8+4,8,-.5]) cube([70-2*8, 105-2*8, 4]);
        // Cutout in walls
        *translate([1.5,0,height-roofRounding/2]) rotate([270,0,0]) cylinder(d=3, h=depth);
        *translate([width-1.5,0,height-roofRounding/2]) rotate([270,0,0]) cylinder(d=3, h=depth);


        // Bottom wall cutouts:
        // Re-ARM: micro-USB, SD-card, power
        // RAMPS: EFB, power connector
        translate([10.5, -.5, 6]) cube([11, 3, 8]);
        translate([23.5, -.5, 6]) cube([15.5, 3, 8]);
 *       translate([40, -.5, 6]) cube([10, 3, 12]);
        translate([40+10/2, -.5, 8+10/2]) rotate([270,0,0]) #polyhole(d=10, h=4);

        translate([17, -.5, 19]) cube([28, 3, 13]);
        translate([47, -.5, 19]) cube([22, 3, 13]);

        // Left wall cut-outs
        translate([-.5, 15, 8]) cube([10, 10, 20]);
        translate([-.5, 40, 30]) cube([10, 10, 18]);
        translate([-.5, 65, 30]) cube([10, 10, 18]);
        translate([-.5, 85, 30]) cube([10, 10, 18]);

        // Clips cut-out
        for(x=[0, 64])
            for(y=[0, 68])
                translate([(!x? 5: 1.9)-.5+x+4, 7+y-.5, 6.5])
                    rotate([270,0,0])
                        polyhole(d=2, h=31);
        // Reset buttons
        translate([63, 8.5+1, 7+2]) cube([12,6,6]);
        translate([width-2-.5, 11.5+1, 10+2]) rotate([0,90,0]) polyhole(d=14, h=10);
        translate([63,8.5+27+2, 7+13+3]) cube([12+12,6,6]);
        translate([70, 11.5+27+2, 10+13+3]) rotate([0,90,0]) polyhole(d=14, h=10);

        // Re-ARM right pins
        translate([63,78,8]) cube([12+10,20,6]);
        // Standoff hole
        translate([59.5+5, 100, .5]) cylinder(d=M3tap, h=6);
        // Fan
        translate([width/2, depth-wallThickness-.5, height-3-40/2]) rotate([270,0,0]) {
            polyhole(d=37.5, h=3);
            for(x=[-1,1]) for(y=[-1,1]) translate([16*x, 16*y, 0]) polyhole(d=M3tap, h=3);
        }
    }
}

/*** CoreXY v1 only ***/

// To mount a Raspbery Pi Zero + camera on a Zeroview bracket to the frame */
module zeroviewBracket() {
    width = 115;
    keyHoleDistance = 95;
    height = 70;
    beamSize = 20;
    difference() {
        union() {
            // Base plate
            translate([0,0,0]) cube([beamSize/2+keyHoleDistance+beamSize/2, beamSize, thickness]);
            // Left arm and reinforcement
            translate([0, 0, 0]) cube([beamSize, beamSize+height, thickness]);
            translate([0, beamSize+thickness, thickness]) rotate([0, 90, 0]) cylinder(d=thickness*2, h=beamSize);
            // Right arm
            translate([keyHoleDistance, 0, 0]) cube([beamSize, beamSize+height, thickness]);
            translate([keyHoleDistance, beamSize+thickness, thickness]) rotate([0, 90, 0]) cylinder(d=thickness*2, h=beamSize);
            // Connect arms
            translate([0, beamSize+height, 0]) cube([beamSize/2+keyHoleDistance+beamSize/2, thickness, thickness]);
            // Z plate
            translate([0,beamSize,0]) cube([beamSize/2+keyHoleDistance+beamSize/2, thickness, beamSize+thickness]);
        }

        // Mounting holes base plate
        translate([beamSize/2, beamSize/2, -.5]) polyhole(d=M4hole, h=thickness+1);
        translate([beamSize/2+keyHoleDistance/2, beamSize/2, -.5]) polyhole(d=M4hole, h=thickness+1);
        translate([beamSize/2+keyHoleDistance, beamSize/2, -.5]) polyhole(d=M4hole, h=thickness+1);
        // Slot holes left arm
        for(x=[beamSize/2, beamSize/2+keyHoleDistance]) {
            hull() {
                translate([x, 2*beamSize, -.5]) polyhole(d=M4hole, h=thickness+1);
                translate([x, beamSize+height-beamSize/2, -.5]) polyhole(d=M4hole, h=thickness+1);
            }
        }

        // Mounting holes Z plate
        translate([beamSize/2, beamSize-.5, thickness+beamSize/2]) rotate([270,0,0]) polyhole(d=M4hole, h=thickness+1);
        translate([beamSize/2+keyHoleDistance/2, beamSize-.5, thickness+beamSize/2]) rotate([270,0,0]) polyhole(d=M4hole, h=thickness+1);
        translate([keyHoleDistance+beamSize/2, beamSize-.5, thickness+beamSize/2]) rotate([270,0,0]) polyhole(d=M4hole, h=thickness+1);
    }
}
