var/list/flooring_types

/proc/get_flooring_data(flooring_path)
	if(!flooring_types)
		flooring_types = list()
	if(!flooring_types["[flooring_path]"])
		flooring_types["[flooring_path]"] = new flooring_path
	return flooring_types["[flooring_path]"]

// State values:
// [icon_base]: initial base icon_state without edges or corners.
// if has_base_range is set, append 0-has_base_range ie.
//   [icon_base][has_base_range]
// [icon_base]_broken: damaged overlay.
// if has_damage_range is set, append 0-damage_range for state ie.
//   [icon_base]_broken[has_damage_range]
// [icon_base]_edges: directional overlays for edges.
// [icon_base]_corners: directional overlays for non-edge corners.

/decl/flooring
	var/name
	var/desc
	var/icon
	var/icon_base
	var/color

	var/has_base_range
	var/has_damage_range
	var/has_burn_range
	var/damage_temperature
	var/apply_thermal_conductivity
	var/apply_heat_capacity

	var/build_type      // Unbuildable if not set. Must be /obj/item/stack.
	var/build_cost = 1  // Stack units.
	var/build_time = 0  // BYOND ticks.

	var/descriptor = "tiles"
	var/flags
	var/can_paint
	var/footstep_sound = SFX_FOOTSTEP_PLATING

/decl/flooring/proc/on_remove()
	return

/decl/flooring/grass
	name = "grass"
	desc = "Do they smoke grass out in space, Bowie? Or do they smoke AstroTurf?"
	icon = 'icons/turf/flooring/grass.dmi'
	icon_base = "grass"
	has_base_range = 3
	damage_temperature = 80 CELSIUS
	flags = TURF_HAS_EDGES | TURF_REMOVE_SHOVEL
	build_type = /obj/item/stack/tile/grass

/decl/flooring/asteroid
	name = "coarse sand"
	desc = "Gritty and unpleasant."
	icon = 'icons/turf/flooring/asteroid.dmi'
	icon_base = "asteroid"
	flags = TURF_HAS_EDGES | TURF_REMOVE_SHOVEL
	build_type = null

/decl/flooring/carpet
	name = "brown carpet"
	desc = "Comfy and fancy carpeting."
	icon = 'icons/turf/flooring/carpet.dmi'
	icon_base = "brown"
	build_type = /obj/item/stack/tile/carpet
	damage_temperature = 200 CELSIUS
	flags = TURF_HAS_EDGES | TURF_HAS_CORNERS | TURF_REMOVE_CROWBAR | TURF_CAN_BURN
	footstep_sound = SFX_FOOTSTEP_CARPET

/decl/flooring/carpet/blue
	name = "blue carpet"
	icon_base = "blue1"
	build_type = /obj/item/stack/tile/carpetblue

/decl/flooring/carpet/gblue
	name = "blue carpet"
	icon_base = "gblue"
	build_type = /obj/item/stack/tile/carpetblue

/decl/flooring/carpet/blue2
	name = "pale blue carpet"
	icon_base = "blue2"
	build_type = /obj/item/stack/tile/carpetblue2

/decl/flooring/carpet/arcade
	name = "pale arcade carpet"
	icon_base = "arcade"
	build_type = /obj/item/stack/tile/carpetarcade

/decl/flooring/carpet/purple
	name = "purple carpet"
	icon_base = "purple"
	build_type = /obj/item/stack/tile/carpetpurple

/decl/flooring/carpet/gpurple
	name = "purple carpet"
	icon_base = "gpurple"
	build_type = /obj/item/stack/tile/carpetgpurple

/decl/flooring/carpet/orange
	name = "orange carpet"
	icon_base = "orange"
	build_type = /obj/item/stack/tile/carpetorange

/decl/flooring/carpet/green
	name = "green carpet"
	icon_base = "green"
	build_type = /obj/item/stack/tile/carpetgreen

/decl/flooring/carpet/red
	name = "red carpet"
	icon_base = "red"
	build_type = /obj/item/stack/tile/carpetred

/decl/flooring/carpet/oldred
	name = "red carpet"
	icon_base = "oldred"
	build_type = /obj/item/stack/tile/carpetoldred

/decl/flooring/linoleum
	name = "linoleum"
	desc = "It's like the 2390's all over again."
	icon = 'icons/turf/flooring/linoleum.dmi'
	icon_base = "lino"
	can_paint = TRUE
	build_type = /obj/item/stack/tile/linoleum
	flags = TURF_REMOVE_SCREWDRIVER
	footstep_sound = SFX_FOOTSTEP_TILES

/decl/flooring/tiling
	name = "floor"
	desc = "Scuffed from the passage of countless greyshirts."
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_base = "steel"
	has_damage_range = 4
	damage_temperature = 1400 CELSIUS
	flags = TURF_REMOVE_CROWBAR | TURF_CAN_BREAK | TURF_CAN_BURN
	build_type = /obj/item/stack/tile/floor
	can_paint = TRUE
	footstep_sound = SFX_FOOTSTEP_TILES

