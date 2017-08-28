/**
 * CoreXY v2
 * X axis modules
 *
 *   -- noah@hack.se, 2016-2017
 */

// Sizes for bearing, screw holes/taps, ..
include <defs.scad>
// Printer configuration
include <config.scad>

// Modules
use <helpers.scad>


// Print statements for CoreXY v2
*!xCarriageV2();
*!xCarriageExtruder();
*!xCarriageOnly();
*!xCarriagePrint();
*!xCarriageV2BeltFastener();
*!partCoolingFanTemporaryMount();
*!partCoolingFanDeflector();
*!extruderMount();  // Scrapped
// Print statements for CoreXY v1
*!xCarriageV1Fastener();
*!xCarriageV1();

// Print helpers
module xCarriageV2Only() {
    rotate([90,0,0])
        difference() {
            xCarriageV2();
            translate([-15, -150, -xBearing[1]-2*thickness-.5])
                cube([150,150,150]);
        }
}
module xCarriageV2Extruder() {
    rotate([270,0,270])
        difference() {
            xCarriageV2();
            translate([-15, 0, -xBearing[1]-2*thickness-.5])
                cube([150,150,150]);
        }
}
module xCarriagePrint() {
    *translate([0,xRodDistance,0])
        xCarriageV2Only();
    translate([90,86,0])
        xCarriageV2Extruder();
}


// X carriage for E3D Titan Extruder and E3D V6 hotend
module xCarriageV2() {
    // E3D v6 Hotend drawing, total height: 63.5, of which 13.9 is hidden inside titan and 49.6 extend out from it
    // https://wiki.nut/images/1/15/V6-175-ASSM.pdf
    // https://wiki.e3d-online.com/images/b/b5/V6-175-SINK.pdf
    // http://files.e3d-online.com/Titan/Titan%20Assembly%20Supplementary.pdf
    eStepperSize = 42.3;
    // http://files.e3d-online.com/Titan/Titan%20Assembly%20Supplementary.pdf
    extruderOffset = xCarriageWidth/2-11.1-eStepperSize/2;  // offset in X direction for NEMA17 motor axle
    hotendXOffset = xCarriageWidth/2;
    hotendYOffset = -15.5;
    titanThickness = 28;

    // BLtouch - https://locxess.de/3d/BLTouch_Anleitung_englisch.pdf
    BLtouchWidth  = 26;
    BLtouchHeight = 11.53;
    BLtouchHoleDistance = 18;
    BLtouchXOffset = xCarriageWidth/2+(15/*heat block end from nozzle*/+15/*bltouch safe distance*/)+BLtouchHeight/2;

    beltFastenerOffset = xBearing[1]/2+thickness;
    // For belt fasteners/extension
    radius=4;
    extensionWidth = 8;
    // Extruder footer width
    extruderFooterWidth=29;

