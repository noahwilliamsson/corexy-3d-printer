// inner diameter, outer diameter, length/height
lm8uu=[8,15,24];    // same as RJ4JP-01-08
lm8luu=[8,15,45];
rjmp0108=[8,16,25]; // RJMP-01-08

lm10uu=[10,19,29];  // same as RJ4JP-01-10
lm10luu=[10,19,55];
rjmp0110=[10,19,29]; // RJMP-01-10

lm12uu=[12,21,30];  // same as RJ4JP-01-12
lm12luu=[12,21,57];
rjmp0112=[12,22,32]; // RJMP-01-12

// Ball bearings (ID, OD (not considering flange), thickness, flange thickness)
B623=[3,10,5];
B624=[4,13,5];
F624=[4,13,5, 1];
B625=[5,16,5];
F625=[5,16,5, 1];
F695=[5,13,4, 1];
B626=[6,19,6];
B608=[8,22,7];

M2tap=1.85;
M3tap=2.85;
M3hole=3.6;
M4tap=3.9;
M4hole=4.6;
M5tap=4.8;
M5hole=5.4;
M8tap=7.5;

// X, Y, Height, axle diameter, half distance between two mounting holes, axle length
NEMA17=[43.2, 43.2, 50, 5, 31/2, 22];


// Wall thickness
thickness=4;
// Aluminium extrusion size
beamSize=20;

xBeamLength=500;
xRodLength=400;
xBearing=lm12uu;

yBeamLength=420;
yRodLength=400;
yBearing=lm12uu;

zBeamLength=360;
zRodLength=300;
zBearing=lm12uu;  // Guide rod
zLeadScrewBearing=B608;
zNut=[8,22,10.5, 8]; // ID, OD (flange), OD (cylinder), mounting hole center-to-center radius

// Bed beams
bedXBeamLength=360;
bedYBeamLength=420;


// Bearings for belt on xy guide bracket
xyBearing=F625;
// XY guide bracket clearance from beams
beamClearance=.5;
// Y rod offset from beam, should be > (yBearing[1]/2+thickness)
yRodBeamOffset=14;

// Corner bearings
cornerBearing=F695;

// Distance between X rods (center-to-center)
// Lulzbot, Adapto and other designs use 70mm distances
xRodDistance=70;
// Total width of X rod bracket that is sliding on the Y axis
// Should be at least xRodDistance+2*(xBearing[1]/2+thickness)
xyGuideBracketWidth=99;

xyStepper=NEMA17;
zStepper=NEMA17;
xyPulleySize=9.6;
xyPulleySizeWithBelt=11.6;
xyBeltThickness=1;

xCarriageWidth=70;
xCarriageHeight=xRodDistance+xBearing[1];
xRodMinimumXOffset=beamSize+yRodBeamOffset+yBearing[1]/2;
xRodCalculatedXOffset = beamSize+(xBeamLength-xRodLength)/2;
xGuideLengths=xRodCalculatedXOffset-xRodMinimumXOffset+10+thickness;
xTravel=beamSize+xBeamLength+beamSize-2*(xRodMinimumXOffset+xGuideLengths)-xCarriageWidth;
echo("INFO:",xTravel=xTravel, xRodMinimumXOffset=xRodMinimumXOffset, xRodCalculatedXOffset=xRodCalculatedXOffset, xGuideLengths=xGuideLengths);

yBearingShellDiameter = yBearing[1]+2*thickness < 2*(yRodBeamOffset-beamClearance)? yBearing[1]+2*thickness: 2*(yRodBeamOffset-beamClearance);
echo("Y bearing shell diameter", yBearing[1]+2*thickness, "can be at most", 2*(yRodBeamOffset-beamClearance),"with yRodBeamOffset",yRodBeamOffset,"and beamClearance",beamClearance);

if(yRodBeamOffset <= (yBearing[1]/2+thickness))
    echo("WARNING: yRodBeamOffset too small, need to be at least", (yBearing[1]/2+thickness));
if(xyGuideBracketWidth < xRodDistance+2*(xBearing[1]/2+thickness))
    echo("WARNING: xyGuideBracketWidth too small, need to be at least", xRodDistance+2*(xBearing[1]/2+thickness));


