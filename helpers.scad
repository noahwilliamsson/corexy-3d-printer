/**
 * CoreXY v2
 * Helper modules
 *
 *   -- noah@hack.se, 2016-2017
 */


module polyhole(d, h) {
    n = max(round(2 * d),3);
    rotate([0,0,180])
        cylinder(h = h, r = (d / 2) / cos (180 / n), $fn = n);
}

/* M3: 5.5, M4: 7, M5: 8 */
module nuttrap(d=5.5, h=3) {
    cylinder(r=d/2/cos(180/6)+0.2, h=h, $fn=6);
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