    difference() {
        union() {
            // E3D Titan extruder
            %translate([2+extruderOffset,-2,eStepperSize]) rotate([90,0,0])  import("E3D_Titan.stl");
            // E3D v6 Hotend
            %translate([32+extruderOffset,hotendYOffset,-9.7+1]) mirror([1,0,0])
                rotate([90,0,0])
                    import("E3D_V6_1.75mm_Universal_HotEnd_Mockup.stl");
            // BL-Touch
            %translate([BLtouchXOffset,hotendYOffset,-thickness+1 /* Must be 1mm above hotend fins */])
                rotate([180,0,270])
                    import("BLTouch_extracted.stl");

            // Place bearing shells
            for(offset=[0, xCarriageWidth-xBearing[2]]) {
                translate([offset,xBearing[1]/2+thickness,-xBearing[1]/2-thickness])
                    rotate([-90,0,-90])
                        cylinder(d=xBearing[1]+2*thickness, h=xBearing[2]);
                translate([offset,xBearing[1]/2+thickness,-xBearing[1]/2-thickness+xRodDistance])
                    rotate([-90,0,-90])
                        cylinder(d=xBearing[1]+2*thickness, h=xBearing[2]);
            }
            // Plate connecting bearing shells
            translate([0,0,-xBearing[1]/2-thickness])
                cube([xCarriageWidth, thickness, xRodDistance]);

            // Extension to plate with rounded corners
            hull() {
                for(x=[-1,1]) {
                    for(z=[-thickness+radius,
                        -thickness-xBearing[1]/2+xRodDistance/2 /* xCarriage z center */
                        -xRodZShift+5+xyBearing[2]*4+1+radius]) {
                        translate([xCarriageWidth/2+x*(xCarriageWidth/2+extensionWidth-radius), -2, z])
                            rotate([270,0,0])
                                cylinder(r=radius, h=2+thickness);
                    }
                }
            }

            // Belt fastener
            for(x=[-1,1]) {
                // Belt fastener bar
                hull() {
                    for(z=[
                        -thickness-xBearing[1]/2+xRodDistance/2 /* xCarriage z center */
                        -xRodZShift+5-1-radius,
                        -thickness-xBearing[1]/2+xRodDistance/2 /* xCarriage z center */
                        -xRodZShift+5+xyBearing[2]*4+1+radius]) {
                        translate([xCarriageWidth/2+x*(xCarriageWidth/2+extensionWidth-radius), 0, z]) {
                            rotate([270,0,0]) {
                                cylinder(r=3, h=xBearing[1]/2+thickness-1);
                            }
                        }
                    }
                }
                // Belt fastener standoff
                for(z=[
                    -thickness-xBearing[1]/2+xRodDistance/2 /* xCarriage z center */
                    -xRodZShift+5-1-radius,
                    -thickness-xBearing[1]/2+xRodDistance/2 /* xCarriage z center */
                    -xRodZShift+5+xyBearing[2]*4+1+radius]) {
                    translate([xCarriageWidth/2+x*(xCarriageWidth/2+extensionWidth-radius), 0, z]) {
                        rotate([270,0,0]) {
                            cylinder(r=3, h=xBearing[1]/2+thickness-1+1);
                        }
                    }
                }

                // X endstop mounting plate
                centerOffset=11.2+eStepperSize/2+1;
                endstopWidth=(xCarriageWidth+2*extensionWidth)/2-centerOffset;
                translate([xCarriageWidth/2+x*(centerOffset+endstopWidth/2)-endstopWidth/2,
                    0,
                    -thickness-xBearing[1]/2+xRodDistance/2-1*xRodZShift-radius-7-3])
                    cube([endstopWidth,xBearing[1]+2*thickness, 3]);
            }

            // Virtual belts
            %translate([-30, thickness+xBearing[1]/2,
                -thickness-xBearing[1]/2+xRodDistance/2 /* xCarriage z center */
                -xRodZShift+5])
                cube([60+xCarriageWidth,1.5,6]);
           %translate([-30, thickness+xBearing[1]/2,
                -thickness-xBearing[1]/2+xRodDistance/2 /* xCarriage z center */
                -xRodZShift+5+2*xyBearing[2]])
                cube([60+xCarriageWidth,1.5,6]);

            // Extruder foot
            translate([xCarriageWidth/2-11.1+5/2-24-1, -extruderFooterWidth, -thickness])
                cube([-1*min(0, xCarriageWidth/2-11.1+5/2-24-1)+BLtouchXOffset+BLtouchHeight/2+1, extruderFooterWidth, thickness]);
            // Footer reinforcement on both sides of the Titan extruder
            for(x=[xCarriageWidth/2-11.1+5/2-24-1, xCarriageWidth/2-11.1+5/2+24+1]) {
                hull() {
                    // top
                    translate([x, -2, eStepperSize/2])
                        rotate([270,0,0])
                            cylinder(d=2, h=thickness);
                    // origin
                    translate([x, 0, -thickness])
                        cylinder(d=2, h=thickness+1);
                    // footer edge
                    translate([x, -extruderFooterWidth+2/2, -thickness])
                        cylinder(d=2, h=thickness+1);
                }
            }

            // Virtual xyBracketV3
            %for(offset=[0, xCarriageWidth+15.5+0.5]) {
                translate([-15.5+offset, xBearing[1]/2-xBearing[0]/2, xRodDistance-xBearing[1]-thickness])
                    cube([15, xBearing[0]+2*thickness, xBearing[0]+2*thickness]);
                translate([-15.5+offset, xBearing[1]/2-xBearing[0]/2, -2*thickness-xBearing[1]/2-xBearing[0]/2])
                    cube([15, xBearing[0]+2*thickness, xBearing[0]+2*thickness]);
            }

        }

        // Remove material in X bearing shells
        for(offset=[0, xCarriageWidth-xBearing[2]]) {
            // Bearing holes
            translate([offset-.5,xBearing[1]/2+thickness,-xBearing[1]/2-thickness])
                rotate([-90,0,-90])
                    polyhole(d=xBearing[1]+.1, h=xBearing[2]+1);
            translate([offset-.5,xBearing[1]/2+thickness,-xBearing[1]/2-thickness+xRodDistance])
                rotate([-90,0,-90])
                    polyhole(d=xBearing[1]+.1, h=xBearing[2]+1);

            // Slot for X axis
            translate([offset-.5,xBearing[1]/2+thickness,-xBearing[1]/2-thickness-xBearing[0]/2])
                cube([xBearing[2]+1, xBearing[1]+.5, xBearing[0]]);
            translate([offset-.5,xBearing[1]/2+thickness,-xBearing[1]/2-thickness+xRodDistance-xBearing[0]/2])
                cube([xBearing[2]+1, xBearing[1]+.5, xBearing[0]]);
        }

        // Belt fastener and extruder faceplate screw holes
        for(x=[-1,1]) {
            for(z=[
                -thickness-xBearing[1]/2+xRodDistance/2 /* xCarriage z center */
                -xRodZShift+5-1-radius,
                -thickness-xBearing[1]/2+xRodDistance/2 /* xCarriage z center */
                -xRodZShift+5+xyBearing[2]*4+1+radius]) {

                translate([xCarriageWidth/2+x*(xCarriageWidth/2+extensionWidth-radius), -thickness-.5, z]) {
                    rotate([270,0,0]) {
                        polyhole(d=M3tap, h=10+2*thickness+1);
                    }
                }
                // Use M3 holes in extruder face plate
                translate([xCarriageWidth/2+x*(xCarriageWidth/2+extensionWidth-radius), -thickness-.5, z]) {
                    rotate([270,0,0]) {
                        polyhole(d=M3hole, h=thickness+0.5);
                    }
                }
            }
        }

        // Extra screw next to extruder stepper
        for(y=[6,16]) {
            translate([xCarriageWidth/2-11.1+eStepperSize/2+5+y, 0, eStepperSize/2])
                rotate([270,0,0])
                    polyhole(d=M3tap, h=thickness+1);
            translate([xCarriageWidth/2-11.1+eStepperSize/2+5+y, -thickness, eStepperSize/2])
                rotate([270,0,0])
                    polyhole(d=M3hole, h=thickness);
        }

        // NEMA17 cutout to make a 2mm thick mounting plate for the Titan extruder
        nemaCornerRadius=3;
        hull() for(x=[-1,1]) for(z=[-1,1])
            translate([hotendXOffset-11.1+x*(eStepperSize+1.2)/2-x*nemaCornerRadius, 0, -1.2/2+(eStepperSize+1.2)/2+z*(eStepperSize+1.2)/2-z*nemaCornerRadius])
                rotate([270,0,0])
                    cylinder(r=nemaCornerRadius, h=thickness+xBearing[1]);

        // Connector cut-out to allow removing of motor
        translate([hotendXOffset-11.1+eStepperSize/2, 0, eStepperSize/2-1.2/2-18/2])
            cube([6,thickness, 18]);
        // NEMA17 holes
        translate([hotendXOffset-11.1, -thickness-.5, eStepperSize/2-1.2/2]) {
            // Axle
            rotate([270,0,0])
                polyhole(d=NEMA17[5]+2 /* allow some slack */, h=thickness*2+1);
            // Screw holes
            for(x=[-1,1])
                for(z=[-1,1])
                    translate([NEMA17[4]*x, 0, NEMA17[4]*z])
                        rotate([270,0,0])
                            polyhole(d=M3hole+1.5 /* allow some slack */, h=2*thickness+1);
        }
        // Remove a thin layer from the footer to account for irregularities
        translate([hotendXOffset-11.1-(eStepperSize+1.2)/2, -extruderFooterWidth, -0.1])
            cube([eStepperSize+1.2+5, extruderFooterWidth-2, 0.1]);

        // Extruder footer
        // Hotend hole
        hull() {
            translate([hotendXOffset, hotendYOffset, -thickness-.5])
                polyhole(d=16+0.2, h=thickness+1);
            translate([hotendXOffset, -extruderFooterWidth, -thickness-.5])
                polyhole(d=16+0.2, h=thickness+1);
        }

        // Mounting of BL-Touch in extruder foot
        // Remove 1mm material for Bl-Touch mount
        translate([BLtouchXOffset-BLtouchHeight/2-0.5, -extruderFooterWidth, -thickness])
            cube([BLtouchHeight+4, extruderFooterWidth, 1]);
        // BL-Touch: mounting holes
        for(y=[-1,0,1]) translate([BLtouchXOffset, -16+y*BLtouchHoleDistance/2, -thickness])
            polyhole(d=M3hole, h=thickness+1);

        // LED holes
        for(y=[-1,0,1])
            translate([xCarriageWidth/2+21, -extruderFooterWidth/2+10*y, -thickness-.5])
                polyhole(d=M3hole+.2, h=thickness+1);


    }
}