/decl/flooring/tiling/rough
	icon_base = "steel_rough"
	build_type = /obj/item/stack/tile/floor_rough

/decl/flooring/tiling/dirty
	icon_base = "steel_dirty"

/decl/flooring/tiling/dirty/rough
	icon_base = "steel_dirty_rough"

/decl/flooring/tiling/mono
	icon_base = "steel_mono"
	build_type = /obj/item/stack/tile/floor_mono

/decl/flooring/tiling/white
	desc = "How sterile."
	icon_base = "white"
	build_type = /obj/item/stack/tile/floor_white

/decl/flooring/tiling/white/mono
	icon_base = "white_mono"
	build_type = /obj/item/stack/tile/floor_mono_white

/decl/flooring/tiling/white/rough
	icon_base = "white_rough"
	build_type = /obj/item/stack/tile/floor_white_rough

/decl/flooring/tiling/dark
	desc = "How ominous."
	icon_base = "dark"
	build_type = /obj/item/stack/tile/floor_dark

/decl/flooring/tiling/dark/mono
	icon_base = "dark_mono"
	build_type = /obj/item/stack/tile/floor_mono_dark

/decl/flooring/tiling/dark/rough
	icon_base = "dark_rough"
	build_type = /obj/item/stack/tile/floor_dark_rough

/decl/flooring/tiling/brown
	desc = "How sterile."
	icon_base = "brown"
	build_type = /obj/item/stack/tile/floor_brown

/decl/flooring/tiling/techfloor
	desc = "How industrial."
	icon_base = "techfloor"
	build_type = /obj/item/stack/tile/techfloor

/decl/flooring/tiling/techfloor/maint
	icon_base = "techmaint"
	build_type = /obj/item/stack/tile/techfloor/maint

/decl/flooring/tiling/techfloor/grid
	icon_base = "techgrid"
	build_type = /obj/item/stack/tile/techfloor/grid

/decl/flooring/tiling/techfloor/ridge
	icon_base = "techridge"
	build_type = /obj/item/stack/tile/techfloor/ridge

/decl/flooring/tiling/freezer
	desc = "Don't slip."
	icon_base = "freezer"
	color = null
	has_damage_range = null
	flags = TURF_REMOVE_CROWBAR
	build_type = /obj/item/stack/tile/floor_freezer

/decl/flooring/darkwood
	name = "dark wooden floor"
	desc = "Polished darwood planks."
	icon = 'icons/turf/flooring/wood.dmi'
	icon_base = "darkwood"
	damage_temperature = 200 CELSIUS
	descriptor = "dark planks"
	build_type = /obj/item/stack/tile/darkwood
	flags = TURF_CAN_BREAK | TURF_IS_FRAGILE | TURF_REMOVE_SCREWDRIVER
	can_paint = TRUE
	footstep_sound = SFX_FOOTSTEP_WOOD

/decl/flooring/wood
	name = "wooden floor"
	desc = "Polished redwood planks."
	icon = 'icons/turf/flooring/wood.dmi'
	icon_base = "wood"
	has_damage_range = 6
	damage_temperature = 200 CELSIUS
	descriptor = "planks"
	build_type = /obj/item/stack/tile/wood
	flags = TURF_CAN_BREAK | TURF_IS_FRAGILE | TURF_REMOVE_SCREWDRIVER
	can_paint = TRUE

/decl/flooring/wood/broken0
	name = "broken wooden floor"
	icon_base = "wood_broken0"

/decl/flooring/wood/broken1
	name = "broken wooden floor"
	icon_base = "wood_broken1"

/decl/flooring/wood/broken2
	name = "broken wooden floor"
	icon_base = "wood_broken2"

/decl/flooring/wood/broken3
	name = "broken wooden floor"
	icon_base = "wood_broken3"

/decl/flooring/wood/broken4
	name = "broken wooden floor"
	icon_base = "wood_broken4"

/decl/flooring/wood/broken5
	name = "broken wooden floor"
	icon_base = "wood_broken5"

/decl/flooring/wood/broken6
	name = "broken wooden floor"
	icon_base = "wood_broken6"

/decl/flooring/reinforced
	name = "reinforced floor"
	desc = "Heavily reinforced with steel plating."
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_base = "reinforced"
	flags = TURF_REMOVE_WRENCH | TURF_ACID_IMMUNE
	build_type = /obj/item/stack/material/steel
	build_cost = 1
	build_time = 30
	apply_thermal_conductivity = 0.025
	apply_heat_capacity = 325000
	can_paint = TRUE
	footstep_sound = SFX_FOOTSTEP_PLATING

