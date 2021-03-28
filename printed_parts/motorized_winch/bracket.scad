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

$fn          = 50;
pipe_dia     = 22.5;
mount_width  = 32;
mount_height = 46;
mount_depth  = 30;
motor_depth  = 21.6;
thickness    = (mount_width - pipe_dia)/2;
total_h      = mount_height + thickness*2 + pipe_dia;

module body() {
    linear_extrude(mount_depth) {
        difference() {
            union() {
                translate([-mount_width/2,0])
                    square([mount_width, mount_height+thickness+pipe_dia/2]);
                translate([0,mount_height+pipe_dia/2+thickness])
                    circle(pipe_dia/2+thickness);
            }
            translate([0,mount_height+pipe_dia/2+thickness])
                circle(pipe_dia/2);
        }
    }
}

module cutout() {
    linear_extrude(motor_depth)
        translate([-mount_width/2-0.5,0])
            square([mount_width+1, mount_height+1]);
}

module cutout2(inset = 2.5) {
    w = mount_width - inset*2;
    h = mount_height - inset*2;
    linear_extrude(24)
        translate([-w/2,inset])
            square([w,h]);
}

module screw_holes() {
    linear_extrude(mount_depth+1) {
        translate([-9,39.5]) circle(r=1.75);
        translate([ 9,39.5]) circle(r=1.75);
        translate([ 0,31.0]) circle(r=4);
        translate([-9,7.25]) circle(r=1.75);
        translate([ 9,7.25]) circle(r=1.75);
    }
}

module clamp() {
    difference() {
        body();
        cutout();
        cutout2();
        screw_holes();
    }
}

difference() {
    union() {
        rotate([0,0,90])
        translate([0,-total_h,0])
            clamp();
        rotate([0,0,-90])
            translate([0,-total_h,0])
                clamp();
    }
    translate([0,-500,0])
    cube([1000,1000,1000], center=true);
}