module xCarriageV2BeltFastener() {
    radius=4;
    //rotate([90,0,180])
    difference() {
        union() {
            // Belt fastener standoff
            hull() for(z=[
                -thickness-xBearing[1]/2+xRodDistance/2 /* xCarriage z center */
                -xRodZShift+5-1-radius,
                -thickness-xBearing[1]/2+xRodDistance/2 /* xCarriage z center */
                -xRodZShift+5+xyBearing[2]*4+1+radius]) {
                translate([0, 0, z]) {
                    rotate([270,0,0]) {
                        cylinder(r=3, h=thickness);
                    }
                }
            }
        }

        for(x=[-2,0,2]) {
            translate([x-0.5, thickness-1,
            -thickness-xBearing[1]/2+xRodDistance/2 /* xCarriage z center */
            -xRodZShift+5-2])
                cube([1,1.5,xyBearing[2]*4+4]);
        }

        for(z=[
            -thickness-xBearing[1]/2+xRodDistance/2 /* xCarriage z center */
            -xRodZShift+5-1-radius,
            -thickness-xBearing[1]/2+xRodDistance/2 /* xCarriage z center */
            -xRodZShift+5+xyBearing[2]*4+1+radius]) {

            translate([0, -.5, z]) {
                rotate([270,0,0]) {
                    polyhole(d=M3hole, h=thickness+1);
                }
            }
        }
    }
}

