/**
 * CoreXY v2
 * Configuration parameters
 *
 *   -- noah@hack.se, 2016-2017
 */

// Sizes for bearing, screw holes/taps, ..
include <defs.scad>


// Wall thickness
thickness=4;
// Aluminium extrusion size
beamSize=20;

xBeamLength=500;
xRodLength=400;
xBearing=lm12uu;
// XXX: New
xRodLength=400;
xBeamLength=420;
xBearing=lm10uu;

yBeamLength=420;
yRodLength=400;
yBearing=lm10luu;

zBeamLength=360;
zRodLength=300;
zBearing=lm8uu;  // Guide rod
zLeadScrewBearing=B608;
zNut=[8,22,10.5, 8]; // ID, OD (flange), OD (cylinder), mounting hole center-to-center radius

// Bed beams
bedXBeamLength=360;
bedYBeamLength=420;


// Bearings for belt on xy guide bracket
//xyBearing=F625; // 2016
xyBearing=F695; // update 2017
// XY guide bracket clearance from beams
beamClearance=.5;
// Y rod offset from beam, should be > (yBearing[1]/2+thickness)
yRodBeamOffset=13;

// Corner bearings
cornerBearing=F695;

// Distance between X rods (center-to-center)
// Lulzbot, Adapto and other designs use 70mm distances
xRodDistance=70;
// How much to shift X axis up
xRodZShift=5;
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


// For the Arduino bracket
board = ArduinoMega2560_Board;
holes = ArduinoMega2560_ReverseHoles;
standoffHeight = 3;