/decl/flooring/reinforced/circuit
	name = "processing strata"
	icon = 'icons/turf/flooring/circuit.dmi'
	icon_base = "bcircuit"
	build_type = null
	flags = TURF_ACID_IMMUNE | TURF_CAN_BREAK | TURF_REMOVE_WRENCH
	can_paint = TRUE

/decl/flooring/reinforced/circuit/green
	icon_base = "gcircuit"

/decl/flooring/reinforced/circuit/red
	icon_base = "rcircuit"
	flags = TURF_ACID_IMMUNE

/decl/flooring/reinforced/cult
	name = "engraved floor"
	desc = "Unsettling whispers waver from the surface..."
	icon = 'icons/turf/flooring/cult.dmi'
	icon_base = "cult"
	build_type = null
	has_damage_range = 6
	flags = TURF_ACID_IMMUNE | TURF_CAN_BREAK
	can_paint = null

/decl/flooring/reinforced/cult/on_remove()
	GLOB.cult.remove_cultiness(CULTINESS_PER_TURF)

/decl/flooring/reinforced/shuttle
	name = "floor"
	icon = 'icons/turf/shuttle.dmi'
	build_type = null
	flags = TURF_ACID_IMMUNE | TURF_CAN_BREAK | TURF_REMOVE_WRENCH
	can_paint = TRUE

/decl/flooring/reinforced/shuttle/blue
	icon_base = "floor"

/decl/flooring/reinforced/shuttle/yellow
	icon_base = "floor2"

/decl/flooring/reinforced/shuttle/white
	icon_base = "floor3"

/decl/flooring/reinforced/shuttle/red
	icon_base = "floor4"

/decl/flooring/reinforced/shuttle/purple
	icon_base = "floor5"

/decl/flooring/reinforced/shuttle/darkred
	icon_base = "floor6"

/decl/flooring/reinforced/shuttle/black
	icon_base = "floor7"

/decl/flooring/reinforced/shuttle/pod
	icon_base = "podfloor"

/decl/flooring/reinforced/shuttle/research
	icon_base = "podfloor_res"

/decl/flooring/diona
	name = "biomass"
	desc = "A mass of small intertwined aliens forming a floor... Creepy."
	icon = 'icons/turf/floors.dmi'
	icon_base = "diona"
	flags = TURF_ACID_IMMUNE | TURF_REMOVE_SHOVEL

/decl/flooring/sand_tile
	name = "sand floor"
	desc = "Floor in sand. Nothing interesting."
	icon = 'icons/turf/flooring/sand.dmi'
	icon_base = "sand_floor"
	flags = TURF_REMOVE_CROWBAR

/decl/flooring/tiling/vox1
	name = "old floor"
	desc = "A strange old floor."
	icon_base = "vox1"
	has_damage_range = 4
	damage_temperature = 1400 CELSIUS
	flags = TURF_REMOVE_CROWBAR | TURF_CAN_BREAK | TURF_CAN_BURN
	build_type = /obj/item/stack/tile/floor
	can_paint = FALSE

/decl/flooring/tiling/vox2
	name = "old floor"
	desc = "A strange old floor."
	icon_base = "vox2"
	has_damage_range = 4
	damage_temperature = 1400 CELSIUS
	flags = TURF_REMOVE_CROWBAR | TURF_CAN_BREAK | TURF_CAN_BURN
	build_type = /obj/item/stack/tile/floor
	can_paint = FALSE

/decl/flooring/tiling/vox3
	name = "old floor"
	desc = "A strange old floor."
	icon_base = "vox3"
	has_damage_range = 4
	damage_temperature = 1400 CELSIUS
	flags = TURF_REMOVE_CROWBAR | TURF_CAN_BREAK | TURF_CAN_BURN
	build_type = /obj/item/stack/tile/floor
	can_paint = FALSE

/decl/flooring/tiling/vox4
	name = "old floor"
	desc = "A strange old floor."
	icon_base = "vox4"
	has_damage_range = 4
	damage_temperature = 1400 CELSIUS
	flags = TURF_REMOVE_CROWBAR | TURF_CAN_BREAK | TURF_CAN_BURN
	build_type = /obj/item/stack/tile/floor
	can_paint = FALSE

/turf/simulated/floor/tiled/vox
	name = "old floor"
	desc = "A strange old floor."
	icon_state = "vox1"
	initial_flooring = /decl/flooring/tiling/vox1

/turf/simulated/floor/tiled/vox/vox2
	name = "old floor"
	desc = "A strange old floor."
	icon_state = "vox2"
	initial_flooring = /decl/flooring/tiling/vox2

/turf/simulated/floor/tiled/vox/vox3
	name = "old floor"
	desc = "A strange old floor."
	icon_state = "vox3"
	initial_flooring = /decl/flooring/tiling/vox3

/turf/simulated/floor/tiled/vox/vox4
	name = "old floor"
	desc = "A strange old floor."
	icon_state = "vox4"
	initial_flooring = /decl/flooring/tiling/vox4
