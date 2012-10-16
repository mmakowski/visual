#declare tx_window_glass = texture {
	pigment { color rgbf <1, 1, 1, 0> } 
	/*finish {
		specular 0.7
		roughness 0.001
		ambient 0
		diffuse 0
		reflection {
			0.2, 1.0
			fresnel on
		}
		conserve_energy
	}*/
}
#declare in_window_glass = 	interior {
	ior 1.5
	fade_distance 1.0
	fade_power 2
}