// https://blog.arduino.cc/2011/01/05/nice-drawings-of-the-arduino-uno-and-mega-2560/
ArduinoMega2560_Board=[101.6,53.4]; // X, Y
ArduinoMega2560_Holes=[
        [14, 2.54],  // bottom left
        [15.24, 50.8], // top left
//        [66.04, 7.62],  // bottom middle,
//        [66.04, 35.56],  // top middle,
        [96.52, 2.54],  // bottom right,
        [90.17, 50.8],  // top right,
];
ArduinoMega2560_ReverseHoles = [
    [11.43, 2.54],
    [86.36, 2.54],
//    [35.56, 17.78],
//    [35.56, 45.72],
    [5.08, 50.8],
    [87.63, 50.8]
];

// For the Arduino bracket
board = ArduinoMega2560_Board;
holes = ArduinoMega2560_ReverseHoles;
standoffHeight = 3;

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

// Scrapped
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

module bedDistance() {
    difference() {
        union() {
            cylinder(d=8,h=thickness);
            rotate(45) translate([-4,-6,0]) cube([8,12,thickness]);
        }
        translate([0,0,-.5]) cylinder(d=M3hole, h=thickness+1);
    }
}

// Top Z motor mounting bracket
// Centered around X axis
module zMotorBracket() {
    difference() {
        union() {
            hull() {
                // Under the beam
                translate([-beamSize-zStepper[0]/2,0,-thickness]) cube([beamSize+zStepper[0]+beamSize, beamSize+thickness, thickness]);
                translate([-zStepper[0]/2, beamSize+beamClearance, -thickness]) cube([zStepper[0], zStepper[1], thickness]);

                // Guide rod shell foundations
                translate([-35,beamSize+thickness+zBearing[1]/2, -thickness]) cylinder(d=zBearing[0]+2*thickness,h=thickness);
                translate([35,beamSize+thickness+zBearing[1]/2, -thickness]) cylinder(d=zBearing[0]+2*thickness,h=thickness);
            }

            // Guide bearing shells and grub screw spheres
            for(x=[-35,35]) {
                translate([x,beamSize+thickness+zBearing[1]/2, -thickness]) cylinder(d=zBearing[0]+2*thickness,h=zBearing[0]*2);
                translate([x+ (x>0? 1:-1)*(zBearing[0]/2+thickness/1.5),beamSize+thickness+zBearing[1]/2, -thickness+zBearing[0]])
                    sphere(r=thickness);
                translate([x,beamSize+thickness+zBearing[1]/2+zBearing[0]/2+thickness/1.5, -thickness+zBearing[0]])
                    sphere(r=thickness);
            }
        }

        // Stepper center hole
        translate([0, beamSize+beamClearance+zStepper[1]/2, -thickness-.5])
            polyhole(d=zStepper[5]+.5, h=thickness+1);
        // Stepper mounting holes
        for(x=[-zStepper[4], zStepper[4]])
            for(y=[-zStepper[4], zStepper[4]])
                translate([x, beamSize+beamClearance+zStepper[1]/2+y, -thickness-.5])
                    polyhole(d=M3hole, h=thickness+1);

        // Guide bearing shells and grub screw holes
        for(x=[-35,35]) {
            translate([x,beamSize+thickness+zBearing[1]/2, -thickness -.5]) polyhole(d=zBearing[0]+0.25,h=zBearing[2]+1);
            translate([x,beamSize+thickness+zBearing[1]/2, -thickness+zBearing[0]])
                rotate(x>0? [90,0,90]: [90,0,270]) polyhole(d=M3tap,h=zBearing[2]/2+thickness);
            translate([x,beamSize+thickness+zBearing[1]/2, -thickness+zBearing[0]])
                rotate([90,0,180]) polyhole(d=M4tap,h=zBearing[2]/2+thickness);
        }

        // Under the beam mounting holes
        translate([-beamSize/2-zStepper[0]/2, beamSize/2, -thickness-.5]) polyhole(d=M4hole, h=thickness+1);
        translate([0, beamSize/2, -thickness-.5]) polyhole(d=M4hole, h=thickness+1);
        translate([zStepper[0]/2+beamSize/2, beamSize/2, -thickness-.5]) polyhole(d=M4hole, h=thickness+1);
    }
}