// Part cooling fan thing for xCarriageV2()
module partCoolingFanTemporaryMount() {
    tiltDegrees=70;
    difference() {
        union() {
            translate([0,-10,0])
                cube([10, 10+20, 3]);
            hull() {
                translate([0,-10,0]) rotate([tiltDegrees,0,0])
                    cube([10, 10, 6]);
                translate([0,-12,0]) rotate([0,0,0])
                    cube([10, 8, 6]);
            }
        }
        for(y=[-1,0,1]) translate([10/2, 7+y*18/2, -.5]) polyhole(d=M3tap, h=15);
        for(y=[-1,0,1]) translate([10/2, 7+y*18/2, 3]) polyhole(d=6.5, h=10);
        translate([10/2,-4,2]) rotate([tiltDegrees,0,0])
            polyhole(d=M3tap, h=15);
    }
}

// Deflector for xCarriageV2, for 4010mm laptop fan
module partCoolingFanDeflector() {
    difference() {
        union() {
            translate([-2,0,0]) cube([2+40+5,40,3]);
            translate([40+1,0,3]) cube([4,40,12]);
*            translate([-10,0,0]) rotate([-90,0,0]) cylinder(d=10,h=40);
            // Reinforcement screw holes
            for(x=[-1,1],y=[-1,1])
                translate([20+x*35/2, 20+y*35/2,0]) cylinder(d=7,3);
            // Deflector
            hull() {
                translate([-5,0,0]) cube([1,40,3]);
                translate([0,0,0]) rotate([0,-45,0])cube([2,40,15]);
            }
        }
*        translate([-10,0,0]) rotate([-90,0,0]) cylinder(d=6,h=40);
        // Fan Screw holes
        for(x=[-1,1],y=[-1,1])
            translate([20+x*35/2, 20+y*35/2,-.5]) cylinder(d=3,5);
        // BLtouch mounting holes
        for(y=[-1,0,1])
            translate([40,40/2+8+y*18/2,3+6])
                rotate([0,90,0]) cylinder(d=3.5,h=6);
        // Remove material
        translate([20,20,-.5]) cylinder(d=30,h=5);
        translate([-8-10,-.5,0]) cube([10,40+1,30]);
    }

}

// Scrapped
module extruderMount() {
    // For belt fasteners/extension
    radius=5;
    extraWidth=11-radius;
    totalWidth = extraWidth*2+xCarriageWidth;
    mountWidth = 30; // Titan is 27.3 thick including bolts, fan is 30mm

    eStepperSize = 43.2;
    extruderOffset = xCarriageWidth/2-eStepperSize/2-11;  // offset in X direction

