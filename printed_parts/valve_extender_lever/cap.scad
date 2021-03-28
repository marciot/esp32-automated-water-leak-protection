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

$fn = 30;
outer_dia = 21.5;
inner_dia = 2.75;

module strain_relief(outer_dia, inner_dia, rings = 3) {
    spacing = (outer_dia - inner_dia)/rings;
    for(n = [0:rings]) {
        o = outer_dia - n*spacing;
        difference() {
            circle(d=o);
            if(n < rings)
            circle(d=o - spacing/2);
        }
        if(n < rings)
        for(r = [0,180])
            rotate(n*90 + r)
                translate([(o-spacing*.75)/2,0,0])
                    square([spacing/2,spacing/4], center=true);
    }
}

linear_extrude(2.5)
    difference() {
        strain_relief(outer_dia, inner_dia+3);
        circle(inner_dia);
    }

linear_extrude(19)
    difference() {
        circle(d=inner_dia+3);
        circle(d=inner_dia);
    }
    
linear_extrude(19) {
    spacing = (outer_dia - inner_dia)/3;
    difference() {
        circle(d=outer_dia);
        circle(d=outer_dia-spacing/2);
    }
}