module zGantryBracket() {
    difference() {
        union() {
            hull() {
                // Bottom mount
                translate([-45,0,0]) cube([90,beamSize+thickness,thickness]);
                // Lead screw
                translate([0,beamSize+beamClearance+zStepper[1]/2, 0]) cylinder(d=zNut[1]+2*thickness,h=thickness);
                // Guide bearing shells
                translate([-35,beamSize+thickness+zBearing[1]/2, 0]) cylinder(d=zBearing[1]+2*thickness,h=thickness);
                translate([35,beamSize+thickness+zBearing[1]/2, 0]) cylinder(d=zBearing[1]+2*thickness,h=thickness);
            }
            // Wall mount
            translate([-45, beamSize, 0]) cube([90, thickness, beamSize+thickness]);
            // Reinforcement
            translate([-45, beamSize+thickness,thickness]) rotate([0,90,0]) polyhole(d=8, h=90);
            *for(i=[-1,1]) hull() {
                translate([-thickness/2+i*(zNut[1]/2+1+thickness/2), beamSize, 0]) cube([thickness, beamClearance+zStepper[1]/2+zNut[1]/2, thickness]);
                translate([-thickness/2+i*(zNut[1]/2+1+thickness/2), beamSize, 0]) cube([thickness, thickness, thickness+beamSize/2]);
            }
            // Guide bearing shells and grub screw spheres
            for(x=[-35,35]) {
                translate([x,beamSize+thickness+zBearing[1]/2, 0]) cylinder(d=zBearing[1]+2*thickness,h=zBearing[2]);
                translate([x+ (x>0? 1:-1)*(zBearing[1]/2+thickness/1.5), beamSize+thickness+zBearing[1]/2, zBearing[2]/2])
                    sphere(r=thickness);
                translate([x,beamSize+thickness+zBearing[1]/2+zBearing[1]/2+thickness/1.5, zBearing[2]/2])
                    sphere(r=thickness);
            }
            // Lead screw standoff
            translate([0,beamSize+beamClearance+zStepper[1]/2, 0]) cylinder(d=zNut[1],h=thickness*2);
       }

        // Bottom mounting holes
        for(x=[-35,0,35])
            translate([x,beamSize/2,-.5])
                polyhole(d=M4hole,h=thickness+1);

        // Wall mounting holes
        for(x=[-17, 17])
            translate([x,beamSize-.5,thickness+beamSize/2])
                rotate([-90,0,0])
                    polyhole(d=M4hole, h=thickness+1);

        // Guide bearing shells and grub screw holes
        for(x=[-35,35]) {
            translate([x,beamSize+thickness+zBearing[1]/2, -.5]) polyhole(d=zBearing[1]+0.25,h=zBearing[2]+1);
            // Outside grub
            translate([x,beamSize+thickness+zBearing[1]/2, zBearing[2]/2])
                rotate(x>0? [90,0,90]: [90,0,270]) polyhole(d=M3tap,h=zBearing[2]/2+thickness);
            // Front grub
            translate([x,beamSize+thickness+zBearing[1]/2, zBearing[2]/2])
                rotate([90,0,180]) polyhole(d=M4tap,h=zBearing[2]/2+thickness);
        }

        // Z nut
        translate([0,beamSize+beamClearance+zStepper[1]/2, -.5]) {
            // Z Nut cylinder hole
            polyhole(d=zNut[2]+0.3,h=beamSize+thickness+1);
            // Mounting holes
            for(x=[-8, 8])
                for(y=[-8,8])
                    rotate([0,0,45])
                        translate([sin(45)*x,sin(45)*y,0])
                            polyhole(d=M3tap, h=beamSize);
        }
    }
}

