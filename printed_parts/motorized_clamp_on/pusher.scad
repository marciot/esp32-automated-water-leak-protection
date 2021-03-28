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
 
$fn              = 50;
slack            = 0.3;

axle_dia         = 6;
axle_notch_dia   = 5.50;
axle_notch_depth = axle_dia - axle_notch_dia;

handle_width     = 17;
mount_hole_dia   = 15;
mount_thickness  = 4 + 3.3;
pusher_thickness = 10;

part_depth       = pusher_thickness + mount_thickness - 2;
wall_thickness   = handle_width/2;

module axle_profile() {
    d = axle_dia + slack*2;
    n = axle_notch_depth + slack;
    difference() {
        circle(d=d);
        translate([axle_dia-n,0])
            square([axle_dia,axle_dia], center=true);
    }
}

module axle() {
    linear_extrude(100,center=true)
        axle_profile();
}

module pusher_dents() {
    r = handle_width/2+1;
    for(a=[0,-90])
        translate([r*cos(a),r*sin(a)])
            circle(d=4);    
}

module pusher_profile() {
    mirror([1,0]) {
        hull() {
            circle(d=handle_width);
            translate([handle_width/2,0])
                circle(d=handle_width);
        }
        translate([handle_width/2+wall_thickness/2,0,0])
            hull() {
                circle(d=wall_thickness);
                translate([0, handle_width*2,0])
                    circle(d=wall_thickness);
            }
    }
}

module pusher_shaft() {
    cylinder(d=mount_hole_dia - 3, h=part_depth);
}

module pusher() {
    difference() {
        union() {
            linear_extrude(pusher_thickness)
                difference() {
                    pusher_profile();
                    pusher_dents();
                }
            pusher_shaft();
        }
        #axle();
    }
}

module pusher2() {
    translate([0,-part_depth+mount_thickness,0])
        rotate([90,0,180])
            #pusher();
}

pusher();
