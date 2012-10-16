/*
This file contains basic dimensions of the models -- it should be possible
to accurately control building proportions by changing these.
*/

// building dimensions
#declare outer_width = 7;
#declare outer_depth = 7;
#declare ground_floor_height = 2.5;
#declare first_floor_height= 2.5;

// roof
#declare roof_height = 3;
#declare roof_outset = 0.3;

// wall and floor dimensions
#declare inner_wall_thickness = 0.25;
#declare outer_wall_thickness = 0.05;
#declare base_thickness = 0.2;
#declare ceiling_thickness = 0.3;

// staircase
#declare stairs_hole_depth = 1.5;
#declare stairs_hole_width = 2;
#declare stairs_hole_offset_n = 1;

// window dimensions and placement
// -- front reception window
#declare rec_front_window_width = 1.4;
#declare rec_front_window_height = 2;
#declare rec_front_window_offset_s = 1.3;
// -- staircase window
#declare scase_window_width = stairs_hole_width;
#declare scase_window_offset_n = stairs_hole_offset_n;
#declare scase_window_height = 4;
#declare scase_window_front_facet_width = 1;
#declare scase_window_outset = (scase_window_width - scase_window_front_facet_width) / 2;
#declare scase_window_roof_outset = 0.2;
#declare scase_window_roof_height = 0.5;
// -- corner windows
#declare corner_window_height = 1.2;
#declare corner_window_bottom_offset = 1.2;
#declare corner_window_width = 1;
#declare corner_window_depth = 0.8;
#declare corner_window_box_offset = 0.2;
#declare corner_window_box_side_thickness = 0.1;
// -- bathroom window
#declare bath_window_bottom_offset = 1.2;
#declare bath_window_offset_w = 2;
#declare bath_window_height = 1.2;
#declare bath_window_width = 1.2;
// -- frames and glass
#declare window_glass_thickness = 0.005;
#declare window_frame_thickness = 0.05;
