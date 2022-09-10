tool
extends TileSet


const GRASS = 0
const DIRT = 1
const WETDIRT = 2
const WATER = 3
const FARMLAND = 4
const TILLABLEDIRT = 5
const TILLABLEWETDIRT = 6
const OPENWATER = 7
const WINTERSTAIR = 8

var binds = {
	GRASS: [DIRT, WETDIRT, WATER],
	DIRT: [GRASS, WETDIRT, WATER],
	WETDIRT: [DIRT, GRASS, WATER],
	WATER: [GRASS, DIRT, WETDIRT, WINTERSTAIR],
	WINTERSTAIR: [WATER]
}

func _is_tile_bound(id, neighborId):
	return neighborId in binds[id]
