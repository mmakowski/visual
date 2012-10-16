// config
#include "etc/common.inc"
#include "etc/parameters.inc"
// helper values
#include "models/derived_params.inc"
// textures
#include "textures/ceiling.inc"
#include "textures/roof.inc"
#include "textures/staircase_roof.inc"
#include "textures/wall_inner.inc"
#include "textures/wall_outer.inc"

// common transformations of basic elements
#declare to_e = transform { translate 0 }
#declare to_s = transform { rotate z * -90 translate y * outer_depth }
#declare to_w = transform { rotate z * 180 translate x * outer_width + y * outer_depth }
#declare to_n = transform { rotate z * 90 translate x * outer_width }
#declare to_se = to_e;
#declare to_sw = to_s;
#declare to_nw = to_w;

// base
#declare scase_window_base = difference {
	box { 0, <scase_window_width, -scase_window_outset, base_thickness> }
	box { 
		<0, 0, -E>, <scase_window_width, -2 * scase_window_outset, base_thickness + E> 
		rotate z * -scase_window_angle
	}
	box { 
		<0, 0, -E>, <-scase_window_width, -2 * scase_window_outset, base_thickness + E> 
		rotate z * scase_window_angle
		translate x * scase_window_width
	}
}

#declare base = union {
	box { 0, <outer_width, outer_depth, base_thickness> }
	object { scase_window_base translate x * (outer_width - scase_window_offset_n - scase_window_width) }
	texture { tx_wall_outer }
}

// roof
#declare roof = difference {
	box { 
		<-roof_outset, -roof_outset, wall_height>, 
		<outer_width + roof_outset, outer_depth + roof_outset, wall_height + roof_height> 
	}
	box {
		<-roof_outset - E, 0, 0>, <outer_width + roof_outset + E, outer_depth, roof_height>
		rotate x * roof_angle_ew
		translate y * -roof_outset + z * wall_height
	}
	box {
		<-roof_outset - E, 0, 0>, <outer_width + roof_outset + E, -outer_depth, roof_height>
		rotate x * -roof_angle_ew
		translate y * (outer_depth + roof_outset) + z * wall_height
	}
	box {
		<0, -roof_outset - E, 0>, <outer_width, outer_depth + roof_outset + E, roof_height>
		rotate y * roof_angle_sn
		translate x * -roof_outset + z * wall_height
	}
	
	box {
		<0, -roof_outset - E, 0>, <-outer_width, outer_depth + roof_outset + E, roof_height>
		rotate y * -roof_angle_sn
		translate x * (outer_width + roof_outset) + z * wall_height
	}
	texture { tx_roof }	
}

// outer walls
#declare outer_wall_outer_layer = box {
	0, <1, outer_wall_thickness, wall_height>
	texture { tx_wall_outer }
}

#declare outer_wall_inner_layer = box {
	0, <1, inner_wall_thickness, wall_height>
	texture { tx_wall_inner }
}

#declare outer_wall = union {
	object { outer_wall_outer_layer }
	object { outer_wall_inner_layer scale <1 - 2* E, 1, 1 - 2 * E> translate <E, outer_wall_thickness, E> }
}

#declare outer_wall_e = object { outer_wall	scale <outer_width, 1, 1> transform to_e }
#declare outer_wall_s = object { outer_wall scale <outer_width, 1, 1> transform to_s }
#declare outer_wall_w = object { outer_wall scale <outer_width, 1, 1> transform to_w }
#declare outer_wall_n = object { outer_wall scale <outer_width, 1, 1> transform to_n }

#declare corner_window_box = union {
	box { 
		<-corner_window_box_offset, -corner_window_box_offset, corner_window_box_bottom>,
		<corner_window_width - corner_window_box_offset, 0, corner_window_box_top>
	}
	box {
		<-corner_window_box_offset, -corner_window_box_offset, corner_window_box_bottom>,
		<0, corner_window_depth - corner_window_box_offset, corner_window_box_top>
	}
	texture { tx_wall_outer	}
}

#declare corner_window_box_se = object { corner_window_box transform to_se }
#declare corner_window_box_sw = object { corner_window_box transform to_sw }
#declare corner_window_box_nw = object { corner_window_box transform to_nw }

