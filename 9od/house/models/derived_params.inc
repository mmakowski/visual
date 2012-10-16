#include "etc/common.inc"
#include "etc/parameters.inc"

// helper (derived) dimensions
#declare roof_angle_ew = degrees(atan2(roof_height, outer_depth / 2 + roof_outset));
#declare roof_angle_sn = 360 - degrees(atan2(roof_height, outer_width / 2 + roof_outset));
#declare scase_window_angle = degrees(atan2((scase_window_width - scase_window_front_facet_width) / 2, scase_window_outset));
#declare ground_floor_floor_level = base_thickness;
#declare first_floor_floor_level = ground_floor_floor_level + ground_floor_height + ceiling_thickness;
#declare wall_height = ground_floor_floor_level + ground_floor_height + ceiling_thickness + first_floor_height + E;
#declare corner_window_bottom = first_floor_floor_level + corner_window_bottom_offset;
#declare corner_window_top = corner_window_bottom + corner_window_height;
#declare corner_window_box_bottom = corner_window_bottom - corner_window_box_side_thickness;
#declare corner_window_box_top = corner_window_top + corner_window_box_side_thickness;
#declare rec_front_window_top = ground_floor_floor_level + rec_front_window_height;
#declare total_outer_wall_thickness = outer_wall_thickness + inner_wall_thickness;
#declare scase_window_top = ground_floor_floor_level + scase_window_height;
#declare bath_window_bottom = first_floor_floor_level + bath_window_bottom_offset;
#declare bath_window_top = bath_window_bottom + bath_window_height;
#declare scase_window_roof_width = scase_window_width + 2 * scase_window_roof_outset;
#declare scase_window_roof_depth = scase_window_outset + scase_window_roof_outset;
#declare scase_window_roof_angle = degrees(atan2(scase_window_roof_height, scase_window_outset + scase_window_roof_outset));
