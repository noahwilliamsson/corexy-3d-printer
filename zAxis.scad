/**
 * CoreXY v2
 * Z axis modules
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
*!zMotorBracket();
*!zGantryBracket();
*!zBottomBracket();
*!printzGantryBrackets();
*!printZGuideBracketV2s();  // Scrapped because hard to align

// Print helpers
module printzGantryBrackets() {
    translate([0,10,0]) zGantryBracket();
    translate([0,130,0]) rotate([0,0,180]) zGantryBracket();
}
module printZGuideBracketV2s() {
    for(i=[0,1]) translate([i*40,0,0]) {
        zGuideBracketV2();
        translate([0,-5,0]) mirror([0,1,0])zGuideBracketV2();
    }

    translate([88,0,0]) zGuideBracketV2(true);
    translate([88,-5,0]) mirror([0,1,0]) zGuideBracketV2(true);
}


// Top Z motor mounting bracket
// Centered around X axis
module zMotorBracket() {
    width=86;
    cornerRadius=4;
    difference() {
        union() {
            hull() {
                // Under the beam
                translate([-width/2+cornerRadius,cornerRadius,-thickness])
                    polyhole(d=2*cornerRadius, h=thickness);
                translate([width/2-cornerRadius,cornerRadius,-thickness])
                    polyhole(d=2*cornerRadius, h=thickness);
                // Stepper motor
                translate([-zStepper[0]/2+cornerRadius, beamSize+beamClearance+zStepper[1]-cornerRadius, -thickness])
                    polyhole(d=2*cornerRadius, h=thickness);
                translate([zStepper[0]/2-cornerRadius, beamSize+beamClearance+zStepper[1]-cornerRadius, -thickness])
                    polyhole(d=2*cornerRadius, h=thickness);
                // Guide rod shell foundations
                translate([-35,beamSize+thickness+zBearing[1]/2, -thickness]) cylinder(d=zBearing[0]+2*thickness,h=thickness);
                translate([35,beamSize+thickness+zBearing[1]/2, -thickness]) cylinder(d=zBearing[0]+2*thickness,h=thickness);
            }

            // Guide bearing shells and grub screw spheres
            for(x=[-35,35]) {
                translate([x,beamSize+thickness+zBearing[1]/2, -thickness]) cylinder(d=zBearing[0]+2*thickness,h=zBearing[0]*2);
                // Outside grub screw
                *translate([x+ (x>0? 1:-1)*(zBearing[0]/2+thickness/1.5),beamSize+thickness+zBearing[1]/2, -thickness+zBearing[0]])
                    sphere(r=thickness);
                // Front grubscrew
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
            translate([x,beamSize+thickness+zBearing[1]/2, -thickness -.5]) polyhole(d=zBearing[0]+0.35,h=zBearing[2]+1);
            // Outside grub screw
            *translate([x,beamSize+thickness+zBearing[1]/2, -thickness+zBearing[0]])
                rotate(x>0? [90,0,90]: [90,0,270]) polyhole(d=M3tap,h=zBearing[2]/2+thickness);
            // Front grub screw
            translate([x,beamSize+thickness+zBearing[1]/2, -thickness+zBearing[0]])
                rotate([90,0,180]) polyhole(d=M4tap,h=zBearing[2]/2+thickness);
        }

        // Under the beam mounting holes
        translate([-beamSize/2-zStepper[0]/2, beamSize/2, -thickness-.5]) polyhole(d=M4hole, h=thickness+1);
        translate([0, beamSize/2, -thickness-.5]) polyhole(d=M4hole, h=thickness+1);
        translate([zStepper[0]/2+beamSize/2, beamSize/2, -thickness-.5]) polyhole(d=M4hole, h=thickness+1);
    }
}

// Bed Z bracket
module zGantryBracket() {
    cornerRadius=4;
    width=90;
    difference() {
        union() {
            hull() {
                // Bottom mount
                translate([-width/2+cornerRadius, cornerRadius, 0]) polyhole(d=2*cornerRadius, h=thickness);
                translate([+width/2-cornerRadius, cornerRadius, 0]) polyhole(d=2*cornerRadius, h=thickness);
                // Lead screw
                translate([0,beamSize+beamClearance+zStepper[1]/2, 0]) cylinder(d=zNut[1]+2*thickness,h=thickness);
                // Guide bearing shells
                translate([-35,beamSize+thickness+zBearing[1]/2, 0]) cylinder(d=zBearing[1]+2*thickness,h=thickness);
                translate([35,beamSize+thickness+zBearing[1]/2, 0]) cylinder(d=zBearing[1]+2*thickness,h=thickness);
            }
            // Wall mount
            translate([-45+zBearing[1]/2, beamSize, 0]) cube([90-zBearing[1], thickness, beamSize+thickness]);
            // Reinforcement
            translate([-45+zBearing[1]/2, beamSize+thickness,thickness]) rotate([0,90,0]) polyhole(d=8, h=90-zBearing[1]);
            *for(i=[-1,1]) hull() {
                translate([-thickness/2+i*(zNut[1]/2+1+thickness/2), beamSize, 0]) cube([thickness, beamClearance+zStepper[1]/2+zNut[1]/2, thickness]);
                translate([-thickness/2+i*(zNut[1]/2+1+thickness/2), beamSize, 0]) cube([thickness, thickness, thickness+beamSize/2]);
            }
            // Guide bearing shells and grub screw spheres
            for(x=[-35,35]) {
                translate([x,beamSize+thickness+zBearing[1]/2, 0]) cylinder(d=zBearing[1]+2*thickness,h=zBearing[2]);
                // Outside grub
                *translate([x+ (x>0? 1:-1)*(zBearing[1]/2+thickness/1.5), beamSize+thickness+zBearing[1]/2, zBearing[2]/2])
                    sphere(r=thickness);
                // Front grub
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
            translate([x,beamSize+thickness+zBearing[1]/2, -.5]) polyhole(d=zBearing[1]+0.4,h=zBearing[2]+1);
            // Outside grub
            *translate([x,beamSize+thickness+zBearing[1]/2, zBearing[2]/2])
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
    cornerRadius=4;
    width=86;
    difference() {
        union() {
            hull() {
                // Bottom mount
                translate([-width/2+cornerRadius, cornerRadius, -thickness]) polyhole(d=2*cornerRadius, h=thickness);
                translate([+width/2-cornerRadius, cornerRadius, -thickness]) polyhole(d=2*cornerRadius, h=thickness);
                // Lead screw bearing shell
                translate([0,beamSize+beamClearance+zStepper[1]/2, -thickness]) cylinder(d=zLeadScrewBearing[1]+2*thickness,h=thickness);
                // Guide rod shell foundations
                translate([-35,beamSize+thickness+zBearing[1]/2, -thickness]) cylinder(d=zBearing[0]+2*thickness,h=thickness);
                translate([35,beamSize+thickness+zBearing[1]/2, -thickness]) cylinder(d=zBearing[0]+2*thickness,h=thickness);
            }
            // Guide bearing shells and grub screw spheres
            for(x=[-35,35]) {
                translate([x,beamSize+thickness+zBearing[1]/2, -thickness]) cylinder(d=zBearing[0]+2*thickness,h=zBearing[0]*2);
                // Outside grub screw
                *translate([x+ (x>0? 1:-1)*(zBearing[0]/2+thickness/1.5),beamSize+thickness+zBearing[1]/2, -thickness+zBearing[0]])
                    sphere(r=thickness);
                // Front grub screw
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
            translate([x,beamSize+thickness+zBearing[1]/2, -thickness -.5]) polyhole(d=zBearing[0]+0.35,h=zBearing[2]+1);
            // Outside grub screw
            *translate([x,beamSize+thickness+zBearing[1]/2, -thickness+zBearing[0]])
                rotate(x>0? [90,0,90]: [90,0,270]) polyhole(d=M3tap,h=zBearing[2]/2+thickness);
            // Front grub screw
            translate([x,beamSize+thickness+zBearing[1]/2, -thickness+zBearing[0]])
                rotate([90,0,180]) polyhole(d=M4tap,h=zBearing[2]/2+thickness);
        }

        // Z lead screw bearing through-hole and inset
        translate([0,beamSize+beamClearance+zStepper[1]/2, -thickness -.5])
            polyhole(d=zLeadScrewBearing[1]-2*thickness,h=thickness+zLeadScrewBearing[0]*2+1);
        translate([0,beamSize+beamClearance+zStepper[1]/2, -thickness+zLeadScrewBearing[0]*2-zLeadScrewBearing[2]])
            polyhole(d=zLeadScrewBearing[1]+0.35,h=zLeadScrewBearing[2]+1);
    }
}

// Scrapped because hard to align correctly
module zGuideBracketV2(bearingInsteadOfRod=false) {
    r=2;
    id=zBearing[0];
    od=zBearing[1];
    h=bearingInsteadOfRod? zBearing[2]: zBearing[2]/2;

    washerSize=12.5;
    length=(bearingInsteadOfRod? od: id+thickness-2)+washerSize+thickness;

    difference() {
        union() {
            // Bottom
            hull() {
                for(x=[-thickness+r,beamSize-r]) for(y=[r,length-r]) translate([x,y,0]) polyhole(d=2*r, h=thickness);
                translate([-od/2-thickness/2, od/2+thickness/2, 0]) cylinder(d=bearingInsteadOfRod? od+thickness: id+thickness, h=thickness);
            }
            // Side
            hull() {
                for(x=[-thickness+r]) for(y=[r,length-r]) translate([x,y,0]) polyhole(d=2*r, h=thickness);
                translate([-thickness,thickness-1,thickness]) cube([thickness,length-thickness, 20]);
            }

            // Shell
            translate([-od/2-thickness/2, od/2+thickness/2, 0]) cylinder(d=bearingInsteadOfRod? od+thickness: id+thickness, h=h);
        }
        // Screw hole in bottom
        translate([beamSize/2, od/2, -.5]) polyhole(d=M4hole, h=thickness+1);
        // Screw hole in wall
        translate([-thickness-.5, (bearingInsteadOfRod? od+thickness-1: id+thickness+1)+washerSize/2, thickness+beamSize/2]) rotate([0,90,0]) polyhole(d=M4hole, h=thickness+1);
        // Make room for a 12mm washer
        translate([-thickness-1.5, (bearingInsteadOfRod? od+thickness-1: id+thickness+1)+washerSize/2, thickness+beamSize/2]) rotate([0,90,0]) polyhole(d=12.5, h=1.5);


        // Z guide rod hole
        translate([-od/2-thickness/2, od/2+thickness/2, -.5]) polyhole(d=(bearingInsteadOfRod? od+0.4: id+0.2), h=zBearing[2]+1);
    }
}
