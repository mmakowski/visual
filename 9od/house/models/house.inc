#include "models/house_structure.inc"
#include "models/house_windows.inc"

#declare house = union {
	object { house_structure }
	object { house_windows }
}