/**
 * CoreXY v2 config
 *
 *   -- noah@hack.se, 2016-2017
 */


/**
 * @section Definitions
 */
// inner diameter, outer diameter, length/height
lm8uu=[8,15,24];    // same as RJ4JP-01-08
lm8luu=[8,15,45];
rjmp0108=[8,16,25]; // RJMP-01-08

lm10uu=[10,19,29];  // same as RJ4JP-01-10
lm10luu=[10,19,55];
rjmp0110=[10,19,29]; // RJMP-01-10

lm12uu=[12,21,30];  // same as  -01-12
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

/**
 * @section Hole configuration
 */
M2tap=1.85;
M3tap=2.85;
M3hole=3.6;
M4tap=3.9;
M4hole=4.6;
M5tap=4.8;
M5hole=5.4;
M5nut=8;
M8tap=7.5;

// X, Y, Height, axle diameter, half distance between two mounting holes, axle length
// Was: NEMA17=[43.2, 43.2, 50, 5, 31/2, 22];
NEMA17=[42.3, 42.3, 50, 5, 31/2, 22];


/**
 * @section Electronics definitions
 */

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

Pi3_Board=[85,56];
Pi3_Holes=[
    [3.5, 3.5],
    [3.5, 52.5],
    [61.5, 52.5],
    [61.5, 3.5]
];
