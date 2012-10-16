#include "colors.inc"
#include "models/house.inc"
#include "textures/grass.inc"

global_settings {
	//radiosity {}	
}

camera {
    location <-1.5, -1.5, 5.5> look_at <0, 0, 5>
    //location <13, -4, 1.73> look_at <3.5, 3.5, 3>
    up z
    sky <0, 0, 1>
    // focus settings
	/*
    aperture 0.3
    blur_samples 5
    focal_point <3.5, 3.5, 2>
    */
}

light_source { <20, -10, 10> color White }
light_source { <-5, -5, 5> color White }

object { house }

// misc stuff
sky_sphere {
	pigment {
		gradient z
		color_map {
			[ 0.5 color <0.8, 0.9, 1> ]
			[ 1.0 color <0.2, 0.3, 1> ]
		}
		scale 2
		translate -1
	}
}

plane {
	z, 0
	texture { tx_grass }	
}