    difference() {
        union() {
            // Extension to plate for belt fasteners
            hull() {
                for(x=[-1,1]) {
                    for(y=[-1,1]) {
                        translate([-extraWidth+totalWidth/2+x*totalWidth/2, 0, xRodDistance/2-xBearing[1]/2-thickness+y*(xRodDistance/2-radius-3*thickness)])
                            rotate([270,0,0])
                                cylinder(r=radius, h=thickness);
                    }
                }
            }
            *translate([0,0,0])
                cube([xCarriageWidth,26,thickness]);
        }

        // Belt fastener
        for(x=[-1,1]) {
            for(y=[-1,1]) {
                translate([-extraWidth+totalWidth/2+x*totalWidth/2, -.5, xRodDistance/2-xBearing[1]/2-thickness+y*(xRodDistance/2-radius-3*thickness)-y*3]) {
                    rotate([270,0,0]) {
                        polyhole(d=M3tap, h=10+thickness+1);
                    }
                }
            }
        }

        // NEMA17 cutout to make a 2mm thick mounting plate for the Titan extruder
        translate([extruderOffset, 2, -xBearing[1]/2-thickness+xRodDistance/2-NEMA17[1]/2])
            cube([NEMA17[0], thickness, NEMA17[1]]);
        translate([extruderOffset+eStepperSize/2, -.5, -xBearing[1]/2-thickness+xRodDistance/2]) {
            rotate([270,0,0])
                polyhole(d=22+.5, h=thickness+1);
            for(x=[-1,1])
                for(z=[-1,1])
                    translate([NEMA17[4]*x, -.5, NEMA17[4]*z])
                        rotate([270,0,0])
                            polyhole(d=M3hole, h=thickness+1);
        }
    }
}


/*** CoreXY v1 only ***/

module xCarriageV1() {
    difference() {
        union() {
            // Foundation
            translate([0, -xBearing[1]/2, -xBearing[1]/2 -thickness +beamClearance])
                cube([xCarriageWidth,xCarriageHeight,thickness]);
            // Edge extensions
            translate([-5,-xBearing[1]/2+xCarriageHeight/2-15,-xBearing[1]/2 -thickness+beamClearance])
                cube([xCarriageWidth+2*5,30,thickness]);
            // First rod's bearing shells
            translate([0,0,0])
                rotate([-90,0,-90])
                    cylinder(d=xBearing[1]+2*thickness, h=xBearing[2]);
            translate([xCarriageWidth-xBearing[2],0,0])
                rotate([-90,0,-90])
                    cylinder(d=xBearing[1]+2*thickness, h=xBearing[2]);
            // Second rod's bearing shells
            translate([0,xRodDistance,0])
                rotate([-90,0,-90])
                    cylinder(d=xBearing[1]+2*thickness, h=xBearing[2]);
            translate([xCarriageWidth-xBearing[2],xRodDistance,0])
                rotate([-90,0,-90])
                    cylinder(d=xBearing[1]+2*thickness, h=xBearing[2]);


            // Virtual E3D Titan extruder
            %translate([74-2*8.5,49,-58+beamClearance]) rotate([90,180,0]) import("E3D_Titan.stl");
        }

        // Shave off bearing shell
        translate([-20, -20 -xBearing[1]/2, -xBearing[1]/2 -thickness +beamClearance -thickness])
            cube([120,120,thickness]);

        // First rod's bearings
        translate([-1,0,0])
            rotate([-90,0,-90])
                cylinder(d=xBearing[1]+.3, h=xCarriageWidth+2);
        // Second rod's bearings
        translate([-1,xRodDistance,0])
            rotate([-90,0,-90])
                polyhole(d=xBearing[1]+.3, h=xCarriageWidth+2);

        // Hotend hole
        translate([-8.5, -xBearing[1]/2, -xBearing[1]/2 -thickness])
            translate([xCarriageWidth/2, xCarriageHeight/2, -1])
                polyhole(d=16+1,h=xBearing[1]+2);

        // Hotend mounting holes
        for(x=[-31,-16,13,31]) {
        for(y=[-42,-19,0,19,42]) {
        translate([0, y-xBearing[1]/2, -xBearing[1]/2 -thickness])
            translate([xCarriageWidth/2 +x, xCarriageHeight/2, -1])
                polyhole(d=M3tap,h=thickness+1.5);
        translate([0, y-xBearing[1]/2, -xBearing[1]/2 -thickness])
            translate([xCarriageWidth/2 +x, xCarriageHeight/2, -1])
                polyhole(d=M3tap,h=thickness+1.5);
            }
        }
    }
}

