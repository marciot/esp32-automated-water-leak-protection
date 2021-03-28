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

use <pusher.scad>;

$fn            = 50;
pipe_dia       = 22.5;
motor_height   = 45;
motor_width    = 30;
motor_recess   = 2;
motor_inset    = 2;
clamp_height   = 20;
clamp_length   = 50;
clamp_to_pivot = 50;
clamp_flange   = 15;
clamp_gap      = 1;
screw_countersink = 3.3;

nut_flats = 5.43; // Measure across the flats.
nut_slack = 0.25;
nut_rad   = nut_flats / 2 / cos(30) + nut_slack;

side_thickness = 8;
rear_thickness = 4;
space_height   = clamp_to_pivot - 31;

w = pipe_dia   + side_thickness * 2;
h = clamp_height + space_height + motor_height;

module bottom_view() {
    l = clamp_length + 1;
    union() {
        //translate([0, l/2])
            //square([w, l], center = true);
            //square([side_thickness, l], center = true);
        circle(d = w);
        o = pipe_dia/2 + clamp_flange/2 + side_thickness/2;
        translate([-o,0])
            square([clamp_flange, side_thickness * 2 + clamp_gap], center = true);
        translate([ o,0])
            square([clamp_flange, side_thickness * 2 + clamp_gap], center = true);
    }
}

module bottom_support() {
    l = clamp_length + 1;
    linear_extrude(side_thickness)
    hull() {
        union() {
            bottom_view();
            translate([0, l/2])
            square([w, l], center = true);
        }
    }
}

module clamp() {
    linear_extrude(clamp_height)
        bottom_view();
}

module mount() {
    d = rear_thickness + motor_recess + screw_countersink;
    translate([-w/2,clamp_length,0])
        cube([w,d,h]);
}

module screw_holes() {
    translate([-9,39.1]) circle(r=1.75);
    translate([ 9,39.1]) circle(r=1.75);
    translate([ 0,30.1]) circle(r=7.5);
    translate([-9,6.50]) circle(r=1.75);
    translate([ 9,6.50]) circle(r=1.75);
}

module screw_countersink() {
    translate([-9,6.50]) circle(r=3);
    translate([ 9,6.50]) circle(r=3);
    translate([-9,39.1]) circle(r=3);
    translate([ 9,39.1]) circle(r=3);
}

module screw_recess() {
    w = motor_width - motor_inset*2;
    h = motor_height - motor_inset*2;
    translate([-w/2,motor_inset])
        square([w, h]);
}

module recess() {
    y = clamp_length + rear_thickness + motor_recess + screw_countersink + 1;
    translate([0, y, clamp_height + space_height])
        rotate([90,0,0]) {
            linear_extrude(rear_thickness + motor_recess + screw_countersink + 2)
                screw_holes();
            linear_extrude(motor_recess + 1)
                screw_recess();
        };
     y2 = clamp_length + screw_countersink;
     translate([0, y2, clamp_height + space_height])
        rotate([90,0,0])
            linear_extrude(10)
                screw_countersink();
}

module brace() {
    rotate([0,-90,0])
    linear_extrude(side_thickness)
        polygon(points=[
            [0,side_thickness],
            [clamp_height,side_thickness],
            [clamp_height + space_height, clamp_length],
            [0,clamp_length]]);
}

module flange_hole(depth=side_thickness,r=1.75,fn=50) {
    translate([pipe_dia/2+clamp_flange/2+side_thickness/2,side_thickness+clamp_gap/2-depth-0.1,clamp_height/2+side_thickness/2])
        rotate([-90,0,0])
            #cylinder(r=r,h=depth+0.2,$fn=fn);
}

module flange_holes() {
    flange_hole();
    flange_hole(r=nut_rad,fn=6,depth=1);
    mirror([0,1,0]) {
        flange_hole();
        flange_hole(r=3,depth=1);
    }
}

module symmetry(v) {
    children();
    mirror(v) children();
}

module endstop() {
    w = 19.8;
    d = 6.15;
    h = 9.97;
    s = 9.7;
    #translate([0,-d/2,0])
        cube([w,d,h], center=true);
    #translate([-w/2+5.61,-d+1.35,h/2])
        cube([2,3.48,1]);
    symmetry([1,0,0])
        translate([-s/2,0,1.8-h/2])
            rotate([90,0,0])
                cylinder(d=1.9,h=100,center=true);
}

module part() {
    difference() {
        union() {
            clamp();
            mount();
            translate([w/2,0,])
                brace();
            translate([-w/2+side_thickness,0,])
                brace();
            bottom_support();
        }
        recess();
        translate([0,0,-1]) {
            cube([200,clamp_gap,200],center=true);
            cylinder(d = pipe_dia, h = 1000);
        }

        flange_holes();
        mirror([1,0,0])
            flange_holes();
        translate([3.3,clamp_to_pivot-0.01,clamp_height + space_height + 16.2])
            endstop();
    }
}

axle_depth       = 14;
mount_thickness  = 4;

part();
*translate([0,clamp_to_pivot,clamp_height + space_height + 30.1])
    pusher2();

