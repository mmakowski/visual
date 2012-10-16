#include "etc/common.inc"
#include "etc/parameters.inc"
#include "models/derived_params.inc"
#include "textures/window_frame.inc"
#include "textures/window_glass.inc"

// corner windows
#declare corner_window_frame = union {
	#local vertical_bar = box { 
		<-corner_window_box_offset, -corner_window_box_offset, 0>, 
		<window_frame_thickness - corner_window_box_offset, window_frame_thickness - corner_window_box_offset, corner_window_height>
		translate z * corner_window_bottom
	}
	object { vertical_bar }
	#local offset_correction = -corner_window_box_side_thickness - window_frame_thickness;
	object { vertical_bar translate x * (corner_window_width + offset_correction) }
	object { vertical_bar translate y * (corner_window_depth + offset_correction) }
	#local horiz_bar_s = box {
		<-corner_window_box_offset, -corner_window_box_offset, 0>, 
		<window_frame_thickness - corner_window_box_offset, 
		 corner_window_depth - corner_window_box_offset - corner_window_box_side_thickness,
		 window_frame_thickness>
		 translate z * corner_window_bottom
	}
	object { horiz_bar_s }
	object { horiz_bar_s translate z * (corner_window_height - window_frame_thickness) }
	#local horiz_bar_e = box {
		<-corner_window_box_offset, -corner_window_box_offset, 0>, 
		<corner_window_width - corner_window_box_offset - corner_window_box_side_thickness,
		 window_frame_thickness - corner_window_box_offset, 
		 window_frame_thickness>
		 translate z * corner_window_bottom
	}
	object { horiz_bar_e }
	object { horiz_bar_e translate z * (corner_window_height - window_frame_thickness) }
	texture { tx_window_frame }
}

#declare corner_window_glass = union {
    #local to_frame_offset = window_frame_thickness - corner_window_box_offset;
    #local in_frame_offset = - (window_frame_thickness - window_glass_thickness) / 2 - corner_window_box_offset;
	#local glass_bottom = corner_window_bottom + corner_window_box_side_thickness + window_frame_thickness;
	#local glass_height = corner_window_height - 2 * window_frame_thickness;
	#local width_correction = -corner_window_box_offset - corner_window_box_side_thickness - window_frame_thickness;
	box { 
		<to_frame_offset, in_frame_offset, glass_bottom>,
		<to_frame_offset + corner_window_width + width_correction,
		 in_frame_offset + window_glass_thickness,
		 glass_bottom + glass_height>
	}
	box { 
		<in_frame_offset, to_frame_offset, glass_bottom>,
		<in_frame_offset + window_glass_thickness,
		 to_frame_offset + corner_window_depth + width_correction,
		 glass_bottom + glass_height>
	}
	texture { tx_window_glass }
	interior { in_window_glass }
}

#declare corner_window = union {
	object { corner_window_frame }
	object { corner_window_glass }
}

#declare corner_window_se = object { corner_window }

#declare house_windows = union {
	object { corner_window_se }
}