// Belt fastener
// Centered around X axis
beltFastenerRadius=4;
beltFastenerHeight=12;
beltFastenerLength=15;
beltFastenerWidth=2*beltFastenerRadius+thickness+3;
module fastenerThing() {

    difference() {
        union() {
            // Part from hull around four corners
            hull() {
                translate([beltFastenerRadius, -beltFastenerWidth/2 +beltFastenerRadius, beltFastenerHeight/2])
                    cube([beltFastenerRadius*2,beltFastenerRadius*2, beltFastenerHeight],center=true);
                translate([beltFastenerRadius, /*xyBearing[1]+*/beltFastenerWidth/2 -beltFastenerRadius, beltFastenerHeight/2])
                    cube([beltFastenerRadius*2,beltFastenerRadius*2, beltFastenerHeight],center=true);
                translate([beltFastenerLength-beltFastenerRadius, -beltFastenerWidth/2 +beltFastenerRadius, 0])
                    cylinder(r=beltFastenerRadius,h=beltFastenerHeight);
                translate([beltFastenerLength-beltFastenerRadius, /*xyBearing[1]+*/beltFastenerWidth/2 -beltFastenerRadius, 0])
                    cylinder(r=beltFastenerRadius,h=beltFastenerHeight);
            }
        }

        hull() {
            // Outer teardrop
            beltFastenerRadius=beltFastenerRadius+1.7;
            translate([beltFastenerLength/3,0,thickness]) cylinder(r=beltFastenerRadius, h=beltFastenerHeight);
            translate([beltFastenerLength/3+sqrt(2*beltFastenerRadius*beltFastenerRadius),0,thickness]) cylinder(r=.5, h=beltFastenerHeight);
        }
        // Belt entry/exit
        translate([beltFastenerLength/3+sqrt(2*beltFastenerRadius*beltFastenerRadius),0,thickness+beltFastenerHeight/2])
            cube([beltFastenerLength,2.6,beltFastenerHeight+1], center=true);
        // Allow belt to be taken out
        cubeDepth=8;
        translate([-1,-cubeDepth/2,thickness])
            cube([cubeDepth,cubeDepth,beltFastenerHeight]);
    }


    // Inner teardrop column
    difference() {
        hull() {
            translate([beltFastenerLength/3,0,0]) cylinder(r=beltFastenerRadius, h=beltFastenerHeight-2);
            translate([beltFastenerLength/3,0,beltFastenerHeight-2]) cylinder(r1=beltFastenerRadius, r2=beltFastenerRadius-1, h=2);
            translate([beltFastenerLength/3+sqrt(2*beltFastenerRadius*beltFastenerRadius),0,0]) cylinder(r=.5, h=beltFastenerHeight-2);
        }
        *translate([beltFastenerLength/3,0,-.5])
            polyhole(d=M3tap, h=beltFastenerHeight+1);
    }
}

// X carriage belt fastener for V1
// Print with 100% infill
// Centered around X axis
module xCarriageV1Fastener() {
    difference() {
        union() {
            hull() {
                translate([beltFastenerLength/2, /*-beltFastenerWidth/2-earRadius*/ -19, 0]) {
                    cylinder(d=M3tap+2*thickness, h=thickness-1);
                }
                translate([0,-xyBearing[1]/2, 0])
                    cube([beltFastenerLength, xyBearing[1], thickness-1]);
                translate([beltFastenerLength/2, /*beltFastenerWidth/2+xyBearing[1]+earRadius*/19, 0]) {
                    cylinder(d=M3tap+2*thickness, h=thickness-1);
                }
            }

            translate([0, -5/2, 0]) cube([beltFastenerLength, 5, beltFastenerHeight]);

            translate([0,-xyBearing[1]/2,0]) fastenerThing();
            translate([0,xyBearing[1]/2,0]) scale([1,1,(beltFastenerHeight+8)/beltFastenerHeight]) fastenerThing();
        }
        // Mounting holes
        translate([beltFastenerLength/2, -19, -.5]) {
            polyhole(d=M3tap, h=thickness);
        }
        translate([beltFastenerLength/2, 0, -.5]) {
            polyhole(d=M3tap, h=thickness);
        }
        translate([beltFastenerLength/2, 19, -5.5]) {
            polyhole(d=M3tap, h=thickness+20);
        }
        // Hole for adjustment screw
        translate([beltFastenerLength+.5, 0, 2*beltFastenerHeight/3]) rotate([0,270,0]) {
            polyhole(d=M3tap, h=beltFastenerLength+1);
            polyhole(d=M3hole, h=beltFastenerLength/2);
        }
    }
}
