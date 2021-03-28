/****************************************************************************
 *   Open-Source Whole Home Water Shutoff System                            *
 *   Copyright 2021 Marcio Teixeira                                         *
 *                                                                          *
 *   This program is free software: you can redistribute it and/or modify   *
 *   it under the terms of the GNU General Public License as published by   *
 *   the Free Software Foundation, either version 3 of the License, or      *
 *   (at your option) any later version.                                    *
 *                                                                          *
 *   This program is distributed in the hope that it will be useful,        *
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of         *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the          *
 *   GNU General Public License for more details.                           *
 *                                                                          *
 *   To view a copy of the GNU General Public License, go to the following  *
 *   location: <http://www.gnu.org/licenses/>.                              *
 ****************************************************************************/

$fn = 50;
axis_radius   = 3 * 1.05;
notch_depth   = 6.0 - 5.55;
pulley_radius = 15;
pulley_thickness = 5;
groove_dia = pulley_thickness * 0.75;

module tie_hole() {
    translate([pulley_radius,0,0])
        rotate([90,0,0])
            torus(pulley_thickness/2,1.0);
}

module torus(r, d) {
    rotate_extrude(convexity = 10)
        translate([r, 0, 0])
        circle(r = d);
}

module axle() {
    difference() {
        h = pulley_thickness * 2 + 10;
        cylinder(r=axis_radius, h, center=true);
        translate([axis_radius*2-notch_depth,0,0])
            cube([axis_radius*2,axis_radius*2,h+1], center=true);
    }
}

difference() {
    rotate_extrude() {
        difference() {
            square([pulley_radius,pulley_thickness]);
            translate([pulley_radius,pulley_thickness/2])
                circle(d=groove_dia);
        };
    }
    axle();
    tie_hole();
}