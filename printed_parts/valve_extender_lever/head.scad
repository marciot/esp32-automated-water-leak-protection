/****************************************************************************
 *   Shutoff Valve Extender by (c) 2019 Marcio Teixeira                     *
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

handle_depth  = 6;
handle_width  = 20;
handle_length = 60;

pvc_outer_dia = 21.33;

wall_thickness = 3;
clearance      = 0.3;
cap_height     = 2;

$fn = 40;

module round_rect(dim, center, r=2) {
    w = dim[0];
    h = dim[1];
    hull()
    for(x=[-w/2+r,w/2-r])
    for(y=[-h/2+r,h/2-r])
            translate([x,y])
                circle(r=r);
}

module tool_openings() {
    circle(r = pvc_outer_dia/2+clearance);
    
    translate([0,-pvc_outer_dia/2-handle_depth/2-wall_thickness-clearance*2])
        round_rect([handle_width+clearance*2, handle_depth+clearance*2],center=true);
}

module tool_outer_wall() {
    minkowski() {
        hull()
            tool_openings();
        circle(r = wall_thickness);
    }
}

module tool_shape() {
    difference() {
        linear_extrude(handle_length + cap_height)
            tool_outer_wall();
        translate([0,0,cap_height-0.1])
            linear_extrude(handle_length + cap_height+0.2)
            tool_openings();
    }
}

tool_shape();