// Centered aroud X axis
module zBottomBracket() {
    difference() {
        union() {
            hull() {
                // Bottom mount
                translate([-45,0,-thickness]) cube([90,beamSize+thickness,thickness]);
                // Lead screw bearing shell
                translate([0,beamSize+beamClearance+zStepper[1]/2, -thickness]) cylinder(d=zLeadScrewBearing[1]+2*thickness,h=thickness);
                // Guide rod shell foundations
                translate([-35,beamSize+thickness+zBearing[1]/2, -thickness]) cylinder(d=zBearing[0]+2*thickness,h=thickness);
                translate([35,beamSize+thickness+zBearing[1]/2, -thickness]) cylinder(d=zBearing[0]+2*thickness,h=thickness);
            }
            // Guide bearing shells and grub screw spheres
            for(x=[-35,35]) {
                translate([x,beamSize+thickness+zBearing[1]/2, -thickness]) cylinder(d=zBearing[0]+2*thickness,h=zBearing[0]*2);
                translate([x+ (x>0? 1:-1)*(zBearing[0]/2+thickness/1.5),beamSize+thickness+zBearing[1]/2, -thickness+zBearing[0]])
                    sphere(r=thickness);
                translate([x,beamSize+thickness+zBearing[1]/2+zBearing[0]/2+thickness/1.5, -thickness+zBearing[0]])
                    sphere(r=thickness);
            }
            // Lead screw bearing shell
            translate([0,beamSize+beamClearance+zStepper[1]/2, -thickness])
                cylinder(d=zLeadScrewBearing[1]+2*thickness,h=zLeadScrewBearing[0]*2);
            // Wall mount
            *translate([-80/2, beamSize, -thickness]) cube([80, thickness, beamSize+thickness]);
            // Reinforcement
            *translate([-80/2, beamSize+thickness,0]) rotate([0,90,0]) polyhole(d=8, h=80);
        }

        // Bottom mounting holes
        for(x=[-35,0,35])
            translate([x,beamSize/2,-thickness-.5])
                polyhole(d=M4hole,h=thickness+1);

        // Wall mounting holes
        for(x=[-20, 20])
            translate([x,beamSize-.5,beamSize/2])
                rotate([-90,0,0])
                    polyhole(d=M4hole, h=thickness+1);

        // Guide bearing shells and grub screw holes
        for(x=[-35,35]) {
            translate([x,beamSize+thickness+zBearing[1]/2, -thickness -.5]) polyhole(d=zBearing[0]+0.25,h=zBearing[2]+1);
            translate([x,beamSize+thickness+zBearing[1]/2, -thickness+zBearing[0]])
                rotate(x>0? [90,0,90]: [90,0,270]) polyhole(d=M3tap,h=zBearing[2]/2+thickness);
            translate([x,beamSize+thickness+zBearing[1]/2, -thickness+zBearing[0]])
                rotate([90,0,180]) polyhole(d=M4tap,h=zBearing[2]/2+thickness);
        }

        // Z lead screw bearing through-hole and inset
        translate([0,beamSize+beamClearance+zStepper[1]/2, -thickness -.5])
            polyhole(d=zLeadScrewBearing[1]-2*thickness,h=thickness+zLeadScrewBearing[0]*2+1);
        translate([0,beamSize+beamClearance+zStepper[1]/2, -thickness+zLeadScrewBearing[0]*2-zLeadScrewBearing[2]])
            polyhole(d=zLeadScrewBearing[1]+0.25,h=zLeadScrewBearing[2]+1);
    }
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


// Helpers
module polyhole(d, h) {
    n = max(round(2 * d),3);
    rotate([0,0,180])
        cylinder(h = h, r = (d / 2) / cos (180 / n), $fn = n);
}

module convexCorner(h, r) {
    // Offset for how much to merge corner into existing walls (offset from origin)
    merge=1;
    difference() {
        translate([-merge,-merge,0]) cube([r,r,h]);
        translate([r/2,r/2,-.1]) cylinder(d=r,h=h+.2);
        translate([r/2-merge,-.1-merge,-.1]) cube([r+.1,r+.1,h+.3]);
        translate([-merge-.1,r/2-merge,-.1]) cube([r+.1,r+.1,h+.3]);
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

// TODO: Center around some axle
module xyStepper() {
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

module xyBearingBracket() {
    size=[4,2,0];
    difference() {
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
                    cylinder(d=M5tap+2*thickness, h=thickness);
            translate([beamSize+beamClearance+xyStepper[0]/2+xyPulleySizeWithBelt/2+cornerBearing[1]/2,
                        beamSize+7+cornerBearing[1]/2+xyBeltThickness, thickness*2])
                    cylinder(d=M5tap+2*thickness, h=thickness);
        }

        // Top X and Y mounting holes
        for(i=[1:2:2*size[0]]) translate([i*beamSize/2, beamSize/2, 2*thickness+.1]) rotate([180, 0, 0]) cylinder(d=M4hole, h=thickness+.2);
#        for(i=[1:2:2*size[1]]) translate([beamSize/2,i*beamSize/2, 2*thickness+.1]) rotate([180, 0, 0]) cylinder(d=M4hole, h=thickness+.2);

    // Inner corner bearing, for belt from stepper; can be as close to the beam as possible
    translate([beamSize+7/*screw in corner bracket*/+cornerBearing[1]/2+xyBeltThickness,
                beamSize+7+cornerBearing[1]/2+xyBeltThickness,
                thickness+thickness-20]) {
        polyhole(d=M5tap, h=20+thickness+1);
        // Virtual bearings
        %polyhole(d=cornerBearing[1], h=cornerBearing[2]*4);
        // Virtual belt
        %color("black", 0.5) translate([-cornerBearing[1]/2 -xyBeltThickness, -cornerBearing[1]/2 -xyBeltThickness, 0]) cube([yBeamLength-100, xyBeltThickness, 6]);
    }


    // Outer corner bearing, for belt from stepper; can be as close to the beam as possible
    translate([beamSize+beamClearance+xyStepper[0]/2+xyPulleySizeWithBelt/2+cornerBearing[1]/2,
                beamSize+7+cornerBearing[1]/2+xyBeltThickness,
                thickness+thickness-20]) {
        polyhole(d=M5tap, h=20+thickness+1);
        // Virtual bearings
        %polyhole(d=cornerBearing[1], h=cornerBearing[2]*4);
        // Virtual belt
        %color("black", 0.5) translate([-cornerBearing[1]/2 -xyBeltThickness, -cornerBearing[1]/2 -xyBeltThickness, 0]) cube([yBeamLength-100, xyBeltThickness, 6]);
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

module frameCornerBracketRegular(size=[3,2,3]) {
    // X, Y and Z size in multiples of beamSize
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

            // Front X and Y
            translate([-thickness, -thickness, -thickness]) {
                cube([thickness+size[0]*beamSize, thickness, thickness+beamSize]);
                cube([thickness+beamSize, thickness, thickness+size[2]*beamSize]);
            }
            // Reinforcement front XZ
            if(size[0] > 1 && size[2] > 1)
                translate([beamSize,0,beamSize]) rotate([90,0,0]) convexCorner(h=thickness, r=20);

            // Left Y and Z
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
    }
}

// Size: X, Y and Z size in multiples of beamSize
module yRodOutsideBracket(size=[3,0,3]) {
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


// Similar to above, but modified with an Y rod bracket
// Size: X, Y and Z size in multiples of beamSize
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

            // Inner walls
*            translate([beamSize, beamSize, beamSize])
                cube([thickness, beamClearance+xyStepper[1]+2*thickness, beamSize]);
*            translate([beamSize, beamSize, beamSize])
                cube([beamClearance+xyStepper[1], thickness, beamSize]);

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

// Guide rail bracket
// TODO: Remove dependency on beamSize (move origin) so it lays flat on the origin+beamClearance
module xyGuideBracket() {
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

beltFastenerRadius=4;
beltFastenerHeight=12;
beltFastenerLength=15;
beltFastenerWidth=2*beltFastenerRadius+thickness+3;
// Centered around X axis
module fastener() {

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



// Print with 100% infill
// Centered around X axis
module xCarriageFastener() {
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

            translate([0,-xyBearing[1]/2,0]) fastener();
            translate([0,xyBearing[1]/2,0]) scale([1,1,(beltFastenerHeight+8)/beltFastenerHeight]) fastener();
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


module xCarriage() {
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
            %translate([74-2*8.5,49,-58+beamClearance]) rotate([-90,0,180]) import("E3D_Titan.stl");
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

module show() {
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
                xyGuideBracket();

               // Virtual X carriage
                xPosition=2*($t < .5? xTravel*$t: xTravel-xTravel*$t);
                %translate([xRodMinimumXOffset+xGuideLengths+xPosition, beamSize+(xyGuideBracketWidth-xRodDistance)/2, beamSize+thickness+xBearing[1]/2]) {
                    xCarriage();
                    translate([10,xCarriageWidth/2,-xBearing[1]/2-thickness])
                        rotate([180,0,180])
                            xCarriageFastener();

                    translate([xCarriageWidth-10,xCarriageWidth/2,-xBearing[1]/2-thickness])
                        rotate([180,0,0])
                            xCarriageFastener();
                }
            }

    translate([beamSize+xBeamLength+beamSize, beamSize+yBeamLength+beamSize, zBeamLength])
        rotate([180,0,0])
            mirror([1,0,0]) {
                frameCornerBracketForYRod();
                mirror([0,0,0]) xyGuideBracket();
            }

    // Left stepper bracket
    translate([0,0,zBeamLength]) mirror([0,1,0]) rotate([180,0,0])  xyMotorMount();
    // Left stepper
    %translate([0,0,zBeamLength-xyStepper[2]-beamSize-thickness])
        rotate([0,180,270])
            mirror([0,0,1])
                xyStepper();
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
                xyStepper();
    // Right stepper Up-side down
    *translate([xBeamLength-xyStepper[0],0,zBeamLength])
        rotate([0,180,270])
                xyStepper();

    translate([beamSize+xBeamLength/2,0])
        zBottomBracket();

}

// Show design (not all parts shown)
show();

*translate([-0,0,0]) mirror([0,0,0]) rotate([180,180,0]) xCarriage();
*translate([-10,0,0]) rotate([0,0,180]) mirror([0,1,0]) xyBearingBracket();
*translate([-0,0,0]) mirror([0,0,0]) rotate([0,0,0]) xyBearingBracket();
*translate([-100,-100,0]) zMotorBracket();

*translate([80,0,thickness]) zBottomBracket();
*translate([80,-70,thickness]) zMotorBracket();
*translate([-20, -70, 0]) zGantryBracket();
*translate([15,0,-beamSize]) yEndstopBracket();
*translate([-15,0,-beamSize]) yEndstopBracket(40);

*translate([]) {
translate([-20, -30, 0]) xCarriageFastener();
translate([-0, -30, 0]) xCarriageFastener();
*zGantryBracket();
}

*translate([]) {
    translate([0,0,0]) bedCorner();
    translate([42,0,0]) bedCorner();
    translate([0,42,0]) bedCorner();
    translate([42,42,0]) bedCorner();
    translate([0,87,0])arduinoBracket();
}
*translate([]) {
    translate([0,0,0]) bedDistance();
    translate([42,0,0]) bedDistance();
    translate([0,42,0]) bedDistance();
    translate([42,42,0]) bedDistance();
}

//translate([xBeamLength+beamSize,0,zBeamLength-beamSize]) rotate([])
//translate([xBeamLength+beamSize+yRodBeamOffset,0,zBeamLength-beamSize*3]) mirror([1,0,0]) xyGuideBracket();

// yRodOutsideBracket();


*showVirtualFrame();
*rotate([90,0,0]) frameCornerBracketRegular();
*translate([125,0,0]) rotate([90,0,0]) mirror([1,0,0]) frameCornerBracketRegular();
*translate([140,0,0]) rotate([90,0,0]) mirror([0,0,0]) yRodOutsideBracket();
*translate([290,0,0]) rotate([90,0,0]) mirror([1,0,0]) yRodOutsideBracket();


// Uncomment (remove '*') to print individual parts
*color("green") translate([yBeamLength/2, 150+beamSize, 0]) xCarriage();
*color("green") translate([0,0,0]) xyMotorMount();
*color("green") translate([0,130, 0]) xyGuideBracket();
*color("yellow") translate([yBeamLength+100,120+beamSize/2,0])  mirror([1,0,0]) xyGuideBracket();
*color("yellow") translate([yBeamLength+100,0,0])  mirror([1,0,0]) xyMotorMount();