#declare outer_walls = union {	
	object { outer_wall_e }
	object { outer_wall_s } 
	object { outer_wall_w }
	object { outer_wall_n }
	object { corner_window_box_se }
	object { corner_window_box_sw }
	object { corner_window_box_nw }
}

// window and door holes
#declare rec_front_window_hole = box {
	<rec_front_window_offset_s, -E, ground_floor_floor_level>, 
	<rec_front_window_offset_s + rec_front_window_width, total_outer_wall_thickness + E, rec_front_window_top>
}

#declare scase_window_hole = box {
	<outer_width - scase_window_offset_n - scase_window_width, -E, ground_floor_floor_level>, 
	<outer_width - scase_window_offset_n, total_outer_wall_thickness + E, scase_window_top>
}

#declare corner_window_hole = box {
	<-corner_window_box_offset - E, -corner_window_box_offset - E, corner_window_bottom + E>,
	<corner_window_width - corner_window_box_offset - corner_window_box_side_thickness,
	 corner_window_depth - corner_window_box_offset - corner_window_box_side_thickness,
	 corner_window_box_top - corner_window_box_side_thickness>
}

#declare corner_window_hole_se = object { corner_window_hole transform to_se }
#declare corner_window_hole_sw = object { corner_window_hole transform to_sw }
#declare corner_window_hole_nw = object { corner_window_hole transform to_nw }

#declare bath_window_hole = box {
	<outer_width - total_outer_wall_thickness - E, bath_window_offset_w, bath_window_bottom>,
	<outer_width + E, bath_window_offset_w + bath_window_width, bath_window_top>
}

#declare holes = union {
	object { rec_front_window_hole }
	object { scase_window_hole }
	object { corner_window_hole_se }
	object { corner_window_hole_sw }
	object { corner_window_hole_nw }
	object { bath_window_hole }
}

#declare outer_walls_with_holes = difference {
	object { outer_walls }
	object { holes }
}

// ground floor ceiling
#declare ground_floor_ceiling = difference { 
	box { <E, E, first_floor_floor_level - ceiling_thickness>, <outer_width - E, outer_depth - E, first_floor_floor_level> }
	box { 
		<outer_width - stairs_hole_offset_n - stairs_hole_width, -E, first_floor_floor_level - ceiling_thickness - E>,
		<outer_width - stairs_hole_offset_n, stairs_hole_depth + total_outer_wall_thickness, first_floor_floor_level + E>
	}
	texture { tx_ceiling }
}

// first floor ceiling
#declare first_floor_ceiling = box {
	<E, E, first_floor_floor_level + first_floor_height>, 
	<outer_width - E, outer_depth - E, first_floor_floor_level + first_floor_height + E> 
	texture { tx_ceiling }
}

// staircase window roof
#declare scase_window_roof = difference {
	box { 0, <scase_window_roof_width, -scase_window_roof_depth, scase_window_roof_height> }
	box { 
		<0, 0, -E>, <scase_window_width, -2 * scase_window_roof_depth, scase_window_roof_height + E> 
		rotate z * -scase_window_angle
	}
	box { 
		<0, 0, -E>, <-scase_window_width, -2 * scase_window_roof_depth, scase_window_roof_height + E> 
		rotate z * scase_window_angle translate x * scase_window_roof_width
	}
	#local slope_minus = box {
		0, <scase_window_roof_width, 2 * scase_window_roof_depth, 2 * scase_window_roof_height>	
		rotate x * scase_window_roof_angle
	}
	object { slope_minus translate y * -scase_window_roof_depth }
	object { slope_minus rotate z * -scase_window_angle }
	object { 
		slope_minus 
		translate -x * scase_window_roof_width
		rotate z * scase_window_angle 
		translate x * scase_window_roof_width
	}
	translate <outer_width - scase_window_offset_n - scase_window_width - scase_window_roof_outset, 0, scase_window_top>
	texture { tx_staircase_roof }
}

// whole structure 
#declare house_structure = union { 
	object { base }
	object { outer_walls_with_holes }
	object { ground_floor_ceiling }
	object { first_floor_ceiling }
	object { roof }
	object { scase_window_roof }
}
