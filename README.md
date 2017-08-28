# Overview

This is my attempt at designing a 3D printer with [CoreXY](http://corexy.com/theory.html) motion.  There's nothing novel about it except all plastic parts were designed in the open source [OpenSCAD](http://www.openscad.org).  So far it has successfully printed a 20mm calibration cube.

The printer has been built around some 2020 aluminium extrusions I had lying around:

- 4x 500mm beams for the frame (X)
- 4x 420mm beams for the frame (Y)
- 4x 360mm beams for the frame (Z)
- 2x 360mm beams for the bed (X)
- 2x 420mm beams for the bed (Y)

For the linear motion, 4x 12x400mm stainless steel rods (X and Y) and 4x 10x400mm (Z axises) have been used together with 8x LM12UU bearings and IGUS DryLin RJMP-01-10 bearings.

The plastic parts were printed in PLA, with some of the load bearing parts printed at 100% infill.

In the current design it requires 4 NEMA17 stepper motors (two for the corexy motion and two to support the bed in the Z direction).

For the extruder and hotend, an [E3D Titan Extruder](https://e3d-online.com/Titan-Extruder) is used with an [E3D v6 HotEnd](https://e3d-online.com/E3D-v6/Full-Kit/v6-1.75mm-Universal).

Electronics wise, it uses an Arduino Mega2560 r3 board and has been tested with both:

- 4x [Big Easy Driver](http://www.schmalzhaus.com/BigEasyDriver/) stepper motor drivers and a custom board with MOSFETs and misc support electronics
- A standard [RAMPS v1.4](http://reprap.org/wiki/RAMPS_1.4) board

The Arduino board runs the [Marlin 1.1.0 RC8](https://github.com/MarlinFirmware/Marlin) firmware with the following settings in `Configuration.h`:

	#define COREXY
	// Travel limits after homing (units are in mm)
	#define X_MAX_POS 290
	#define Y_MAX_POS 275
	#define Z_MAX_POS 205

The Y max value is no longer up-to-date because it was determined when I was using a cantilever design for the bed (single Z axis).  Unfortunately, it wasn't rigid enough and I got some 5mm flex at the far end.  I've since moved on to a dual Z-axis design to support the bed in two places (not reflected in the .scad file).

This is work in progress but here's a quick screenshot from OpenSCAD of the general idea (not all parts are shown).

![corexy.scad](corexy.png)

# Update 2017

Changed made since the initial commit:

- The horizontal X carriage offered stability but hid the print head so I've opted for a vertical X axis with a new X carriage and new X/Y guide brackets
- The new V2 X carriage is now slightly more modular to make it easier to swap out the print head
- The new V2 X/Y guide brackets are however painful to print properly (use a brim)
- Some parts got slightly rounded corners instead of sharp edges to avoid warping issues
- The X beam length has been reduced to reduce weight of the X axis
- Flexible couplers on the Z axis were replaced with non-flexible ones to reduce lag/flex in the Z axis
- The NEMA17 defs was changed from 43.2mm to 42.3mm (required a re-print of most of the top parts)
- The single, large .scad file has been split up to multiple files

## Imported models

The following STLs were found and downloaded from the internet.

- [BLTouch_extracted.stl](https://www.thingiverse.com/thing:1229934/apps) (CC-BY license)
- [E3D_Titan.stl](https://www.youmagine.com/designs/e3d-titan-extruder-model) (CC-BY-SA license)
- [E3D_V6_1.75mm_Universal_HotEnd_Mockup.stl](https://www.thingiverse.com/thing:341689) (CC-BY license)


# Approximate BOM

Notes:

- All-in-all it's about €1K not including time spent building, waiting, printing and debugging
- Don't cheap out on the hotend, extruder or the heated bed
- While PEI on a heated bed is nice, both PLA and PETG is painless to print on a 4mm float glass bed with 3M Blue Painter's tape (`#2090`)
- Motedis or McMaster-Carr has aluminium beams, steel rods, nuts, washers and bolts for the frame
- China (eBay) has cheaper kits with Arduino+RAMPS 1.4+stepper drivers (€30 in total, saving €50+ vs. buying from E3D)
- The Panucatt Devices _Re-ARM for RAMPS_ board (runs Smoothieware instead of Marlin) is a nice alternative to the Arduino Mega2560 (€40 + shipping)
- I've found the Panucatt Devices _SD6128 Stepper driver_ better able to drive the recent pancake stepper motor E3D offers with their Titan Extruder
- Bearings, misc nuts, washers and bolts can be found on eBay
- Large washers are preferred to spread out the load on plastic parts
- M4 bolts are used around the frame (approx. 150 bolts, washers and alu beam nuts)
- M3 bolts are used in brackets for steppers, electronics, bed leveling and the print head

| Item                                                                                                                                                 | Vendor     | Count | Price  | Total EUR |
|------------------------------------------------------------------------------------------------------------------------------------------------------|------------|-------|--------|-----------|
| [Arduino Mega 2560 Compatible Controller Board & USB Cable](https://e3d-online.com/Electrical/Electronics-Boards/Arduino-Mega-2560-Compatible-Board) | E3D Online | 1     | £25    | 28.50     |
| [RAMPS 1.4 - Arduino Mega Pololu Shield](https://e3d-online.com/Electrical/Electronics-Boards/RAMPS-1.4-Arduino-Mega-Pololu-Shield)                  | E3D Online | 1     | £25    | 28.50     |
| [A4988 Stepper Driver with Heatsink](https://e3d-online.com/A4988-Stepper-Driver-with-Heatsink)                                                      | E3D Online | 4     | £6.50  | 29.50     |
| [v6 HotEnd Full Kit - 1.75mm Universal (Direct) (12v)](http://e3d-online.com/E3D-v6/Full-Kit/v6-1.75mm-Universal) (assembled +£12.50)                | E3D Online | 1     | £43    | 49.00     |
| [Titan Extruder](https://e3d-online.com/Titan-Extruder)+Mounting bracket+Motor: NEMA17 21N                                                           | E3D Online | 1     | £56    | 63.50     |
| [PCB Heated Bed MK2B 12v and 24v](https://e3d-online.com/Mechanical/Print-Surfaces/PCB-Heated-Bed-MK2B-12v-and-24v)                                  | E3D Online | 1     | £12.50 | 13.50     |
| [Borosilicate Glass Beds 214x214x4](https://e3d-online.com/Print-Surfaces/Borosilicate-Bed-200x200) (214x314x4 +£7.00)                               | E3D Online | 1     | £22    | 25.00     |
| [100k Ohm NTC Thermistor - Semitec](https://e3d-online.com/Electrical/100k-Ohm-NTC-Thermistor-Semitec)                                               | E3D Online | 1     | £3.50  | 4.00      |
| [NEMA17 47N-cm - High Torque Axes Stepper Motor - Wantai](https://e3d-online.com/Electrical/Stepper-Motors/NEMA17-47Ncm)                             | E3D Online | 4     | £9.30  | 42.00     |
| [GT2 Belt (6mm) (per 100mm)](https://e3d-online.com/Mechanical/Motion/GT2-Belt-6mm)                                                                  | E3D Online | 24    | £0.35  | 9.50      |
| [GT2 Pulley (16 tooth)](https://e3d-online.com/Mechanical/Motion/GT2-Pulley-16-Tooth)                                                                | E3D Online | 2     | £3.50  | 8.00      |
| [Flexible motor coupling 5mm to 8mm](https://e3d-online.com/Mechanical/Motion/Flexible-motor-coupling-5mm-to-8mm)                                    | E3D Online | 2     | £2.50  | 5.65      |
| [40x40x10mm 12v DC Fan](https://e3d-online.com/Electrical/Fans/40x40x10mm-12v-DC-Fan)                                                                | E3D Online | 2     | £4.50  | 10.50     |
| [Bulldog Clips x 4](https://e3d-online.com/Mechanical/Fixings/Bulldog%20Clips)                                                                       | E3D Online | 1     | £0.90  | 1.00      |
| [Compression spring - 20mm x 7.5mm](https://e3d-online.com/Mechanical/Fixings/Compression-spring-20mmx7.5mm-)                                        | E3D Online | 4     | £0.50  | 2.50      |
| [Endstop Microswitches - Omron](https://e3d-online.com/Endstop-Microswitches-Omron)                                                                  | E3D Online | 5     | £1.50  | 8.50      |
| E3D shipping and VAT (£16+£61)                                                                                                                       |            | 1     | £77    | 87.00     |
| E3D Total                                                                                                                                            |            | 1     | £367   | 415.00    |
|                                                                                                                                                      |            |       |        |           |
| Be Quiet! ATX PSU                                                                                                                                    |            | 1     | €60    | 60.00     |
| Filament 1.75mm 1KG spool                                                                                                                            |            | 1     | €30    | 30.00     |
| 8x400mm T8 2mm pitch lead screw plus nut                                                                                                             |            | 2     | €10    | 20.00     |
| NEMA17 stepper motor vibration dampener                                                                                                              |            | 2     | €2.5   | 5.00      |
| Misc electrical cables and cable guides                                                                                                              |            | 1     | €40    | 40.00     |
| Aluminium beams 20x20 (X 4x500mm; Y 6x420mm; Z 6x360mm)                                                                                              |            | 1     | €100   | 100.00    |
| Nuts and bolts                                                                                                                                       |            | 1     | €150   | 150.00    |
| Stainless steel rods 12x400mm (X and Y guides)                                                                                                       |            | 4     | €8     | 32.00     |
| Stainless steel rods 8x3600mm (Z guides)                                                                                                             |            | 4     | €7     | 28.00     |
| Bearing 608 (Z screw bottom)                                                                                                                         |            | 2     | €3     | 6.00      |
| Bearing F624 (X/Y guide bracket)                                                                                                                     |            | 8     | €3     | 24.00     |
| Bearing F695 (corner brackets)                                                                                                                       |            | 16    | €3     | 18.00     |
| Bearing LM12UU (X/Y guide rods)                                                                                                                      |            | 8     | €4     | 32.00     |
| Bearing LM8UU (Z guide rods)                                                                                                                         |            | 4     | €4     | 16.00     |
| Printed parts                                                                                                                                        |            | 1     | €50    | 50.00     |
|                                                                                                                                                      |            |       |        |           |
| Total                                                                                                                                                |            | 1     | €1030  | 1030.00   |

# Wiring

![RAMPS 1.4 pinout](http://reprap.org/mediawiki/images/c/ca/Arduinomega1-4connectors.png)
![RAMPS 1.4 wiring](http://reprap.org/mediawiki/images/6/6d/Rampswire14.svg)
